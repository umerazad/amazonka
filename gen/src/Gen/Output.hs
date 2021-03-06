{-# LANGUAGE BangPatterns               #-}
{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE DeriveFunctor              #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE DeriveTraversable          #-}
{-# LANGUAGE ExtendedDefaultRules       #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE FunctionalDependencies     #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE LambdaCase                 #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE OverloadedLists            #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE RecordWildCards            #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE ViewPatterns               #-}

{-# OPTIONS_GHC -fno-warn-type-defaults #-}

-- Module      : Gen.Output
-- Copyright   : (c) 2013-2014 Brendan Hay <brendan.g.hay@gmail.com>
-- License     : This Source Code Form is subject to the terms of
--               the Mozilla Public License, v. 2.0.
--               A copy of the MPL can be found in the LICENSE file or
--               you can obtain it at http://mozilla.org/MPL/2.0/.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)

module Gen.Output where

import           Control.Applicative
import           Control.Arrow            ((&&&))
import           Control.Error
import           Control.Lens             hiding ((.=), (<.>), op, mapping)
import           Data.Aeson
import           Data.Aeson.Encode.Pretty
import           Data.Aeson.Types         (Pair)
import           Data.Bifunctor
import           Data.CaseInsensitive     (CI)
import qualified Data.CaseInsensitive     as CI
import           Data.Char
import           Data.Function            (on)
import           Data.HashMap.Strict      (HashMap)
import qualified Data.HashMap.Strict      as Map
import           Data.HashSet             (HashSet)
import qualified Data.HashSet             as Set
import           Data.Hashable
import           Data.List
import           Data.Monoid              hiding (Product)
import           Data.SemVer
import           Data.Text                (Text)
import qualified Data.Text                as Text
import           Data.Text.Manipulate
import           GHC.Generics
import           Gen.Documentation
import           Gen.Filters
import           Gen.Names
import           Gen.TH
import           Gen.Types
import           System.FilePath

default (Text, FilePath)

newtype Exposed  a = Exposed  a
newtype Internal a = Internal a

data Derive
    = Eq'
    | Ord'
    | Show'
    | Generic'
    | Enum'
    | Num'
    | Integral'
    | Whole'
    | Real'
    | RealFrac'
    | RealFloat'
    | Monoid'
    | Semigroup'
    | IsString'
      deriving (Eq, Ord, Show, Generic)

instance Hashable Derive

instance ToJSON Derive where
    toJSON = toJSON . takeWhile (/= '\'') . show

class DerivingOf a where
    derivingOf :: a -> HashSet Derive

instance DerivingOf a => DerivingOf [a] where
    derivingOf xs =
        case map derivingOf xs of
            y:ys -> foldl' Set.intersection y ys
            _    -> mempty

data Derived a = Derived !a !Value

instance (DerivingOf a, ToJSON a) => ToJSON (Derived a) where
    toJSON (Derived x v) = rewrapped ("deriving", toJSON xs) v
      where
        xs = sort . Set.toList $ derivingOf x

class HasName a where
    nameOf :: Lens' a Text

instance HasName Text where
    nameOf = id

nameCI :: HasName a => a -> CI Text
nameCI = CI.mk . view nameOf

constructor :: HasName a => a -> Text
constructor = reserved
    . uncurry (<>)
    . first Text.toLower
    . breakWord
    . view nameOf

newtype Description = Description Text
    deriving (Eq, Ord, Show, ToJSON)

description :: Text -> Description
description = Description . wrapDescription

newtype Above = Above Text
    deriving (Eq, Ord, Show, ToJSON)

above :: Text -> Above
above = Above . wrapHaddock "| " 78 0

rewrapped :: Pair -> Value -> Value
rewrapped (k, v) = Object . \case
    Object o -> Map.insert    k v o
    _        -> Map.singleton k v

data Prim
    = PBlob
    | PReq
    | PRes
    | PBool
    | PText
    | PInt
    | PInteger
    | PDouble
    | PNatural
    | PTime !Timestamp
      deriving (Eq, Ord, Show)

primitive :: Bool -> Prim -> Text
primitive int = \case
    PBlob           -> "Base64"
    PReq            -> "RqBody"
    PRes            -> "RsBody"
    PBool           -> "Bool"
    PText           -> "Text"
    PInt            -> "Int"
    PInteger        -> "Integer"
    PDouble         -> "Double"
    PNatural
        | int       -> "Nat"
        | otherwise -> "Natural"
    PTime ts
        | int       -> timestamp ts
        | otherwise -> "UTCTime"

data Type
    = TType      !Text
    | TPrim      !Prim
    | TMaybe     !Type
    | TSensitive !Type
    | TFlatten   !Type
    | TCase      !Type
    | TList      !Text !Type
    | TList1     !Text !Type
    | TMap       !(Text, Text, Text) !Type !Type
    | THashMap   !Type !Type
      deriving (Eq, Ord, Show)

isRequired :: Type -> Bool
isRequired = \case
    TMaybe {} -> False
    _         -> True

isMonoid :: Type -> Bool
isMonoid = \case
    TList      {} -> True
    TMap       {} -> True
    THashMap   {} -> True
    TSensitive t  -> isMonoid t
    TFlatten   t  -> isMonoid t
    _             -> False

isFlattened :: Type -> Bool
isFlattened = any f . universe
  where
    f (TFlatten _) = True
    f _            = False

listElement :: Type -> Maybe Type
listElement (TList _ x) = Just x
listElement _           = Nothing

instance Plated Type where
    plate f = \case
        TMaybe     x     -> TMaybe     <$> f x
        TSensitive x     -> TSensitive <$> f x
        TFlatten   x     -> TFlatten   <$> f x
        TCase      x     -> TCase      <$> f x
        TList      e x   -> TList    e <$> f x
        TList1     e x   -> TList1   e <$> f x
        TMap       e k v -> TMap     e <$> f k <*> f v
        THashMap     k v -> THashMap   <$> f k <*> f v
        x                -> pure x

instance ToJSON (Exposed Type) where
    toJSON (Exposed e) = toJSON (go e)
      where
        go = \case
            TType      t -> upperHead t
            TPrim      p -> primitive False p
            TMaybe     x -> "Maybe " <> wrapped (go x)
            TCase      x -> "CI "    <> wrapped (go x)
            TSensitive x -> go x
            TFlatten   x -> go x

            TList  _ x   -> "[" <> go x <> "]"
            TList1 _ x   -> "NonEmpty " <> wrapped (go x)
            TMap   _ k v -> "HashMap "  <> wrapped (go k) <> " " <> wrapped (go v)
            THashMap k v -> "HashMap "  <> wrapped (go k) <> " " <> wrapped (go v)

instance ToJSON (Internal Type) where
    toJSON (Internal i) = toJSON (go i)
      where
        go = \case
            TType      t -> upperHead t
            TPrim      p -> primitive True p
            TMaybe     x -> "Maybe "     <> wrapped (go x)
            TSensitive x -> "Sensitive " <> wrapped (go x)
            TCase      x -> "CI "        <> wrapped (go x)
            TFlatten   x -> go x

            TList    e x -> "List"  <> witness e   <> " " <> wrapped (go x)
            TList1   e x -> "List1" <> witness e   <> " " <> wrapped (go x)
            THashMap k v -> "Map "  <> wrapped (go k) <> " " <> wrapped (go v)

            TMap  (e, i', j) k v ->
                "EMap" <> witness e
                       <> witness i'
                       <> witness j
                       <> " "
                       <> wrapped (go k)
                       <> " "
                       <> wrapped (go v)

        witness t = " \"" <> t <> "\""

typeMapping :: Type -> Maybe Text
typeMapping t
    | x:xs <- go t = Just (Text.intercalate " . " (x : xs))
    | otherwise    = Nothing
  where
    go y = case y of
        TType      {} -> []
        TPrim      p  -> maybeToList (primIso p)
        TMaybe     x  -> mapping (go x)
        TSensitive x  -> maybeToList (typeIso y) ++ go x
        TFlatten   x  -> go x
        TCase      x  -> go x
        TList      {} -> maybeToList (typeIso y)
        TList1     {} -> maybeToList (typeIso y)
        TMap       {} -> maybeToList (typeIso y)
        THashMap   {} -> maybeToList (typeIso y)

    mapping (x:xs) = "mapping " <> x : xs
    mapping _      = []

typeIso :: Type   -> Maybe Text
typeIso = \case
    TPrim      p  -> primIso p
    TSensitive {} -> Just "_Sensitive"
    TFlatten   x  -> typeIso x
    TList      {} -> Just "_List"  -- No nested mappings, since it's Coercible.
    TList1     {} -> Just "_List1" -- No nested mappings, since it's Coercible.
    TMap       {} -> Just "_EMap"  -- No nested mappings, since it's Coercible.
    THashMap   {} -> Just "_Map"   -- No nested mappings, since it's Coercible.
    _             -> Nothing

primIso :: Prim -> Maybe Text
primIso = \case
    PTime _  -> Just "_Time"
    PNatural -> Just "_Nat"
    _        -> Nothing

typeDefault :: Type -> Text
typeDefault t
    | isMonoid   t = "mempty"
    | isRequired t = "<error>"
    | otherwise    = "Nothing"

class HasType a where
    typeOf :: Lens' a Type

data Field = Field
    { _fName          :: !Text
    , _fShape         :: !Text
    , _fType          :: !Type
    , _fLocation      :: Maybe Location
    , _fLocationName  :: !Text
    , _fPayload       :: !Bool
    , _fStream        :: !Bool
    , _fDocumentation :: Maybe Above
    } deriving (Eq, Show)

instance Ord Field where
    compare a b = on compare _fName a b <> on compare _fType a b

makeLenses ''Field

instance ToJSON Field where
    toJSON Field{..} = object
        [ "name"          .= fieldName _fName
        , "lens"          .= lensName  _fName
        , "lensMapping"   .= typeMapping _fType
        , "shape"         .= _fShape
        , "type"          .= Internal _fType
        , "typeExposed"   .= Exposed _fType
        , "location"      .= _fLocation
        , "locationName"  .= _fLocationName
        , "documentation" .= _fDocumentation
        , "required"      .= isRequired _fType
        , "flattened"     .= isFlattened _fType
        , "monoid"        .= isMonoid _fType
        , "default"       .= typeDefault _fType
        , "iso"           .= typeIso _fType
        ]

instance HasName Field where
    nameOf = fName

instance HasType Field where
    typeOf = fType

parameters :: [Field] -> ([Field], [Field])
parameters = partition (f . view typeOf)
  where
    f x = not (isMonoid x) && isRequired x

isHeader :: Field -> Bool
isHeader = f . view fLocation
  where
    f (Just Header)  = True
    f (Just Headers) = True
    f _              = False

isQuery :: Field -> Bool
isQuery = f . view fLocation
  where
    f (Just Querystring) = True
    f _                  = False

fieldLocation :: Field -> Value
fieldLocation f = object
    [ "type"         .= "field"
    , "field"        .= fieldName (_fName f)
    , "locationName" .= _fLocationName f
    ]

fieldPad :: [Field] -> Int
fieldPad [] = 0
fieldPad xs = (+1) . maximum $ map (Text.length . _fLocationName) xs

data Data
    = Nullary !Text (HashMap Text Text)
    | Newtype !Text !Field
    | Record  !Text [Field]
    | Product !Text [Type]
    | Empty   !Text
    | Void
      deriving (Eq, Show)

instance Ord Data where
    compare a b =
        case (a, b) of
            (Nullary x _, Nullary y _) -> x `compare` y
            (Newtype x _, Newtype y _) -> x `compare` y
            (Record  x _, Record  y _) -> x `compare` y
            (Nullary _ _, _)           -> LT
            (Newtype _ _, _)           -> LT
            (Record  _ _, _)           -> LT
            _                          -> GT

instance ToJSON Data where
    toJSON d = toJSON . Derived d $
        case d of
            Void -> object
                [ "type"        .= "void"
                ]

            Empty n -> object
                [ "type"        .= "empty"
                , "name"        .= typeName n
                , "ctor"        .= constructor n
                , "fieldPad"    .= (0 :: Int)
                , "fields"      .= ([] :: [Text])
                , "optional"    .= ([] :: [Text])
                , "required"    .= ([] :: [Text])
                ]

            Product n fs -> object
                [ "type"        .= "product"
                , "name"        .= typeName n
                , "slots"       .= map Internal fs
                ]

            Nullary n fs -> object
                [ "type"        .= "nullary"
                , "name"        .= typeName n
                , "branches"    .= fs
                , "branchPad"   .= maximum (map Text.length $ Map.keys fs)
                , "valuePad"    .= (maximum (map Text.length $ Map.elems fs) + 1)
                ]

            Newtype n f -> object
                [ "type"        .= "newtype"
                , "name"        .= typeName n
                , "ctor"        .= constructor n
                , "field"       .= f
                , "fields"      .= ([f] :: [Field])
                , "fieldPad"    .= (0 :: Int)
                , "contents"    .= filter (isNothing . _fLocation) [f]
                , "contentPad"  .= (0 :: Int)
                , "required"    .= req
                , "optional"    .= opt
                , "payload"     .= if _fPayload f then Just f else Nothing
                , "listElement" .= fmap Internal (listElement (f ^. typeOf))
                , "locationPad" .= (0 :: Int)
                ]
              where
                (req, opt) = parameters [f]

            Record n fs -> object
                [ "type"        .= "record"
                , "name"        .= typeName n
                , "ctor"        .= constructor n
                , "fields"      .= sort fs
                , "fieldPad"    .= (maximum (map (Text.length . view nameOf) fs) + 1)
                , "contents"    .= contents
                , "contentPad"  .= contentPad
                , "required"    .= req
                , "optional"    .= opt
                , "payload"     .= find _fPayload fs
                , "locationPad" .= (maximum (map (Text.length . _fLocationName) fs) + 1)
                ]
              where
                (req, opt) = parameters fs

                contentPad
                    | [] <- contents = 0
                    | otherwise      =
                        maximum (map (Text.length . _fLocationName) contents) + 1

                contents = filter (isNothing . _fLocation) fs

dataRename :: Text -> Data -> Data
dataRename k = \case
    Nullary _ m  -> Nullary k m
    Newtype _ f  -> Newtype k f
    Record  _ fs -> Record  k fs
    Product _ fs -> Product k fs
    Empty   _    -> Empty   k
    x            -> x

dataFields :: Traversal' Data Field
dataFields f = \case
    Newtype n x  -> Newtype n <$> f x
    Record  n xs -> Record  n <$> traverse f xs
    Product n xs -> pure (Product n xs)
    Nullary n m  -> pure (Nullary n m)
    Empty   n    -> pure (Empty n)
    Void         -> pure Void

fieldNames :: Data -> [Text]
fieldNames (Nullary _ m) = Map.keys m
fieldNames d             = toListOf (dataFields . nameOf) d

fieldLocations :: Data -> [(Text, Text)]
fieldLocations = map (_fLocationName &&& _fName) . toListOf dataFields

fieldPrefix :: Data -> Maybe Text
fieldPrefix = fmap (Text.takeWhile (not . isUpper)) . headMay . fieldNames

mapFieldNames :: (Text -> Text) -> Data -> Data
mapFieldNames f (Nullary n m) = Nullary n . Map.fromList . map (first f) $ Map.toList m
mapFieldNames f d             = d & dataFields %~ nameOf %~ f

setStreaming :: Bool -> Data -> Data
setStreaming rq = dataFields %~ go
  where
    go x = x & typeOf %~ transform (body (x ^. fStream) (x ^. fLocation))

    body :: Bool -> Maybe Location -> Type -> Type
    body True _ _
        | rq        = TPrim PReq
        | otherwise = TPrim PRes
    body _ (Just Body) (TMaybe x@(TPrim y))
        | PReq <- y = x
        | PRes <- y = x
        | otherwise = body False (Just Body) x
    body _ (Just Body) (TPrim _)
        | rq        = TPrim PReq
        | otherwise = TPrim PRes
    body _ _ x      = x

isVoid :: Data -> Bool
isVoid Void = True
isVoid _    = False

instance DerivingOf Prim where
    derivingOf = (def <>) . \case
        PBool    -> [Eq', Ord', Enum']
        PText    -> [Eq', Ord', Monoid', IsString']
        PInt     -> [Eq', Ord', Num', Enum', Integral', Real']
        PInteger -> [Eq', Ord', Num', Enum', Integral', Real']
        PDouble  -> [Eq', Ord', Num', Enum', RealFrac', RealFloat', Real']
        PNatural -> [Eq', Ord', Num', Enum', Integral', Whole', Real']
        PTime _  -> [Eq', Ord']
        PBlob    -> [Eq']
        _        -> []
      where
        def = [Show', Generic']

instance DerivingOf Type where
    derivingOf = \case
        TType      _     -> [Eq', Show', Generic']
        TPrim      p     -> derivingOf p
        TMaybe     x     -> prim (derivingOf x)
        TSensitive x     -> derivingOf x
        TFlatten   x     -> derivingOf x
        TCase      _     -> [Eq', Ord', Show', Monoid']
        TList      _ x   -> list (derivingOf x)
        TList1     _ x   -> Set.delete Monoid' . list $ derivingOf x
        TMap       _ k v -> hmap k v
        THashMap     k v -> hmap k v
      where
        hmap k v = Set.delete Ord' . list $
            derivingOf k `Set.intersection` derivingOf v

        list = prim . mappend
            [ Monoid'
            , Semigroup'
            ]

        prim = flip Set.difference
            [ Enum'
            , Num'
            , Integral'
            , Real'
            , RealFrac'
            , RealFloat'
            , Whole'
            , IsString'
            ]

instance DerivingOf Data where
    derivingOf d = f . derivingOf $ toListOf (dataFields . typeOf) d
      where
        f | Newtype {} <- d = Set.delete Generic'
          | Nullary {} <- d = const [Eq', Ord', Enum', Show', Generic']
          | Empty   {} <- d = const [Eq', Ord', Show', Generic']
          | otherwise       = flip Set.difference
              [ Semigroup'
              , Monoid'
              , Enum'
              , Num'
              , Integral'
              , Real'
              , RealFrac'
              , RealFloat'
              , Whole'
              , IsString'
              , Generic'
              ]

data Request = Request
    { _rqProto  :: !Protocol
    , _rqUri    :: !URI
    , _rqName   :: !Text
    , _rqShared :: !Bool
    , _rqData   :: !Data
    } deriving (Eq, Show)

instance ToJSON Request where
    toJSON Request{..} =
        Object (x <> operationJSON _rqProto _rqShared True _rqName _rqData)
      where
        Object x = object
            [ "path"     .= _uriPath _rqUri
            , "query"    .= qry
            , "queryPad" .= fieldPad qs
            , "queryAll" .= (length qs == length fs && not (null fs))
            , "shared"   .= _rqShared
            ]

        qry = map toJSON (_uriQuery _rqUri) ++ map fieldLocation qs

        qs = filter isQuery fs
        fs = toListOf dataFields _rqData

data Response = Response
    { _rsProto         :: !Protocol
    , _rsWrapper       :: !Bool
    , _rsResultWrapper :: Maybe Text
    , _rsName          :: !Text
    , _rsShared        :: !Bool
    , _rsData          :: !Data
    } deriving (Eq, Show)

instance ToJSON Response where
    toJSON Response{..} =
        Object (x <> operationJSON _rsProto _rsShared False _rsName _rsData)
      where
        Object x = object
            [ "resultWrapper" .= _rsResultWrapper
            , "wrapper"       .= _rsWrapper
            , "shared"        .= _rsShared
            ]

operationJSON :: Protocol -> Bool -> Bool -> Text -> Data -> Object
operationJSON p s rq n d = y <> x
  where
    Object x = toJSON d
    Object y = object
        [ "ctor"      .= constructor n
        , "protocol"  .= p
        , "streaming" .= stream
        , "headers"   .= map fieldLocation hs
        , "headerPad" .= fieldPad hs
        , "headerAll" .= headerAll
        , "style"     .= style
        ]

    headerAll = length hs == length fs && not (null fs)

    hs = filter isHeader fs
    fs = toListOf dataFields d

    stream :: Bool
    stream = any (view fStream) $
        case d of
            Newtype _ f  -> [f]
            Record  _ xs -> xs
            _            -> []

    style :: Text
    style | Empty{} <- d
          , not rq         = "nullary"
          | headerAll      = "headers"
          | s {- shared -} = k
          | stream         = h "body"
          | otherwise      = h (b k)
      where
        h | null hs   = id
          | otherwise = (<> "-headers")

        b | stream    = (<> "-body")
          | otherwise = id

        k = case p of
            Json       -> "json"
            RestJson   -> "json"
            Xml        -> "xml"
            RestXml    -> "xml"
            Query | rq -> "query"
            Query      -> "xml"
            Ec2   | rq -> "query"
            Ec2        -> "xml"

instance ToJSON (Token Type) where
    toJSON Token{..} = object
        [ "input"          .= _tokInput
        , "inputRequired"  .= isRequired _tokInputAnn
        , "output"         .= _tokOutput
        , "outputRequired" .= isRequired _tokInputAnn
        ]

data Operation = Operation
    { _opName             :: !Text
    , _opUrl              :: !Text
    , _opService          :: !Abbrev
    , _opProtocol         :: !Protocol
    , _opNamespace        :: !NS
    , _opImports          :: [NS]
    , _opDocumentation    :: Maybe Above
    , _opDocumentationUrl :: Maybe Text
    , _opMethod           :: !Method
    , _opRequest          :: !Request
    , _opResponse         :: !Response
    , _opPager            :: Maybe (Pager Type)
    } deriving (Eq, Show)

record output ''Operation

instance Ord Operation where
    compare = on compare _opName

instance ToFilePath Operation where
    toFilePath = toFilePath . _opNamespace

operationDataTypes :: Operation -> HashMap Text Data
operationDataTypes o = Map.fromList
    [ let rq = o ^. opRequest  in (_rqName rq, _rqData rq)
    , let rs = o ^. opResponse in (_rsName rs, _rsData rs)
    ]

data RetryDelay = Exp
    { _eAttempts :: !Int
    , _eBase     :: !Base
    , _eGrowth   :: !Int
    } deriving (Eq, Show)

record output ''RetryDelay

data RetryPolicy = Status
    { _sError :: Maybe Text
    , _sCode  :: !Int
    } deriving (Eq, Show)

record output ''RetryPolicy

data Service = Service
    { _svName           :: !Text
    , _svUrl            :: !Text
    , _svAbbrev         :: !Abbrev
    , _svNamespace      :: !NS
    , _svImports        :: [NS]
    , _svVersion        :: !Text
    , _svDocumentation  :: !Above
    , _svProtocol       :: !Protocol
    , _svEndpointPrefix :: !Text
    , _svSignature      :: !Signature
    , _svChecksum       :: !Checksum
    , _svXmlNamespace   :: Maybe Text
    , _svTargetPrefix   :: Maybe Text
    , _svJsonVersion    :: Maybe Text
    , _svError          :: !Text
    , _svRetryDelay     :: !RetryDelay
    , _svRetryPolicies  :: HashMap Text RetryPolicy
    } deriving (Eq, Show)

record output ''Service

instance ToFilePath Service where
    toFilePath = toFilePath . _svNamespace

data Cabal = Cabal
    { _cName         :: !Text
    , _cAbbrev       :: !Abbrev
    , _cUrl          :: !Text
    , _cLibrary      :: !Library
    , _cVersion      :: !Version
    , _cProtocol     :: !Protocol
    , _cDescription  :: !Description
    , _cExposed      :: [NS]
    , _cOther        :: [NS]
    } deriving (Eq, Show)

record output ''Cabal

instance ToFilePath Cabal where
    toFilePath c = toFilePath (_cLibrary c) <.> "cabal"

data Types = Types
    { _tNamespace :: !NS
    , _tImports   :: [NS]
    , _tTypes     :: [Data]
    , _tShared    :: HashSet Text
    } deriving (Eq, Show)

record output ''Types

instance ToFilePath Types where
    toFilePath = toFilePath . _tNamespace

data Waiters = Waiters
    { _wNamespace :: !NS
    , _wImports   :: [NS]
    , _wWaiters   :: HashMap Text Waiter
    } deriving (Eq, Show)

record output ''Waiters

instance ToFilePath Waiters where
    toFilePath = toFilePath . _wNamespace

data Output = Output
    { _outCabal      :: Cabal
    , _outService    :: Service
    , _outOperations :: [Operation]
    , _outTypes      :: Types
    , _outWaiters    :: Waiters
    } deriving (Eq, Show)

record output ''Output

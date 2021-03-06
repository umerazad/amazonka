{-# LANGUAGE DataKinds                   #-}
{-# LANGUAGE DeriveGeneric               #-}
{-# LANGUAGE FlexibleInstances           #-}
{-# LANGUAGE GeneralizedNewtypeDeriving  #-}
{-# LANGUAGE LambdaCase                  #-}
{-# LANGUAGE NoImplicitPrelude           #-}
{-# LANGUAGE OverloadedStrings           #-}
{-# LANGUAGE RecordWildCards             #-}
{-# LANGUAGE TypeFamilies                #-}
{-# LANGUAGE ViewPatterns                #-}

{-# OPTIONS_GHC -fno-warn-unused-imports #-}

-- Module      : Network.AWS.CognitoIdentity.Types
-- Copyright   : (c) 2013-2014 Brendan Hay <brendan.g.hay@gmail.com>
-- License     : This Source Code Form is subject to the terms of
--               the Mozilla Public License, v. 2.0.
--               A copy of the MPL can be found in the LICENSE file or
--               you can obtain it at http://mozilla.org/MPL/2.0/.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)
--
-- Derived from AWS service descriptions, licensed under Apache 2.0.

module Network.AWS.CognitoIdentity.Types
    (
    -- * Service
      CognitoIdentity
    -- ** Error
    , JSONError

    -- * IdentityDescription
    , IdentityDescription
    , identityDescription
    , idIdentityId
    , idLogins

    -- * IdentityPool
    , IdentityPool
    , identityPool
    , ipAllowUnauthenticatedIdentities
    , ipDeveloperProviderName
    , ipIdentityPoolId
    , ipIdentityPoolName
    , ipOpenIdConnectProviderARNs
    , ipSupportedLoginProviders

    -- * IdentityPoolShortDescription
    , IdentityPoolShortDescription
    , identityPoolShortDescription
    , ipsdIdentityPoolId
    , ipsdIdentityPoolName
    ) where

import Network.AWS.Prelude
import Network.AWS.Signing
import qualified GHC.Exts

-- | Version @2014-06-30@ of the Amazon Cognito Identity service.
data CognitoIdentity

instance AWSService CognitoIdentity where
    type Sg CognitoIdentity = V4
    type Er CognitoIdentity = JSONError

    service = service'
      where
        service' :: Service CognitoIdentity
        service' = Service
            { _svcAbbrev       = "CognitoIdentity"
            , _svcPrefix       = "cognito-identity"
            , _svcVersion      = "2014-06-30"
            , _svcTargetPrefix = Just "AWSCognitoIdentityService"
            , _svcJSONVersion  = Just "1.1"
            , _svcHandle       = handle
            , _svcRetry        = retry
            }

        handle :: Status
               -> Maybe (LazyByteString -> ServiceError JSONError)
        handle = jsonError statusSuccess service'

        retry :: Retry CognitoIdentity
        retry = Exponential
            { _retryBase     = 0.05
            , _retryGrowth   = 2
            , _retryAttempts = 5
            , _retryCheck    = check
            }

        check :: Status
              -> JSONError
              -> Bool
        check (statusCode -> s) (awsErrorCode -> e)
            | s == 500  = True -- General Server Error
            | s == 509  = True -- Limit Exceeded
            | s == 503  = True -- Service Unavailable
            | otherwise = False

data IdentityDescription = IdentityDescription
    { _idIdentityId :: Maybe Text
    , _idLogins     :: List "Logins" Text
    } deriving (Eq, Ord, Show)

-- | 'IdentityDescription' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'idIdentityId' @::@ 'Maybe' 'Text'
--
-- * 'idLogins' @::@ ['Text']
--
identityDescription :: IdentityDescription
identityDescription = IdentityDescription
    { _idIdentityId = Nothing
    , _idLogins     = mempty
    }

-- | A unique identifier in the format REGION:GUID.
idIdentityId :: Lens' IdentityDescription (Maybe Text)
idIdentityId = lens _idIdentityId (\s a -> s { _idIdentityId = a })

-- | A set of optional name-value pairs that map provider names to provider tokens.
idLogins :: Lens' IdentityDescription [Text]
idLogins = lens _idLogins (\s a -> s { _idLogins = a }) . _List

instance FromJSON IdentityDescription where
    parseJSON = withObject "IdentityDescription" $ \o -> IdentityDescription
        <$> o .:? "IdentityId"
        <*> o .:? "Logins" .!= mempty

instance ToJSON IdentityDescription where
    toJSON IdentityDescription{..} = object
        [ "IdentityId" .= _idIdentityId
        , "Logins"     .= _idLogins
        ]

data IdentityPool = IdentityPool
    { _ipAllowUnauthenticatedIdentities :: Bool
    , _ipDeveloperProviderName          :: Maybe Text
    , _ipIdentityPoolId                 :: Text
    , _ipIdentityPoolName               :: Text
    , _ipOpenIdConnectProviderARNs      :: List "OpenIdConnectProviderARNs" Text
    , _ipSupportedLoginProviders        :: Map Text Text
    } deriving (Eq, Show)

-- | 'IdentityPool' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'ipAllowUnauthenticatedIdentities' @::@ 'Bool'
--
-- * 'ipDeveloperProviderName' @::@ 'Maybe' 'Text'
--
-- * 'ipIdentityPoolId' @::@ 'Text'
--
-- * 'ipIdentityPoolName' @::@ 'Text'
--
-- * 'ipOpenIdConnectProviderARNs' @::@ ['Text']
--
-- * 'ipSupportedLoginProviders' @::@ 'HashMap' 'Text' 'Text'
--
identityPool :: Text -- ^ 'ipIdentityPoolId'
             -> Text -- ^ 'ipIdentityPoolName'
             -> Bool -- ^ 'ipAllowUnauthenticatedIdentities'
             -> IdentityPool
identityPool p1 p2 p3 = IdentityPool
    { _ipIdentityPoolId                 = p1
    , _ipIdentityPoolName               = p2
    , _ipAllowUnauthenticatedIdentities = p3
    , _ipSupportedLoginProviders        = mempty
    , _ipDeveloperProviderName          = Nothing
    , _ipOpenIdConnectProviderARNs      = mempty
    }

-- | TRUE if the identity pool supports unauthenticated logins.
ipAllowUnauthenticatedIdentities :: Lens' IdentityPool Bool
ipAllowUnauthenticatedIdentities =
    lens _ipAllowUnauthenticatedIdentities
        (\s a -> s { _ipAllowUnauthenticatedIdentities = a })

-- | The "domain" by which Cognito will refer to your users.
ipDeveloperProviderName :: Lens' IdentityPool (Maybe Text)
ipDeveloperProviderName =
    lens _ipDeveloperProviderName (\s a -> s { _ipDeveloperProviderName = a })

-- | An identity pool ID in the format REGION:GUID.
ipIdentityPoolId :: Lens' IdentityPool Text
ipIdentityPoolId = lens _ipIdentityPoolId (\s a -> s { _ipIdentityPoolId = a })

-- | A string that you provide.
ipIdentityPoolName :: Lens' IdentityPool Text
ipIdentityPoolName =
    lens _ipIdentityPoolName (\s a -> s { _ipIdentityPoolName = a })

ipOpenIdConnectProviderARNs :: Lens' IdentityPool [Text]
ipOpenIdConnectProviderARNs =
    lens _ipOpenIdConnectProviderARNs
        (\s a -> s { _ipOpenIdConnectProviderARNs = a })
            . _List

-- | Optional key:value pairs mapping provider names to provider app IDs.
ipSupportedLoginProviders :: Lens' IdentityPool (HashMap Text Text)
ipSupportedLoginProviders =
    lens _ipSupportedLoginProviders
        (\s a -> s { _ipSupportedLoginProviders = a })
            . _Map

instance FromJSON IdentityPool where
    parseJSON = withObject "IdentityPool" $ \o -> IdentityPool
        <$> o .:  "AllowUnauthenticatedIdentities"
        <*> o .:? "DeveloperProviderName"
        <*> o .:  "IdentityPoolId"
        <*> o .:  "IdentityPoolName"
        <*> o .:? "OpenIdConnectProviderARNs" .!= mempty
        <*> o .:? "SupportedLoginProviders" .!= mempty

instance ToJSON IdentityPool where
    toJSON IdentityPool{..} = object
        [ "IdentityPoolId"                 .= _ipIdentityPoolId
        , "IdentityPoolName"               .= _ipIdentityPoolName
        , "AllowUnauthenticatedIdentities" .= _ipAllowUnauthenticatedIdentities
        , "SupportedLoginProviders"        .= _ipSupportedLoginProviders
        , "DeveloperProviderName"          .= _ipDeveloperProviderName
        , "OpenIdConnectProviderARNs"      .= _ipOpenIdConnectProviderARNs
        ]

data IdentityPoolShortDescription = IdentityPoolShortDescription
    { _ipsdIdentityPoolId   :: Maybe Text
    , _ipsdIdentityPoolName :: Maybe Text
    } deriving (Eq, Ord, Show)

-- | 'IdentityPoolShortDescription' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'ipsdIdentityPoolId' @::@ 'Maybe' 'Text'
--
-- * 'ipsdIdentityPoolName' @::@ 'Maybe' 'Text'
--
identityPoolShortDescription :: IdentityPoolShortDescription
identityPoolShortDescription = IdentityPoolShortDescription
    { _ipsdIdentityPoolId   = Nothing
    , _ipsdIdentityPoolName = Nothing
    }

-- | An identity pool ID in the format REGION:GUID.
ipsdIdentityPoolId :: Lens' IdentityPoolShortDescription (Maybe Text)
ipsdIdentityPoolId =
    lens _ipsdIdentityPoolId (\s a -> s { _ipsdIdentityPoolId = a })

-- | A string that you provide.
ipsdIdentityPoolName :: Lens' IdentityPoolShortDescription (Maybe Text)
ipsdIdentityPoolName =
    lens _ipsdIdentityPoolName (\s a -> s { _ipsdIdentityPoolName = a })

instance FromJSON IdentityPoolShortDescription where
    parseJSON = withObject "IdentityPoolShortDescription" $ \o -> IdentityPoolShortDescription
        <$> o .:? "IdentityPoolId"
        <*> o .:? "IdentityPoolName"

instance ToJSON IdentityPoolShortDescription where
    toJSON IdentityPoolShortDescription{..} = object
        [ "IdentityPoolId"   .= _ipsdIdentityPoolId
        , "IdentityPoolName" .= _ipsdIdentityPoolName
        ]

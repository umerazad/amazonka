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

-- Module      : Network.AWS.Kinesis.Types
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

module Network.AWS.Kinesis.Types
    (
    -- * Service
      Kinesis
    -- ** Error
    , JSONError

    -- * Shard
    , Shard
    , shard
    , sAdjacentParentShardId
    , sHashKeyRange
    , sParentShardId
    , sSequenceNumberRange
    , sShardId

    -- * Tag
    , Tag
    , tag
    , tagKey
    , tagValue

    -- * StreamDescription
    , StreamDescription
    , streamDescription
    , sdHasMoreShards
    , sdShards
    , sdStreamARN
    , sdStreamName
    , sdStreamStatus

    -- * PutRecordsResultEntry
    , PutRecordsResultEntry
    , putRecordsResultEntry
    , prreErrorCode
    , prreErrorMessage
    , prreSequenceNumber
    , prreShardId

    -- * PutRecordsRequestEntry
    , PutRecordsRequestEntry
    , putRecordsRequestEntry
    , prreData
    , prreExplicitHashKey
    , prrePartitionKey

    -- * StreamStatus
    , StreamStatus (..)

    -- * HashKeyRange
    , HashKeyRange
    , hashKeyRange
    , hkrEndingHashKey
    , hkrStartingHashKey

    -- * Record
    , Record
    , record
    , rData
    , rPartitionKey
    , rSequenceNumber

    -- * SequenceNumberRange
    , SequenceNumberRange
    , sequenceNumberRange
    , snrEndingSequenceNumber
    , snrStartingSequenceNumber

    -- * ShardIteratorType
    , ShardIteratorType (..)
    ) where

import Network.AWS.Prelude
import Network.AWS.Signing
import qualified GHC.Exts

-- | Version @2013-12-02@ of the Amazon Kinesis service.
data Kinesis

instance AWSService Kinesis where
    type Sg Kinesis = V4
    type Er Kinesis = JSONError

    service = service'
      where
        service' :: Service Kinesis
        service' = Service
            { _svcAbbrev       = "Kinesis"
            , _svcPrefix       = "kinesis"
            , _svcVersion      = "2013-12-02"
            , _svcTargetPrefix = Just "Kinesis_20131202"
            , _svcJSONVersion  = Just "1.1"
            , _svcHandle       = handle
            , _svcRetry        = retry
            }

        handle :: Status
               -> Maybe (LazyByteString -> ServiceError JSONError)
        handle = jsonError statusSuccess service'

        retry :: Retry Kinesis
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

data Shard = Shard
    { _sAdjacentParentShardId :: Maybe Text
    , _sHashKeyRange          :: HashKeyRange
    , _sParentShardId         :: Maybe Text
    , _sSequenceNumberRange   :: SequenceNumberRange
    , _sShardId               :: Text
    } deriving (Eq, Show)

-- | 'Shard' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'sAdjacentParentShardId' @::@ 'Maybe' 'Text'
--
-- * 'sHashKeyRange' @::@ 'HashKeyRange'
--
-- * 'sParentShardId' @::@ 'Maybe' 'Text'
--
-- * 'sSequenceNumberRange' @::@ 'SequenceNumberRange'
--
-- * 'sShardId' @::@ 'Text'
--
shard :: Text -- ^ 'sShardId'
      -> HashKeyRange -- ^ 'sHashKeyRange'
      -> SequenceNumberRange -- ^ 'sSequenceNumberRange'
      -> Shard
shard p1 p2 p3 = Shard
    { _sShardId               = p1
    , _sHashKeyRange          = p2
    , _sSequenceNumberRange   = p3
    , _sParentShardId         = Nothing
    , _sAdjacentParentShardId = Nothing
    }

-- | The shard Id of the shard adjacent to the shard's parent.
sAdjacentParentShardId :: Lens' Shard (Maybe Text)
sAdjacentParentShardId =
    lens _sAdjacentParentShardId (\s a -> s { _sAdjacentParentShardId = a })

-- | The range of possible hash key values for the shard, which is a set of
-- ordered contiguous positive integers.
sHashKeyRange :: Lens' Shard HashKeyRange
sHashKeyRange = lens _sHashKeyRange (\s a -> s { _sHashKeyRange = a })

-- | The shard Id of the shard's parent.
sParentShardId :: Lens' Shard (Maybe Text)
sParentShardId = lens _sParentShardId (\s a -> s { _sParentShardId = a })

-- | The range of possible sequence numbers for the shard.
sSequenceNumberRange :: Lens' Shard SequenceNumberRange
sSequenceNumberRange =
    lens _sSequenceNumberRange (\s a -> s { _sSequenceNumberRange = a })

-- | The unique identifier of the shard within the Amazon Kinesis stream.
sShardId :: Lens' Shard Text
sShardId = lens _sShardId (\s a -> s { _sShardId = a })

instance FromJSON Shard where
    parseJSON = withObject "Shard" $ \o -> Shard
        <$> o .:? "AdjacentParentShardId"
        <*> o .:  "HashKeyRange"
        <*> o .:? "ParentShardId"
        <*> o .:  "SequenceNumberRange"
        <*> o .:  "ShardId"

instance ToJSON Shard where
    toJSON Shard{..} = object
        [ "ShardId"               .= _sShardId
        , "ParentShardId"         .= _sParentShardId
        , "AdjacentParentShardId" .= _sAdjacentParentShardId
        , "HashKeyRange"          .= _sHashKeyRange
        , "SequenceNumberRange"   .= _sSequenceNumberRange
        ]

data Tag = Tag
    { _tagKey   :: Text
    , _tagValue :: Maybe Text
    } deriving (Eq, Ord, Show)

-- | 'Tag' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'tagKey' @::@ 'Text'
--
-- * 'tagValue' @::@ 'Maybe' 'Text'
--
tag :: Text -- ^ 'tagKey'
    -> Tag
tag p1 = Tag
    { _tagKey   = p1
    , _tagValue = Nothing
    }

-- | A unique identifier for the tag. Maximum length: 128 characters. Valid
-- characters: Unicode letters, digits, white space, _ . / = + - % @
tagKey :: Lens' Tag Text
tagKey = lens _tagKey (\s a -> s { _tagKey = a })

-- | An optional string, typically used to describe or define the tag. Maximum
-- length: 256 characters. Valid characters: Unicode letters, digits, white
-- space, _ . / = + - % @
tagValue :: Lens' Tag (Maybe Text)
tagValue = lens _tagValue (\s a -> s { _tagValue = a })

instance FromJSON Tag where
    parseJSON = withObject "Tag" $ \o -> Tag
        <$> o .:  "Key"
        <*> o .:? "Value"

instance ToJSON Tag where
    toJSON Tag{..} = object
        [ "Key"   .= _tagKey
        , "Value" .= _tagValue
        ]

data StreamDescription = StreamDescription
    { _sdHasMoreShards :: Bool
    , _sdShards        :: List "Shards" Shard
    , _sdStreamARN     :: Text
    , _sdStreamName    :: Text
    , _sdStreamStatus  :: StreamStatus
    } deriving (Eq, Show)

-- | 'StreamDescription' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'sdHasMoreShards' @::@ 'Bool'
--
-- * 'sdShards' @::@ ['Shard']
--
-- * 'sdStreamARN' @::@ 'Text'
--
-- * 'sdStreamName' @::@ 'Text'
--
-- * 'sdStreamStatus' @::@ 'StreamStatus'
--
streamDescription :: Text -- ^ 'sdStreamName'
                  -> Text -- ^ 'sdStreamARN'
                  -> StreamStatus -- ^ 'sdStreamStatus'
                  -> Bool -- ^ 'sdHasMoreShards'
                  -> StreamDescription
streamDescription p1 p2 p3 p4 = StreamDescription
    { _sdStreamName    = p1
    , _sdStreamARN     = p2
    , _sdStreamStatus  = p3
    , _sdHasMoreShards = p4
    , _sdShards        = mempty
    }

-- | If set to 'true', more shards in the stream are available to describe.
sdHasMoreShards :: Lens' StreamDescription Bool
sdHasMoreShards = lens _sdHasMoreShards (\s a -> s { _sdHasMoreShards = a })

-- | The shards that comprise the stream.
sdShards :: Lens' StreamDescription [Shard]
sdShards = lens _sdShards (\s a -> s { _sdShards = a }) . _List

-- | The Amazon Resource Name (ARN) for the stream being described.
sdStreamARN :: Lens' StreamDescription Text
sdStreamARN = lens _sdStreamARN (\s a -> s { _sdStreamARN = a })

-- | The name of the stream being described.
sdStreamName :: Lens' StreamDescription Text
sdStreamName = lens _sdStreamName (\s a -> s { _sdStreamName = a })

-- | The current status of the stream being described.
--
-- The stream status is one of the following states:
--
-- 'CREATING' - The stream is being created. Amazon Kinesis immediately returns
-- and sets 'StreamStatus' to 'CREATING'.  'DELETING' - The stream is being deleted.
-- The specified stream is in the 'DELETING' state until Amazon Kinesis completes
-- the deletion.  'ACTIVE' - The stream exists and is ready for read and write
-- operations or deletion. You should perform read and write operations only on
-- an 'ACTIVE' stream.  'UPDATING' - Shards in the stream are being merged or split.
-- Read and write operations continue to work while the stream is in the 'UPDATING'
-- state.
sdStreamStatus :: Lens' StreamDescription StreamStatus
sdStreamStatus = lens _sdStreamStatus (\s a -> s { _sdStreamStatus = a })

instance FromJSON StreamDescription where
    parseJSON = withObject "StreamDescription" $ \o -> StreamDescription
        <$> o .:  "HasMoreShards"
        <*> o .:? "Shards" .!= mempty
        <*> o .:  "StreamARN"
        <*> o .:  "StreamName"
        <*> o .:  "StreamStatus"

instance ToJSON StreamDescription where
    toJSON StreamDescription{..} = object
        [ "StreamName"    .= _sdStreamName
        , "StreamARN"     .= _sdStreamARN
        , "StreamStatus"  .= _sdStreamStatus
        , "Shards"        .= _sdShards
        , "HasMoreShards" .= _sdHasMoreShards
        ]

data PutRecordsResultEntry = PutRecordsResultEntry
    { _prreErrorCode      :: Maybe Text
    , _prreErrorMessage   :: Maybe Text
    , _prreSequenceNumber :: Maybe Text
    , _prreShardId        :: Maybe Text
    } deriving (Eq, Ord, Show)

-- | 'PutRecordsResultEntry' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'prreErrorCode' @::@ 'Maybe' 'Text'
--
-- * 'prreErrorMessage' @::@ 'Maybe' 'Text'
--
-- * 'prreSequenceNumber' @::@ 'Maybe' 'Text'
--
-- * 'prreShardId' @::@ 'Maybe' 'Text'
--
putRecordsResultEntry :: PutRecordsResultEntry
putRecordsResultEntry = PutRecordsResultEntry
    { _prreSequenceNumber = Nothing
    , _prreShardId        = Nothing
    , _prreErrorCode      = Nothing
    , _prreErrorMessage   = Nothing
    }

-- | The error code for an individual record result. 'ErrorCodes' can be either 'ProvisionedThroughputExceededException' or 'InternalFailure'.
prreErrorCode :: Lens' PutRecordsResultEntry (Maybe Text)
prreErrorCode = lens _prreErrorCode (\s a -> s { _prreErrorCode = a })

-- | The error message for an individual record result. An 'ErrorCode' value of 'ProvisionedThroughputExceededException' has an error message that includes the account ID, stream name, and shard
-- ID. An 'ErrorCode' value of 'InternalFailure' has the error message '"InternalService Failure"'.
prreErrorMessage :: Lens' PutRecordsResultEntry (Maybe Text)
prreErrorMessage = lens _prreErrorMessage (\s a -> s { _prreErrorMessage = a })

-- | The sequence number for an individual record result.
prreSequenceNumber :: Lens' PutRecordsResultEntry (Maybe Text)
prreSequenceNumber =
    lens _prreSequenceNumber (\s a -> s { _prreSequenceNumber = a })

-- | The shard ID for an individual record result.
prreShardId :: Lens' PutRecordsResultEntry (Maybe Text)
prreShardId = lens _prreShardId (\s a -> s { _prreShardId = a })

instance FromJSON PutRecordsResultEntry where
    parseJSON = withObject "PutRecordsResultEntry" $ \o -> PutRecordsResultEntry
        <$> o .:? "ErrorCode"
        <*> o .:? "ErrorMessage"
        <*> o .:? "SequenceNumber"
        <*> o .:? "ShardId"

instance ToJSON PutRecordsResultEntry where
    toJSON PutRecordsResultEntry{..} = object
        [ "SequenceNumber" .= _prreSequenceNumber
        , "ShardId"        .= _prreShardId
        , "ErrorCode"      .= _prreErrorCode
        , "ErrorMessage"   .= _prreErrorMessage
        ]

data PutRecordsRequestEntry = PutRecordsRequestEntry
    { _prreData            :: Base64
    , _prreExplicitHashKey :: Maybe Text
    , _prrePartitionKey    :: Text
    } deriving (Eq, Show)

-- | 'PutRecordsRequestEntry' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'prreData' @::@ 'Base64'
--
-- * 'prreExplicitHashKey' @::@ 'Maybe' 'Text'
--
-- * 'prrePartitionKey' @::@ 'Text'
--
putRecordsRequestEntry :: Base64 -- ^ 'prreData'
                       -> Text -- ^ 'prrePartitionKey'
                       -> PutRecordsRequestEntry
putRecordsRequestEntry p1 p2 = PutRecordsRequestEntry
    { _prreData            = p1
    , _prrePartitionKey    = p2
    , _prreExplicitHashKey = Nothing
    }

-- | The data blob to put into the record, which is base64-encoded when the blob
-- is serialized. The maximum size of the data blob (the payload before
-- base64-encoding) is 50 kilobytes (KB)
prreData :: Lens' PutRecordsRequestEntry Base64
prreData = lens _prreData (\s a -> s { _prreData = a })

-- | The hash value used to determine explicitly the shard that the data record is
-- assigned to by overriding the partition key hash.
prreExplicitHashKey :: Lens' PutRecordsRequestEntry (Maybe Text)
prreExplicitHashKey =
    lens _prreExplicitHashKey (\s a -> s { _prreExplicitHashKey = a })

-- | Determines which shard in the stream the data record is assigned to.
-- Partition keys are Unicode strings with a maximum length limit of 256 bytes.
-- Amazon Kinesis uses the partition key as input to a hash function that maps
-- the partition key and associated data to a specific shard. Specifically, an
-- MD5 hash function is used to map partition keys to 128-bit integer values and
-- to map associated data records to shards. As a result of this hashing
-- mechanism, all data records with the same partition key map to the same shard
-- within the stream.
prrePartitionKey :: Lens' PutRecordsRequestEntry Text
prrePartitionKey = lens _prrePartitionKey (\s a -> s { _prrePartitionKey = a })

instance FromJSON PutRecordsRequestEntry where
    parseJSON = withObject "PutRecordsRequestEntry" $ \o -> PutRecordsRequestEntry
        <$> o .:  "Data"
        <*> o .:? "ExplicitHashKey"
        <*> o .:  "PartitionKey"

instance ToJSON PutRecordsRequestEntry where
    toJSON PutRecordsRequestEntry{..} = object
        [ "Data"            .= _prreData
        , "ExplicitHashKey" .= _prreExplicitHashKey
        , "PartitionKey"    .= _prrePartitionKey
        ]

data StreamStatus
    = Active   -- ^ ACTIVE
    | Creating -- ^ CREATING
    | Deleting -- ^ DELETING
    | Updating -- ^ UPDATING
      deriving (Eq, Ord, Show, Generic, Enum)

instance Hashable StreamStatus

instance FromText StreamStatus where
    parser = takeText >>= \case
        "ACTIVE"   -> pure Active
        "CREATING" -> pure Creating
        "DELETING" -> pure Deleting
        "UPDATING" -> pure Updating
        e          -> fail $
            "Failure parsing StreamStatus from " ++ show e

instance ToText StreamStatus where
    toText = \case
        Active   -> "ACTIVE"
        Creating -> "CREATING"
        Deleting -> "DELETING"
        Updating -> "UPDATING"

instance ToByteString StreamStatus
instance ToHeader     StreamStatus
instance ToQuery      StreamStatus

instance FromJSON StreamStatus where
    parseJSON = parseJSONText "StreamStatus"

instance ToJSON StreamStatus where
    toJSON = toJSONText

data HashKeyRange = HashKeyRange
    { _hkrEndingHashKey   :: Text
    , _hkrStartingHashKey :: Text
    } deriving (Eq, Ord, Show)

-- | 'HashKeyRange' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'hkrEndingHashKey' @::@ 'Text'
--
-- * 'hkrStartingHashKey' @::@ 'Text'
--
hashKeyRange :: Text -- ^ 'hkrStartingHashKey'
             -> Text -- ^ 'hkrEndingHashKey'
             -> HashKeyRange
hashKeyRange p1 p2 = HashKeyRange
    { _hkrStartingHashKey = p1
    , _hkrEndingHashKey   = p2
    }

-- | The ending hash key of the hash key range.
hkrEndingHashKey :: Lens' HashKeyRange Text
hkrEndingHashKey = lens _hkrEndingHashKey (\s a -> s { _hkrEndingHashKey = a })

-- | The starting hash key of the hash key range.
hkrStartingHashKey :: Lens' HashKeyRange Text
hkrStartingHashKey =
    lens _hkrStartingHashKey (\s a -> s { _hkrStartingHashKey = a })

instance FromJSON HashKeyRange where
    parseJSON = withObject "HashKeyRange" $ \o -> HashKeyRange
        <$> o .:  "EndingHashKey"
        <*> o .:  "StartingHashKey"

instance ToJSON HashKeyRange where
    toJSON HashKeyRange{..} = object
        [ "StartingHashKey" .= _hkrStartingHashKey
        , "EndingHashKey"   .= _hkrEndingHashKey
        ]

data Record = Record
    { _rData           :: Base64
    , _rPartitionKey   :: Text
    , _rSequenceNumber :: Text
    } deriving (Eq, Show)

-- | 'Record' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'rData' @::@ 'Base64'
--
-- * 'rPartitionKey' @::@ 'Text'
--
-- * 'rSequenceNumber' @::@ 'Text'
--
record :: Text -- ^ 'rSequenceNumber'
       -> Base64 -- ^ 'rData'
       -> Text -- ^ 'rPartitionKey'
       -> Record
record p1 p2 p3 = Record
    { _rSequenceNumber = p1
    , _rData           = p2
    , _rPartitionKey   = p3
    }

-- | The data blob. The data in the blob is both opaque and immutable to the
-- Amazon Kinesis service, which does not inspect, interpret, or change the data
-- in the blob in any way. The maximum size of the data blob (the payload before
-- base64-encoding) is 50 kilobytes (KB)
rData :: Lens' Record Base64
rData = lens _rData (\s a -> s { _rData = a })

-- | Identifies which shard in the stream the data record is assigned to.
rPartitionKey :: Lens' Record Text
rPartitionKey = lens _rPartitionKey (\s a -> s { _rPartitionKey = a })

-- | The unique identifier for the record in the Amazon Kinesis stream.
rSequenceNumber :: Lens' Record Text
rSequenceNumber = lens _rSequenceNumber (\s a -> s { _rSequenceNumber = a })

instance FromJSON Record where
    parseJSON = withObject "Record" $ \o -> Record
        <$> o .:  "Data"
        <*> o .:  "PartitionKey"
        <*> o .:  "SequenceNumber"

instance ToJSON Record where
    toJSON Record{..} = object
        [ "SequenceNumber" .= _rSequenceNumber
        , "Data"           .= _rData
        , "PartitionKey"   .= _rPartitionKey
        ]

data SequenceNumberRange = SequenceNumberRange
    { _snrEndingSequenceNumber   :: Maybe Text
    , _snrStartingSequenceNumber :: Text
    } deriving (Eq, Ord, Show)

-- | 'SequenceNumberRange' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'snrEndingSequenceNumber' @::@ 'Maybe' 'Text'
--
-- * 'snrStartingSequenceNumber' @::@ 'Text'
--
sequenceNumberRange :: Text -- ^ 'snrStartingSequenceNumber'
                    -> SequenceNumberRange
sequenceNumberRange p1 = SequenceNumberRange
    { _snrStartingSequenceNumber = p1
    , _snrEndingSequenceNumber   = Nothing
    }

-- | The ending sequence number for the range. Shards that are in the OPEN state
-- have an ending sequence number of 'null'.
snrEndingSequenceNumber :: Lens' SequenceNumberRange (Maybe Text)
snrEndingSequenceNumber =
    lens _snrEndingSequenceNumber (\s a -> s { _snrEndingSequenceNumber = a })

-- | The starting sequence number for the range.
snrStartingSequenceNumber :: Lens' SequenceNumberRange Text
snrStartingSequenceNumber =
    lens _snrStartingSequenceNumber
        (\s a -> s { _snrStartingSequenceNumber = a })

instance FromJSON SequenceNumberRange where
    parseJSON = withObject "SequenceNumberRange" $ \o -> SequenceNumberRange
        <$> o .:? "EndingSequenceNumber"
        <*> o .:  "StartingSequenceNumber"

instance ToJSON SequenceNumberRange where
    toJSON SequenceNumberRange{..} = object
        [ "StartingSequenceNumber" .= _snrStartingSequenceNumber
        , "EndingSequenceNumber"   .= _snrEndingSequenceNumber
        ]

data ShardIteratorType
    = AfterSequenceNumber -- ^ AFTER_SEQUENCE_NUMBER
    | AtSequenceNumber    -- ^ AT_SEQUENCE_NUMBER
    | Latest              -- ^ LATEST
    | TrimHorizon         -- ^ TRIM_HORIZON
      deriving (Eq, Ord, Show, Generic, Enum)

instance Hashable ShardIteratorType

instance FromText ShardIteratorType where
    parser = takeText >>= \case
        "AFTER_SEQUENCE_NUMBER" -> pure AfterSequenceNumber
        "AT_SEQUENCE_NUMBER"    -> pure AtSequenceNumber
        "LATEST"                -> pure Latest
        "TRIM_HORIZON"          -> pure TrimHorizon
        e                       -> fail $
            "Failure parsing ShardIteratorType from " ++ show e

instance ToText ShardIteratorType where
    toText = \case
        AfterSequenceNumber -> "AFTER_SEQUENCE_NUMBER"
        AtSequenceNumber    -> "AT_SEQUENCE_NUMBER"
        Latest              -> "LATEST"
        TrimHorizon         -> "TRIM_HORIZON"

instance ToByteString ShardIteratorType
instance ToHeader     ShardIteratorType
instance ToQuery      ShardIteratorType

instance FromJSON ShardIteratorType where
    parseJSON = parseJSONText "ShardIteratorType"

instance ToJSON ShardIteratorType where
    toJSON = toJSONText

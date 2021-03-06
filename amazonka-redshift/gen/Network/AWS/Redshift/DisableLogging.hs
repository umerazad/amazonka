{-# LANGUAGE DataKinds                   #-}
{-# LANGUAGE DeriveGeneric               #-}
{-# LANGUAGE FlexibleInstances           #-}
{-# LANGUAGE GeneralizedNewtypeDeriving  #-}
{-# LANGUAGE LambdaCase                  #-}
{-# LANGUAGE NoImplicitPrelude           #-}
{-# LANGUAGE OverloadedStrings           #-}
{-# LANGUAGE RecordWildCards             #-}
{-# LANGUAGE TypeFamilies                #-}

{-# OPTIONS_GHC -fno-warn-unused-imports #-}

-- Module      : Network.AWS.Redshift.DisableLogging
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

-- | Stops logging information, such as queries and connection attempts, for the
-- specified Amazon Redshift cluster.
--
-- <http://docs.aws.amazon.com/redshift/latest/APIReference/API_DisableLogging.html>
module Network.AWS.Redshift.DisableLogging
    (
    -- * Request
      DisableLogging
    -- ** Request constructor
    , disableLogging
    -- ** Request lenses
    , dlClusterIdentifier

    -- * Response
    , DisableLoggingResponse
    -- ** Response constructor
    , disableLoggingResponse
    -- ** Response lenses
    , dlrBucketName
    , dlrLastFailureMessage
    , dlrLastFailureTime
    , dlrLastSuccessfulDeliveryTime
    , dlrLoggingEnabled
    , dlrS3KeyPrefix
    ) where

import Network.AWS.Prelude
import Network.AWS.Request.Query
import Network.AWS.Redshift.Types
import qualified GHC.Exts

newtype DisableLogging = DisableLogging
    { _dlClusterIdentifier :: Text
    } deriving (Eq, Ord, Show, Monoid, IsString)

-- | 'DisableLogging' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'dlClusterIdentifier' @::@ 'Text'
--
disableLogging :: Text -- ^ 'dlClusterIdentifier'
               -> DisableLogging
disableLogging p1 = DisableLogging
    { _dlClusterIdentifier = p1
    }

-- | The identifier of the cluster on which logging is to be stopped.
--
-- Example: 'examplecluster'
dlClusterIdentifier :: Lens' DisableLogging Text
dlClusterIdentifier =
    lens _dlClusterIdentifier (\s a -> s { _dlClusterIdentifier = a })

data DisableLoggingResponse = DisableLoggingResponse
    { _dlrBucketName                 :: Maybe Text
    , _dlrLastFailureMessage         :: Maybe Text
    , _dlrLastFailureTime            :: Maybe ISO8601
    , _dlrLastSuccessfulDeliveryTime :: Maybe ISO8601
    , _dlrLoggingEnabled             :: Maybe Bool
    , _dlrS3KeyPrefix                :: Maybe Text
    } deriving (Eq, Ord, Show)

-- | 'DisableLoggingResponse' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'dlrBucketName' @::@ 'Maybe' 'Text'
--
-- * 'dlrLastFailureMessage' @::@ 'Maybe' 'Text'
--
-- * 'dlrLastFailureTime' @::@ 'Maybe' 'UTCTime'
--
-- * 'dlrLastSuccessfulDeliveryTime' @::@ 'Maybe' 'UTCTime'
--
-- * 'dlrLoggingEnabled' @::@ 'Maybe' 'Bool'
--
-- * 'dlrS3KeyPrefix' @::@ 'Maybe' 'Text'
--
disableLoggingResponse :: DisableLoggingResponse
disableLoggingResponse = DisableLoggingResponse
    { _dlrLoggingEnabled             = Nothing
    , _dlrBucketName                 = Nothing
    , _dlrS3KeyPrefix                = Nothing
    , _dlrLastSuccessfulDeliveryTime = Nothing
    , _dlrLastFailureTime            = Nothing
    , _dlrLastFailureMessage         = Nothing
    }

-- | The name of the S3 bucket where the log files are stored.
dlrBucketName :: Lens' DisableLoggingResponse (Maybe Text)
dlrBucketName = lens _dlrBucketName (\s a -> s { _dlrBucketName = a })

-- | The message indicating that logs failed to be delivered.
dlrLastFailureMessage :: Lens' DisableLoggingResponse (Maybe Text)
dlrLastFailureMessage =
    lens _dlrLastFailureMessage (\s a -> s { _dlrLastFailureMessage = a })

-- | The last time when logs failed to be delivered.
dlrLastFailureTime :: Lens' DisableLoggingResponse (Maybe UTCTime)
dlrLastFailureTime =
    lens _dlrLastFailureTime (\s a -> s { _dlrLastFailureTime = a })
        . mapping _Time

-- | The last time when logs were delivered.
dlrLastSuccessfulDeliveryTime :: Lens' DisableLoggingResponse (Maybe UTCTime)
dlrLastSuccessfulDeliveryTime =
    lens _dlrLastSuccessfulDeliveryTime
        (\s a -> s { _dlrLastSuccessfulDeliveryTime = a })
            . mapping _Time

-- | 'true' if logging is on, 'false' if logging is off.
dlrLoggingEnabled :: Lens' DisableLoggingResponse (Maybe Bool)
dlrLoggingEnabled =
    lens _dlrLoggingEnabled (\s a -> s { _dlrLoggingEnabled = a })

-- | The prefix applied to the log file names.
dlrS3KeyPrefix :: Lens' DisableLoggingResponse (Maybe Text)
dlrS3KeyPrefix = lens _dlrS3KeyPrefix (\s a -> s { _dlrS3KeyPrefix = a })

instance ToPath DisableLogging where
    toPath = const "/"

instance ToQuery DisableLogging where
    toQuery DisableLogging{..} = mconcat
        [ "ClusterIdentifier" =? _dlClusterIdentifier
        ]

instance ToHeaders DisableLogging

instance AWSRequest DisableLogging where
    type Sv DisableLogging = Redshift
    type Rs DisableLogging = DisableLoggingResponse

    request  = post "DisableLogging"
    response = xmlResponse

instance FromXML DisableLoggingResponse where
    parseXML = withElement "DisableLoggingResult" $ \x -> DisableLoggingResponse
        <$> x .@? "BucketName"
        <*> x .@? "LastFailureMessage"
        <*> x .@? "LastFailureTime"
        <*> x .@? "LastSuccessfulDeliveryTime"
        <*> x .@? "LoggingEnabled"
        <*> x .@? "S3KeyPrefix"

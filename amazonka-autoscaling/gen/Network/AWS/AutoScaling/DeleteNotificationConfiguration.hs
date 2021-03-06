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

-- Module      : Network.AWS.AutoScaling.DeleteNotificationConfiguration
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

-- | Deletes the specified notification.
--
-- <http://docs.aws.amazon.com/AutoScaling/latest/APIReference/API_DeleteNotificationConfiguration.html>
module Network.AWS.AutoScaling.DeleteNotificationConfiguration
    (
    -- * Request
      DeleteNotificationConfiguration
    -- ** Request constructor
    , deleteNotificationConfiguration
    -- ** Request lenses
    , dncAutoScalingGroupName
    , dncTopicARN

    -- * Response
    , DeleteNotificationConfigurationResponse
    -- ** Response constructor
    , deleteNotificationConfigurationResponse
    ) where

import Network.AWS.Prelude
import Network.AWS.Request.Query
import Network.AWS.AutoScaling.Types
import qualified GHC.Exts

data DeleteNotificationConfiguration = DeleteNotificationConfiguration
    { _dncAutoScalingGroupName :: Text
    , _dncTopicARN             :: Text
    } deriving (Eq, Ord, Show)

-- | 'DeleteNotificationConfiguration' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'dncAutoScalingGroupName' @::@ 'Text'
--
-- * 'dncTopicARN' @::@ 'Text'
--
deleteNotificationConfiguration :: Text -- ^ 'dncAutoScalingGroupName'
                                -> Text -- ^ 'dncTopicARN'
                                -> DeleteNotificationConfiguration
deleteNotificationConfiguration p1 p2 = DeleteNotificationConfiguration
    { _dncAutoScalingGroupName = p1
    , _dncTopicARN             = p2
    }

-- | The name of the Auto Scaling group.
dncAutoScalingGroupName :: Lens' DeleteNotificationConfiguration Text
dncAutoScalingGroupName =
    lens _dncAutoScalingGroupName (\s a -> s { _dncAutoScalingGroupName = a })

-- | The Amazon Resource Name (ARN) of the Amazon Simple Notification Service
-- (SNS) topic.
dncTopicARN :: Lens' DeleteNotificationConfiguration Text
dncTopicARN = lens _dncTopicARN (\s a -> s { _dncTopicARN = a })

data DeleteNotificationConfigurationResponse = DeleteNotificationConfigurationResponse
    deriving (Eq, Ord, Show, Generic)

-- | 'DeleteNotificationConfigurationResponse' constructor.
deleteNotificationConfigurationResponse :: DeleteNotificationConfigurationResponse
deleteNotificationConfigurationResponse = DeleteNotificationConfigurationResponse

instance ToPath DeleteNotificationConfiguration where
    toPath = const "/"

instance ToQuery DeleteNotificationConfiguration where
    toQuery DeleteNotificationConfiguration{..} = mconcat
        [ "AutoScalingGroupName" =? _dncAutoScalingGroupName
        , "TopicARN"             =? _dncTopicARN
        ]

instance ToHeaders DeleteNotificationConfiguration

instance AWSRequest DeleteNotificationConfiguration where
    type Sv DeleteNotificationConfiguration = AutoScaling
    type Rs DeleteNotificationConfiguration = DeleteNotificationConfigurationResponse

    request  = post "DeleteNotificationConfiguration"
    response = nullResponse DeleteNotificationConfigurationResponse

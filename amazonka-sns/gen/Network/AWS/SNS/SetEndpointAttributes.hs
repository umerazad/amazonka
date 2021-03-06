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

-- Module      : Network.AWS.SNS.SetEndpointAttributes
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

-- | Sets the attributes for an endpoint for a device on one of the supported push
-- notification services, such as GCM and APNS. For more information, see <http://docs.aws.amazon.com/sns/latest/dg/SNSMobilePush.html UsingAmazon SNS Mobile Push Notifications>.
--
-- <http://docs.aws.amazon.com/sns/latest/api/API_SetEndpointAttributes.html>
module Network.AWS.SNS.SetEndpointAttributes
    (
    -- * Request
      SetEndpointAttributes
    -- ** Request constructor
    , setEndpointAttributes
    -- ** Request lenses
    , seaAttributes
    , seaEndpointArn

    -- * Response
    , SetEndpointAttributesResponse
    -- ** Response constructor
    , setEndpointAttributesResponse
    ) where

import Network.AWS.Prelude
import Network.AWS.Request.Query
import Network.AWS.SNS.Types
import qualified GHC.Exts

data SetEndpointAttributes = SetEndpointAttributes
    { _seaAttributes  :: EMap "entry" "key" "value" Text Text
    , _seaEndpointArn :: Text
    } deriving (Eq, Show)

-- | 'SetEndpointAttributes' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'seaAttributes' @::@ 'HashMap' 'Text' 'Text'
--
-- * 'seaEndpointArn' @::@ 'Text'
--
setEndpointAttributes :: Text -- ^ 'seaEndpointArn'
                      -> SetEndpointAttributes
setEndpointAttributes p1 = SetEndpointAttributes
    { _seaEndpointArn = p1
    , _seaAttributes  = mempty
    }

-- | A map of the endpoint attributes. Attributes in this map include the
-- following:
--
-- 'CustomUserData' -- arbitrary user data to associate with the endpoint.
-- Amazon SNS does not use this data. The data must be in UTF-8 format and less
-- than 2KB.  'Enabled' -- flag that enables/disables delivery to the endpoint.
-- Amazon SNS will set this to false when a notification service indicates to
-- Amazon SNS that the endpoint is invalid. Users can set it back to true,
-- typically after updating Token.  'Token' -- device token, also referred to as a
-- registration id, for an app and mobile device. This is returned from the
-- notification service when an app and mobile device are registered with the
-- notification service.
seaAttributes :: Lens' SetEndpointAttributes (HashMap Text Text)
seaAttributes = lens _seaAttributes (\s a -> s { _seaAttributes = a }) . _EMap

-- | EndpointArn used for SetEndpointAttributes action.
seaEndpointArn :: Lens' SetEndpointAttributes Text
seaEndpointArn = lens _seaEndpointArn (\s a -> s { _seaEndpointArn = a })

data SetEndpointAttributesResponse = SetEndpointAttributesResponse
    deriving (Eq, Ord, Show, Generic)

-- | 'SetEndpointAttributesResponse' constructor.
setEndpointAttributesResponse :: SetEndpointAttributesResponse
setEndpointAttributesResponse = SetEndpointAttributesResponse

instance ToPath SetEndpointAttributes where
    toPath = const "/"

instance ToQuery SetEndpointAttributes where
    toQuery SetEndpointAttributes{..} = mconcat
        [ "Attributes"  =? _seaAttributes
        , "EndpointArn" =? _seaEndpointArn
        ]

instance ToHeaders SetEndpointAttributes

instance AWSRequest SetEndpointAttributes where
    type Sv SetEndpointAttributes = SNS
    type Rs SetEndpointAttributes = SetEndpointAttributesResponse

    request  = post "SetEndpointAttributes"
    response = nullResponse SetEndpointAttributesResponse

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

-- Module      : Network.AWS.SNS.GetEndpointAttributes
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

-- | Retrieves the endpoint attributes for a device on one of the supported push
-- notification services, such as GCM and APNS. For more information, see <http://docs.aws.amazon.com/sns/latest/dg/SNSMobilePush.html UsingAmazon SNS Mobile Push Notifications>.
--
-- <http://docs.aws.amazon.com/sns/latest/api/API_GetEndpointAttributes.html>
module Network.AWS.SNS.GetEndpointAttributes
    (
    -- * Request
      GetEndpointAttributes
    -- ** Request constructor
    , getEndpointAttributes
    -- ** Request lenses
    , geaEndpointArn

    -- * Response
    , GetEndpointAttributesResponse
    -- ** Response constructor
    , getEndpointAttributesResponse
    -- ** Response lenses
    , gearAttributes
    ) where

import Network.AWS.Prelude
import Network.AWS.Request.Query
import Network.AWS.SNS.Types
import qualified GHC.Exts

newtype GetEndpointAttributes = GetEndpointAttributes
    { _geaEndpointArn :: Text
    } deriving (Eq, Ord, Show, Monoid, IsString)

-- | 'GetEndpointAttributes' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'geaEndpointArn' @::@ 'Text'
--
getEndpointAttributes :: Text -- ^ 'geaEndpointArn'
                      -> GetEndpointAttributes
getEndpointAttributes p1 = GetEndpointAttributes
    { _geaEndpointArn = p1
    }

-- | EndpointArn for GetEndpointAttributes input.
geaEndpointArn :: Lens' GetEndpointAttributes Text
geaEndpointArn = lens _geaEndpointArn (\s a -> s { _geaEndpointArn = a })

newtype GetEndpointAttributesResponse = GetEndpointAttributesResponse
    { _gearAttributes :: EMap "entry" "key" "value" Text Text
    } deriving (Eq, Show, Monoid, Semigroup)

-- | 'GetEndpointAttributesResponse' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'gearAttributes' @::@ 'HashMap' 'Text' 'Text'
--
getEndpointAttributesResponse :: GetEndpointAttributesResponse
getEndpointAttributesResponse = GetEndpointAttributesResponse
    { _gearAttributes = mempty
    }

-- | Attributes include the following:
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
gearAttributes :: Lens' GetEndpointAttributesResponse (HashMap Text Text)
gearAttributes = lens _gearAttributes (\s a -> s { _gearAttributes = a }) . _EMap

instance ToPath GetEndpointAttributes where
    toPath = const "/"

instance ToQuery GetEndpointAttributes where
    toQuery GetEndpointAttributes{..} = mconcat
        [ "EndpointArn" =? _geaEndpointArn
        ]

instance ToHeaders GetEndpointAttributes

instance AWSRequest GetEndpointAttributes where
    type Sv GetEndpointAttributes = SNS
    type Rs GetEndpointAttributes = GetEndpointAttributesResponse

    request  = post "GetEndpointAttributes"
    response = xmlResponse

instance FromXML GetEndpointAttributesResponse where
    parseXML = withElement "GetEndpointAttributesResult" $ \x -> GetEndpointAttributesResponse
        <$> x .@? "Attributes" .!@ mempty

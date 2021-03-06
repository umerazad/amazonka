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

-- Module      : Network.AWS.Route53.GetReusableDelegationSet
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

-- | To retrieve the reusable delegation set, send a 'GET' request to the '2013-04-01/delegationset//delegation set ID/ resource.
--
-- <http://docs.aws.amazon.com/Route53/latest/APIReference/API_GetReusableDelegationSet.html>
module Network.AWS.Route53.GetReusableDelegationSet
    (
    -- * Request
      GetReusableDelegationSet
    -- ** Request constructor
    , getReusableDelegationSet
    -- ** Request lenses
    , grdsId

    -- * Response
    , GetReusableDelegationSetResponse
    -- ** Response constructor
    , getReusableDelegationSetResponse
    -- ** Response lenses
    , grdsrDelegationSet
    ) where

import Network.AWS.Prelude
import Network.AWS.Request.RestXML
import Network.AWS.Route53.Types
import qualified GHC.Exts

newtype GetReusableDelegationSet = GetReusableDelegationSet
    { _grdsId :: Text
    } deriving (Eq, Ord, Show, Monoid, IsString)

-- | 'GetReusableDelegationSet' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'grdsId' @::@ 'Text'
--
getReusableDelegationSet :: Text -- ^ 'grdsId'
                         -> GetReusableDelegationSet
getReusableDelegationSet p1 = GetReusableDelegationSet
    { _grdsId = p1
    }

-- | The ID of the reusable delegation set for which you want to get a list of the
-- name server.
grdsId :: Lens' GetReusableDelegationSet Text
grdsId = lens _grdsId (\s a -> s { _grdsId = a })

newtype GetReusableDelegationSetResponse = GetReusableDelegationSetResponse
    { _grdsrDelegationSet :: DelegationSet
    } deriving (Eq, Show)

-- | 'GetReusableDelegationSetResponse' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'grdsrDelegationSet' @::@ 'DelegationSet'
--
getReusableDelegationSetResponse :: DelegationSet -- ^ 'grdsrDelegationSet'
                                 -> GetReusableDelegationSetResponse
getReusableDelegationSetResponse p1 = GetReusableDelegationSetResponse
    { _grdsrDelegationSet = p1
    }

-- | A complex type that contains the information about the nameservers for the
-- specified delegation set ID.
grdsrDelegationSet :: Lens' GetReusableDelegationSetResponse DelegationSet
grdsrDelegationSet =
    lens _grdsrDelegationSet (\s a -> s { _grdsrDelegationSet = a })

instance ToPath GetReusableDelegationSet where
    toPath GetReusableDelegationSet{..} = mconcat
        [ "/2013-04-01/delegationset/"
        , toText _grdsId
        ]

instance ToQuery GetReusableDelegationSet where
    toQuery = const mempty

instance ToHeaders GetReusableDelegationSet

instance ToXMLRoot GetReusableDelegationSet where
    toXMLRoot = const (namespaced ns "GetReusableDelegationSet" [])

instance ToXML GetReusableDelegationSet

instance AWSRequest GetReusableDelegationSet where
    type Sv GetReusableDelegationSet = Route53
    type Rs GetReusableDelegationSet = GetReusableDelegationSetResponse

    request  = get
    response = xmlResponse

instance FromXML GetReusableDelegationSetResponse where
    parseXML x = GetReusableDelegationSetResponse
        <$> x .@  "DelegationSet"

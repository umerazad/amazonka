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

-- Module      : Network.AWS.ELB.DeleteLoadBalancerPolicy
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

-- | Deletes a policy from the load balancer. The specified policy must not be
-- enabled for any listeners.
--
-- <http://docs.aws.amazon.com/ElasticLoadBalancing/latest/APIReference/API_DeleteLoadBalancerPolicy.html>
module Network.AWS.ELB.DeleteLoadBalancerPolicy
    (
    -- * Request
      DeleteLoadBalancerPolicy
    -- ** Request constructor
    , deleteLoadBalancerPolicy
    -- ** Request lenses
    , dlbp1LoadBalancerName
    , dlbp1PolicyName

    -- * Response
    , DeleteLoadBalancerPolicyResponse
    -- ** Response constructor
    , deleteLoadBalancerPolicyResponse
    ) where

import Network.AWS.Prelude
import Network.AWS.Request.Query
import Network.AWS.ELB.Types
import qualified GHC.Exts

data DeleteLoadBalancerPolicy = DeleteLoadBalancerPolicy
    { _dlbp1LoadBalancerName :: Text
    , _dlbp1PolicyName       :: Text
    } deriving (Eq, Ord, Show)

-- | 'DeleteLoadBalancerPolicy' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'dlbp1LoadBalancerName' @::@ 'Text'
--
-- * 'dlbp1PolicyName' @::@ 'Text'
--
deleteLoadBalancerPolicy :: Text -- ^ 'dlbp1LoadBalancerName'
                         -> Text -- ^ 'dlbp1PolicyName'
                         -> DeleteLoadBalancerPolicy
deleteLoadBalancerPolicy p1 p2 = DeleteLoadBalancerPolicy
    { _dlbp1LoadBalancerName = p1
    , _dlbp1PolicyName       = p2
    }

-- | The mnemonic name associated with the load balancer.
dlbp1LoadBalancerName :: Lens' DeleteLoadBalancerPolicy Text
dlbp1LoadBalancerName =
    lens _dlbp1LoadBalancerName (\s a -> s { _dlbp1LoadBalancerName = a })

-- | The mnemonic name for the policy being deleted.
dlbp1PolicyName :: Lens' DeleteLoadBalancerPolicy Text
dlbp1PolicyName = lens _dlbp1PolicyName (\s a -> s { _dlbp1PolicyName = a })

data DeleteLoadBalancerPolicyResponse = DeleteLoadBalancerPolicyResponse
    deriving (Eq, Ord, Show, Generic)

-- | 'DeleteLoadBalancerPolicyResponse' constructor.
deleteLoadBalancerPolicyResponse :: DeleteLoadBalancerPolicyResponse
deleteLoadBalancerPolicyResponse = DeleteLoadBalancerPolicyResponse

instance ToPath DeleteLoadBalancerPolicy where
    toPath = const "/"

instance ToQuery DeleteLoadBalancerPolicy where
    toQuery DeleteLoadBalancerPolicy{..} = mconcat
        [ "LoadBalancerName" =? _dlbp1LoadBalancerName
        , "PolicyName"       =? _dlbp1PolicyName
        ]

instance ToHeaders DeleteLoadBalancerPolicy

instance AWSRequest DeleteLoadBalancerPolicy where
    type Sv DeleteLoadBalancerPolicy = ELB
    type Rs DeleteLoadBalancerPolicy = DeleteLoadBalancerPolicyResponse

    request  = post "DeleteLoadBalancerPolicy"
    response = nullResponse DeleteLoadBalancerPolicyResponse

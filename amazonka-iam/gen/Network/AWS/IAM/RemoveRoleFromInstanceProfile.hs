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

-- Module      : Network.AWS.IAM.RemoveRoleFromInstanceProfile
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

-- | Removes the specified role from the specified instance profile.
--
-- Make sure you do not have any Amazon EC2 instances running with the role
-- you are about to remove from the instance profile. Removing a role from an
-- instance profile that is associated with a running instance will break any
-- applications running on the instance.   For more information about roles, go
-- to <http://docs.aws.amazon.com/IAM/latest/UserGuide/WorkingWithRoles.html Working with Roles>. For more information about instance profiles, go to <http://docs.aws.amazon.com/IAM/latest/UserGuide/AboutInstanceProfiles.html About Instance Profiles>.
--
-- <http://docs.aws.amazon.com/IAM/latest/APIReference/API_RemoveRoleFromInstanceProfile.html>
module Network.AWS.IAM.RemoveRoleFromInstanceProfile
    (
    -- * Request
      RemoveRoleFromInstanceProfile
    -- ** Request constructor
    , removeRoleFromInstanceProfile
    -- ** Request lenses
    , rrfipInstanceProfileName
    , rrfipRoleName

    -- * Response
    , RemoveRoleFromInstanceProfileResponse
    -- ** Response constructor
    , removeRoleFromInstanceProfileResponse
    ) where

import Network.AWS.Prelude
import Network.AWS.Request.Query
import Network.AWS.IAM.Types
import qualified GHC.Exts

data RemoveRoleFromInstanceProfile = RemoveRoleFromInstanceProfile
    { _rrfipInstanceProfileName :: Text
    , _rrfipRoleName            :: Text
    } deriving (Eq, Ord, Show)

-- | 'RemoveRoleFromInstanceProfile' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'rrfipInstanceProfileName' @::@ 'Text'
--
-- * 'rrfipRoleName' @::@ 'Text'
--
removeRoleFromInstanceProfile :: Text -- ^ 'rrfipInstanceProfileName'
                              -> Text -- ^ 'rrfipRoleName'
                              -> RemoveRoleFromInstanceProfile
removeRoleFromInstanceProfile p1 p2 = RemoveRoleFromInstanceProfile
    { _rrfipInstanceProfileName = p1
    , _rrfipRoleName            = p2
    }

-- | The name of the instance profile to update.
rrfipInstanceProfileName :: Lens' RemoveRoleFromInstanceProfile Text
rrfipInstanceProfileName =
    lens _rrfipInstanceProfileName
        (\s a -> s { _rrfipInstanceProfileName = a })

-- | The name of the role to remove.
rrfipRoleName :: Lens' RemoveRoleFromInstanceProfile Text
rrfipRoleName = lens _rrfipRoleName (\s a -> s { _rrfipRoleName = a })

data RemoveRoleFromInstanceProfileResponse = RemoveRoleFromInstanceProfileResponse
    deriving (Eq, Ord, Show, Generic)

-- | 'RemoveRoleFromInstanceProfileResponse' constructor.
removeRoleFromInstanceProfileResponse :: RemoveRoleFromInstanceProfileResponse
removeRoleFromInstanceProfileResponse = RemoveRoleFromInstanceProfileResponse

instance ToPath RemoveRoleFromInstanceProfile where
    toPath = const "/"

instance ToQuery RemoveRoleFromInstanceProfile where
    toQuery RemoveRoleFromInstanceProfile{..} = mconcat
        [ "InstanceProfileName" =? _rrfipInstanceProfileName
        , "RoleName"            =? _rrfipRoleName
        ]

instance ToHeaders RemoveRoleFromInstanceProfile

instance AWSRequest RemoveRoleFromInstanceProfile where
    type Sv RemoveRoleFromInstanceProfile = IAM
    type Rs RemoveRoleFromInstanceProfile = RemoveRoleFromInstanceProfileResponse

    request  = post "RemoveRoleFromInstanceProfile"
    response = nullResponse RemoveRoleFromInstanceProfileResponse

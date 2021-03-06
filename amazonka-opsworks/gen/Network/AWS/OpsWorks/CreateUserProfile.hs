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

-- Module      : Network.AWS.OpsWorks.CreateUserProfile
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

-- | Creates a new user profile.
--
-- Required Permissions: To use this action, an IAM user must have an attached
-- policy that explicitly grants permissions. For more information on user
-- permissions, see <http://docs.aws.amazon.com/opsworks/latest/userguide/opsworks-security-users.html Managing User Permissions>.
--
-- <http://docs.aws.amazon.com/opsworks/latest/APIReference/API_CreateUserProfile.html>
module Network.AWS.OpsWorks.CreateUserProfile
    (
    -- * Request
      CreateUserProfile
    -- ** Request constructor
    , createUserProfile
    -- ** Request lenses
    , cupAllowSelfManagement
    , cupIamUserArn
    , cupSshPublicKey
    , cupSshUsername

    -- * Response
    , CreateUserProfileResponse
    -- ** Response constructor
    , createUserProfileResponse
    -- ** Response lenses
    , cuprIamUserArn
    ) where

import Network.AWS.Prelude
import Network.AWS.Request.JSON
import Network.AWS.OpsWorks.Types
import qualified GHC.Exts

data CreateUserProfile = CreateUserProfile
    { _cupAllowSelfManagement :: Maybe Bool
    , _cupIamUserArn          :: Text
    , _cupSshPublicKey        :: Maybe Text
    , _cupSshUsername         :: Maybe Text
    } deriving (Eq, Ord, Show)

-- | 'CreateUserProfile' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'cupAllowSelfManagement' @::@ 'Maybe' 'Bool'
--
-- * 'cupIamUserArn' @::@ 'Text'
--
-- * 'cupSshPublicKey' @::@ 'Maybe' 'Text'
--
-- * 'cupSshUsername' @::@ 'Maybe' 'Text'
--
createUserProfile :: Text -- ^ 'cupIamUserArn'
                  -> CreateUserProfile
createUserProfile p1 = CreateUserProfile
    { _cupIamUserArn          = p1
    , _cupSshUsername         = Nothing
    , _cupSshPublicKey        = Nothing
    , _cupAllowSelfManagement = Nothing
    }

-- | Whether users can specify their own SSH public key through the My Settings
-- page. For more information, see <http://docs.aws.amazon.com/opsworks/latest/userguide/security-settingsshkey.html Setting an IAM User's Public SSH Key>.
cupAllowSelfManagement :: Lens' CreateUserProfile (Maybe Bool)
cupAllowSelfManagement =
    lens _cupAllowSelfManagement (\s a -> s { _cupAllowSelfManagement = a })

-- | The user's IAM ARN.
cupIamUserArn :: Lens' CreateUserProfile Text
cupIamUserArn = lens _cupIamUserArn (\s a -> s { _cupIamUserArn = a })

-- | The user's public SSH key.
cupSshPublicKey :: Lens' CreateUserProfile (Maybe Text)
cupSshPublicKey = lens _cupSshPublicKey (\s a -> s { _cupSshPublicKey = a })

-- | The user's SSH user name. The allowable characters are [a-z], [A-Z], [0-9],
-- '-', and '_'. If the specified name includes other punctuation marks, AWS
-- OpsWorks removes them. For example, 'my.name' will be changed to 'myname'. If you
-- do not specify an SSH user name, AWS OpsWorks generates one from the IAM user
-- name.
cupSshUsername :: Lens' CreateUserProfile (Maybe Text)
cupSshUsername = lens _cupSshUsername (\s a -> s { _cupSshUsername = a })

newtype CreateUserProfileResponse = CreateUserProfileResponse
    { _cuprIamUserArn :: Maybe Text
    } deriving (Eq, Ord, Show, Monoid)

-- | 'CreateUserProfileResponse' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'cuprIamUserArn' @::@ 'Maybe' 'Text'
--
createUserProfileResponse :: CreateUserProfileResponse
createUserProfileResponse = CreateUserProfileResponse
    { _cuprIamUserArn = Nothing
    }

-- | The user's IAM ARN.
cuprIamUserArn :: Lens' CreateUserProfileResponse (Maybe Text)
cuprIamUserArn = lens _cuprIamUserArn (\s a -> s { _cuprIamUserArn = a })

instance ToPath CreateUserProfile where
    toPath = const "/"

instance ToQuery CreateUserProfile where
    toQuery = const mempty

instance ToHeaders CreateUserProfile

instance ToJSON CreateUserProfile where
    toJSON CreateUserProfile{..} = object
        [ "IamUserArn"          .= _cupIamUserArn
        , "SshUsername"         .= _cupSshUsername
        , "SshPublicKey"        .= _cupSshPublicKey
        , "AllowSelfManagement" .= _cupAllowSelfManagement
        ]

instance AWSRequest CreateUserProfile where
    type Sv CreateUserProfile = OpsWorks
    type Rs CreateUserProfile = CreateUserProfileResponse

    request  = post "CreateUserProfile"
    response = jsonResponse

instance FromJSON CreateUserProfileResponse where
    parseJSON = withObject "CreateUserProfileResponse" $ \o -> CreateUserProfileResponse
        <$> o .:? "IamUserArn"

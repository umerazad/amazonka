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

-- Module      : Network.AWS.IAM.ListRoles
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

-- | Lists the roles that have the specified path prefix. If there are none, the
-- action returns an empty list. For more information about roles, go to <http://docs.aws.amazon.com/IAM/latest/UserGuide/WorkingWithRoles.html Workingwith Roles>.
--
-- You can paginate the results using the 'MaxItems' and 'Marker' parameters.
--
-- The returned policy is URL-encoded according to RFC 3986. For more
-- information about RFC 3986, go to <http://www.faqs.org/rfcs/rfc3986.html http://www.faqs.org/rfcs/rfc3986.html>.
--
-- <http://docs.aws.amazon.com/IAM/latest/APIReference/API_ListRoles.html>
module Network.AWS.IAM.ListRoles
    (
    -- * Request
      ListRoles
    -- ** Request constructor
    , listRoles
    -- ** Request lenses
    , lrMarker
    , lrMaxItems
    , lrPathPrefix

    -- * Response
    , ListRolesResponse
    -- ** Response constructor
    , listRolesResponse
    -- ** Response lenses
    , lrrIsTruncated
    , lrrMarker
    , lrrRoles
    ) where

import Network.AWS.Prelude
import Network.AWS.Request.Query
import Network.AWS.IAM.Types
import qualified GHC.Exts

data ListRoles = ListRoles
    { _lrMarker     :: Maybe Text
    , _lrMaxItems   :: Maybe Nat
    , _lrPathPrefix :: Maybe Text
    } deriving (Eq, Ord, Show)

-- | 'ListRoles' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'lrMarker' @::@ 'Maybe' 'Text'
--
-- * 'lrMaxItems' @::@ 'Maybe' 'Natural'
--
-- * 'lrPathPrefix' @::@ 'Maybe' 'Text'
--
listRoles :: ListRoles
listRoles = ListRoles
    { _lrPathPrefix = Nothing
    , _lrMarker     = Nothing
    , _lrMaxItems   = Nothing
    }

-- | Use this parameter only when paginating results, and only in a subsequent
-- request after you've received a response where the results are truncated. Set
-- it to the value of the 'Marker' element in the response you just received.
lrMarker :: Lens' ListRoles (Maybe Text)
lrMarker = lens _lrMarker (\s a -> s { _lrMarker = a })

-- | Use this parameter only when paginating results to indicate the maximum
-- number of roles you want in the response. If there are additional roles
-- beyond the maximum you specify, the 'IsTruncated' response element is 'true'.
-- This parameter is optional. If you do not include it, it defaults to 100.
lrMaxItems :: Lens' ListRoles (Maybe Natural)
lrMaxItems = lens _lrMaxItems (\s a -> s { _lrMaxItems = a }) . mapping _Nat

-- | The path prefix for filtering the results. For example, the prefix '/application_abc/component_xyz/' gets all roles whose path starts with '/application_abc/component_xyz/'.
--
-- This parameter is optional. If it is not included, it defaults to a slash
-- (/), listing all roles.
lrPathPrefix :: Lens' ListRoles (Maybe Text)
lrPathPrefix = lens _lrPathPrefix (\s a -> s { _lrPathPrefix = a })

data ListRolesResponse = ListRolesResponse
    { _lrrIsTruncated :: Maybe Bool
    , _lrrMarker      :: Maybe Text
    , _lrrRoles       :: List "member" Role
    } deriving (Eq, Show)

-- | 'ListRolesResponse' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'lrrIsTruncated' @::@ 'Maybe' 'Bool'
--
-- * 'lrrMarker' @::@ 'Maybe' 'Text'
--
-- * 'lrrRoles' @::@ ['Role']
--
listRolesResponse :: ListRolesResponse
listRolesResponse = ListRolesResponse
    { _lrrRoles       = mempty
    , _lrrIsTruncated = Nothing
    , _lrrMarker      = Nothing
    }

-- | A flag that indicates whether there are more roles to list. If your results
-- were truncated, you can make a subsequent pagination request using the 'Marker'
-- request parameter to retrieve more roles in the list.
lrrIsTruncated :: Lens' ListRolesResponse (Maybe Bool)
lrrIsTruncated = lens _lrrIsTruncated (\s a -> s { _lrrIsTruncated = a })

-- | If 'IsTruncated' is 'true', this element is present and contains the value to
-- use for the 'Marker' parameter in a subsequent pagination request.
lrrMarker :: Lens' ListRolesResponse (Maybe Text)
lrrMarker = lens _lrrMarker (\s a -> s { _lrrMarker = a })

-- | A list of roles.
lrrRoles :: Lens' ListRolesResponse [Role]
lrrRoles = lens _lrrRoles (\s a -> s { _lrrRoles = a }) . _List

instance ToPath ListRoles where
    toPath = const "/"

instance ToQuery ListRoles where
    toQuery ListRoles{..} = mconcat
        [ "Marker"     =? _lrMarker
        , "MaxItems"   =? _lrMaxItems
        , "PathPrefix" =? _lrPathPrefix
        ]

instance ToHeaders ListRoles

instance AWSRequest ListRoles where
    type Sv ListRoles = IAM
    type Rs ListRoles = ListRolesResponse

    request  = post "ListRoles"
    response = xmlResponse

instance FromXML ListRolesResponse where
    parseXML = withElement "ListRolesResult" $ \x -> ListRolesResponse
        <$> x .@? "IsTruncated"
        <*> x .@? "Marker"
        <*> x .@? "Roles" .!@ mempty

instance AWSPager ListRoles where
    page rq rs
        | stop (rs ^. lrrIsTruncated) = Nothing
        | otherwise = Just $ rq
            & lrMarker .~ rs ^. lrrMarker

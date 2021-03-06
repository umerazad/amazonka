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

-- Module      : Network.AWS.RDS.ListTagsForResource
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

-- | Lists all tags on an Amazon RDS resource.
--
-- For an overview on tagging an Amazon RDS resource, see <http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Overview.Tagging.html Tagging Amazon RDSResources>.
--
-- <http://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_ListTagsForResource.html>
module Network.AWS.RDS.ListTagsForResource
    (
    -- * Request
      ListTagsForResource
    -- ** Request constructor
    , listTagsForResource
    -- ** Request lenses
    , ltfrFilters
    , ltfrResourceName

    -- * Response
    , ListTagsForResourceResponse
    -- ** Response constructor
    , listTagsForResourceResponse
    -- ** Response lenses
    , ltfrrTagList
    ) where

import Network.AWS.Prelude
import Network.AWS.Request.Query
import Network.AWS.RDS.Types
import qualified GHC.Exts

data ListTagsForResource = ListTagsForResource
    { _ltfrFilters      :: List "member" Filter
    , _ltfrResourceName :: Text
    } deriving (Eq, Show)

-- | 'ListTagsForResource' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'ltfrFilters' @::@ ['Filter']
--
-- * 'ltfrResourceName' @::@ 'Text'
--
listTagsForResource :: Text -- ^ 'ltfrResourceName'
                    -> ListTagsForResource
listTagsForResource p1 = ListTagsForResource
    { _ltfrResourceName = p1
    , _ltfrFilters      = mempty
    }

-- | This parameter is not currently supported.
ltfrFilters :: Lens' ListTagsForResource [Filter]
ltfrFilters = lens _ltfrFilters (\s a -> s { _ltfrFilters = a }) . _List

-- | The Amazon RDS resource with tags to be listed. This value is an Amazon
-- Resource Name (ARN). For information about creating an ARN, see <http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_Tagging.html#USER_Tagging.ARN  Constructingan RDS Amazon Resource Name (ARN)>.
ltfrResourceName :: Lens' ListTagsForResource Text
ltfrResourceName = lens _ltfrResourceName (\s a -> s { _ltfrResourceName = a })

newtype ListTagsForResourceResponse = ListTagsForResourceResponse
    { _ltfrrTagList :: List "member" Tag
    } deriving (Eq, Show, Monoid, Semigroup)

instance GHC.Exts.IsList ListTagsForResourceResponse where
    type Item ListTagsForResourceResponse = Tag

    fromList = ListTagsForResourceResponse . GHC.Exts.fromList
    toList   = GHC.Exts.toList . _ltfrrTagList

-- | 'ListTagsForResourceResponse' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'ltfrrTagList' @::@ ['Tag']
--
listTagsForResourceResponse :: ListTagsForResourceResponse
listTagsForResourceResponse = ListTagsForResourceResponse
    { _ltfrrTagList = mempty
    }

-- | List of tags returned by the ListTagsForResource operation.
ltfrrTagList :: Lens' ListTagsForResourceResponse [Tag]
ltfrrTagList = lens _ltfrrTagList (\s a -> s { _ltfrrTagList = a }) . _List

instance ToPath ListTagsForResource where
    toPath = const "/"

instance ToQuery ListTagsForResource where
    toQuery ListTagsForResource{..} = mconcat
        [ "Filters"      =? _ltfrFilters
        , "ResourceName" =? _ltfrResourceName
        ]

instance ToHeaders ListTagsForResource

instance AWSRequest ListTagsForResource where
    type Sv ListTagsForResource = RDS
    type Rs ListTagsForResource = ListTagsForResourceResponse

    request  = post "ListTagsForResource"
    response = xmlResponse

instance FromXML ListTagsForResourceResponse where
    parseXML = withElement "ListTagsForResourceResult" $ \x -> ListTagsForResourceResponse
        <$> x .@? "TagList" .!@ mempty

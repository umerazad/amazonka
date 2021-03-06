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

-- Module      : Network.AWS.AutoScaling.DescribeTags
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

-- | Describes the specified tags.
--
-- You can use filters to limit the results. For example, you can query for the
-- tags for a specific Auto Scaling group. You can specify multiple values for a
-- filter. A tag must match at least one of the specified values for it to be
-- included in the results.
--
-- You can also specify multiple filters. The result includes information for a
-- particular tag only if it matches all the filters. If there's no match, no
-- special message is returned.
--
-- <http://docs.aws.amazon.com/AutoScaling/latest/APIReference/API_DescribeTags.html>
module Network.AWS.AutoScaling.DescribeTags
    (
    -- * Request
      DescribeTags
    -- ** Request constructor
    , describeTags
    -- ** Request lenses
    , dtFilters
    , dtMaxRecords
    , dtNextToken

    -- * Response
    , DescribeTagsResponse
    -- ** Response constructor
    , describeTagsResponse
    -- ** Response lenses
    , dtrNextToken
    , dtrTags
    ) where

import Network.AWS.Prelude
import Network.AWS.Request.Query
import Network.AWS.AutoScaling.Types
import qualified GHC.Exts

data DescribeTags = DescribeTags
    { _dtFilters    :: List "member" Filter
    , _dtMaxRecords :: Maybe Int
    , _dtNextToken  :: Maybe Text
    } deriving (Eq, Show)

-- | 'DescribeTags' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'dtFilters' @::@ ['Filter']
--
-- * 'dtMaxRecords' @::@ 'Maybe' 'Int'
--
-- * 'dtNextToken' @::@ 'Maybe' 'Text'
--
describeTags :: DescribeTags
describeTags = DescribeTags
    { _dtFilters    = mempty
    , _dtNextToken  = Nothing
    , _dtMaxRecords = Nothing
    }

-- | The value of the filter type used to identify the tags to be returned. For
-- example, you can filter so that tags are returned according to Auto Scaling
-- group, the key and value, or whether the new tag will be applied to instances
-- launched after the tag is created (PropagateAtLaunch).
dtFilters :: Lens' DescribeTags [Filter]
dtFilters = lens _dtFilters (\s a -> s { _dtFilters = a }) . _List

-- | The maximum number of items to return with this call.
dtMaxRecords :: Lens' DescribeTags (Maybe Int)
dtMaxRecords = lens _dtMaxRecords (\s a -> s { _dtMaxRecords = a })

-- | The token for the next set of items to return. (You received this token from
-- a previous call.)
dtNextToken :: Lens' DescribeTags (Maybe Text)
dtNextToken = lens _dtNextToken (\s a -> s { _dtNextToken = a })

data DescribeTagsResponse = DescribeTagsResponse
    { _dtrNextToken :: Maybe Text
    , _dtrTags      :: List "member" TagDescription
    } deriving (Eq, Show)

-- | 'DescribeTagsResponse' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'dtrNextToken' @::@ 'Maybe' 'Text'
--
-- * 'dtrTags' @::@ ['TagDescription']
--
describeTagsResponse :: DescribeTagsResponse
describeTagsResponse = DescribeTagsResponse
    { _dtrTags      = mempty
    , _dtrNextToken = Nothing
    }

-- | The token to use when requesting the next set of items. If there are no
-- additional items to return, the string is empty.
dtrNextToken :: Lens' DescribeTagsResponse (Maybe Text)
dtrNextToken = lens _dtrNextToken (\s a -> s { _dtrNextToken = a })

-- | The tags.
dtrTags :: Lens' DescribeTagsResponse [TagDescription]
dtrTags = lens _dtrTags (\s a -> s { _dtrTags = a }) . _List

instance ToPath DescribeTags where
    toPath = const "/"

instance ToQuery DescribeTags where
    toQuery DescribeTags{..} = mconcat
        [ "Filters"    =? _dtFilters
        , "MaxRecords" =? _dtMaxRecords
        , "NextToken"  =? _dtNextToken
        ]

instance ToHeaders DescribeTags

instance AWSRequest DescribeTags where
    type Sv DescribeTags = AutoScaling
    type Rs DescribeTags = DescribeTagsResponse

    request  = post "DescribeTags"
    response = xmlResponse

instance FromXML DescribeTagsResponse where
    parseXML = withElement "DescribeTagsResult" $ \x -> DescribeTagsResponse
        <$> x .@? "NextToken"
        <*> x .@? "Tags" .!@ mempty

instance AWSPager DescribeTags where
    page rq rs
        | stop (rq ^. dtNextToken) = Nothing
        | otherwise = (\x -> rq & dtNextToken ?~ x)
            <$> (rs ^. dtrNextToken)

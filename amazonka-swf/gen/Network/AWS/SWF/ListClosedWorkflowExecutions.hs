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

-- Module      : Network.AWS.SWF.ListClosedWorkflowExecutions
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

-- | Returns a list of closed workflow executions in the specified domain that
-- meet the filtering criteria. The results may be split into multiple pages. To
-- retrieve subsequent pages, make the call again using the nextPageToken
-- returned by the initial call.
--
-- Access Control
--
-- You can use IAM policies to control this action's access to Amazon SWF
-- resources as follows:
--
-- Use a 'Resource' element with the domain name to limit the action to only
-- specified domains. Use an 'Action' element to allow or deny permission to call
-- this action. Constrain the following parameters by using a 'Condition' element
-- with the appropriate keys.   'tagFilter.tag': String constraint. The key is 'swf:tagFilter.tag'.  'typeFilter.name': String constraint. The key is 'swf:typeFilter.name'.  'typeFilter.version': String constraint. The key is 'swf:typeFilter.version'.    If the caller does
-- not have sufficient permissions to invoke the action, or the parameter values
-- fall outside the specified constraints, the action fails by throwing 'OperationNotPermitted'. For details and example IAM policies, see <http://docs.aws.amazon.com/amazonswf/latest/developerguide/swf-dev-iam.html Using IAM to Manage Access toAmazon SWF Workflows>.
--
-- <http://docs.aws.amazon.com/amazonswf/latest/apireference/API_ListClosedWorkflowExecutions.html>
module Network.AWS.SWF.ListClosedWorkflowExecutions
    (
    -- * Request
      ListClosedWorkflowExecutions
    -- ** Request constructor
    , listClosedWorkflowExecutions
    -- ** Request lenses
    , lcweCloseStatusFilter
    , lcweCloseTimeFilter
    , lcweDomain
    , lcweExecutionFilter
    , lcweMaximumPageSize
    , lcweNextPageToken
    , lcweReverseOrder
    , lcweStartTimeFilter
    , lcweTagFilter
    , lcweTypeFilter

    -- * Response
    , ListClosedWorkflowExecutionsResponse
    -- ** Response constructor
    , listClosedWorkflowExecutionsResponse
    -- ** Response lenses
    , lcwerExecutionInfos
    , lcwerNextPageToken
    ) where

import Network.AWS.Prelude
import Network.AWS.Request.JSON
import Network.AWS.SWF.Types
import qualified GHC.Exts

data ListClosedWorkflowExecutions = ListClosedWorkflowExecutions
    { _lcweCloseStatusFilter :: Maybe CloseStatusFilter
    , _lcweCloseTimeFilter   :: Maybe ExecutionTimeFilter
    , _lcweDomain            :: Text
    , _lcweExecutionFilter   :: Maybe WorkflowExecutionFilter
    , _lcweMaximumPageSize   :: Maybe Nat
    , _lcweNextPageToken     :: Maybe Text
    , _lcweReverseOrder      :: Maybe Bool
    , _lcweStartTimeFilter   :: Maybe ExecutionTimeFilter
    , _lcweTagFilter         :: Maybe TagFilter
    , _lcweTypeFilter        :: Maybe WorkflowTypeFilter
    } deriving (Eq, Show)

-- | 'ListClosedWorkflowExecutions' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'lcweCloseStatusFilter' @::@ 'Maybe' 'CloseStatusFilter'
--
-- * 'lcweCloseTimeFilter' @::@ 'Maybe' 'ExecutionTimeFilter'
--
-- * 'lcweDomain' @::@ 'Text'
--
-- * 'lcweExecutionFilter' @::@ 'Maybe' 'WorkflowExecutionFilter'
--
-- * 'lcweMaximumPageSize' @::@ 'Maybe' 'Natural'
--
-- * 'lcweNextPageToken' @::@ 'Maybe' 'Text'
--
-- * 'lcweReverseOrder' @::@ 'Maybe' 'Bool'
--
-- * 'lcweStartTimeFilter' @::@ 'Maybe' 'ExecutionTimeFilter'
--
-- * 'lcweTagFilter' @::@ 'Maybe' 'TagFilter'
--
-- * 'lcweTypeFilter' @::@ 'Maybe' 'WorkflowTypeFilter'
--
listClosedWorkflowExecutions :: Text -- ^ 'lcweDomain'
                             -> ListClosedWorkflowExecutions
listClosedWorkflowExecutions p1 = ListClosedWorkflowExecutions
    { _lcweDomain            = p1
    , _lcweStartTimeFilter   = Nothing
    , _lcweCloseTimeFilter   = Nothing
    , _lcweExecutionFilter   = Nothing
    , _lcweCloseStatusFilter = Nothing
    , _lcweTypeFilter        = Nothing
    , _lcweTagFilter         = Nothing
    , _lcweNextPageToken     = Nothing
    , _lcweMaximumPageSize   = Nothing
    , _lcweReverseOrder      = Nothing
    }

-- | If specified, only workflow executions that match this /close status/ are
-- listed. For example, if TERMINATED is specified, then only TERMINATED
-- workflow executions are listed.
lcweCloseStatusFilter :: Lens' ListClosedWorkflowExecutions (Maybe CloseStatusFilter)
lcweCloseStatusFilter =
    lens _lcweCloseStatusFilter (\s a -> s { _lcweCloseStatusFilter = a })

-- | If specified, the workflow executions are included in the returned results
-- based on whether their close times are within the range specified by this
-- filter. Also, if this parameter is specified, the returned results are
-- ordered by their close times.
lcweCloseTimeFilter :: Lens' ListClosedWorkflowExecutions (Maybe ExecutionTimeFilter)
lcweCloseTimeFilter =
    lens _lcweCloseTimeFilter (\s a -> s { _lcweCloseTimeFilter = a })

-- | The name of the domain that contains the workflow executions to list.
lcweDomain :: Lens' ListClosedWorkflowExecutions Text
lcweDomain = lens _lcweDomain (\s a -> s { _lcweDomain = a })

-- | If specified, only workflow executions matching the workflow id specified in
-- the filter are returned.
lcweExecutionFilter :: Lens' ListClosedWorkflowExecutions (Maybe WorkflowExecutionFilter)
lcweExecutionFilter =
    lens _lcweExecutionFilter (\s a -> s { _lcweExecutionFilter = a })

-- | The maximum number of results returned in each page. The default is 100, but
-- the caller can override this value to a page size /smaller/ than the default.
-- You cannot specify a page size greater than 100. Note that the number of
-- executions may be less than the maxiumum page size, in which case, the
-- returned page will have fewer results than the maximumPageSize specified.
lcweMaximumPageSize :: Lens' ListClosedWorkflowExecutions (Maybe Natural)
lcweMaximumPageSize =
    lens _lcweMaximumPageSize (\s a -> s { _lcweMaximumPageSize = a })
        . mapping _Nat

-- | If on a previous call to this method a 'NextPageToken' was returned, the
-- results are being paginated. To get the next page of results, repeat the call
-- with the returned token and all other arguments unchanged.
lcweNextPageToken :: Lens' ListClosedWorkflowExecutions (Maybe Text)
lcweNextPageToken =
    lens _lcweNextPageToken (\s a -> s { _lcweNextPageToken = a })

-- | When set to 'true', returns the results in reverse order. By default the
-- results are returned in descending order of the start or the close time of
-- the executions.
lcweReverseOrder :: Lens' ListClosedWorkflowExecutions (Maybe Bool)
lcweReverseOrder = lens _lcweReverseOrder (\s a -> s { _lcweReverseOrder = a })

-- | If specified, the workflow executions are included in the returned results
-- based on whether their start times are within the range specified by this
-- filter. Also, if this parameter is specified, the returned results are
-- ordered by their start times.
lcweStartTimeFilter :: Lens' ListClosedWorkflowExecutions (Maybe ExecutionTimeFilter)
lcweStartTimeFilter =
    lens _lcweStartTimeFilter (\s a -> s { _lcweStartTimeFilter = a })

-- | If specified, only executions that have the matching tag are listed.
lcweTagFilter :: Lens' ListClosedWorkflowExecutions (Maybe TagFilter)
lcweTagFilter = lens _lcweTagFilter (\s a -> s { _lcweTagFilter = a })

-- | If specified, only executions of the type specified in the filter are
-- returned.
lcweTypeFilter :: Lens' ListClosedWorkflowExecutions (Maybe WorkflowTypeFilter)
lcweTypeFilter = lens _lcweTypeFilter (\s a -> s { _lcweTypeFilter = a })

data ListClosedWorkflowExecutionsResponse = ListClosedWorkflowExecutionsResponse
    { _lcwerExecutionInfos :: List "executionInfos" WorkflowExecutionInfo
    , _lcwerNextPageToken  :: Maybe Text
    } deriving (Eq, Show)

-- | 'ListClosedWorkflowExecutionsResponse' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'lcwerExecutionInfos' @::@ ['WorkflowExecutionInfo']
--
-- * 'lcwerNextPageToken' @::@ 'Maybe' 'Text'
--
listClosedWorkflowExecutionsResponse :: ListClosedWorkflowExecutionsResponse
listClosedWorkflowExecutionsResponse = ListClosedWorkflowExecutionsResponse
    { _lcwerExecutionInfos = mempty
    , _lcwerNextPageToken  = Nothing
    }

-- | The list of workflow information structures.
lcwerExecutionInfos :: Lens' ListClosedWorkflowExecutionsResponse [WorkflowExecutionInfo]
lcwerExecutionInfos =
    lens _lcwerExecutionInfos (\s a -> s { _lcwerExecutionInfos = a })
        . _List

-- | The token of the next page in the result. If set, the results have more than
-- one page. The next page can be retrieved by repeating the request with this
-- token and all other arguments unchanged.
lcwerNextPageToken :: Lens' ListClosedWorkflowExecutionsResponse (Maybe Text)
lcwerNextPageToken =
    lens _lcwerNextPageToken (\s a -> s { _lcwerNextPageToken = a })

instance ToPath ListClosedWorkflowExecutions where
    toPath = const "/"

instance ToQuery ListClosedWorkflowExecutions where
    toQuery = const mempty

instance ToHeaders ListClosedWorkflowExecutions

instance ToJSON ListClosedWorkflowExecutions where
    toJSON ListClosedWorkflowExecutions{..} = object
        [ "domain"            .= _lcweDomain
        , "startTimeFilter"   .= _lcweStartTimeFilter
        , "closeTimeFilter"   .= _lcweCloseTimeFilter
        , "executionFilter"   .= _lcweExecutionFilter
        , "closeStatusFilter" .= _lcweCloseStatusFilter
        , "typeFilter"        .= _lcweTypeFilter
        , "tagFilter"         .= _lcweTagFilter
        , "nextPageToken"     .= _lcweNextPageToken
        , "maximumPageSize"   .= _lcweMaximumPageSize
        , "reverseOrder"      .= _lcweReverseOrder
        ]

instance AWSRequest ListClosedWorkflowExecutions where
    type Sv ListClosedWorkflowExecutions = SWF
    type Rs ListClosedWorkflowExecutions = ListClosedWorkflowExecutionsResponse

    request  = post "ListClosedWorkflowExecutions"
    response = jsonResponse

instance FromJSON ListClosedWorkflowExecutionsResponse where
    parseJSON = withObject "ListClosedWorkflowExecutionsResponse" $ \o -> ListClosedWorkflowExecutionsResponse
        <$> o .:? "executionInfos" .!= mempty
        <*> o .:? "nextPageToken"

instance AWSPager ListClosedWorkflowExecutions where
    page rq rs
        | stop (rq ^. lcweNextPageToken) = Nothing
        | otherwise = (\x -> rq & lcweNextPageToken ?~ x)
            <$> (rs ^. lcwerNextPageToken)

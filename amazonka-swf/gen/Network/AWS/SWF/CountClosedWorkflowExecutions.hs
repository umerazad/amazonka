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

-- Module      : Network.AWS.SWF.CountClosedWorkflowExecutions
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

-- | Returns the number of closed workflow executions within the given domain
-- that meet the specified filtering criteria.
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
-- <http://docs.aws.amazon.com/amazonswf/latest/apireference/API_CountClosedWorkflowExecutions.html>
module Network.AWS.SWF.CountClosedWorkflowExecutions
    (
    -- * Request
      CountClosedWorkflowExecutions
    -- ** Request constructor
    , countClosedWorkflowExecutions
    -- ** Request lenses
    , ccweCloseStatusFilter
    , ccweCloseTimeFilter
    , ccweDomain
    , ccweExecutionFilter
    , ccweStartTimeFilter
    , ccweTagFilter
    , ccweTypeFilter

    -- * Response
    , CountClosedWorkflowExecutionsResponse
    -- ** Response constructor
    , countClosedWorkflowExecutionsResponse
    -- ** Response lenses
    , ccwerCount
    , ccwerTruncated
    ) where

import Network.AWS.Prelude
import Network.AWS.Request.JSON
import Network.AWS.SWF.Types
import qualified GHC.Exts

data CountClosedWorkflowExecutions = CountClosedWorkflowExecutions
    { _ccweCloseStatusFilter :: Maybe CloseStatusFilter
    , _ccweCloseTimeFilter   :: Maybe ExecutionTimeFilter
    , _ccweDomain            :: Text
    , _ccweExecutionFilter   :: Maybe WorkflowExecutionFilter
    , _ccweStartTimeFilter   :: Maybe ExecutionTimeFilter
    , _ccweTagFilter         :: Maybe TagFilter
    , _ccweTypeFilter        :: Maybe WorkflowTypeFilter
    } deriving (Eq, Show)

-- | 'CountClosedWorkflowExecutions' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'ccweCloseStatusFilter' @::@ 'Maybe' 'CloseStatusFilter'
--
-- * 'ccweCloseTimeFilter' @::@ 'Maybe' 'ExecutionTimeFilter'
--
-- * 'ccweDomain' @::@ 'Text'
--
-- * 'ccweExecutionFilter' @::@ 'Maybe' 'WorkflowExecutionFilter'
--
-- * 'ccweStartTimeFilter' @::@ 'Maybe' 'ExecutionTimeFilter'
--
-- * 'ccweTagFilter' @::@ 'Maybe' 'TagFilter'
--
-- * 'ccweTypeFilter' @::@ 'Maybe' 'WorkflowTypeFilter'
--
countClosedWorkflowExecutions :: Text -- ^ 'ccweDomain'
                              -> CountClosedWorkflowExecutions
countClosedWorkflowExecutions p1 = CountClosedWorkflowExecutions
    { _ccweDomain            = p1
    , _ccweStartTimeFilter   = Nothing
    , _ccweCloseTimeFilter   = Nothing
    , _ccweExecutionFilter   = Nothing
    , _ccweTypeFilter        = Nothing
    , _ccweTagFilter         = Nothing
    , _ccweCloseStatusFilter = Nothing
    }

-- | If specified, only workflow executions that match this close status are
-- counted. This filter has an affect only if 'executionStatus' is specified as 'CLOSED'.
ccweCloseStatusFilter :: Lens' CountClosedWorkflowExecutions (Maybe CloseStatusFilter)
ccweCloseStatusFilter =
    lens _ccweCloseStatusFilter (\s a -> s { _ccweCloseStatusFilter = a })

-- | If specified, only workflow executions that meet the close time criteria of
-- the filter are counted.
ccweCloseTimeFilter :: Lens' CountClosedWorkflowExecutions (Maybe ExecutionTimeFilter)
ccweCloseTimeFilter =
    lens _ccweCloseTimeFilter (\s a -> s { _ccweCloseTimeFilter = a })

-- | The name of the domain containing the workflow executions to count.
ccweDomain :: Lens' CountClosedWorkflowExecutions Text
ccweDomain = lens _ccweDomain (\s a -> s { _ccweDomain = a })

-- | If specified, only workflow executions matching the 'WorkflowId' in the filter
-- are counted.
ccweExecutionFilter :: Lens' CountClosedWorkflowExecutions (Maybe WorkflowExecutionFilter)
ccweExecutionFilter =
    lens _ccweExecutionFilter (\s a -> s { _ccweExecutionFilter = a })

-- | If specified, only workflow executions that meet the start time criteria of
-- the filter are counted.
ccweStartTimeFilter :: Lens' CountClosedWorkflowExecutions (Maybe ExecutionTimeFilter)
ccweStartTimeFilter =
    lens _ccweStartTimeFilter (\s a -> s { _ccweStartTimeFilter = a })

-- | If specified, only executions that have a tag that matches the filter are
-- counted.
ccweTagFilter :: Lens' CountClosedWorkflowExecutions (Maybe TagFilter)
ccweTagFilter = lens _ccweTagFilter (\s a -> s { _ccweTagFilter = a })

-- | If specified, indicates the type of the workflow executions to be counted.
ccweTypeFilter :: Lens' CountClosedWorkflowExecutions (Maybe WorkflowTypeFilter)
ccweTypeFilter = lens _ccweTypeFilter (\s a -> s { _ccweTypeFilter = a })

data CountClosedWorkflowExecutionsResponse = CountClosedWorkflowExecutionsResponse
    { _ccwerCount     :: Nat
    , _ccwerTruncated :: Maybe Bool
    } deriving (Eq, Ord, Show)

-- | 'CountClosedWorkflowExecutionsResponse' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'ccwerCount' @::@ 'Natural'
--
-- * 'ccwerTruncated' @::@ 'Maybe' 'Bool'
--
countClosedWorkflowExecutionsResponse :: Natural -- ^ 'ccwerCount'
                                      -> CountClosedWorkflowExecutionsResponse
countClosedWorkflowExecutionsResponse p1 = CountClosedWorkflowExecutionsResponse
    { _ccwerCount     = withIso _Nat (const id) p1
    , _ccwerTruncated = Nothing
    }

-- | The number of workflow executions.
ccwerCount :: Lens' CountClosedWorkflowExecutionsResponse Natural
ccwerCount = lens _ccwerCount (\s a -> s { _ccwerCount = a }) . _Nat

-- | If set to true, indicates that the actual count was more than the maximum
-- supported by this API and the count returned is the truncated value.
ccwerTruncated :: Lens' CountClosedWorkflowExecutionsResponse (Maybe Bool)
ccwerTruncated = lens _ccwerTruncated (\s a -> s { _ccwerTruncated = a })

instance ToPath CountClosedWorkflowExecutions where
    toPath = const "/"

instance ToQuery CountClosedWorkflowExecutions where
    toQuery = const mempty

instance ToHeaders CountClosedWorkflowExecutions

instance ToJSON CountClosedWorkflowExecutions where
    toJSON CountClosedWorkflowExecutions{..} = object
        [ "domain"            .= _ccweDomain
        , "startTimeFilter"   .= _ccweStartTimeFilter
        , "closeTimeFilter"   .= _ccweCloseTimeFilter
        , "executionFilter"   .= _ccweExecutionFilter
        , "typeFilter"        .= _ccweTypeFilter
        , "tagFilter"         .= _ccweTagFilter
        , "closeStatusFilter" .= _ccweCloseStatusFilter
        ]

instance AWSRequest CountClosedWorkflowExecutions where
    type Sv CountClosedWorkflowExecutions = SWF
    type Rs CountClosedWorkflowExecutions = CountClosedWorkflowExecutionsResponse

    request  = post "CountClosedWorkflowExecutions"
    response = jsonResponse

instance FromJSON CountClosedWorkflowExecutionsResponse where
    parseJSON = withObject "CountClosedWorkflowExecutionsResponse" $ \o -> CountClosedWorkflowExecutionsResponse
        <$> o .:  "count"
        <*> o .:? "truncated"

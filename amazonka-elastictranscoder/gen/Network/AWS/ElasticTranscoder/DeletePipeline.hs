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

-- Module      : Network.AWS.ElasticTranscoder.DeletePipeline
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

-- | The DeletePipeline operation removes a pipeline.
--
-- You can only delete a pipeline that has never been used or that is not
-- currently in use (doesn't contain any active jobs). If the pipeline is
-- currently in use, 'DeletePipeline' returns an error.
--
-- <http://docs.aws.amazon.com/elastictranscoder/latest/developerguide/DeletePipeline.html>
module Network.AWS.ElasticTranscoder.DeletePipeline
    (
    -- * Request
      DeletePipeline
    -- ** Request constructor
    , deletePipeline
    -- ** Request lenses
    , dp1Id

    -- * Response
    , DeletePipelineResponse
    -- ** Response constructor
    , deletePipelineResponse
    ) where

import Network.AWS.Prelude
import Network.AWS.Request.RestJSON
import Network.AWS.ElasticTranscoder.Types
import qualified GHC.Exts

newtype DeletePipeline = DeletePipeline
    { _dp1Id :: Text
    } deriving (Eq, Ord, Show, Monoid, IsString)

-- | 'DeletePipeline' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'dp1Id' @::@ 'Text'
--
deletePipeline :: Text -- ^ 'dp1Id'
               -> DeletePipeline
deletePipeline p1 = DeletePipeline
    { _dp1Id = p1
    }

-- | The identifier of the pipeline that you want to delete.
dp1Id :: Lens' DeletePipeline Text
dp1Id = lens _dp1Id (\s a -> s { _dp1Id = a })

data DeletePipelineResponse = DeletePipelineResponse
    deriving (Eq, Ord, Show, Generic)

-- | 'DeletePipelineResponse' constructor.
deletePipelineResponse :: DeletePipelineResponse
deletePipelineResponse = DeletePipelineResponse

instance ToPath DeletePipeline where
    toPath DeletePipeline{..} = mconcat
        [ "/2012-09-25/pipelines/"
        , toText _dp1Id
        ]

instance ToQuery DeletePipeline where
    toQuery = const mempty

instance ToHeaders DeletePipeline

instance ToJSON DeletePipeline where
    toJSON = const (toJSON Empty)

instance AWSRequest DeletePipeline where
    type Sv DeletePipeline = ElasticTranscoder
    type Rs DeletePipeline = DeletePipelineResponse

    request  = delete
    response = nullResponse DeletePipelineResponse

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

-- Module      : Network.AWS.RDS.DeleteDBSubnetGroup
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

-- | Deletes a DB subnet group.
--
-- <http://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_DeleteDBSubnetGroup.html>
module Network.AWS.RDS.DeleteDBSubnetGroup
    (
    -- * Request
      DeleteDBSubnetGroup
    -- ** Request constructor
    , deleteDBSubnetGroup
    -- ** Request lenses
    , ddbsg1DBSubnetGroupName

    -- * Response
    , DeleteDBSubnetGroupResponse
    -- ** Response constructor
    , deleteDBSubnetGroupResponse
    ) where

import Network.AWS.Prelude
import Network.AWS.Request.Query
import Network.AWS.RDS.Types
import qualified GHC.Exts

newtype DeleteDBSubnetGroup = DeleteDBSubnetGroup
    { _ddbsg1DBSubnetGroupName :: Text
    } deriving (Eq, Ord, Show, Monoid, IsString)

-- | 'DeleteDBSubnetGroup' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'ddbsg1DBSubnetGroupName' @::@ 'Text'
--
deleteDBSubnetGroup :: Text -- ^ 'ddbsg1DBSubnetGroupName'
                    -> DeleteDBSubnetGroup
deleteDBSubnetGroup p1 = DeleteDBSubnetGroup
    { _ddbsg1DBSubnetGroupName = p1
    }

-- | The name of the database subnet group to delete.
--
-- Constraints:
--
-- Must be 1 to 255 alphanumeric characters First character must be a letter Cannot end with a hyphen or contain two consecutive hyphens
--
ddbsg1DBSubnetGroupName :: Lens' DeleteDBSubnetGroup Text
ddbsg1DBSubnetGroupName =
    lens _ddbsg1DBSubnetGroupName (\s a -> s { _ddbsg1DBSubnetGroupName = a })

data DeleteDBSubnetGroupResponse = DeleteDBSubnetGroupResponse
    deriving (Eq, Ord, Show, Generic)

-- | 'DeleteDBSubnetGroupResponse' constructor.
deleteDBSubnetGroupResponse :: DeleteDBSubnetGroupResponse
deleteDBSubnetGroupResponse = DeleteDBSubnetGroupResponse

instance ToPath DeleteDBSubnetGroup where
    toPath = const "/"

instance ToQuery DeleteDBSubnetGroup where
    toQuery DeleteDBSubnetGroup{..} = mconcat
        [ "DBSubnetGroupName" =? _ddbsg1DBSubnetGroupName
        ]

instance ToHeaders DeleteDBSubnetGroup

instance AWSRequest DeleteDBSubnetGroup where
    type Sv DeleteDBSubnetGroup = RDS
    type Rs DeleteDBSubnetGroup = DeleteDBSubnetGroupResponse

    request  = post "DeleteDBSubnetGroup"
    response = nullResponse DeleteDBSubnetGroupResponse

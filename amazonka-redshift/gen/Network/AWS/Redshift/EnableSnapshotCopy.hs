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

-- Module      : Network.AWS.Redshift.EnableSnapshotCopy
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

-- | Enables the automatic copy of snapshots from one region to another region for
-- a specified cluster.
--
-- <http://docs.aws.amazon.com/redshift/latest/APIReference/API_EnableSnapshotCopy.html>
module Network.AWS.Redshift.EnableSnapshotCopy
    (
    -- * Request
      EnableSnapshotCopy
    -- ** Request constructor
    , enableSnapshotCopy
    -- ** Request lenses
    , escClusterIdentifier
    , escDestinationRegion
    , escRetentionPeriod

    -- * Response
    , EnableSnapshotCopyResponse
    -- ** Response constructor
    , enableSnapshotCopyResponse
    -- ** Response lenses
    , escrCluster
    ) where

import Network.AWS.Prelude
import Network.AWS.Request.Query
import Network.AWS.Redshift.Types
import qualified GHC.Exts

data EnableSnapshotCopy = EnableSnapshotCopy
    { _escClusterIdentifier :: Text
    , _escDestinationRegion :: Text
    , _escRetentionPeriod   :: Maybe Int
    } deriving (Eq, Ord, Show)

-- | 'EnableSnapshotCopy' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'escClusterIdentifier' @::@ 'Text'
--
-- * 'escDestinationRegion' @::@ 'Text'
--
-- * 'escRetentionPeriod' @::@ 'Maybe' 'Int'
--
enableSnapshotCopy :: Text -- ^ 'escClusterIdentifier'
                   -> Text -- ^ 'escDestinationRegion'
                   -> EnableSnapshotCopy
enableSnapshotCopy p1 p2 = EnableSnapshotCopy
    { _escClusterIdentifier = p1
    , _escDestinationRegion = p2
    , _escRetentionPeriod   = Nothing
    }

-- | The unique identifier of the source cluster to copy snapshots from.
--
-- Constraints: Must be the valid name of an existing cluster that does not
-- already have cross-region snapshot copy enabled.
escClusterIdentifier :: Lens' EnableSnapshotCopy Text
escClusterIdentifier =
    lens _escClusterIdentifier (\s a -> s { _escClusterIdentifier = a })

-- | The destination region that you want to copy snapshots to.
--
-- Constraints: Must be the name of a valid region. For more information, see <http://docs.aws.amazon.com/general/latest/gr/rande.html#redshift_region Regions and Endpoints> in the Amazon Web Services General Reference.
escDestinationRegion :: Lens' EnableSnapshotCopy Text
escDestinationRegion =
    lens _escDestinationRegion (\s a -> s { _escDestinationRegion = a })

-- | The number of days to retain automated snapshots in the destination region
-- after they are copied from the source region.
--
-- Default: 7.
--
-- Constraints: Must be at least 1 and no more than 35.
escRetentionPeriod :: Lens' EnableSnapshotCopy (Maybe Int)
escRetentionPeriod =
    lens _escRetentionPeriod (\s a -> s { _escRetentionPeriod = a })

newtype EnableSnapshotCopyResponse = EnableSnapshotCopyResponse
    { _escrCluster :: Maybe Cluster
    } deriving (Eq, Show)

-- | 'EnableSnapshotCopyResponse' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'escrCluster' @::@ 'Maybe' 'Cluster'
--
enableSnapshotCopyResponse :: EnableSnapshotCopyResponse
enableSnapshotCopyResponse = EnableSnapshotCopyResponse
    { _escrCluster = Nothing
    }

escrCluster :: Lens' EnableSnapshotCopyResponse (Maybe Cluster)
escrCluster = lens _escrCluster (\s a -> s { _escrCluster = a })

instance ToPath EnableSnapshotCopy where
    toPath = const "/"

instance ToQuery EnableSnapshotCopy where
    toQuery EnableSnapshotCopy{..} = mconcat
        [ "ClusterIdentifier" =? _escClusterIdentifier
        , "DestinationRegion" =? _escDestinationRegion
        , "RetentionPeriod"   =? _escRetentionPeriod
        ]

instance ToHeaders EnableSnapshotCopy

instance AWSRequest EnableSnapshotCopy where
    type Sv EnableSnapshotCopy = Redshift
    type Rs EnableSnapshotCopy = EnableSnapshotCopyResponse

    request  = post "EnableSnapshotCopy"
    response = xmlResponse

instance FromXML EnableSnapshotCopyResponse where
    parseXML = withElement "EnableSnapshotCopyResult" $ \x -> EnableSnapshotCopyResponse
        <$> x .@? "Cluster"

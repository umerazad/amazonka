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

-- Module      : Network.AWS.Redshift.RevokeSnapshotAccess
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

-- | Removes the ability of the specified AWS customer account to restore the
-- specified snapshot. If the account is currently restoring the snapshot, the
-- restore will run to completion.
--
-- For more information about working with snapshots, go to <http://docs.aws.amazon.com/redshift/latest/mgmt/working-with-snapshots.html Amazon RedshiftSnapshots> in the /Amazon Redshift Cluster Management Guide/.
--
-- <http://docs.aws.amazon.com/redshift/latest/APIReference/API_RevokeSnapshotAccess.html>
module Network.AWS.Redshift.RevokeSnapshotAccess
    (
    -- * Request
      RevokeSnapshotAccess
    -- ** Request constructor
    , revokeSnapshotAccess
    -- ** Request lenses
    , rsaAccountWithRestoreAccess
    , rsaSnapshotClusterIdentifier
    , rsaSnapshotIdentifier

    -- * Response
    , RevokeSnapshotAccessResponse
    -- ** Response constructor
    , revokeSnapshotAccessResponse
    -- ** Response lenses
    , rsarSnapshot
    ) where

import Network.AWS.Prelude
import Network.AWS.Request.Query
import Network.AWS.Redshift.Types
import qualified GHC.Exts

data RevokeSnapshotAccess = RevokeSnapshotAccess
    { _rsaAccountWithRestoreAccess  :: Text
    , _rsaSnapshotClusterIdentifier :: Maybe Text
    , _rsaSnapshotIdentifier        :: Text
    } deriving (Eq, Ord, Show)

-- | 'RevokeSnapshotAccess' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'rsaAccountWithRestoreAccess' @::@ 'Text'
--
-- * 'rsaSnapshotClusterIdentifier' @::@ 'Maybe' 'Text'
--
-- * 'rsaSnapshotIdentifier' @::@ 'Text'
--
revokeSnapshotAccess :: Text -- ^ 'rsaSnapshotIdentifier'
                     -> Text -- ^ 'rsaAccountWithRestoreAccess'
                     -> RevokeSnapshotAccess
revokeSnapshotAccess p1 p2 = RevokeSnapshotAccess
    { _rsaSnapshotIdentifier        = p1
    , _rsaAccountWithRestoreAccess  = p2
    , _rsaSnapshotClusterIdentifier = Nothing
    }

-- | The identifier of the AWS customer account that can no longer restore the
-- specified snapshot.
rsaAccountWithRestoreAccess :: Lens' RevokeSnapshotAccess Text
rsaAccountWithRestoreAccess =
    lens _rsaAccountWithRestoreAccess
        (\s a -> s { _rsaAccountWithRestoreAccess = a })

-- | The identifier of the cluster the snapshot was created from. This parameter
-- is required if your IAM user has a policy containing a snapshot resource
-- element that specifies anything other than * for the cluster name.
rsaSnapshotClusterIdentifier :: Lens' RevokeSnapshotAccess (Maybe Text)
rsaSnapshotClusterIdentifier =
    lens _rsaSnapshotClusterIdentifier
        (\s a -> s { _rsaSnapshotClusterIdentifier = a })

-- | The identifier of the snapshot that the account can no longer access.
rsaSnapshotIdentifier :: Lens' RevokeSnapshotAccess Text
rsaSnapshotIdentifier =
    lens _rsaSnapshotIdentifier (\s a -> s { _rsaSnapshotIdentifier = a })

newtype RevokeSnapshotAccessResponse = RevokeSnapshotAccessResponse
    { _rsarSnapshot :: Maybe Snapshot
    } deriving (Eq, Show)

-- | 'RevokeSnapshotAccessResponse' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'rsarSnapshot' @::@ 'Maybe' 'Snapshot'
--
revokeSnapshotAccessResponse :: RevokeSnapshotAccessResponse
revokeSnapshotAccessResponse = RevokeSnapshotAccessResponse
    { _rsarSnapshot = Nothing
    }

rsarSnapshot :: Lens' RevokeSnapshotAccessResponse (Maybe Snapshot)
rsarSnapshot = lens _rsarSnapshot (\s a -> s { _rsarSnapshot = a })

instance ToPath RevokeSnapshotAccess where
    toPath = const "/"

instance ToQuery RevokeSnapshotAccess where
    toQuery RevokeSnapshotAccess{..} = mconcat
        [ "AccountWithRestoreAccess"  =? _rsaAccountWithRestoreAccess
        , "SnapshotClusterIdentifier" =? _rsaSnapshotClusterIdentifier
        , "SnapshotIdentifier"        =? _rsaSnapshotIdentifier
        ]

instance ToHeaders RevokeSnapshotAccess

instance AWSRequest RevokeSnapshotAccess where
    type Sv RevokeSnapshotAccess = Redshift
    type Rs RevokeSnapshotAccess = RevokeSnapshotAccessResponse

    request  = post "RevokeSnapshotAccess"
    response = xmlResponse

instance FromXML RevokeSnapshotAccessResponse where
    parseXML = withElement "RevokeSnapshotAccessResult" $ \x -> RevokeSnapshotAccessResponse
        <$> x .@? "Snapshot"

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

-- Module      : Network.AWS.Redshift.DescribeDefaultClusterParameters
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

-- | Returns a list of parameter settings for the specified parameter group
-- family.
--
-- For more information about managing parameter groups, go to <http://docs.aws.amazon.com/redshift/latest/mgmt/working-with-parameter-groups.html Amazon RedshiftParameter Groups> in the /Amazon Redshift Cluster Management Guide/.
--
-- <http://docs.aws.amazon.com/redshift/latest/APIReference/API_DescribeDefaultClusterParameters.html>
module Network.AWS.Redshift.DescribeDefaultClusterParameters
    (
    -- * Request
      DescribeDefaultClusterParameters
    -- ** Request constructor
    , describeDefaultClusterParameters
    -- ** Request lenses
    , ddcpMarker
    , ddcpMaxRecords
    , ddcpParameterGroupFamily

    -- * Response
    , DescribeDefaultClusterParametersResponse
    -- ** Response constructor
    , describeDefaultClusterParametersResponse
    -- ** Response lenses
    , ddcprDefaultClusterParameters
    ) where

import Network.AWS.Prelude
import Network.AWS.Request.Query
import Network.AWS.Redshift.Types
import qualified GHC.Exts

data DescribeDefaultClusterParameters = DescribeDefaultClusterParameters
    { _ddcpMarker               :: Maybe Text
    , _ddcpMaxRecords           :: Maybe Int
    , _ddcpParameterGroupFamily :: Text
    } deriving (Eq, Ord, Show)

-- | 'DescribeDefaultClusterParameters' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'ddcpMarker' @::@ 'Maybe' 'Text'
--
-- * 'ddcpMaxRecords' @::@ 'Maybe' 'Int'
--
-- * 'ddcpParameterGroupFamily' @::@ 'Text'
--
describeDefaultClusterParameters :: Text -- ^ 'ddcpParameterGroupFamily'
                                 -> DescribeDefaultClusterParameters
describeDefaultClusterParameters p1 = DescribeDefaultClusterParameters
    { _ddcpParameterGroupFamily = p1
    , _ddcpMaxRecords           = Nothing
    , _ddcpMarker               = Nothing
    }

-- | An optional parameter that specifies the starting point to return a set of
-- response records. When the results of a 'DescribeDefaultClusterParameters'
-- request exceed the value specified in 'MaxRecords', AWS returns a value in the 'Marker' field of the response. You can retrieve the next set of response records by
-- providing the returned marker value in the 'Marker' parameter and retrying the
-- request.
ddcpMarker :: Lens' DescribeDefaultClusterParameters (Maybe Text)
ddcpMarker = lens _ddcpMarker (\s a -> s { _ddcpMarker = a })

-- | The maximum number of response records to return in each call. If the number
-- of remaining response records exceeds the specified 'MaxRecords' value, a value
-- is returned in a 'marker' field of the response. You can retrieve the next set
-- of records by retrying the command with the returned marker value.
--
-- Default: '100'
--
-- Constraints: minimum 20, maximum 100.
ddcpMaxRecords :: Lens' DescribeDefaultClusterParameters (Maybe Int)
ddcpMaxRecords = lens _ddcpMaxRecords (\s a -> s { _ddcpMaxRecords = a })

-- | The name of the cluster parameter group family.
ddcpParameterGroupFamily :: Lens' DescribeDefaultClusterParameters Text
ddcpParameterGroupFamily =
    lens _ddcpParameterGroupFamily
        (\s a -> s { _ddcpParameterGroupFamily = a })

newtype DescribeDefaultClusterParametersResponse = DescribeDefaultClusterParametersResponse
    { _ddcprDefaultClusterParameters :: DefaultClusterParameters
    } deriving (Eq, Show)

-- | 'DescribeDefaultClusterParametersResponse' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'ddcprDefaultClusterParameters' @::@ 'DefaultClusterParameters'
--
describeDefaultClusterParametersResponse :: DefaultClusterParameters -- ^ 'ddcprDefaultClusterParameters'
                                         -> DescribeDefaultClusterParametersResponse
describeDefaultClusterParametersResponse p1 = DescribeDefaultClusterParametersResponse
    { _ddcprDefaultClusterParameters = p1
    }

ddcprDefaultClusterParameters :: Lens' DescribeDefaultClusterParametersResponse DefaultClusterParameters
ddcprDefaultClusterParameters =
    lens _ddcprDefaultClusterParameters
        (\s a -> s { _ddcprDefaultClusterParameters = a })

instance ToPath DescribeDefaultClusterParameters where
    toPath = const "/"

instance ToQuery DescribeDefaultClusterParameters where
    toQuery DescribeDefaultClusterParameters{..} = mconcat
        [ "Marker"               =? _ddcpMarker
        , "MaxRecords"           =? _ddcpMaxRecords
        , "ParameterGroupFamily" =? _ddcpParameterGroupFamily
        ]

instance ToHeaders DescribeDefaultClusterParameters

instance AWSRequest DescribeDefaultClusterParameters where
    type Sv DescribeDefaultClusterParameters = Redshift
    type Rs DescribeDefaultClusterParameters = DescribeDefaultClusterParametersResponse

    request  = post "DescribeDefaultClusterParameters"
    response = xmlResponse

instance FromXML DescribeDefaultClusterParametersResponse where
    parseXML = withElement "DescribeDefaultClusterParametersResult" $ \x -> DescribeDefaultClusterParametersResponse
        <$> x .@  "DefaultClusterParameters"

instance AWSPager DescribeDefaultClusterParameters where
    page rq rs
        | stop (rq ^. ddcpMarker) = Nothing
        | otherwise = (\x -> rq & ddcpMarker ?~ x)
            <$> (rs ^. ddcprDefaultClusterParameters . dcpMarker)

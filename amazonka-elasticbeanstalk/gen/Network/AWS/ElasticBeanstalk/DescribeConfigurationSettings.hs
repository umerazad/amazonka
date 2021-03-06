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

-- Module      : Network.AWS.ElasticBeanstalk.DescribeConfigurationSettings
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

-- | Returns a description of the settings for the specified configuration set,
-- that is, either a configuration template or the configuration set associated
-- with a running environment.
--
-- When describing the settings for the configuration set associated with a
-- running environment, it is possible to receive two sets of setting
-- descriptions. One is the deployed configuration set, and the other is a draft
-- configuration of an environment that is either in the process of deployment
-- or that failed to deploy.
--
-- Related Topics
--
-- 'DeleteEnvironmentConfiguration'
--
-- <http://docs.aws.amazon.com/elasticbeanstalk/latest/api/API_DescribeConfigurationSettings.html>
module Network.AWS.ElasticBeanstalk.DescribeConfigurationSettings
    (
    -- * Request
      DescribeConfigurationSettings
    -- ** Request constructor
    , describeConfigurationSettings
    -- ** Request lenses
    , dcsApplicationName
    , dcsEnvironmentName
    , dcsTemplateName

    -- * Response
    , DescribeConfigurationSettingsResponse
    -- ** Response constructor
    , describeConfigurationSettingsResponse
    -- ** Response lenses
    , dcsrConfigurationSettings
    ) where

import Network.AWS.Prelude
import Network.AWS.Request.Query
import Network.AWS.ElasticBeanstalk.Types
import qualified GHC.Exts

data DescribeConfigurationSettings = DescribeConfigurationSettings
    { _dcsApplicationName :: Text
    , _dcsEnvironmentName :: Maybe Text
    , _dcsTemplateName    :: Maybe Text
    } deriving (Eq, Ord, Show)

-- | 'DescribeConfigurationSettings' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'dcsApplicationName' @::@ 'Text'
--
-- * 'dcsEnvironmentName' @::@ 'Maybe' 'Text'
--
-- * 'dcsTemplateName' @::@ 'Maybe' 'Text'
--
describeConfigurationSettings :: Text -- ^ 'dcsApplicationName'
                              -> DescribeConfigurationSettings
describeConfigurationSettings p1 = DescribeConfigurationSettings
    { _dcsApplicationName = p1
    , _dcsTemplateName    = Nothing
    , _dcsEnvironmentName = Nothing
    }

-- | The application for the environment or configuration template.
dcsApplicationName :: Lens' DescribeConfigurationSettings Text
dcsApplicationName =
    lens _dcsApplicationName (\s a -> s { _dcsApplicationName = a })

-- | The name of the environment to describe.
--
-- Condition: You must specify either this or a TemplateName, but not both. If
-- you specify both, AWS Elastic Beanstalk returns an 'InvalidParameterCombination'
-- error. If you do not specify either, AWS Elastic Beanstalk returns 'MissingRequiredParameter' error.
dcsEnvironmentName :: Lens' DescribeConfigurationSettings (Maybe Text)
dcsEnvironmentName =
    lens _dcsEnvironmentName (\s a -> s { _dcsEnvironmentName = a })

-- | The name of the configuration template to describe.
--
-- Conditional: You must specify either this parameter or an EnvironmentName,
-- but not both. If you specify both, AWS Elastic Beanstalk returns an 'InvalidParameterCombination' error. If you do not specify either, AWS Elastic Beanstalk returns a 'MissingRequiredParameter' error.
dcsTemplateName :: Lens' DescribeConfigurationSettings (Maybe Text)
dcsTemplateName = lens _dcsTemplateName (\s a -> s { _dcsTemplateName = a })

newtype DescribeConfigurationSettingsResponse = DescribeConfigurationSettingsResponse
    { _dcsrConfigurationSettings :: List "member" ConfigurationSettingsDescription
    } deriving (Eq, Show, Monoid, Semigroup)

instance GHC.Exts.IsList DescribeConfigurationSettingsResponse where
    type Item DescribeConfigurationSettingsResponse = ConfigurationSettingsDescription

    fromList = DescribeConfigurationSettingsResponse . GHC.Exts.fromList
    toList   = GHC.Exts.toList . _dcsrConfigurationSettings

-- | 'DescribeConfigurationSettingsResponse' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'dcsrConfigurationSettings' @::@ ['ConfigurationSettingsDescription']
--
describeConfigurationSettingsResponse :: DescribeConfigurationSettingsResponse
describeConfigurationSettingsResponse = DescribeConfigurationSettingsResponse
    { _dcsrConfigurationSettings = mempty
    }

-- | A list of 'ConfigurationSettingsDescription'.
dcsrConfigurationSettings :: Lens' DescribeConfigurationSettingsResponse [ConfigurationSettingsDescription]
dcsrConfigurationSettings =
    lens _dcsrConfigurationSettings
        (\s a -> s { _dcsrConfigurationSettings = a })
            . _List

instance ToPath DescribeConfigurationSettings where
    toPath = const "/"

instance ToQuery DescribeConfigurationSettings where
    toQuery DescribeConfigurationSettings{..} = mconcat
        [ "ApplicationName" =? _dcsApplicationName
        , "EnvironmentName" =? _dcsEnvironmentName
        , "TemplateName"    =? _dcsTemplateName
        ]

instance ToHeaders DescribeConfigurationSettings

instance AWSRequest DescribeConfigurationSettings where
    type Sv DescribeConfigurationSettings = ElasticBeanstalk
    type Rs DescribeConfigurationSettings = DescribeConfigurationSettingsResponse

    request  = post "DescribeConfigurationSettings"
    response = xmlResponse

instance FromXML DescribeConfigurationSettingsResponse where
    parseXML = withElement "DescribeConfigurationSettingsResult" $ \x -> DescribeConfigurationSettingsResponse
        <$> x .@? "ConfigurationSettings" .!@ mempty

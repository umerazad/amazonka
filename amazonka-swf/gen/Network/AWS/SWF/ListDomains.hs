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

-- Module      : Network.AWS.SWF.ListDomains
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

-- | Returns the list of domains registered in the account. The results may be
-- split into multiple pages. To retrieve subsequent pages, make the call again
-- using the nextPageToken returned by the initial call.
--
-- Access Control
--
-- You can use IAM policies to control this action's access to Amazon SWF
-- resources as follows:
--
-- Use a 'Resource' element with the domain name to limit the action to only
-- specified domains. The element must be set to 'arn:aws:swf::AccountID:domain/*"'
-- , where "AccountID" is the account ID, with no dashes. Use an 'Action' element
-- to allow or deny permission to call this action. You cannot use an IAM policy
-- to constrain this action's parameters.  If the caller does not have
-- sufficient permissions to invoke the action, or the parameter values fall
-- outside the specified constraints, the action fails by throwing 'OperationNotPermitted'. For details and example IAM policies, see <http://docs.aws.amazon.com/amazonswf/latest/developerguide/swf-dev-iam.html Using IAM to Manage Access toAmazon SWF Workflows>.
--
-- <http://docs.aws.amazon.com/amazonswf/latest/apireference/API_ListDomains.html>
module Network.AWS.SWF.ListDomains
    (
    -- * Request
      ListDomains
    -- ** Request constructor
    , listDomains
    -- ** Request lenses
    , ldMaximumPageSize
    , ldNextPageToken
    , ldRegistrationStatus
    , ldReverseOrder

    -- * Response
    , ListDomainsResponse
    -- ** Response constructor
    , listDomainsResponse
    -- ** Response lenses
    , ldrDomainInfos
    , ldrNextPageToken
    ) where

import Network.AWS.Prelude
import Network.AWS.Request.JSON
import Network.AWS.SWF.Types
import qualified GHC.Exts

data ListDomains = ListDomains
    { _ldMaximumPageSize    :: Maybe Nat
    , _ldNextPageToken      :: Maybe Text
    , _ldRegistrationStatus :: RegistrationStatus
    , _ldReverseOrder       :: Maybe Bool
    } deriving (Eq, Show)

-- | 'ListDomains' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'ldMaximumPageSize' @::@ 'Maybe' 'Natural'
--
-- * 'ldNextPageToken' @::@ 'Maybe' 'Text'
--
-- * 'ldRegistrationStatus' @::@ 'RegistrationStatus'
--
-- * 'ldReverseOrder' @::@ 'Maybe' 'Bool'
--
listDomains :: RegistrationStatus -- ^ 'ldRegistrationStatus'
            -> ListDomains
listDomains p1 = ListDomains
    { _ldRegistrationStatus = p1
    , _ldNextPageToken      = Nothing
    , _ldMaximumPageSize    = Nothing
    , _ldReverseOrder       = Nothing
    }

-- | The maximum number of results returned in each page. The default is 100, but
-- the caller can override this value to a page size /smaller/ than the default.
-- You cannot specify a page size greater than 100. Note that the number of
-- domains may be less than the maxiumum page size, in which case, the returned
-- page will have fewer results than the maximumPageSize specified.
ldMaximumPageSize :: Lens' ListDomains (Maybe Natural)
ldMaximumPageSize =
    lens _ldMaximumPageSize (\s a -> s { _ldMaximumPageSize = a })
        . mapping _Nat

-- | If on a previous call to this method a 'NextPageToken' was returned, the
-- result has more than one page. To get the next page of results, repeat the
-- call with the returned token and all other arguments unchanged.
ldNextPageToken :: Lens' ListDomains (Maybe Text)
ldNextPageToken = lens _ldNextPageToken (\s a -> s { _ldNextPageToken = a })

-- | Specifies the registration status of the domains to list.
ldRegistrationStatus :: Lens' ListDomains RegistrationStatus
ldRegistrationStatus =
    lens _ldRegistrationStatus (\s a -> s { _ldRegistrationStatus = a })

-- | When set to 'true', returns the results in reverse order. By default the
-- results are returned in ascending alphabetical order of the 'name' of the
-- domains.
ldReverseOrder :: Lens' ListDomains (Maybe Bool)
ldReverseOrder = lens _ldReverseOrder (\s a -> s { _ldReverseOrder = a })

data ListDomainsResponse = ListDomainsResponse
    { _ldrDomainInfos   :: List "domainInfos" DomainInfo
    , _ldrNextPageToken :: Maybe Text
    } deriving (Eq, Show)

-- | 'ListDomainsResponse' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'ldrDomainInfos' @::@ ['DomainInfo']
--
-- * 'ldrNextPageToken' @::@ 'Maybe' 'Text'
--
listDomainsResponse :: ListDomainsResponse
listDomainsResponse = ListDomainsResponse
    { _ldrDomainInfos   = mempty
    , _ldrNextPageToken = Nothing
    }

-- | A list of DomainInfo structures.
ldrDomainInfos :: Lens' ListDomainsResponse [DomainInfo]
ldrDomainInfos = lens _ldrDomainInfos (\s a -> s { _ldrDomainInfos = a }) . _List

-- | Returns a value if the results are paginated. To get the next page of
-- results, repeat the request specifying this token and all other arguments
-- unchanged.
ldrNextPageToken :: Lens' ListDomainsResponse (Maybe Text)
ldrNextPageToken = lens _ldrNextPageToken (\s a -> s { _ldrNextPageToken = a })

instance ToPath ListDomains where
    toPath = const "/"

instance ToQuery ListDomains where
    toQuery = const mempty

instance ToHeaders ListDomains

instance ToJSON ListDomains where
    toJSON ListDomains{..} = object
        [ "nextPageToken"      .= _ldNextPageToken
        , "registrationStatus" .= _ldRegistrationStatus
        , "maximumPageSize"    .= _ldMaximumPageSize
        , "reverseOrder"       .= _ldReverseOrder
        ]

instance AWSRequest ListDomains where
    type Sv ListDomains = SWF
    type Rs ListDomains = ListDomainsResponse

    request  = post "ListDomains"
    response = jsonResponse

instance FromJSON ListDomainsResponse where
    parseJSON = withObject "ListDomainsResponse" $ \o -> ListDomainsResponse
        <$> o .:? "domainInfos" .!= mempty
        <*> o .:? "nextPageToken"

instance AWSPager ListDomains where
    page rq rs
        | stop (rq ^. ldNextPageToken) = Nothing
        | otherwise = (\x -> rq & ldNextPageToken ?~ x)
            <$> (rs ^. ldrNextPageToken)

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

-- Module      : Network.AWS.SDB.DeleteDomain
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

-- | The 'DeleteDomain' operation deletes a domain. Any items (and their
-- attributes) in the domain are deleted as well. The 'DeleteDomain' operation
-- might take 10 or more seconds to complete.
--
-- <http://docs.aws.amazon.com/AmazonSimpleDB/latest/DeveloperGuide/SDB_API_DeleteDomain.html>
module Network.AWS.SDB.DeleteDomain
    (
    -- * Request
      DeleteDomain
    -- ** Request constructor
    , deleteDomain
    -- ** Request lenses
    , ddDomainName

    -- * Response
    , DeleteDomainResponse
    -- ** Response constructor
    , deleteDomainResponse
    ) where

import Network.AWS.Prelude
import Network.AWS.Request.Query
import Network.AWS.SDB.Types
import qualified GHC.Exts

newtype DeleteDomain = DeleteDomain
    { _ddDomainName :: Text
    } deriving (Eq, Ord, Show, Monoid, IsString)

-- | 'DeleteDomain' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'ddDomainName' @::@ 'Text'
--
deleteDomain :: Text -- ^ 'ddDomainName'
             -> DeleteDomain
deleteDomain p1 = DeleteDomain
    { _ddDomainName = p1
    }

-- | The name of the domain to delete.
ddDomainName :: Lens' DeleteDomain Text
ddDomainName = lens _ddDomainName (\s a -> s { _ddDomainName = a })

data DeleteDomainResponse = DeleteDomainResponse
    deriving (Eq, Ord, Show, Generic)

-- | 'DeleteDomainResponse' constructor.
deleteDomainResponse :: DeleteDomainResponse
deleteDomainResponse = DeleteDomainResponse

instance ToPath DeleteDomain where
    toPath = const "/"

instance ToQuery DeleteDomain where
    toQuery DeleteDomain{..} = mconcat
        [ "DomainName" =? _ddDomainName
        ]

instance ToHeaders DeleteDomain

instance AWSRequest DeleteDomain where
    type Sv DeleteDomain = SDB
    type Rs DeleteDomain = DeleteDomainResponse

    request  = post "DeleteDomain"
    response = nullResponse DeleteDomainResponse

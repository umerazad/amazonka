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

-- Module      : Network.AWS.SQS.DeleteMessage
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

-- | Deletes the specified message from the specified queue. You specify the
-- message by using the message's 'receipt handle' and not the 'message ID' you
-- received when you sent the message. Even if the message is locked by another
-- reader due to the visibility timeout setting, it is still deleted from the
-- queue. If you leave a message in the queue for longer than the queue's
-- configured retention period, Amazon SQS automatically deletes it.
--
-- The receipt handle is associated with a specific instance of receiving the
-- message. If you receive a message more than once, the receipt handle you get
-- each time you receive the message is different. When you request 'DeleteMessage'
-- , if you don't provide the most recently received receipt handle for the
-- message, the request will still succeed, but the message might not be
-- deleted.
--
-- It is possible you will receive a message even after you have deleted it.
-- This might happen on rare occasions if one of the servers storing a copy of
-- the message is unavailable when you request to delete the message. The copy
-- remains on the server and might be returned to you again on a subsequent
-- receive request. You should create your system to be idempotent so that
-- receiving a particular message more than once is not a problem.
--
--
--
-- <http://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_DeleteMessage.html>
module Network.AWS.SQS.DeleteMessage
    (
    -- * Request
      DeleteMessage
    -- ** Request constructor
    , deleteMessage
    -- ** Request lenses
    , dmQueueUrl
    , dmReceiptHandle

    -- * Response
    , DeleteMessageResponse
    -- ** Response constructor
    , deleteMessageResponse
    ) where

import Network.AWS.Prelude
import Network.AWS.Request.Query
import Network.AWS.SQS.Types
import qualified GHC.Exts

data DeleteMessage = DeleteMessage
    { _dmQueueUrl      :: Text
    , _dmReceiptHandle :: Text
    } deriving (Eq, Ord, Show)

-- | 'DeleteMessage' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'dmQueueUrl' @::@ 'Text'
--
-- * 'dmReceiptHandle' @::@ 'Text'
--
deleteMessage :: Text -- ^ 'dmQueueUrl'
              -> Text -- ^ 'dmReceiptHandle'
              -> DeleteMessage
deleteMessage p1 p2 = DeleteMessage
    { _dmQueueUrl      = p1
    , _dmReceiptHandle = p2
    }

-- | The URL of the Amazon SQS queue to take action on.
dmQueueUrl :: Lens' DeleteMessage Text
dmQueueUrl = lens _dmQueueUrl (\s a -> s { _dmQueueUrl = a })

-- | The receipt handle associated with the message to delete.
dmReceiptHandle :: Lens' DeleteMessage Text
dmReceiptHandle = lens _dmReceiptHandle (\s a -> s { _dmReceiptHandle = a })

data DeleteMessageResponse = DeleteMessageResponse
    deriving (Eq, Ord, Show, Generic)

-- | 'DeleteMessageResponse' constructor.
deleteMessageResponse :: DeleteMessageResponse
deleteMessageResponse = DeleteMessageResponse

instance ToPath DeleteMessage where
    toPath = const "/"

instance ToQuery DeleteMessage where
    toQuery DeleteMessage{..} = mconcat
        [ "QueueUrl"      =? _dmQueueUrl
        , "ReceiptHandle" =? _dmReceiptHandle
        ]

instance ToHeaders DeleteMessage

instance AWSRequest DeleteMessage where
    type Sv DeleteMessage = SQS
    type Rs DeleteMessage = DeleteMessageResponse

    request  = post "DeleteMessage"
    response = nullResponse DeleteMessageResponse

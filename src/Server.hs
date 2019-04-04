{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TypeOperators   #-}
module Server
  ( api
  , server) where

import Data.IORef
import Control.Monad.IO.Class (liftIO)

import Servant

import AppState


type API =
  "successfulqueries" :> Get '[JSON] Int
  :<|> "failedqueries" :> Get '[JSON] Int
  :<|> "totalissues" :> Get '[JSON] Int
  :<|> "openissues" :> Get '[JSON] Int

api :: Proxy API
api = Proxy

server :: IORef AppState -> Server API
server theRef =
  successfulqueriesHandler
  :<|> failedqueriesHandler
  :<|> totalissuesHandler
  :<|> openissuesHandler
  where
    successfulqueriesHandler = do
      i <- liftIO $ atomicModifyIORef' theRef $ \a -> (a, successfulQueries a)
      pure i
    failedqueriesHandler = do
      i <- liftIO $ atomicModifyIORef' theRef $ \a -> (a, failedQueries a)
      pure i
    totalissuesHandler = do
      i <- liftIO $ atomicModifyIORef' theRef $ \a -> (a, totalIssues a)
      pure i
    openissuesHandler = do
      i <- liftIO $ atomicModifyIORef' theRef $ \a -> (a, openIssues a)
      pure i

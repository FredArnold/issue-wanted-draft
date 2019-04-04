{-# LANGUAGE BangPatterns    #-}
{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE MultiParamTypeClasses#-}
{-# LANGUAGE TypeOperators   #-}
{-# LANGUAGE OverloadedStrings #-}
module Lib
    ( startApp
    ) where

import Control.Concurrent (forkIO, threadDelay)
import Data.IORef
import System.Environment (getArgs)

import Data.Aeson
import Data.Aeson.TH
import GitHub.Data.Name
import Network.Wai
import Network.Wai.Handler.Warp
import Servant

import AppState (zeroState)
import GithubInteraction (updateAppState, mkOwner, mkRepo)
import Server (api, server)

startApp :: IO ()
startApp = do
  theArgs <- getArgs
  let interval = 1000 * 1000 * 60
      (!nameOwner, !nameRepo) = case theArgs of
        [] -> (mkOwner "kowainik", mkRepo "issue-wanted")
        [o, r] -> (mkOwner o, mkRepo r)
  theRef <- newIORef zeroState
  forkIO $ run 8080 (serve api $ server theRef)
  let loop = do
        updateAppState nameOwner nameRepo theRef
        threadDelay interval
        loop
  loop

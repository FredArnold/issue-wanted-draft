module GithubInteraction
  ( mkOwner
  , mkRepo
  , updateAppState
  ) where

import Data.IORef
import Data.Monoid
import Data.Text (pack)
import Data.Proxy

import GitHub.Endpoints.Issues
import GitHub.Data.Name
import GitHub.Data.Options (stateAll)

import AppState


mkOwner :: String -> Name Owner
mkOwner = mkName Proxy . pack

mkRepo :: String -> Name Repo
mkRepo = mkName Proxy . pack

updateAppState :: Name Owner -> Name Repo -> IORef AppState -> IO ()
updateAppState ownerName repoName ref = do
  queryResult <- issuesForRepo ownerName repoName stateAll
  case queryResult of
    Left err -> do
      putStrLn $ "Error: " ++ show err
      atomicModifyIORef' ref $ \a
        -> (a {failedQueries = failedQueries a +1}, ())
    Right theIssues -> atomicModifyIORef' ref $ \a
      -> ( a
           { successfulQueries = successfulQueries a + 1
           , totalIssues = getSum $ foldMap (const $ Sum 1) theIssues
           , openIssues = getSum $ foldMap oneIfOpen theIssues
           }
         , ()
         )
  where
    oneIfOpen i = if issueState i == StateOpen then Sum 1 else Sum 0

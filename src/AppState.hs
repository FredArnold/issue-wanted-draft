module AppState
  ( AppState(..)
  , zeroState
  ) where


data AppState =
  AppState
  { successfulQueries :: Int
  , failedQueries :: Int
  , totalIssues :: Int
  , openIssues :: Int
  }

zeroState :: AppState
zeroState = AppState 0 0 0 0

module Solutions.CountPlayersPerMonth
    ( countPlayersPerMonth
    ) where

import qualified Data.Map.Strict     as Map
import           Data.Time
import           Data.Time.LocalTime
import           EventStore

countPlayersPerMonth =
    Projection {initState = Map.empty, step = step', query = id}

step' state event = when (event |> payload)
  where
    when PlayerHasRegistered {} = Map.alter incr month state
    when _                      = state
    incr Nothing  = Just 1
    incr (Just x) = Just $ x + 1
    month = formatTime defaultTimeLocale "%B" (event |> timestamp)

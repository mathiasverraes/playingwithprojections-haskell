module CountPlayersPerMonth
    ( countPlayersPerMonth
    ) where

import qualified Data.Map.Strict     as Map
import           Data.Time
import           Data.Time.LocalTime
import           EventStore

countPlayersPerMonth =
    Projection {initState = Map.empty, transform = id, step = step'}

step' state event = when (event |> payload)
  where
    when PlayerHasRegistered {} = Map.alter incr month state
    when _                      = state
    incr Nothing  = Just 1
    incr (Just x) = Just $ x + 1
    month = formatTime defaultTimeLocale "%0Y-%m" (event |> timestamp)

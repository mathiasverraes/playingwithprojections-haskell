module CountPlayersPerMonth
    ( countPlayersPerMonth
    ) where

import qualified Data.Map.Strict     as Map
import           Data.Time
import           Data.Time.LocalTime
import           EventStore

countPlayersPerMonth =
    Projection {initState = Map.empty, transform = id, step = step'}

step' state event =
    if typeOf event == "PlayerHasRegistered"
        then Map.alter incr month state
        else state
  where
    incr Nothing  = Just 1
    incr (Just x) = Just $ x + 1
    month = formatTime defaultTimeLocale "%0Y-%m" (timestampOf event)

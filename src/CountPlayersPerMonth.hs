module CountPlayersPerMonth where


import qualified Data.Map.Strict     as M
import           Data.Time
import           Data.Time.LocalTime
import           EventStore

initState = M.empty

projection state event =
    if typeOf event == "PlayerHasRegistered"
        then M.alter incr month state
        else state
  where
    incr Nothing  = Just 1
    incr (Just x) = Just $ x + 1
    month = formatTime defaultTimeLocale "%0Y-%m" (timestampOf event)

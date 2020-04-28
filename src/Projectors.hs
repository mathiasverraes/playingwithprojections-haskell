module Projectors where

import           Data.HashMap.Strict ((!))
import           Data.Time.LocalTime
import           EventStore

go :: EventStore -> IO ()
go eventStore = do
    state <- eventStore `replayInto` countEvents
    print state

countEvents = Projector {initState = 0 :: Int, project = \state event -> state + 1}
{-
Tip: this is how you get values from events:
idOf event                      :: String
typeOf event                    :: String
timestampOf event               :: ZonedTime
payloadOf event                 :: HashMap String String
payloadOf event ! "quiz_title"  :: String
-}

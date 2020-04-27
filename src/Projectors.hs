module Projectors where

import           EventStore

go :: EventStore -> IO ()
go eventStore = do
    state <- eventStore `replayInto` countEvents
    print state

countEvents = Projector {initState = 0 :: Int, project = \state event -> state + 1}

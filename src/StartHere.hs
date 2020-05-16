module StartHere where

import           EventStore

go :: EventStore -> IO ()
go eventStore = do
    result <- replay eventStore yourProjection
    print result


yourProjection = Projection {initState = yourState, step = yourStep, query = yourQuery}

yourState = ()
yourStep state event = state
yourQuery state = state

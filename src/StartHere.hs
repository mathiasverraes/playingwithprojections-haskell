module StartHere (go) where

import qualified CountEvents          (initState, projection)
import qualified CountPlayers         (initState, projection)
import qualified CountPlayersPerMonth (initState, projection)
import           EventStore

go :: EventStore -> IO ()
go eventStore = do
    state <- replay eventStore CountEvents.initState CountEvents.projection
    print state

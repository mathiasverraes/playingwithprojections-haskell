module StartHere (go) where

import qualified CountEvents          (initState, projection)
import qualified CountPlayers         (initState, projection)
import qualified CountPlayersPerMonth (initState, projection)
import qualified MostPopularQuizzes (initState, projection, transform)
import           EventStore

go :: EventStore -> IO ()
go eventStore = do

    state <- replay eventStore CountEvents.initState CountEvents.projection
    print state

    state <- replay eventStore CountPlayers.initState CountPlayers.projection
    print state

    state <- replay eventStore CountPlayersPerMonth.initState CountPlayersPerMonth.projection
    print state

    state <- replay eventStore MostPopularQuizzes.initState MostPopularQuizzes.projection
    print $ MostPopularQuizzes.transform state


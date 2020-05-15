module Sample where

import           EventStore
import           Projections.CountEvents          (countEvents)
import           Projections.CountPlayers         (countPlayers)
import           Projections.CountPlayersPerMonth (countPlayersPerMonth)
import           Projections.MostPopularQuizzes   (mostPopularQuizzes)

go = go' (EventStore "data/basic.json")

go' :: EventStore -> IO ()
go' eventStore = do
    result <- replay eventStore countEvents
    print result

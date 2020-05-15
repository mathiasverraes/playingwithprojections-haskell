module Sample where

import           EventStore
import           Projections.CountEvents          (countEvents)
import           Projections.CountPlayers         (countPlayers)
import           Projections.CountPlayersPerMonth (countPlayersPerMonth)
import           Projections.MostPopularQuizzes   (mostPopularQuizzes)

go :: EventStore -> IO ()
go eventStore = do
    result <- replay eventStore countEvents
    print result
    result <- replay eventStore countPlayers
    print result
    result <- replay eventStore countPlayersPerMonth
    print result
    result <- replay eventStore mostPopularQuizzes
    mapM_ print result

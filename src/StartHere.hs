module StartHere where

import           CountEvents          (countEvents)
import           CountPlayers         (countPlayers)
import           CountPlayersPerMonth (countPlayersPerMonth)
import           EventStore
import           MostPopularQuizzes   (mostPopularQuizzes)

go :: EventStore -> IO ()
go eventStore = do
    result <- replay eventStore countEvents
    print result
    result <- replay eventStore countPlayers
    print result
    result <- replay eventStore countPlayersPerMonth
    print result
    result <- replay eventStore mostPopularQuizzes
    print result

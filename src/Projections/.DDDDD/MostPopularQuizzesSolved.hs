{-# LANGUAGE NamedFieldPuns #-}

module Projections.MostPopularQuizzes
    ( mostPopularQuizzes
    ) where

import           Data.List
import qualified Data.Map.Strict as Map
import           EventStore
import           Flow
import           Text.Printf     (printf)

mostPopularQuizzes =
    Projection {startWith = emptyQuizPops, then' = trackPopularity, andFinally = getTenMostPopular}

trackPopularity :: QuizPops -> Event -> QuizPops
trackPopularity quizPops event = when (event |> payload)
  where
    when QuizWasCreated {quiz_id, quiz_title} =
        quizPops |> startTracking quiz_id (newQuizPop quiz_id quiz_title)
    when GameWasOpened {quiz_id} =
        quizPops |> incrementPopularity quiz_id
    when _ = quizPops

-- Entity
data QuizPopularity =
    QuizPopularity
        { quizId     :: QuizId
        , quizTitle  :: String
        , popularity :: Int
        }
    deriving (Eq)
newQuizPop :: QuizId -> String -> QuizPopularity
newQuizPop quiz_id quiz_title =
    QuizPopularity {quizId = quiz_id, quizTitle = quiz_title, popularity = 0}

-- Repository
type QuizPops = Map.Map QuizId QuizPopularity

emptyQuizPops :: QuizPops
emptyQuizPops = Map.empty

startTracking :: QuizId -> QuizPopularity -> QuizPops -> QuizPops
startTracking = Map.insert

incrementPopularity :: QuizId -> QuizPops -> QuizPops
incrementPopularity =
    Map.adjust (\quiz -> quiz {popularity = popularity quiz + 1})

getTenMostPopular :: QuizPops -> [QuizPopularity]
getTenMostPopular quizzes =
    selectAllFrom quizzes  |> sortOn (desc . popularity) |> limit 10
  where
    selectAllFrom quizzes = quizzes |> Map.toList |> fmap snd
    limit = take
    desc = negate

instance Show QuizPopularity where
    show quiz = printf "%d: %s" (quiz |> popularity) (quiz |> quizTitle)

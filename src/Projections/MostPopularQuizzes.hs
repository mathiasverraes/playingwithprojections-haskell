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
    Projection
        { initState = emptyQuizzes
        , step = trackPopularity
        , transform = tenMostPopular
        }

data Quiz =
    Quiz
        { quizId     :: QuizId
        , quizTitle  :: String
        , popularity :: Int
        }
    deriving (Eq)

type Quizzes = Map.Map QuizId Quiz

emptyQuizzes :: Quizzes
emptyQuizzes = Map.empty

addNewQuiz :: QuizId -> String -> Quizzes -> Quizzes
addNewQuiz id title = Map.insert id (Quiz id title 0)

incrementQuiz :: QuizId -> Quizzes -> Quizzes
incrementQuiz = Map.adjust incr
  where
    incr quiz = quiz {popularity = popularity quiz + 1}

trackPopularity :: Quizzes -> Event -> Quizzes
trackPopularity quizzes event = when (event |> payload)
  where
    when QuizWasCreated {quiz_id, quiz_title} =
        quizzes |> addNewQuiz quiz_id quiz_title
    when GameWasOpened {quiz_id} = quizzes |> incrementQuiz quiz_id
    when _ = quizzes

tenMostPopular :: Quizzes -> [Quiz]
tenMostPopular quizzes =
    quizzes |> fetchAll |> sortOn popularity |> reverse |> take 10
  where
    fetchAll = Map.toList .> fmap snd

instance Show Quiz where
    show = format
      where
        format quiz = printf "%d: %s" (quiz |> popularity) (quiz |> quizTitle)

{-# LANGUAGE NamedFieldPuns #-}

module Projections.MostPopularQuizzesOrig
    ( mostPopularQuizzes
    ) where

import           Data.List
import qualified Data.Map.Strict as Map
import           EventStore
import           Flow
import           Text.Printf     (printf)

mostPopularQuizzes =
    Projection {initState = Map.empty, step = step', transform = transform'}

data Quiz =
    Quiz
        { quizId     :: QuizId
        , quizTitle  :: String
        , popularity :: Int
        }
    deriving (Eq)

step' :: Map.Map QuizId Quiz -> Event -> Map.Map QuizId Quiz
step' state event = when (event |> payload)
  where
    when QuizWasCreated {quiz_id, quiz_title} =
        Map.insert
            quiz_id
            (Quiz {quizId = quiz_id, quizTitle = quiz_title, popularity = 0})
            state
    when GameWasOpened {quiz_id} =
        Map.adjust
            (\quiz -> quiz {popularity = popularity quiz + 1})
            quiz_id
            state
    when _ = state

transform' :: Map.Map QuizId Quiz -> [Quiz]
transform' quizzes =
    quizzes |> Map.toList |> fmap snd |> sortOn popularity |> reverse |> take 10

instance Show Quiz where
    show quiz = printf "%d: %s" (quiz |> popularity) (quiz |> quizTitle)


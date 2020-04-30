{-# LANGUAGE NamedFieldPuns #-}

module Projections.MostPopularQuizzes
    ( mostPopularQuizzes
    ) where

import           Data.List
import qualified Data.Map.Strict as Map
import           EventStore
import           Text.Printf     (printf)

mostPopularQuizzes =
    Projection
        { initState = Map.empty
        , step = trackPopularity
        , transform = tenMostPopular
        }

type State = Map.Map QuizId Quiz

data Quiz =
    Quiz
        { quizId     :: QuizId
        , quizTitle  :: String
        , popularity :: Int
        }
    deriving (Eq)

incr quiz = quiz {popularity = popularity quiz + 1}

format quiz = printf "%d: %s" (quiz |> popularity) (quiz |> quizTitle)

trackPopularity :: State -> Event -> State
trackPopularity state event = when (event |> payload)
  where
    when QuizWasCreated {quiz_id, quiz_title} =
        Map.insert quiz_id (Quiz quiz_id quiz_title 0) state
    when GameWasOpened {quiz_id} = Map.adjust incr quiz_id state
    when _ = state

tenMostPopular :: State -> [Quiz]
tenMostPopular state =
    state |> Map.toList |> fmap snd |> sortOn popularity |> reverse |> take 10

instance Show Quiz where
    show = format

{-# LANGUAGE MultiWayIf #-}

module Projections.MostPopularQuizzes
    ( mostPopularQuizzes
    ) where

import           Data.List
import qualified Data.Map.Strict as M
import           EventStore

mostPopularQuizzes =
    Projection
        { initState = M.empty :: M.Map String Quiz
        , transform = transform'
        , step = step'
        }

data Quiz =
    Quiz
        { quizId     :: String
        , quizTitle  :: String
        , popularity :: Int
        }
    deriving (Eq)

incr quiz = quiz {popularity = popularity quiz + 1}

instance Show Quiz where
    show quiz = show (popularity quiz) <> ": " <> quizTitle quiz

step' :: M.Map String Quiz -> Event -> M.Map String Quiz
step' state event =
    case event |> event_type of
        "QuizWasCreated" -> M.insert getQuizId makeQuiz state
        "GameWasOpened"  -> M.adjust incr getQuizId state
        _                -> state
  where
    getQuizId = event |> payload |> quiz_id
    makeQuiz =
        Quiz
            { quizId = getQuizId
            , quizTitle = event |> payload |> quiz_title
            , popularity = 0
            }

transform' :: M.Map String Quiz -> [Quiz]
transform' state =
    state |> M.toList |> fmap snd |> sortOn popularity |> reverse |> take 15

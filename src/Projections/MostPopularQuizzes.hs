{-# LANGUAGE NamedFieldPuns #-}

module Projections.MostPopularQuizzes
    ( mostPopularQuizzes
    ) where

import           Data.List
import qualified Data.Map.Strict as M
import           EventStore
import           Text.Printf     (printf)

mostPopularQuizzes =
    Projection {initState = M.empty, step = step', transform = transform'}

type State = M.Map QuizId Quiz

data Quiz =
    Quiz
        { quizId     :: QuizId
        , quizTitle  :: String
        , popularity :: Int
        }
    deriving (Eq)

incr quiz = quiz {popularity = popularity quiz + 1}

format quiz = printf "%d: %s" (quiz |> popularity) (quiz |> quizTitle)

step' :: State -> Event -> State
step' state event = when (event |> payload)
  where
    when QuizWasCreated {quiz_id, quiz_title} =
        M.insert quiz_id (Quiz quiz_id quiz_title 0) state
    when GameWasOpened {quiz_id} = M.adjust incr quiz_id state
    when _ = state

transform' :: State -> [Quiz]
transform' state =
    state |> M.toList |> fmap snd |> sortOn popularity |> reverse |> take 10

instance Show Quiz where
    show = format

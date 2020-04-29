{-# LANGUAGE MultiWayIf #-}

module MostPopularQuizzes
    ( mostPopularQuizzes
    ) where

import           Data.List
import qualified Data.Map.Strict as M
import           EventStore
import           Flow

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
    if | typeOf event == "QuizWasCreated" -> M.insert getQuizId makeQuiz state
       | typeOf event == "GameWasOpened" -> M.adjust incr getQuizId state
       | otherwise -> state
  where
    getQuizId = payloadOf event ! "quiz_id"
    makeQuiz =
        Quiz
            { quizId = getQuizId
            , quizTitle = payloadOf event ! "quiz_title"
            , popularity = 0
            }

transform' :: M.Map String Quiz -> [Quiz]
transform' state =
    state |> M.toList |> fmap snd |> sortOn popularity |> reverse |> take 15

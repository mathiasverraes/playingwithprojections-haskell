{-# LANGUAGE MultiWayIf #-}
module MostPopularQuizzes where

import qualified Data.Map.Strict as M
import           EventStore
import           Flow
import Data.List


data Quiz = Quiz
    { quizId :: String
    , quizTitle :: String
    , popularity :: Int
    } deriving (Eq)
    
instance Show Quiz where
    show quiz = show (popularity quiz) <> ": " <> quizTitle quiz

initState :: State (M.Map String Quiz)
initState = M.empty

projection :: State (M.Map String Quiz) -> Event -> State (M.Map String Quiz)
projection state event =
    if | typeOf event == "QuizWasCreated" -> M.insert getQuizId makeQuiz state
       | typeOf event == "GameWasOpened" -> M.adjust incr getQuizId state
       | otherwise -> state
  where
    getQuizId = payloadOf event ! "quiz_id"
    makeQuiz = Quiz
        { quizId = getQuizId
        , quizTitle = payloadOf event ! "quiz_title"
        , popularity = 0
    }
    incr quiz = quiz{popularity = popularity quiz + 1}


transform :: State (M.Map String Quiz) -> [Quiz]
transform state =
    state
    |> M.toList
    |> fmap snd
    |> sortOn popularity
    |> reverse
    |> take 15


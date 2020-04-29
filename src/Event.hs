{-# LANGUAGE OverloadedStrings #-}

module Event
    ( Event
    , event_id
    , event_type
    , timestamp
    , payload
    ) where

import           Data.Aeson
import           Data.Aeson.Types (Parser)
import           Data.Time        (ZonedTime)
import           DomainEvent

data Event =
    Event
        { event_id   :: String
        , event_type :: String
        , timestamp  :: ZonedTime
        , payload    :: DomainEvent
        }
    deriving (Show)

instance FromJSON Event where
    parseJSON =
        withObject "Event" $ \o -> do
            id <- o .: "id"
            type' <- o .: "type"
            timestamp <- o .: "timestamp"
            p <- o .: "payload"
            event <- parse p type'
            return $ Event id type' timestamp event

parse :: Object -> String -> Parser DomainEvent
parse p "PlayerHasRegistered" =
    PlayerHasRegistered <$> p .: "player_id" <*> p .: "last_name" <*>
    p .: "first_name"
parse p "QuestionAddedToQuiz" =
    QuestionAddedToQuiz <$> p .: "quiz_id" <*> p .: "question_id" <*>
    p .: "question" <*>
    p .: "answer"
parse p "QuizWasCreated" =
    QuizWasCreated <$> p .: "quiz_title" <*> p .: "quiz_id" <*> p .: "owner_id"
parse p "GameWasOpened" =
    GameWasOpened <$> p .: "quiz_id" <*> p .: "game_id" <*> p .: "player_id"
parse p "QuestionWasAsked" =
    QuestionWasAsked <$> p .: "question_id" <*> p .: "game_id"
parse p "TimerHasExpired" =
    TimerHasExpired <$> p .: "question_id" <*> p .: "player_id" <*>
    p .: "game_id"
parse p "GameWasStarted" = GameWasStarted <$> p .: "game_id"
parse p "GameWasFinished" = GameWasFinished <$> p .: "game_id"
parse p "QuizWasPublished" = QuizWasPublished <$> p .: "quiz_id"
parse p "PlayerJoinedGame" =
    PlayerJoinedGame <$> p .: "player_id" <*> p .: "game_id"
parse p "AnswerWasGiven" =
    AnswerWasGiven <$> p .: "question_id" <*> p .: "player_id" <*>
    p .: "game_id" <*>
    p .: "answer"
parse p "QuestionWasCompleted" =
    QuestionWasCompleted <$> p .: "question_id" <*> p .: "game_id"
parse p "GameWasCancelled" = GameWasCancelled <$> p .: "game_id"
parse p type' = fail ("unknown event type: " ++ type')

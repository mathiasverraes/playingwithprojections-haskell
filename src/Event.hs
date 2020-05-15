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
        { event_id   :: EventId
        , event_type :: EventType
        , timestamp  :: ZonedTime
        , payload    :: DomainEvent
        }
    deriving (Show)

type EventId = String

type EventType = String

instance FromJSON Event where
    parseJSON =
        withObject "Event" $ \o -> do
            event_id <- o .: "id"
            event_type <- o .: "type"
            timestamp <- o .: "timestamp"
            payload <- o .: "payload"
            event <- parseDomainEvent payload event_type
            return $ Event event_id event_type timestamp event

parseDomainEvent :: Object -> String -> Parser DomainEvent
parseDomainEvent p "PlayerHasRegistered" =
    PlayerHasRegistered <$> p .: "player_id" <*> p .: "last_name" <*>
    p .: "first_name"
parseDomainEvent p "QuestionAddedToQuiz" =
    QuestionAddedToQuiz <$> p .: "quiz_id" <*> p .: "question_id" <*>
    p .: "question" <*>
    p .: "answer"
parseDomainEvent p "QuizWasCreated" =
    QuizWasCreated <$> p .: "quiz_id" <*> p .: "quiz_title" <*> p .: "owner_id"
parseDomainEvent p "GameWasOpened" =
    GameWasOpened <$> p .: "quiz_id" <*> p .: "game_id" <*> p .: "player_id"
parseDomainEvent p "QuestionWasAsked" =
    QuestionWasAsked <$> p .: "question_id" <*> p .: "game_id"
parseDomainEvent p "TimerHasExpired" =
    TimerHasExpired <$> p .: "question_id" <*> p .: "player_id" <*>
    p .: "game_id"
parseDomainEvent p "GameWasStarted" = GameWasStarted <$> p .: "game_id"
parseDomainEvent p "GameWasFinished" = GameWasFinished <$> p .: "game_id"
parseDomainEvent p "QuizWasPublished" = QuizWasPublished <$> p .: "quiz_id"
parseDomainEvent p "PlayerJoinedGame" =
    PlayerJoinedGame <$> p .: "player_id" <*> p .: "game_id"
parseDomainEvent p "AnswerWasGiven" =
    AnswerWasGiven <$> p .: "question_id" <*> p .: "player_id" <*>
    p .: "game_id" <*>
    p .: "answer"
parseDomainEvent p "QuestionWasCompleted" =
    QuestionWasCompleted <$> p .: "question_id" <*> p .: "game_id"
parseDomainEvent p "GameWasCancelled" = GameWasCancelled <$> p .: "game_id"
parseDomainEvent p type' = fail ("unknown event type: " ++ type')

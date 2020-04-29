module DomainEvent where

data DomainEvent
    = PlayerHasRegistered
          { player_id  :: String
          , last_name  :: String
          , first_name :: String
          }
    | QuestionAddedToQuiz
          { quiz_id     :: String
          , question_id :: String
          , question    :: String
          , answer      :: String
          }
    | QuizWasCreated
          { quiz_title :: String
          , quiz_id    :: String
          , owner_id   :: String
          }
    | GameWasOpened
          { quiz_id   :: String
          , game_id   :: String
          , player_id :: String
          }
    | QuestionWasAsked
          { question_id :: String
          , game_id     :: String
          }
    | TimerHasExpired
          { question_id :: String
          , player_id   :: String
          , game_id     :: String
          }
    | GameWasStarted
          { game_id :: String
          }
    | GameWasFinished
          { game_id :: String
          }
    | QuizWasPublished
          { quiz_id :: String
          }
    | PlayerJoinedGame
          { player_id :: String
          , game_id   :: String
          }
    | AnswerWasGiven
          { question_id :: String
          , player_id   :: String
          , game_id     :: String
          , answer      :: String
          }
    | QuestionWasCompleted
          { question_id :: String
          , game_id     :: String
          }
    | GameWasCancelled
          { game_id :: String
          }
    deriving (Show, Eq)

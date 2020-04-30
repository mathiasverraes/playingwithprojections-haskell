module DomainEvent where

data DomainEvent
    = PlayerHasRegistered
          { player_id  :: PlayerId
          , last_name  :: String
          , first_name :: String
          }
    | QuestionAddedToQuiz
          { quiz_id     :: QuizId
          , question_id :: QuestionId
          , question    :: String
          , answer      :: String
          }
    | QuizWasCreated
          { quiz_id    :: QuizId
          , quiz_title :: String
          , owner_id   :: OwnerId
          }
    | GameWasOpened
          { quiz_id   :: QuizId
          , game_id   :: GameId
          , player_id :: PlayerId
          }
    | QuestionWasAsked
          { question_id :: QuestionId
          , game_id     :: GameId
          }
    | TimerHasExpired
          { question_id :: QuestionId
          , player_id   :: PlayerId
          , game_id     :: GameId
          }
    | GameWasStarted
          { game_id :: GameId
          }
    | GameWasFinished
          { game_id :: GameId
          }
    | QuizWasPublished
          { quiz_id :: QuizId
          }
    | PlayerJoinedGame
          { player_id :: PlayerId
          , game_id   :: GameId
          }
    | AnswerWasGiven
          { question_id :: QuestionId
          , player_id   :: PlayerId
          , game_id     :: GameId
          , answer      :: String
          }
    | QuestionWasCompleted
          { question_id :: QuestionId
          , game_id     :: GameId
          }
    | GameWasCancelled
          { game_id :: GameId
          }
    deriving (Show, Eq)

type GameId = String

type PlayerId = String

type OwnerId = String

type QuestionId = String

type QuizId = String

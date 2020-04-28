{-# LANGUAGE OverloadedStrings #-}

module EventStore where

import           Data.Aeson
import           Data.HashMap.Strict
import           Data.Time.LocalTime

newtype EventStore =
    EventStore
        { file :: String
        }
    deriving (Show, Eq)

data Projector a =
    Projector
        { initState :: a
        , project   :: a -> Event -> a
        }

replayInto :: EventStore -> Projector a -> IO a
replayInto es p = do
    result <- decodeFileStrict (file es) :: IO (Maybe [Event])
    let events = concat result
    let state = foldl (project p) (initState p) events
    return state

data Event =
    Event
        { idOf        :: String
        , typeOf      :: String
        , timestampOf :: ZonedTime
        , payloadOf   :: HashMap String String
        }
    deriving (Show)

instance FromJSON Event where
    parseJSON (Object x) = Event <$> x .: "id" <*> x .: "type" <*> x .: "timestamp" <*> x .: "payload"
    parseJSON _ = fail "Expected an Object"

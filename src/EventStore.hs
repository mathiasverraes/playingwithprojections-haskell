{-# LANGUAGE OverloadedStrings #-}

module EventStore (module EventStore, (!)) where

import           Data.Aeson
import           Data.HashMap.Strict (HashMap, (!))
import           Data.Time.LocalTime

data Event =
    Event
        { idOf        :: String
        , typeOf      :: String
        , timestampOf :: ZonedTime
        , payloadOf   :: HashMap String String
        }
    deriving (Show)

newtype EventStore =
    EventStore
        { file :: String
        }
    deriving (Show, Eq)

type State a = a
type Projection a = (State a -> Event -> State a)

stream :: EventStore -> IO [Event]
stream es = concat <$> decodeFileStrict (file es)

replay :: EventStore -> State a -> Projection a -> IO (State a)
replay eventStore initState projection = do
    events <- stream eventStore
    return $ foldl projection initState events

instance FromJSON Event where
    parseJSON (Object x) = Event <$> x .: "id" <*> x .: "type" <*> x .: "timestamp" <*> x .: "payload"
    parseJSON _ = fail "Expected an Object"



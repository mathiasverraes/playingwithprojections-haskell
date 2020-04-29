{-# LANGUAGE OverloadedStrings #-}

module EventStore
    ( module EventStore
    , (!)
    ) where

import           Data.Aeson
import           Data.HashMap.Strict (HashMap, (!))
import           Data.Time.LocalTime
import           Flow

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

stream :: EventStore -> IO [Event]
stream es = concat <$> decodeFileStrict (file es)

instance FromJSON Event where
    parseJSON (Object x) =
        Event <$> x .: "id" <*> x .: "type" <*> x .: "timestamp" <*>
        x .: "payload"
    parseJSON _ = fail "Expected an Object"

data Projection a b =
    Projection
        { initState :: a
        , step      :: a -> Event -> a
        , transform :: a -> b
        }

replay :: EventStore -> Projection a b -> IO b
replay eventStore projection = do
    events <- stream eventStore
    let state = foldl (projection |> step) (projection |> initState) events
    return $ (projection |> transform) state

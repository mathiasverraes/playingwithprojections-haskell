module EventStore
    ( module EventStore
    , module DomainEvent
    , module Event
    , (|>)
    ) where

import           Data.Aeson          (decodeFileStrict)
import           Data.List           (foldl')
import           Data.Time.LocalTime
import           DomainEvent
import           Event
import           Flow

newtype EventStore =
    EventStore
        { file :: String
        }
    deriving (Show, Eq)

data Projection a b =
    Projection
        { initState :: a
        , step      :: a -> Event -> a
        , query :: a -> b
        }

stream :: EventStore -> IO [Event]
stream es = concat <$> decodeFileStrict (file es)

replay :: EventStore -> Projection a b -> IO b
replay eventStore projection = do
    events <- stream eventStore
    let state = foldl' (projection |> step) (projection |> initState) events
    return $ (projection |> query) state

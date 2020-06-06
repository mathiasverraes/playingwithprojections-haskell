module EventStore
    ( module EventStore
    , module DomainEvent
    , module Event
    , (|>)
    ) where

import qualified Data.ByteString.Streaming as ST
import           Data.ByteString.Streaming.Aeson (streamParse)
import           Data.ByteString.Streaming.HTTP  (runResourceT)
import           Data.Function                   ((&))
import           Data.JsonStream.Parser          (arrayOf, value)
import           DomainEvent
import           Event
import           Flow
import           Streaming
import qualified Streaming.Prelude as S

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

replay :: EventStore -> Projection a b -> IO b
replay eventStore projection =
  runResourceT $
    ST.readFile
      (eventStore |> file)
      & streamParse (arrayOf value)
      & void
      & S.fold_ (projection |> step) (projection |> initState) (projection |> query)

{-# LANGUAGE RecordWildCards #-}

module CountPlayers
    ( countPlayers
    ) where

import           EventStore

countPlayers = Projection {initState = 0, transform = id, step = step'}

step' state event = when (event |> payload)
  where
    when PlayerHasRegistered {..} = state + 1
    when _                        = state

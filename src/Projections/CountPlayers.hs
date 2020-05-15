module Projections.CountPlayers
    ( countPlayers
    ) where

import           EventStore

countPlayers = Projection {initState = 0, step = step', transform = id}

step' state event = apply (event |> payload)
  where
    apply PlayerHasRegistered {} = undefined

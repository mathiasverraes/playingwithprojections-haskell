module Projections.CountEvents
    ( countEvents
    ) where

import           EventStore

countEvents = Projection {initState = 0, step = step', transform = id}

step' n event = n + 1

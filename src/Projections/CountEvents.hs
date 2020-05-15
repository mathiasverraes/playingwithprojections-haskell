module Projections.CountEvents
    ( countEvents
    ) where

import           EventStore

countEvents = Projection {initState = 0, step = f, transform = id}

f _ _ = undefined

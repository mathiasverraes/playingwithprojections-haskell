module Projections.CountEvents
    ( countEvents
    ) where

import           EventStore

countEvents = Projection {initState = 0, step = f, query = id}

f init _ = init + 1
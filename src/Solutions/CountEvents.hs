module Solutions.CountEvents
    ( countEvents
    ) where

import           EventStore

countEvents = Projection {initState = 0, step = f, query = id}

f n _ = n + 1

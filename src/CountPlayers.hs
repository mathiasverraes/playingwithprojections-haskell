module CountPlayers
    ( countPlayers
    ) where

import           EventStore

countPlayers = Projection {initState = 0, transform = id, step = step'}

step' state event =
    if typeOf event == "PlayerHasRegistered"
        then state + 1
        else state

module CountPlayers where

import           EventStore

initState = 0

projection state event =
    if typeOf event == "PlayerHasRegistered"
        then state + 1
        else state

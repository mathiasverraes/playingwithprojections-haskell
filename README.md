# Playing with Projections - Haskell

[playingwithprojections.github.io](https://playingwithprojections.github.io/)

## Running it

This should do it: 

```
stack run path/to/basic.json
```

or

```
stack repl
> cmd ["path/to/basic.json"]
```

## Challenges

Tip: this is how you get values from events:

```
idOf event                      :: String
typeOf event                    :: String
timestampOf event               :: ZonedTime
payloadOf event                 :: HashMap String String
payloadOf event ! "quiz_title"  :: String
```
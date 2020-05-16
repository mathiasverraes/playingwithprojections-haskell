# Playing with Projections - Haskell version

Read all about it here first:

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

## Tips

This is how you get values from events:

```
event |> event_id              -- String
event |> event_type            -- String
event |> timestamp             -- ZonedTime
event |> payload |> quiz_title -- String
```

Note: `x |> f = f x`, it's from the [Flow](https://github.com/tfausak/flow#cheat-sheet) library.

### Video

There's a video by @mathiasverraes and @ericevans0 that explains some stuff, albeit rather chaotic.

[![Video](http://img.youtube.com/vi/FtxPdXp_FTA/0.jpg)](http://www.youtube.com/watch?v=FtxPdXp_FTA)


## Domain

![Process](domain/Process.png)
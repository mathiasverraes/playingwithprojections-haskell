{-# LANGUAGE DeriveGeneric #-}

module Lib where

import           GHC.Generics

someFunc :: IO ()
someFunc = putStrLn "someFunc"

data Event =
    Event
        { id        :: String
        , timestamp :: String
        }
    deriving (Generic, Show)

module Main where

import           EventStore
import           Projectors
import           System.Environment
import           System.Exit

main = getArgs >>= cmd

cmd [file] = go $ EventStore file
cmd _      = die "\nProvide the path to the data file as an argument.\n"

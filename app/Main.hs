module Main where

import Lib

import Control.Monad.Loops (whileM_)

main :: IO ()
main = whileM_ interpreter (putStrLn "staying alive")

interpreter :: IO Bool
interpreter = do
    line <- getLine
    if line == "exit"
        then do
            putStrLn "bye"
            pure False
        else pure True


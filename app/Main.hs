module Main where

import Lib

import Control.Monad.Loops (whileM_)

main :: IO ()
main = whileM_ interpreter $ pure ()

execute :: String -> IO ()
execute "put" = putStrLn "putting value"
execute "get" = putStrLn "getting value"
execute other = putStrLn $ "You just entered " ++ other

interpreter :: IO Bool
interpreter = do
    line <- getLine
    if line == "exit"
        then do
            putStrLn "bye"
            pure False
        else do
            execute line
            pure True


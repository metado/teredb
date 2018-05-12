module Main where

import Lib

import System.Exit
import Data.List

data Command = Get String | Put String String | Exit

database :: String
database = "database.txt"

main :: IO ()
main = sequence_ $ repeat interpreter

execute :: Command -> IO ()
execute (Get key) = get key
execute (Put key value) = put key value
execute Exit = putStrLn "Bye!" >> exitWith ExitSuccess

parseCommand :: String -> Either String Command
parseCommand command = case words command of ["get", key] -> Right $ Get key
                                             ["put", key, value] -> Right $ Put key value
                                             ["exit"] -> Right Exit
                                             other -> Left $ intercalate " " other

interpreter :: IO ()
interpreter = do
    line <- getLine
    case parseCommand line of Right command -> do
                                execute command
                              Left unknown -> do
                                putStrLn $ "Unknown command " ++ unknown

put :: String -> String -> IO ()
put key value = appendFile database (key ++ "\t" ++ value ++ "\n")

get :: String -> IO ()
get key = do
    content <- readFile database
    let linesOfFiles = fmap words $ lines content
    print $ find (searchByKey key) linesOfFiles

searchByKey :: String -> [String] -> Bool
searchByKey key kvs = case kvs of h : _ -> h == key
                                  _ -> False

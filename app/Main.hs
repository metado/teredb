module Main where

import Lib

import System.Environment
import System.Exit
import Data.List

data Command = Get String | Put String String | Exit

data Config = Config String

main :: IO ()
main = do
    args <- getArgs
    run args
    
run :: [String] -> IO ()
run args = do
    case parseArgs args of Right config -> sequence_ $ repeat (interpreter config)
                           Left error -> die error
    
execute :: Config -> Command -> IO ()
execute config (Get key) = get config key
execute config (Put key value) = put config key value
execute config Exit = putStrLn "Bye!" >> exitWith ExitSuccess

parseArgs :: [String] -> Either String Config
parseArgs [] = Left "Expected one argument, none given"
parseArgs (p : []) = Right $ Config p
parseArgs other = Left $ "Unexpected arguments " ++ (intercalate " " other)

parseCommand :: String -> Either String Command
parseCommand command = case words command of ["get", key] -> Right $ Get key
                                             ["put", key, value] -> Right $ Put key value
                                             ["exit"] -> Right Exit
                                             other -> Left $ intercalate " " other

interpreter :: Config -> IO ()
interpreter config = do
    line <- getLine
    case parseCommand line of Right command -> do
                                execute config command
                              Left unknown -> do
                                putStrLn $ "Unknown command " ++ unknown

put :: Config -> String -> String -> IO ()
put (Config database) key value = appendFile database (key ++ "\t" ++ value ++ "\n")

get :: Config -> String -> IO ()
get (Config database) key = do
    content <- readFile database
    let linesOfFiles = fmap words $ lines content
    print $ find (searchByKey key) linesOfFiles

searchByKey :: String -> [String] -> Bool
searchByKey key kvs = case kvs of h : _ -> h == key
                                  _ -> False

module Main where

import Lib

import Data.List
import System.Environment
import System.Exit

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


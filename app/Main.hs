module Main where

import Lib

import Data.List
import Control.Monad.Loops (whileM_)

data Command = Get String | Put String String | Exit

main :: IO ()
main = whileM_ interpreter $ pure ()

execute :: Command -> IO ()
execute (Get key) = putStrLn $ "getting key " ++ key
execute (Put key value) = putStrLn $ "putting key " ++ key

parseCommand :: String -> Either String Command
parseCommand command = case words command of ["get", key] -> Right $ Get key
                                             ["put", key, value] -> Right $ Put key value
                                             ["exit"] -> Right Exit
                                             other -> Left $ intercalate " " other

interpreter :: IO Bool
interpreter = do
    line <- getLine
    case parseCommand line of Right Exit -> do
                                putStrLn "bye"
                                pure False
                              Right command -> do
                                execute command
                                pure True
                              Left unknown -> do
                                putStrLn $ "Unknown command " ++ unknown ++ ". Aborting!"
                                pure False


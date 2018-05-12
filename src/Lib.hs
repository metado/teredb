module Lib
    ( Command(..)
    , Config(..)
    , get
    , put
    ) where

import Data.List

data Command = Get String | Put String String | Exit

data Config = Config String

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

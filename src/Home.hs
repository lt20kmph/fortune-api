{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
module Home where

import qualified Data.ByteString.UTF8 as U
import           Data.Maybe
import qualified Data.Text            as T
import           Foundation
import           System.Process
import           Yesod.Core

mkOffArgs :: Maybe String -> Either [String] String
mkOffArgs (Just a)
  | a == "yes"  = Left ["-o"]
  | a == "no"   = Left []
  | a == "both" = Left ["-a"]
  | otherwise   = Right $ "Invalid args, offensive=" ++ a 
mkOffArgs Nothing = Left []  

mkLenArgs :: Maybe String -> Maybe String -> Either [String] String 
mkLenArgs (Just len) (Just sol) 
  | (read len < 15)   && (sol == "short") = Right "Too short!"
  | (read len > 1500) && (sol == "long")  = Right "Too long!" 
  | sol == "short"                        = Left ["-s","-n " ++ len]
  | sol == "long"                         = Left ["-l","-n " ++ len]
  | otherwise                             = Right error 
  where error = "Invalid args, shortorlong=" ++ sol 

mkLenArgs Nothing (Just sol) 
  | sol == "short"                        = Left ["-s"]
  | sol == "long"                         = Left ["-l"]
  | otherwise                             = Right error 
  where error = "Invalid args, shortorlong=" ++ sol 

mkLenArgs _ Nothing                       = Left [] 

mkFortune :: Either [String] String -> Either [String] String -> IO String
mkFortune (Left a)  (Left b)  = readProcess "fortune" (a ++ b) ""
mkFortune (Right a) (Left _)  = return a
mkFortune (Left _)  (Right b) = return b
mkFortune (Right a) (Right b) = return (a ++ "; " ++ b)

getHomeR :: Handler TypedContent
getHomeR = do
  off     <- lookupGetParam "offensive"
  sol     <- lookupGetParam "shortorlong"
  len     <- lookupGetParam "length"
  fortune <- liftIO $ mkFortune (mkOffArgs $ fmap T.unpack off) 
                     (mkLenArgs ( fmap T.unpack len) (fmap T.unpack sol)) 
  sendResponse ( U.fromString "text/plain" :: U.ByteString, toContent fortune)

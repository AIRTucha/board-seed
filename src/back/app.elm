port module Back.App exposing (..)

import Task
import Board.File exposing(read, File)
import Pathfinder exposing (..)
import Board exposing (..)
import Board.Router exposing (..)
import Board.Shared exposing (..)
import Dict exposing(insert)
import Board.Status exposing (..)
import Board.Router.Static exposing (static)
import Board.Internals exposing (..)
import Back.Utils exposing (..)


{-|
-}
config : Configurations ()
config = 
    { state = ()
    , errorPrefix = Just "Warning"
    , options = 
        { portNumber = 8083
        , timeout = 1000
        , https = Just 
            { key = Just "ok"
            , cert = Nothing
            , pfx = Just "shit"
            , passphrase = Nothing
            }
        }
    }
    

{-|
-}
port suggestions : (String -> msg) -> Sub msg


{-|
-}
main : Program Never () (Msg value1 () String)
main = board router config suggestions


{-|
-}
router : Request value -> Mode String (Answer value model String)
router =
    empty
        |> get (p "/") getIndex
        |> static (p "") "./public/"
        |> getSync any (redirect "/index.html")
       

{-|
-}
getIndex : ( b, Request a ) -> Task.Task String (AnswerValue value model error)
getIndex =
    getFile "./public/index.html" 


{-|
-}
redirect : String -> a -> AnswerValue value model error
redirect str _ =
   Redirect str



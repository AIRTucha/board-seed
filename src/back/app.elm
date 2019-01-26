port module App exposing (..)

import Task
import Board.File exposing(read)
import Pathfinder exposing (..)
import Board exposing (..)
import Board.Router exposing (..)
import Board.Shared exposing (..)
import Dict exposing(insert)
import Board.Status exposing (..)
import Board.Router.Static exposing (..)
import Board.Internals exposing (..)
 

{-|
-}
config : { errorPrefix : Maybe String , options : { https : Maybe { cert : Maybe a , key : Maybe String , passphrase : Maybe a1 , pfx : Maybe String } , portNumber : number , timeout : number1 } , state : number2 }
config = 
    { state = 0
    , errorPrefix = Just "Warning"
    , options = 
        { portNumber = 8081
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
main : Program Never number (Msg value1 number String)
main = board router config suggestions


{-|
-}
router : Request value -> Mode String (Answer value number String)
router =
    -- logger "Request"
    empty
        |> useSyncState (p "/count" ) getCount
        |> useState (p "/async/count" ) getAsyncCount
        |> get (p "/") getIndex
        |> static (p "") "./public/"
        |> get (any) (redirect "/index.html")
       

{-|
-}
getAsyncCount : ( b, Request a ) -> Task.Task x (number -> ( number, AnswerValue a model error ))
getAsyncCount (param, req) =
    Task.succeed(\ model -> (model + 1, Reply <| makeTextResponse req (Basics.toString model) ))


{-|
-}
getCount : ( b, Request a ) -> number -> ( number, AnswerValue a model error )
getCount (param, req) model =
    (model + 1, Reply <| makeTextResponse req (Basics.toString model) )


{-|
-}
getIndex : ( b, Request a ) -> Task.Task String (AnswerValue value model error)
getIndex =
    getFile "./public/index.html" 


{-|
-}
redirect : String -> a -> Task.Task x (AnswerValue value model error)
redirect str _ =
    Task.succeed <| Redirect str


{-|
-}
getFile : String -> ( b, Request a ) -> Task.Task String (AnswerValue value model error)
getFile path (param, req)  =
    path
        |> read
        |> Task.map (makeResponse req path)
        |> Task.map Reply


{-|
-}
makeResponse : Request a -> String -> Board.File.File a1 -> Response a1
makeResponse req path file = 
    let 
        res = getResponse req
    in
        { res
        | content = Data (Board.File.getContentType path) file
        , id = req.id
        , status = ok
        , cookeis = res.cookeis
            |> insert "test1" (cookei "testvalue1")
        } 


{-|
-}
makeTextResponse : Request a -> String -> Response a
makeTextResponse req text = 
    let 
        res = getResponse req
    in
        { res
        | content = Text "text/plain" text
        , id = req.id
        , cookeis = res.cookeis
            |> insert "test1" (cookei "testvalue1") 
            |> insert "test2" (cookei "testvalue2") 
            |> insert "test3" (cookei "testvalue3") 
            |> insert "test4" (cookei "testvalue4") 
        } 


{-|
-}
cookei : a -> { domain : Maybe String , httpOnly : Bool , lifetime : Maybe number , path : Maybe String , secure : Bool , value : a }
cookei str = 
    { value = str
    , httpOnly = True
    , secure = False 
    , lifetime = Just 1000000000
    , domain = Just "test.localhost"
    , path = Just "/count"
    }
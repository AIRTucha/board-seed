port module App exposing (..)

import Task
import Maybe exposing (withDefault)
import Debug exposing (log)
import Board.File as File exposing(read)
import Pathfinder exposing (..)
import Board exposing (..)
import Board.Router exposing (..)
import Board.Shared exposing (..)
import Dict exposing(Dict, insert, member, size)
import Board.Status exposing (..)
import Board.Router.Static exposing (..)
import Board.Internals exposing (..)

{-|
-}
config = 
    { state = Dict.empty
    , errorPrefix = Just "Warning"
    , options = 
        { portNumber = 8080
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


type alias Model =
    Dict String String


{-|
-}
main = board router config suggestions


paths =
    { session = p "/session"
    }


{-|
-}
router =
    -- logger "Request"
    empty
        |> getSyncState paths.session getCount
        |> postSyncState paths.session putCount
        |> get (p "/") getIndex
        |> static (p "") "./public/"
        |> getSync (p "/cookie") getCookie
        |> get (any) (redirect "/index.html")


getSession (param, req) =
    "session"
        |> makeTextResponse req
        |> Reply


getCookie (param, req) =
    Reply <| makeTextResponse req "placeholder"

-- {-|
-- -}
-- getAsyncCount : ( b, Request a ) -> Task.Task x (number -> ( number, AnswerValue a model error ))
-- getAsyncCount (param, req) =
--     Task.succeed(\ model -> (model + 1, Reply <| makeTextResponse req (Basics.toString model) ))
--insert sessionTag "" model

{-|
-}
getCount (param, req) model =
    let 
        sessionTag = 
            case Dict.get "session" req.cookies of
                Just oldSessionTag ->
                    oldSessionTag

                Nothing ->
                    (Basics.toString req.time) ++ "-" ++ (Basics.toString <| size model)
        sessionValue = 
            Dict.get sessionTag model
    in
        ( 
            model,
            (withDefault "No value for your session" sessionValue)
                |> makeTextResponse req
                |> Reply
        )


putCount : ( b , Request String ) -> Model -> ( Model, AnswerValue a1 model error )
putCount (param, req) model =
    let 
        sessionTag = 
            case Dict.get "session" req.cookies of
                Just oldSessionTag ->
                    oldSessionTag

                Nothing ->
                    (Basics.toString req.time) ++ "-" ++ (Basics.toString <| size model)
    in
        case req.content of 
            Board.Shared.Data _ file ->    
                let 
                    newValue = file <| File.string File.ASCII
                in
                    (
                        insert sessionTag newValue model, 
                        newValue
                            |> makeTextResponse req 
                            |> addCookeis "session" sessionTag
                            |> Reply
                    )
            _ ->
                (
                    model,
                    Reply <| makeTextResponse req "something went wrong"
                )

             

addCookeis name value res =
    { res 
    | cookeis = res.cookeis
        |> insert name (cookei value) 
    }



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
makeResponse : Request a -> String -> File.File a1 -> Response a1
makeResponse req path file = 
    let 
        res = getResponse req
    in
        { res
        | content = Data (File.getContentType path) file
        , id = req.id
        , status = ok
        } 


{-|
-}
makeTextResponse req text = 
    let 
        res = getResponse req
    in
        { res
        | content = Text "text/plain" text
        , id = req.id
        , status = ok
        } 


{-|
-}
cookei : a -> { domain : Maybe String , httpOnly : Bool , lifetime : Maybe number , path : Maybe String , secure : Bool , value : a }
cookei str = 
    { value = str
    , httpOnly = False
    , secure = False 
    , lifetime = Just <| 24*60*60*1000
    , domain = Nothing
    , path = Nothing
    }
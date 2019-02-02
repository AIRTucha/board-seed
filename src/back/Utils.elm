module Back.Utils exposing (..)


import Task exposing (Task, map)
import Board.File exposing(read, File, getContentType)
import Board.Shared exposing (..)
import Board.Status exposing (..)
import Board.Internals exposing (..)


{-|
-}
getFile : String -> ( b, Request a ) -> Task String (AnswerValue value model error)
getFile path (param, req)  =
    path
        |> read
        |> map (makeResponse req path)
        |> map Reply


{-|
-}
makeResponse : Request a -> String -> File a1 -> Response a1
makeResponse req path file = 
    let 
        res = getResponse req
    in
        { res
        | content = Data (getContentType path) file
        , id = req.id
        , status = ok
        } 
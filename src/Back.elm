port module Back exposing (..)

import Pathfinder exposing (..)
import Board exposing (..)
import Board.Router exposing (..)
import Board.Shared exposing (..)
import Board.Router.Static exposing (static)
import Board.Shared exposing (..)
import Board.Internals exposing (..)


{-| Server configuration
-}
config : Configurations ()
config = 
    { state = ()
    , errorPrefix = Just "Warning"
    , options = 
        { portNumber = 8083
        , timeout = 1000
        , https = Nothing
        }
    }
    

{-| Define port for subscription
-}
port subPort : (String -> msg) -> Sub msg


{-| Define server program
-}
main : Program Never () (Msg value1 () String)
main = board router config subPort


{-| Router describes relationships between paths and request handlers
-}
router : Request value -> Mode String (Answer value model String)
router =
    -- No default actions at empty router
    empty
        -- statically serve files from "./public/"
        |> static any "./public/"   
        -- redirect any unhandled request to "/index.html"                
        |> getSync any (\ _ -> Redirect "/index.html")        



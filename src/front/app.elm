
import Html exposing (Html, input, label, div, text, button)

import Html.Events exposing (onInput, onClick)
import Http exposing (getString, request, send, post, stringBody, expectString)
import Debug exposing (log)
import Json.Decode exposing (string)

-- main : Program Never

main =
  Html.program
    { init = ( model, getSession )
    , view = view
    , update = update
    , subscriptions = \ _ -> Sub.none
    }

getSession : Cmd Msg
getSession = 
  "/session"
    |> getString 
    |> send handleSession


handleSession : Result error String -> Msg
handleSession result =
  case result of 
    Ok str ->
      HandleResponse str

    Err msg ->
      log "msg" msg
        |> \_ -> HandleResponse "No session"




-- MODEL

type alias Model =
  { input: String 
  , value: String
  }

model : Model
model =
  { input = ""
  , value = "Wait status"
  }


-- UPDATE

type Msg
  = HandleInput String
  | HandleResponse String
  | Send (Http.Request String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    HandleInput value ->
      (
        { model
        | input = value
        }
        , 
        Cmd.none
      )
    
    HandleResponse value ->
      (
        { model
        | value = value
        }
        , 
        Cmd.none
      )

    Send req ->
      (model, send handleSession req)


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ input [ onInput HandleInput ] []
    , button [ onClick <| postSession model.input ] [ text "Save" ]
    , text model.value
    ]

postSession str =
    Send <| 
    request
      { method = "POST"
      , headers = []
      , url = "/session"
      , body = stringBody "text/plain" str
      , expect = expectString
      , timeout = Nothing
      , withCredentials = False
      }
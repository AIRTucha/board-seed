module Front exposing (..)

import Html exposing (Html, input, label, div, text)
import Html.Events exposing (onInput)

{-| Simple program definition
-}
main : Program Never Model Msg
main =
  Html.beginnerProgram
    { model = "Hello World!"
    , view = view
    , update = update
    }


{-| Define the application state
-}
type alias Model = String


{-| Define Msg
-}
type Msg = UpdateName String


{-| Msg handler 
-}
update : Msg -> Model -> Model
update (UpdateName name) model =
    "Hello " ++ name


{-| View function
-}
view : Model -> Html Msg
view model =
    div []
        [ label [] [ text "Your Name: " ]
        , input [ onInput UpdateName ] []
        , div [] [ text model ]
        ]
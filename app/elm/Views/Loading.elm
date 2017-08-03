module Views.Loading exposing (..)

import Data.Color exposing (gold)
import Data.Hub.Progress exposing (currentLevelSeedType)
import Helpers.Style exposing (backgroundColor, classes, transitionStyle, widthStyle)
import Html exposing (..)
import Html.Attributes exposing (..)
import Model exposing (..)
import Views.Seed.All exposing (renderSeed)


loadingScreen : Model -> Html Msg
loadingScreen model =
    div
        [ class <|
            classes
                [ "w-100 h-100 fixed z-999 top-0 left-0 flex items-center justify-center"
                , transitionClasses model
                ]
        , style
            [ backgroundColor gold
            , transitionStyle "0.5s ease"
            ]
        ]
        [ div [ style [ widthStyle 50 ] ] [ renderSeed <| currentLevelSeedType model ] ]


transitionClasses : Model -> String
transitionClasses model =
    if model.sceneTransition then
        "o-100"
    else
        "o-0 touch-disabled"

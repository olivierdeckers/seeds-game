module Scenes.Tutorial.View exposing (..)

import Data.Color exposing (darkYellow, greyYellow)
import Data.Level.Board.Block exposing (getTileState)
import Data.Level.Board.Tile exposing (hasLine, isDragging, tileSize)
import Data.Tutorial exposing (getText)
import Dict
import Helpers.Scale exposing (tileScaleFactor)
import Helpers.Style exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Scenes.Level.Types exposing (Move, SeedType(..), TileConfig, TileSize, TileState(..), TileType(..))
import Scenes.Tutorial.Types exposing (..)
import Views.Board.Layout exposing (renderLineLayer, renderLines)
import Views.Board.Styles exposing (boardHeight, boardWidth)
import Views.Board.Tile exposing (renderTile_)
import Views.Board.TopBar exposing (scoreIcon)


tutorialView : Model -> Html Msg
tutorialView model =
    div
        [ class "w-100 h-100 fixed top-0 flex items-center justify-center z-5"
        , style
            [ backgroundColor "rgba(255, 252, 227, 0.98)"
            , transitionStyle "1.2s linear"
            ]
        , classList <| showIf model.canvasVisible
        ]
        [ div
            [ style [ ( "margin-top", pc 0 ), transitionStyle "0.8s linear" ]
            , classList <| showIf model.containerVisible
            ]
            [ tutorialBoard model
            , p
                [ style [ color darkYellow, transitionStyle "0.5s ease" ]
                , classList <| showIf model.textVisible
                ]
                [ text <| getText model.text model.currentText ]
            , p
                [ onClick SkipTutorial
                , style [ color greyYellow, marginTop 70 ]
                , class "pointer tc ttu tracked-mega f6"
                ]
                [ text "skip" ]
            ]
        ]


tutorialBoard : Model -> Html msg
tutorialBoard model =
    div
        [ class "center relative"
        , classList <| showIf model.boardVisible
        , style
            [ widthStyle <| boardWidth model
            , heightStyle <| boardHeight model
            , transitionStyle "0.5s ease"
            ]
        ]
        [ div [ class "absolute z-5" ] [ renderResourceBank model ]
        , div [ class "absolute z-2" ] <| renderTiles model
        , div [ class "absolute z-0" ] <| renderLines_ model
        ]


renderResourceBank : Model -> Html msg
renderResourceBank ({ window, tileSize, resourceBankVisible, resourceBank } as model) =
    let
        tileScale =
            tileScaleFactor window

        offsetX =
            resourceBankOffsetX model

        offsetY =
            -100
    in
        div
            [ style
                [ transitionStyle "0.8s ease"
                , transformStyle <| translate offsetX offsetY
                ]
            , classList <| showIf resourceBankVisible
            ]
            [ scoreIcon resourceBank <| tileSize.y * tileScale ]


resourceBankOffsetX : Model -> Float
resourceBankOffsetX model =
    model.tileSize.x
        * toFloat (model.boardDimensions.x - 1)
        * tileScaleFactor model.window
        / 2


renderLines_ : Model -> List (Html msg)
renderLines_ model =
    model.board
        |> Dict.toList
        |> List.map (fadeLine model)


fadeLine : TileConfig model -> Move -> Html msg
fadeLine model (( _, tile ) as move) =
    let
        visible =
            hasLine tile
    in
        div
            [ style [ transitionStyle "0.5s ease" ]
            , classList <| showIf visible
            ]
            [ renderLineLayer model move ]


renderTiles : Model -> List (Html msg)
renderTiles model =
    model.board
        |> Dict.toList
        |> List.map (\mv -> renderTile_ (leavingStyles model mv) model mv)


leavingStyles : Model -> Move -> List Style
leavingStyles model (( _, block ) as move) =
    let
        tileState =
            getTileState block
    in
        case tileState of
            Leaving _ order ->
                [ transformStyle <| translate (resourceBankOffsetX model) -100
                , transitionStyle "0.5s ease"
                , transitionDelayStyle <| (order % 5) * 80
                ]

            _ ->
                []


showIf : Bool -> List ( String, Bool )
showIf visible =
    [ ( "o-100", visible )
    , ( "o-0", not visible )
    ]

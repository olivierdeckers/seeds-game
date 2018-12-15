module Views.Sprites.Butterfly exposing (butterfly, hovering, inFlight, resting)

import Css.Animation as Animation
import Css.Color as Color exposing (Color)
import Css.Style as Style
import Css.Transform as Transform
import Helpers.Svg exposing (..)
import Svg
import Svg.Attributes exposing (..)


type alias Butterfly =
    { color : Color
    , size : Float
    , wingPhaseDuration : Int
    }


resting =
    Svg.svg [ viewBox_ 0 0 280 140 ]
        [ Svg.g [ Style.svgStyles [ Style.transform [ Transform.translate 240 100 ] ] ]
            [ butterfly
                { color = "#E55E26"
                , size = 40
                , wingPhaseDuration = 2000
                }
            ]
        ]


butterfly { color, size, wingPhaseDuration } =
    Svg.svg [ viewBox_ 0 0 70 40, width_ size, height_ size ]
        [ Svg.g
            [ Style.svgStyles
                [ Style.transformOriginPx 35 35
                , Animation.animation "right-wing" wingPhaseDuration [ Animation.infinite, Animation.ease ]
                ]
            ]
            [ Svg.ellipse
                [ cx "6028.8"
                , cy "3886.5"
                , rx "6.2"
                , ry "11.9"
                , fill color
                , transform "matrix(.97288 1.38941 -1.47536 1.03306 -82 -12371)"
                ]
                []
            ]
        , Svg.g
            [ Style.svgStyles
                [ Style.transformOriginPx 35 35
                , Animation.animation "left-wing" wingPhaseDuration [ Animation.infinite, Animation.ease ]
                ]
            ]
            [ Svg.ellipse
                [ cx "6028.8"
                , cy "3886.5"
                , rx "6.2"
                , ry "11.9"
                , fill color
                , transform "matrix(-.97322 1.3899 -1.47584 -1.03235 11623.4 -4346.7)"
                ]
                []
            ]
        ]


inFlight =
    Svg.svg [ viewBox_ 0 0 280 140 ]
        [ Svg.g []
            [ Svg.g
                [ y_ 0
                , Style.svgStyles
                    [ Animation.animation "vertical-flutter" 420 [ Animation.infinite, Animation.linear ]
                    ]
                ]
                [ butterfly
                    { color = "#E55E26"
                    , size = 25
                    , wingPhaseDuration = 400
                    }
                ]
            , Svg.animateMotion
                [ path "M13.067,23.957C-7.136,43.769 76.419,88.523 128.37,89.607C170.126,90.478 261.253,48.167 238.112,26.678C213.588,3.903 172.147,89.529 128.37,89.607C79.226,89.694 40.029,-2.481 13.067,23.957Z"
                , repeatCount "indefinite"
                , dur "50s"
                ]
                []
            ]
        ]


hovering =
    Svg.svg [ viewBox_ 0 0 280 140 ]
        [ Svg.g []
            [ Svg.g
                [ y_ 0
                , Style.svgStyles
                    [ Animation.animation "vertical-flutter" 500 [ Animation.infinite, Animation.linear ]
                    ]
                ]
                [ butterfly
                    { color = "#E55E26"
                    , size = 12
                    , wingPhaseDuration = 500
                    }
                ]
            , Svg.animateMotion
                [ path "M30.321,61.304C30.321,61.304 5.025,21.519 30.764,21.519C56.503,21.519 30.321,61.304 30.321,61.304Z"
                , repeatCount "indefinite"
                , dur "30s"
                ]
                []
            ]
        ]

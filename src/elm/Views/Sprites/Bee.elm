module Views.Sprites.Bee exposing (bee)

import Helpers.Svg exposing (..)
import Svg
import Svg.Attributes exposing (..)


bee =
    Svg.svg [ viewBox_ 0 0 71 85 ]
        [ Svg.g [ transform "matrix(-1.56806 0 0 2.2802 5009.8 -4558)" ]
            [ Svg.clipPath [ id "bee-body" ] [ Svg.ellipse [ cx "3173.1", cy "2022.1", rx "20", ry "9.9" ] [] ]
            , Svg.g [ clipPath "url(#bee-body)" ]
                [ Svg.path [ fill "#ffc200", d "M3149.8 1998.9h11.3v36.9h-11.3z" ] []
                , Svg.path [ d "M3161 1999h11.4v36.9H3161z" ] []
                , Svg.path [ fill "#ffc200", d "M3172.3 1999h11.3v36.9h-11.3z" ] []
                , Svg.path [ d "M3183.6 1998.9h11.3v36.9h-11.3z" ] []
                ]
            ]
        ]

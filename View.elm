module View exposing (view)

import Model exposing (Model)
import Message as Msg
import Quadrant.View as QV
import Html exposing (Html, program)
import Material.Scheme


view : Model -> Html Msg.Msg
view model =
    Material.Scheme.top <|
        Html.div []
            [ Html.text "Quadrant view of life."
            , Html.map Msg.Quadrant (QV.view model.quadrant)
            ]

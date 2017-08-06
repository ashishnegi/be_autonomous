module View exposing (view)

import Model exposing (Model)
import Message as Msg
import Quadrant.View as QV
import Html exposing (Html, program)


view : Model -> Html Msg.Msg
view model =
    Html.div []
        [ Html.text "Quadrant view of life."
        , Html.map Msg.Quadrant (QV.view model.quadrant)
        ]

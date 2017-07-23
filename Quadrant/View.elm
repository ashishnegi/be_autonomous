module Quadrant.View exposing (view)

import Quadrant.Model as QM exposing (QuadrantModel)
import Quadrant.Message as QMsg exposing (Msg)
import Html exposing (Html, div, text, button, input, fieldset, label)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (placeholder, name, style, type_)


view : QuadrantModel -> Html Msg
view model =
    div []
        [ renderQuadrants model
        , renderActivityInput
        ]


renderQuadrants : QuadrantModel -> Html Msg
renderQuadrants model =
    let
        q1Activities =
            List.filter QM.isQ1 model.activities

        q2Activities =
            List.filter QM.isQ2 model.activities

        q3Activities =
            List.filter QM.isQ3 model.activities

        q4Activities =
            List.filter QM.isQ4 model.activities
    in
        div []
            [ text (toString (List.length q1Activities))
            , text (toString (List.length q2Activities))
            , text (toString (List.length q3Activities))
            , text (toString (List.length q4Activities))
            ]


renderActivityInput : Html Msg
renderActivityInput =
    div []
        [ text "Create new Activity:"
        , input
            [ onInput QMsg.NewActivityText
            , placeholder "New task/goal"
            ]
            []
        , fieldset []
            [ radio "Urgent and Important" (QMsg.NewActivityQuadrant QM.UrgentAndImportant) ]
        , button [ onClick QMsg.NewActivity ] [ text "Create Activity" ]
        ]


radio : String -> msg -> Html msg
radio value msg =
    label
        [ style [ ( "padding", "20px" ) ]
        ]
        [ input [ type_ "radio", name "font-size", onClick msg ] []
        , text value
        ]

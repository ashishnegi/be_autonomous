module Quadrant.View exposing (view)

import Quadrant.Model as QM exposing (QuadrantModel, Activity)
import Quadrant.Message as QMsg exposing (Msg)
import Html exposing (Html, div, text, button, input, fieldset, label)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (placeholder, name, style, type_)
import String

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
            [ renderQuadrantCollapse q1Activities
            , renderQuadrantCollapse q2Activities
            , renderQuadrantCollapse q3Activities
            , renderQuadrantCollapse q4Activities
            ]

renderQuadrantCollapse : List Activity -> Html Msg
renderQuadrantCollapse activities =
    div []
        [
         (List.length activities
         |> toString
         |> String.append "Total : "
         |> text
         )
        , QM.totalTime activities
        |> toString
        |> String.append "\nTime : "
        |> text
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
            [ radio "Urgent and Important" (QMsg.NewActivityQuadrant QM.UrgentAndImportant)
            , radio "Important and not Important" (QMsg.NewActivityQuadrant QM.ImportantNotUrgent)
            , radio "Urgent and not Important" (QMsg.NewActivityQuadrant QM.UrgentNotImportant)
            , radio "Not Urgent and not Important" (QMsg.NewActivityQuadrant QM.NotUrgentNotImportant)
            ]
        , button [ onClick QMsg.NewActivity ] [ text "Create Activity" ]
        ]


renderQuadrant : List Activity -> Html Msg
renderQuadrant activities =
    div []
        [ text "<<<<<<<"
        , div []
              (List.map renderActivity activities)
        , text ">>>>>>>"]


renderActivity : Activity -> Html Msg
renderActivity activity =
    div []
        [ text activity.name
        , toString activity.timeSpent |> text
        ]

radio : String -> msg -> Html msg
radio value msg =
    label
        [ style [ ( "padding", "20px" ) ]
        ]
        [ input [ type_ "radio", name "font-size", onClick msg ] []
        , text value
        ]

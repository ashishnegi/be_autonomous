module Quadrant.View exposing (view)

import Quadrant.Model as QM exposing (QuadrantModel, Activity)
import Quadrant.Message as QMsg exposing (Msg)
import Html exposing (Html, div, text, button, input, fieldset, label)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (placeholder, name, style, type_, disabled, checked, value)
import String
import Dropdown


view : QuadrantModel -> Html Msg
view model =
    div []
        [ renderQuadrants model
        , renderNewActivityInput model
        , renderReportGeneration model
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
            [ renderQuadrant QM.UrgentAndImportant model q1Activities
            , renderQuadrant QM.ImportantNotUrgent model q2Activities
            , renderQuadrant QM.UrgentNotImportant model q3Activities
            , renderQuadrant QM.NotUrgentNotImportant model q4Activities
            , rawView model
            ]


renderQuadrant : QM.QuadrantType -> QuadrantModel -> List Activity -> Html Msg
renderQuadrant quadrantType model activities =
    let
        quadrantViewData =
            QM.getQuadrantViewData model.viewData quadrantType
    in
        if quadrantViewData.expanded then
            renderQuadrantExpanded quadrantType activities
        else
            renderQuadrantCollapse quadrantType activities


renderQuadrantCollapse : QM.QuadrantType -> List Activity -> Html Msg
renderQuadrantCollapse quadrantType activities =
    div []
        [ (List.length activities
            |> toString
            |> String.append "Total : "
            |> text
          )
        , QM.totalTime activities
            |> toString
            |> String.append "\nTime : "
            |> text
        , button [ onClick (QMsg.ExpandQuadrant quadrantType) ] [ text "Expand" ]
        ]


renderNewActivityInput : QuadrantModel -> Html Msg
renderNewActivityInput model =
    div []
        [ text "Create new Activity:"
        , input
            [ onInput QMsg.NewActivityText
            , placeholder "New task/goal"
            ]
            []
        , fieldset []
            [ radio "Urgent and Important" (QMsg.NewActivityQuadrant QM.UrgentAndImportant) (model.viewData.newActivityQuadrant == QM.UrgentAndImportant)
            , radio "Not Urgent but Important" (QMsg.NewActivityQuadrant QM.ImportantNotUrgent) (model.viewData.newActivityQuadrant == QM.ImportantNotUrgent)
            , radio "Urgent but not Important" (QMsg.NewActivityQuadrant QM.UrgentNotImportant) (model.viewData.newActivityQuadrant == QM.UrgentNotImportant)
            , radio "Not Urgent and not Important" (QMsg.NewActivityQuadrant QM.NotUrgentNotImportant) (model.viewData.newActivityQuadrant == QM.NotUrgentNotImportant)
            ]
        , input
            [ type_ "number"
            , onInput QMsg.NewActivityTimeSpan
            , placeholder "Mins spent on activity"
            , value (toString model.viewData.newActivityTimeSpan)
            ]
            []
        , text " minutes in "
        , Html.map QMsg.TimeRangeMsg
            (Dropdown.view QMsg.dropDownConfig
                model.viewData.newActivityTimeRangeState
                QM.timeRange
                model.viewData.newActivityTimeRange
            )
        , button [ onClick QMsg.NewActivity ] [ text "Create Activity" ]
        ]


renderQuadrantExpanded : QM.QuadrantType -> List Activity -> Html Msg
renderQuadrantExpanded quadrantType activities =
    div []
        [ String.concat [ "<<<<<<<", (toString quadrantType), "<<<<<<<<" ]
            |> text
        , div []
            (List.map renderActivity activities)
        , text ">>>>>>>>>>>>>>>>>"
        , button [ onClick (QMsg.ExpandQuadrant quadrantType) ] [ text "Collapse" ]
        ]


renderActivity : Activity -> Html Msg
renderActivity activity =
    div []
        [ text activity.name
        , toString activity.timeSpent |> text
        , button [ onClick (QMsg.DeleteActivity activity.id) ] [ text "Delete" ]
        ]


radio : String -> msg -> Bool -> Html msg
radio value msg isChecked =
    label
        [ style [ ( "padding", "20px" ) ]
        ]
        [ input [ type_ "radio", name "font-size", onClick msg, checked isChecked ] []
        , text value
        ]


rawView : QuadrantModel -> Html Msg
rawView model =
    toString model
        |> text


renderReportGeneration : QuadrantModel -> Html Msg
renderReportGeneration model =
    if QM.shouldGenerateReport model then
        let
            report =
                QM.quadrantRatioTimes model.activities
        in
            div []
                (List.append
                    (List.map renderReportResult report)
                    [ button [ onClick QMsg.ToCreateActivityMode ] [ text "Collapse" ] ]
                )
    else
        div []
            [ button
                [ onClick QMsg.GenerateReport
                , disabled <| not <| QM.canGenerateReport model
                ]
                [ text "GenerateReport" ]
            ]


renderReportResult : QM.Result -> Html Msg
renderReportResult result =
    div []
        [ text (toString result.quadrant)
        , text (toString result.ratio)
        ]

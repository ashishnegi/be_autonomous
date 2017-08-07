module Quadrant.View exposing (view)

import Quadrant.Model as QM exposing (QuadrantModel, Activity)
import Quadrant.Message as QMsg exposing (Msg)
import Html exposing (Html, div, text, button, input, fieldset, label)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (placeholder, name, style, type_, disabled, checked, value)
import String
import Dropdown
import Material
import Material.Button as Button
import Material.Textfield as TextField
import Material.Icon as Icon
import Material.Options as Options
import Material.Toggles as Toggles
import Material.List as MList
import Html.CssHelpers
import Material.Grid as Grid exposing (grid, cell, size, Device(..))


{ id, class, classList } =
    Html.CssHelpers.withNamespace "lifeview"


view : QuadrantModel -> Html Msg
view model =
    Grid.grid
        []
        [ Grid.cell [ Grid.size Grid.All 4 ]
            [ renderNewActivityInput model ]
        , Grid.cell [ Grid.size Grid.All 12 ]
            [ renderQuadrants model ]
        , Grid.cell [ Grid.size Grid.All 4 ]
            [ renderReportGeneration model ]
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
        Grid.grid []
            [ renderQuadrant QM.UrgentAndImportant model q1Activities
            , renderQuadrant QM.ImportantNotUrgent model q2Activities
            , renderQuadrant QM.UrgentNotImportant model q3Activities
            , renderQuadrant QM.NotUrgentNotImportant model q4Activities
            , Grid.cell [ Grid.size Grid.All 12 ]
                [(rawView model)]
            ]


renderQuadrant : QM.QuadrantType -> QuadrantModel -> List Activity -> Grid.Cell Msg
renderQuadrant quadrantType model activities =
    let
        quadrantViewData =
            QM.getQuadrantViewData model.viewData quadrantType
    in
        if quadrantViewData.expanded then
            renderQuadrantExpanded quadrantType activities model.viewData
        else
            renderQuadrantCollapse quadrantType activities model.viewData


renderQuadrantCollapse : QM.QuadrantType -> List Activity -> QM.ViewData -> Grid.Cell Msg
renderQuadrantCollapse quadrantType activities viewData =
    Grid.cell [ Grid.size Grid.All 6 ]
        [ List.length activities
            |> toString
            |> String.append "Total : "
            |> text
        , QM.totalTime activities
            |> toString
            |> String.append "\nTime : "
            |> text
        , Button.render QMsg.Mdl
            [ 7 ]
            viewData.mdl
            [ Button.raised
            , Button.colored
            , Options.onClick (QMsg.ExpandQuadrant quadrantType)
            ]
            [ text "Expand" ]
        ]


renderNewActivityInput : QuadrantModel -> Html Msg
renderNewActivityInput model =
    div []
        [ text "Create new Activity:"
        , TextField.render
            QMsg.Mdl
            [ 0 ]
            model.viewData.mdl
            [ Options.onInput QMsg.NewActivityText
            , TextField.label "New task/goal" -- Todo : this keeps showing up even in the case of input in text.
            ]
            []
        , fieldset []
            [ quadrantRadio model.viewData "Urgent and Important" 10 (QMsg.NewActivityQuadrant QM.UrgentAndImportant) (model.viewData.newActivityQuadrant == QM.UrgentAndImportant)
            , quadrantRadio model.viewData "Not Urgent but Important" 11 (QMsg.NewActivityQuadrant QM.ImportantNotUrgent) (model.viewData.newActivityQuadrant == QM.ImportantNotUrgent)
            , quadrantRadio model.viewData "Urgent but not Important" 12 (QMsg.NewActivityQuadrant QM.UrgentNotImportant) (model.viewData.newActivityQuadrant == QM.UrgentNotImportant)
            , quadrantRadio model.viewData "Not Urgent and not Important" 13 (QMsg.NewActivityQuadrant QM.NotUrgentNotImportant) (model.viewData.newActivityQuadrant == QM.NotUrgentNotImportant)
            ]
        , TextField.render
            QMsg.Mdl
            [ 1 ]
            model.viewData.mdl
            [ Options.onInput QMsg.NewActivityTimeSpan
            , TextField.label "Mins spent on activity"
            , TextField.value (toString model.viewData.newActivityTimeSpan)
            ]
            []
        , text " minutes in "
        , Html.map QMsg.TimeRangeMsg
            (Dropdown.view QMsg.dropDownConfig
                model.viewData.newActivityTimeRangeState
                QM.timeRange
                (Just model.viewData.newActivityTimeRange)
            )
        , Button.render QMsg.Mdl
            [ 2 ]
            model.viewData.mdl
            [ Button.raised
            , Button.colored
            , Options.onClick QMsg.NewActivity
            ]
            [ text "Create Activity" ]
        ]


renderQuadrantExpanded : QM.QuadrantType -> List Activity -> QM.ViewData -> Grid.Cell Msg
renderQuadrantExpanded quadrantType activities viewData =
    Grid.cell [ Grid.size Grid.All 12 ]
        [ String.concat [ "<<<<<<<", (toString quadrantType), "<<<<<<<<" ]
            |> text
        , MList.ul []
            (List.map (\x -> MList.li [] [ MList.content [] (renderActivity viewData x) ])
                activities
            )
        , Button.render QMsg.Mdl
            [ 5 ]
            viewData.mdl
            [ Button.raised
            , Button.colored
            , Options.onClick (QMsg.ExpandQuadrant quadrantType)
            ]
            [ text "Collapse" ]
        ]


renderActivity : QM.ViewData -> Activity -> List (Html Msg)
renderActivity viewData activity =
    [ text activity.name
    , toString activity.timeSpent |> text
    , Button.render QMsg.Mdl
        [ 6 ]
        viewData.mdl
        [ Button.raised
        , Button.colored
        , Options.onClick (QMsg.DeleteActivity activity.id)
        ]
        [ text "Delete" ]
    ]


quadrantRadio =
    radio "new-activity-group"


radio : String -> QM.ViewData -> String -> Int -> QMsg.Msg -> Bool -> Html QMsg.Msg
radio group viewData value index msg isChecked =
    Toggles.radio QMsg.Mdl
        [ index ]
        viewData.mdl
        [ Toggles.value isChecked
        , Toggles.group group
        , Toggles.ripple
        , Options.onToggle msg
        ]
        [ text value ]


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
                    [ Button.render QMsg.Mdl
                        [ 3 ]
                        model.viewData.mdl
                        [ Button.raised
                        , Button.colored
                        , Options.onClick QMsg.ToCreateActivityMode
                        ]
                        [ text "Collapse" ]
                    ]
                )
    else
        div []
            [ Button.render QMsg.Mdl
                [ 4 ]
                model.viewData.mdl
                [ Button.raised
                , Button.colored
                , (if not <| QM.canGenerateReport model then
                    Button.disabled
                   else
                    Options.onClick QMsg.GenerateReport
                  )
                ]
                [ text "GenerateReport" ]
            ]


renderReportResult : QM.Result -> Html Msg
renderReportResult result =
    div []
        [ text (toString result.quadrant)
        , text (toString result.ratio)
        ]

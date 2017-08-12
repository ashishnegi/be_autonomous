module Quadrant.View exposing (view)

import Html exposing (Html, div, text, button, input, fieldset, label, p)
import Html.Attributes exposing (placeholder, name, style, type_, disabled, checked, value)
import Html.CssHelpers
import Html.Events exposing (onClick, onInput)
import Material
import Material.Badge as Badge
import Material.Button as Button
import Material.Card as Card
import Material.Color as Color
import Material.Dropdown.Item as Item
import Material.Elevation as Elevation
import Material.Grid as Grid
import Material.Icon as Icon
import Material.List as MList
import Material.Options as Options
import Material.Select as Select
import Material.Textfield as TextField
import Material.Toggles as Toggles
import Material.Typography as Typo
import Quadrant.Message as QMsg exposing (Msg)
import Quadrant.Model as QM exposing (QuadrantModel, Activity)
import String


white : Options.Property c m
white =
    Color.text Color.white


{ id, class, classList } =
    Html.CssHelpers.withNamespace "lifeview"


view : QuadrantModel -> Html Msg
view model =
    Grid.grid
        []
        [ Grid.cell [ Grid.size Grid.All 12 ]
            [ renderNewActivityInput model ]
        , Grid.cell [ Grid.size Grid.All 12 ]
            [ renderQuadrants model ]
        , Grid.cell [ Grid.size Grid.All 12 ]
            [ renderReportGeneration model ]

        -- , Grid.cell [ Grid.size Grid.All 12 ]
        --    [ (rawView model) ]
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


stringPrepend : String -> String -> String
stringPrepend =
    flip String.append


renderQuadrantCollapse : QM.QuadrantType -> List Activity -> QM.ViewData -> Grid.Cell Msg
renderQuadrantCollapse quadrantType activities viewData =
    let
        numActivities =
            List.length activities
                |> toString

        totalTime =
            QM.totalTime activities
                |> toString
                |> String.append " in "
                |> stringPrepend " mins"
    in
        Grid.cell [ Grid.size Grid.All 6 ]
            [ Card.view
                [ dynamic
                    (QM.raiseQuadrantCardIndex quadrantType)
                    (QMsg.ExpandQuadrant quadrantType)
                    viewData
                , Color.background (Color.color Color.LightBlue Color.S400)
                ]
                [ Card.title []
                    [ Card.head [ white ] [ text <| QM.quadrantToName quadrantType ]
                    ]
                , Card.text [ white ]
                    [ Card.subhead [ white ]
                        [ Options.span
                            [ Badge.add numActivities ]
                            [ text "Activity" ]
                        ]
                    , text totalTime
                    ]
                ]
            ]


renderNewActivityInput : QuadrantModel -> Html Msg
renderNewActivityInput model =
    Grid.grid []
        [ Grid.cell [ Grid.size Grid.All 12 ]
            [ TextField.render
                QMsg.Mdl
                QM.newActivityTextInputIndex
                model.viewData.mdl
                [ Options.onInput QMsg.NewActivityText
                , TextField.label "Your new task/goal"
                , TextField.value model.viewData.newActivityName
                ]
                []
            , Select.render QMsg.Mdl
                QM.quadrantSelectIndex
                model.viewData.mdl
                [ Select.label "Quadrant of activity"
                , Select.below
                , Select.floatingLabel
                , Select.ripple
                , Select.value (QM.quadrantToName model.viewData.newActivityQuadrant)
                ]
                (QM.quadrantTypes
                    |> List.map
                        (\qt ->
                            Select.item [ Item.onSelect (QMsg.NewActivityQuadrant qt) ]
                                [ qt |> QM.quadrantToName |> text ]
                        )
                )
            , TextField.render
                QMsg.Mdl
                QM.newActivityMinsIndex
                model.viewData.mdl
                [ Options.onInput QMsg.NewActivityTimeSpan
                , Options.css "width" "60px"
                , TextField.label "Mins spent on activity"
                , TextField.value (toString model.viewData.newActivityTimeSpan)
                ]
                []
            , text " minutes in "
            , Select.render QMsg.Mdl
                QM.timeRangeDropDownIndex
                model.viewData.mdl
                [ Select.label "Time range"
                , Select.below
                , Options.css "width" "100px"
                , Select.floatingLabel
                , Select.ripple
                , Select.value (QM.timeRangeToName model.viewData.newActivityTimeRange)
                ]
                (QM.timeRange
                    |> List.map
                        (\tr ->
                            Select.item
                                [ Item.onSelect (QMsg.TimeRangeMsg tr)
                                ]
                                [ tr |> QM.timeRangeToName |> text ]
                        )
                )
            , Button.render QMsg.Mdl
                QM.newActivityCreateButtonIndex
                model.viewData.mdl
                [ Button.raised
                , Button.colored
                , Options.onClick QMsg.NewActivity
                ]
                [ text "Create Activity" ]
            ]
        ]


renderQuadrantExpanded : QM.QuadrantType -> List Activity -> QM.ViewData -> Grid.Cell Msg
renderQuadrantExpanded quadrantType activities viewData =
    Grid.cell
        [ Grid.size Grid.All 6
        , Grid.size Grid.Phone 12
        ]
        [ Options.styled p
            [ Typo.headline ]
            [ quadrantType |> QM.quadrantToName |> text ]
        , MList.ul []
            (List.map (\x -> MList.li [] [ MList.content [] [ renderActivity viewData x ] ])
                activities
            )
        , Button.render QMsg.Mdl
            QM.collapseQuadrantIndex
            viewData.mdl
            [ Button.raised
            , Button.colored
            , Options.onClick (QMsg.ExpandQuadrant quadrantType)
            ]
            [ text "Collapse" ]
        ]


renderActivity : QM.ViewData -> Activity -> Html Msg
renderActivity viewData activity =
    Grid.grid
        []
        [ Grid.cell
            [ Grid.size Grid.All 8
            , Grid.size Grid.Phone 12
            ]
            [ Options.styled p
                [ Typo.title ]
                [ text activity.name ]
            ]
        , Grid.cell
            [ Grid.size Grid.All 4
            , Grid.size Grid.Phone 12
            ]
            [ Options.styled p
                [ Typo.subhead ]
                [ activity.timeSpent |> floor |> toString |> stringPrepend " mins/day " |> text ]
            , Button.render QMsg.Mdl
                QM.deleteActivityIndex
                viewData.mdl
                [ Button.raised
                , Button.colored
                , Options.onClick (QMsg.DeleteActivity activity.id)
                ]
                [ text "Delete" ]
            ]
        ]


quadrantRadio =
    radio "new-activity-group"


radio : String -> QM.ViewData -> String -> List Int -> QMsg.Msg -> Bool -> Html QMsg.Msg
radio group viewData value index msg isChecked =
    Toggles.radio QMsg.Mdl
        index
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
                        QM.collapseReportIndex
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
                QM.generateReportIndex
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


dynamic : Int -> QMsg.Msg -> QM.ViewData -> Options.Style Msg
dynamic k showcode viewData =
    [ if viewData.raised == k then
        Elevation.e8
      else
        Elevation.e2
    , Elevation.transition 250
    , Options.onMouseEnter (QMsg.Raise k)
    , Options.onMouseLeave (QMsg.Raise -1)
    , Options.onClick showcode
    ]
        |> Options.many

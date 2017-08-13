module Quadrant.View exposing (view)

import Html exposing (Html, div, text, button, input, fieldset, label, p)
import Html.Attributes exposing (placeholder, name, style, type_, disabled, checked, value)
import Html.CssHelpers
import Html.Events exposing (onClick, onInput)
import Markdown
import Material
import Material.Badge as Badge
import Material.Button as Button
import Material.Card as Card
import Material.Color as Color
import Material.Dropdown.Item as Item
import Material.Elevation as Elevation
import Material.Grid as Grid
import Material.Icon as Icon
import Material.Layout as Layout
import Material.List as MList
import Material.Options as Options
import Material.Select as Select
import Material.Textfield as TextField
import Material.Toggles as Toggles
import Material.Tooltip as Tooltip
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
            [ renderHelpText model ]
        , Grid.cell
            [ Grid.size Grid.All 12 ]
            [ renderNewActivityInput model ]
        , Grid.cell [ Grid.size Grid.All 12 ]
            [ renderQuadrants model ]
        , Grid.cell [ Grid.size Grid.All 12 ]
            [ renderReportGeneration model ]

        -- , Grid.cell [ Grid.size Grid.All 12 ]
        --    [ (rawView model) ]
        ]


renderHelpText : QuadrantModel -> Html QMsg.Msg
renderHelpText model =
    Grid.grid []
        [ Grid.cell [ Grid.size Grid.All 1 ]
            [ Button.render QMsg.Mdl
                [ 0 ]
                model.viewData.mdl
                [ Button.fab
                , Button.colored
                , Options.onClick QMsg.ShowHelpMsg
                ]
                [ Icon.i "help_outline" ]
            ]
        , Grid.cell [ Grid.size Grid.All 11 ]
            [ Options.styled p
                [ Typo.headline

                -- , Typo.center
                ]
                [ text "Quadrant view of Life" ]
            ]
        , Grid.cell [ Grid.size Grid.All 12 ]
            [ if model.viewData.showHelpMsg then
                Markdown.toHtml []
                    """
> Urgent task is something that needs to be done now.
> Important task is one that will benefit us in long run.

Examples :

a. Urgent and Important :
   - Crisis and Pressing problems.
   - Medical situation.

b. Important but not Urgent :
   - Reading book relevent to your field.
   - Planning next family outing.

c. Urgent but not Important :
   - Some meeting.
   - Some email.

d. Not Urgent and not Important :
   - Going through social media feeds.
              """
              else
                div [] []
            ]
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
                |> stringPrepend " mins / day"

        urgentIcon =
            if QM.isUrgent quadrantType then
                "check"
            else
                "close"

        importantIcon =
            if QM.isImportant quadrantType then
                "check"
            else
                "close"
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
                    [ Card.head [ white ]
                        [ Icon.view urgentIcon [ Options.css "width" "40px" ]
                        , text <| "Urgent"
                        ]
                    , Card.head [ white ]
                        [ Icon.view importantIcon [ Options.css "width" "40px" ]
                        , text <| "Important"
                        ]
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
        [ Grid.cell
            [ Grid.size Grid.All 4
            , Grid.size Grid.Desktop 3
            ]
            [ TextField.render
                QMsg.Mdl
                QM.newActivityTextInputIndex
                model.viewData.mdl
                [ Options.onInput QMsg.NewActivityText
                , TextField.label "Your new task/goal"
                , TextField.value model.viewData.newActivityName
                ]
                []
            ]
        , Grid.cell
            [ Grid.size Grid.All 3
            , Grid.size Grid.Desktop 2
            , Options.css "display" "flex"
            , Options.css "flex-direction" "row"
            ]
            [ Toggles.checkbox QMsg.Mdl
                QM.urgentCheckboxIndex
                model.viewData.mdl
                [ Options.onToggle QMsg.NewActivityUrgent
                , Toggles.ripple
                , Toggles.value model.viewData.newActivityUrgent
                , Toggles.group "new-activity-quadrant"
                , Options.css "display" "inline-block"
                ]
                [ text "Urgent" ]
            , Toggles.checkbox QMsg.Mdl
                QM.importantCheckboxIndex
                model.viewData.mdl
                [ Options.onToggle QMsg.NewActivityImportant
                , Toggles.ripple
                , Toggles.value model.viewData.newActivityImportant
                , Toggles.group "new-activity-quadrant"
                , Options.css "display" "inline-block"
                ]
                [ text "Important" ]
            ]
        , Grid.cell
            [ Grid.size Grid.All 3
            , Grid.size Grid.Desktop 3
            ]
            [ TextField.render
                QMsg.Mdl
                QM.newActivityMinsIndex
                model.viewData.mdl
                [ Options.onInput QMsg.NewActivityTimeSpan
                , Options.css "width" "60px"
                , TextField.label "Mins spent on activity"
                , TextField.value (toString model.viewData.newActivityTimeSpan)
                ]
                []
            , Options.span
                [ Typo.subhead ]
                [ text " mins in " ]
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
            ]
        , Grid.cell [ Grid.size Grid.All 2 ]
            [ Button.render QMsg.Mdl
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
        [ Options.span
            [ Typo.headline ]
            [ quadrantType |> QM.quadrantToName |> text ]
        , MList.ul []
            (List.map (renderActivity viewData) activities)
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
    MList.li [ MList.withSubtitle ]
        [ MList.content []
            [ -- Options.span
              --   [ Typo.title
              --   , Typo.nowrap
              --   ]
              --   [
              -- Texts wrap and we can see the subtitle if we uncomment above..
              -- but content2 goes out of view : delete button.
              -- mobile : width : 150px, desktop 450px for fixing.
              text activity.name

            -- ]
            , MList.subtitle []
                [ activity.timeSpent |> floor |> toString |> stringPrepend " mins/day " |> text ]
            ]
        , MList.content2 []
            [ Button.render QMsg.Mdl
                QM.deleteActivityIndex
                viewData.mdl
                [ Button.raised
                , Button.colored
                , Options.onClick (QMsg.DeleteActivity activity.id)
                ]
                [ Icon.view "delete_forever" [ Tooltip.attach QMsg.Mdl [ 0 ] ]
                , Tooltip.render QMsg.Mdl
                    [ 0 ]
                    viewData.mdl
                    []
                    [ text "Delete activity forever." ]
                ]
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
                [ text "Generate Report" ]
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

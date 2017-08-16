module Quadrant.Update exposing (update)

import JavascriptCall as JC
import Material
import Quadrant.Message exposing (..)
import Quadrant.Model exposing (..)


update : Msg -> QuadrantModel -> ( QuadrantModel, Cmd Msg )
update msg model =
    let
        { viewData, activities } =
            model
    in
        case msg of
            NewActivityText name ->
                ( { model | viewData = { viewData | newActivityName = name } }, Cmd.none )

            NewActivityTimeSpan timeSpan ->
                ( { model | viewData = { viewData | newActivityTimeSpan = convertToFloat timeSpan } }
                , JC.sendFirebaseAnalytics "timespan"
                )

            NewActivity ->
                ( commitNewActivity model, JC.sendFirebaseAnalytics "new_activity" )

            ExpandQuadrant quadrantType ->
                ( { model | viewData = toggleExpand quadrantType viewData }
                , JC.sendFirebaseAnalytics (String.append "expand_quadrant_" (quadrantToName quadrantType))
                )

            GenerateReport ->
                ( { model | viewData = { viewData | viewMode = ViewReportMode } }, JC.sendFirebaseAnalytics "generate_report" )

            ToCreateActivityMode ->
                ( { model | viewData = { viewData | viewMode = CreateActivityMode } }, JC.sendFirebaseAnalytics "to_create_activity_mode" )

            DeleteActivity activityId ->
                ( { model | activities = List.filter (\x -> x.id /= activityId) model.activities }, JC.sendFirebaseAnalytics "delete_activity" )

            TimeRangeMsg timeRange ->
                ( { model | viewData = { viewData | newActivityTimeRange = timeRange } }, JC.sendFirebaseAnalytics "change_timerange" )

            Raise raised ->
                { model | viewData = { viewData | raised = raised } } ! []

            NewActivityImportant ->
                ( { model | viewData = { viewData | newActivityImportant = not viewData.newActivityImportant } }, JC.sendFirebaseAnalytics "change_important_checkbox" )

            NewActivityUrgent ->
                ( { model | viewData = { viewData | newActivityUrgent = not viewData.newActivityUrgent } }, JC.sendFirebaseAnalytics "change_urgent_checkbox" )

            ShowHelpMsg ->
                ( { model | viewData = { viewData | showHelpMsg = not viewData.showHelpMsg } }
                , JC.sendFirebaseAnalytics (String.append "show_helpmsg_" (toString <| not viewData.showHelpMsg))
                )

            Mdl msg_ ->
                let
                    ( viewData_, cmds ) =
                        Material.update Mdl msg_ viewData
                in
                    ( { model | viewData = viewData_ }, cmds )


toggleExpand : QuadrantType -> ViewData -> ViewData
toggleExpand quadrantType viewData =
    let
        quadrantViewData =
            getQuadrantViewData viewData quadrantType

        newQuadrantViewData =
            { quadrantViewData | expanded = not quadrantViewData.expanded }
    in
        case quadrantType of
            UrgentAndImportant ->
                { viewData | q1Quadrant = newQuadrantViewData }

            ImportantNotUrgent ->
                { viewData | q2Quadrant = newQuadrantViewData }

            UrgentNotImportant ->
                { viewData | q3Quadrant = newQuadrantViewData }

            NotUrgentNotImportant ->
                { viewData | q4Quadrant = newQuadrantViewData }


convertToFloat : String -> Float
convertToFloat num =
    Result.withDefault 0 (String.toFloat num)

module Quadrant.Update exposing (update)

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

            NewActivityQuadrant quadrant ->
                ( { model | viewData = { viewData | newActivityQuadrant = quadrant } }, Cmd.none )

            NewActivityTimeSpan timeSpan ->
                ( { model | viewData = { viewData | newActivityTimeSpan = timeSpan } }, Cmd.none )

            NewActivity ->
                ( commitNewActivity model, Cmd.none )

            ExpandQuadrant quadrantType ->
                ( { model | viewData = toggleExpand quadrantType viewData }, Cmd.none )

            GenerateReport ->
                ( { model | viewData = { viewData | viewMode = ViewReportMode } }, Cmd.none )

            ToCreateActivityMode ->
                ( { model | viewData = { viewData | viewMode = CreateActivityMode } }, Cmd.none )

            DeleteActivity activityId ->
                ( { model | activities = List.filter (\x -> x.id /= activityId) model.activities }, Cmd.none )


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

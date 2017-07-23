module Quadrant.Update exposing (update)

import Quadrant.Message exposing (..)
import Quadrant.Model exposing (..)


newActivity : ViewData -> Activity
newActivity viewData =
    let
        { newActivityName, newActivityQuadrant, newActivityTimeSpan } =
            viewData
    in
        Activity "id1" newActivityName newActivityQuadrant newActivityTimeSpan


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
                ( { model | activities = newActivity viewData :: activities }, Cmd.none )

            GenerateReport ->
                -- move to new view by sending back the command .. ?
                ( model, Cmd.none )

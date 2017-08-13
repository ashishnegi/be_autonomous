module Main exposing (main)

import Html exposing (Html, programWithFlags)
import Json.Decode as JD
import Material
import Material.Select as Select
import Message as Msg
import Model exposing (Model)
import Quadrant.Message as QMsg
import Quadrant.Model as QM
import Random.Pcg exposing (initialSeed)
import Update exposing (update)
import Uuid
import View exposing (view)


main =
    programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : String -> ( Model, Cmd Msg.Msg )
init val =
    let
        collapseView =
            QM.QuadrantView False

        activities =
            Result.withDefault
                [ { id = stringToUuid "0a431ce2-5c3b-4c66-8e00-cfd08cbe2e91", name = val, quadrant = QM.UrgentAndImportant, timeSpent = 30 }
                , { id = stringToUuid "79f14407-657d-4028-9ee7-a34dc07da535", name = "how is it going..", quadrant = QM.UrgentAndImportant, timeSpent = 30 }
                , { id = stringToUuid "79f3a82b-0441-43ab-8359-b7aec537787d", name = "how is it going..", quadrant = QM.UrgentAndImportant, timeSpent = 30 }
                , { id = stringToUuid "e9354ce5-8323-4ef6-bbac-994db21e3fc4", name = "how is it going..", quadrant = QM.UrgentAndImportant, timeSpent = 30 }
                , { id = stringToUuid "48cce67d-a40b-4112-be49-a49cb9897201", name = "so whats up..", quadrant = QM.UrgentAndImportant, timeSpent = 30 }
                , { id = stringToUuid "0a431ce2-5c3b-4c66-8e00-cfd08cbe2e91", name = "how is it going.. how is it going.. how is it going..", quadrant = QM.ImportantNotUrgent, timeSpent = 30 }
                , { id = stringToUuid "79f14407-657d-4028-9ee7-a34dc07da535", name = "how is it going..", quadrant = QM.ImportantNotUrgent, timeSpent = 30 }
                , { id = stringToUuid "79f3a82b-0441-43ab-8359-b7aec537787d", name = "how is it going..", quadrant = QM.ImportantNotUrgent, timeSpent = 30 }
                , { id = stringToUuid "e9354ce5-8323-4ef6-bbac-994db21e3fc4", name = "how is it going..", quadrant = QM.ImportantNotUrgent, timeSpent = 30 }
                ]
                (JD.decodeString QM.decodeModel val)
    in
        ( Model
            (QM.QuadrantModel
                activities
                (QM.ViewData ""
                    True
                    True
                    30
                    QM.Day
                    0
                    collapseView
                    collapseView
                    collapseView
                    collapseView
                    QM.CreateActivityMode
                    -1
                    False
                    Material.model
                )
                (initialSeed 0)
            )
            Material.model
        , Cmd.none
        )


stringToUuid : String -> Uuid.Uuid
stringToUuid str =
    case Uuid.fromString str of
        Just v ->
            v

        Nothing ->
            Debug.crash "not possible"


subscriptions model =
    Sub.batch
        [ Sub.map Msg.Quadrant (Select.subs QMsg.Mdl model.quadrant.viewData.mdl)
        , Material.subscriptions Msg.Mdl model
        ]



-- { activities = [{ id = Uuid "0a431ce2-5c3b-4c66-8e00-cfd08cbe2e91", name = "how is it going.. how is it going.. how is it going..", quadrant = UrgentAndImportant, timeSpent = 30 },{ id = Uuid "79f14407-657d-4028-9ee7-a34dc07da535", name = "how is it going..", quadrant = UrgentAndImportant, timeSpent = 30 },{ id = Uuid "79f3a82b-0441-43ab-8359-b7aec537787d", name = "how is it going..", quadrant = UrgentAndImportant, timeSpent = 30 },{ id = Uuid "e9354ce5-8323-4ef6-bbac-994db21e3fc4", name = "how is it going..", quadrant = UrgentAndImportant, timeSpent = 30 },{ id = Uuid "48cce67d-a40b-4112-be49-a49cb9897201", name = "so whats up..", quadrant = UrgentAndImportant, timeSpent = 30 }], viewData = { newActivityName = "how is it going.. how is it going.. how is it going..", newActivityQuadrant = UrgentAndImportant, newActivityTimeSpan = 30, newActivityTimeRangeState = PrivateState { id = "new-activity-dropdown", isOpened = False }, newActivityTimeRange = Day, q1Quadrant = { expanded = True }, q2Quadrant = { expanded = False }, q3Quadrant = { expanded = False }, q4Quadrant = { expanded = False }, viewMode = CreateActivityMode, mdl = { button = Dict.fromList [([2],{ animation = Inert, metrics = Just { rect = { top = 128, left = 1189, width = 146, height = 36 }, x = 99, y = 18 }, ignoringMouseDown = False })], textfield = Dict.fromList [([0],{ isFocused = False, isDirty = True })], menu = Dict.fromList [], layout = { ripples = Dict.fromList [], isSmallScreen = False, isCompact = False, isAnimating = False, isScrolled = False, isDrawerOpen = False, tabScrollState = { canScrollRight = True, canScrollLeft = False, width = Nothing } }, toggles = Dict.fromList [], tooltip = Dict.fromList [], tabs = Dict.fromList [], select = Dict.fromList [([12],{ dropdown = { ripples = Dict.fromList [(-1,{ animation = Inert, metrics = Nothing, ignoringMouseDown = False })], open = False, geometry = Nothing, index = Nothing }, textfield = { isFocused = False, isDirty = False }, openOnFocus = False }),([13],{ dropdown = { ripples = Dict.fromList [(-1,{ animation = Inert, metrics = Nothing, ignoringMouseDown = False })], open = False, geometry = Nothing, index = Nothing }, textfield = { isFocused = False, isDirty = False }, openOnFocus = False })] } }, currentSeed = Seed 4166496411 1013904223 }

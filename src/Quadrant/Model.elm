module Quadrant.Model exposing (..)

import Json.Decode as JD exposing (field)
import Json.Encode as JE
import Material
import Random.Pcg exposing (Seed, step)
import Uuid


{-
                    Urgent  NotUrgent
                  --------------------
                  |        |         |
   Important      |  Q1    |   Q2    |
                  |        |         |
                  |--------|---------|
                  |        |         |
   NotImportant   |  Q3    |   Q4    |
                  |        |         |
                  --------------------

-}


type QuadrantType
    = UrgentAndImportant -- Q1
    | ImportantNotUrgent -- Q2
    | UrgentNotImportant -- Q3
    | NotUrgentNotImportant -- Q4


type Urgency
    = Urgent
    | NotUrgent


type Importance
    = Important
    | NotImportant


getQuadrantType : Urgency -> Importance -> QuadrantType
getQuadrantType urgency importance =
    case ( urgency, importance ) of
        ( Urgent, Important ) ->
            UrgentAndImportant

        ( NotUrgent, Important ) ->
            ImportantNotUrgent

        ( Urgent, NotImportant ) ->
            UrgentNotImportant

        ( NotUrgent, NotImportant ) ->
            NotUrgentNotImportant


type alias Activity =
    { id : Id
    , name : Name
    , quadrant : QuadrantType
    , timeSpent : TimeSpan
    }


{-| TimeSpan : number of minute
-}
type alias TimeSpan =
    Float


type alias Id =
    Uuid.Uuid


type alias Name =
    String


type alias Result =
    { quadrant : QuadrantType
    , ratio : Float
    }


isQ1 : Activity -> Bool
isQ1 activity =
    case activity.quadrant of
        UrgentAndImportant ->
            True

        _ ->
            False


isQ2 : Activity -> Bool
isQ2 activity =
    case activity.quadrant of
        ImportantNotUrgent ->
            True

        _ ->
            False


isQ3 : Activity -> Bool
isQ3 activity =
    case activity.quadrant of
        UrgentNotImportant ->
            True

        _ ->
            False


isQ4 : Activity -> Bool
isQ4 activity =
    case activity.quadrant of
        NotUrgentNotImportant ->
            True

        _ ->
            False


quadrantRatioTimes : List Activity -> List Result
quadrantRatioTimes activities =
    let
        sumFn =
            List.sum << List.map .timeSpent

        totalTimeSpent =
            sumFn activities

        q1Time =
            sumFn (List.filter isQ1 activities)

        q2Time =
            sumFn (List.filter isQ2 activities)

        q3Time =
            sumFn (List.filter isQ3 activities)

        q4Time =
            sumFn (List.filter isQ4 activities)
    in
        [ { quadrant = UrgentAndImportant, ratio = q1Time / totalTimeSpent }
        , { quadrant = ImportantNotUrgent, ratio = q2Time / totalTimeSpent }
        , { quadrant = UrgentNotImportant, ratio = q3Time / totalTimeSpent }
        , { quadrant = NotUrgentNotImportant, ratio = q4Time / totalTimeSpent }
        ]


totalTime : List Activity -> TimeSpan
totalTime activities =
    List.map .timeSpent activities
        |> List.sum


getQuadrantViewData : ViewData -> QuadrantType -> QuadrantView
getQuadrantViewData viewData quadrantType =
    case quadrantType of
        UrgentAndImportant ->
            viewData.q1Quadrant

        ImportantNotUrgent ->
            viewData.q2Quadrant

        UrgentNotImportant ->
            viewData.q3Quadrant

        NotUrgentNotImportant ->
            viewData.q4Quadrant


shouldGenerateReport : QuadrantModel -> Bool
shouldGenerateReport model =
    case model.viewData.viewMode of
        ViewReportMode ->
            not <| List.isEmpty model.activities

        _ ->
            False


canGenerateReport : QuadrantModel -> Bool
canGenerateReport model =
    case model.viewData.viewMode of
        ViewReportMode ->
            False

        _ ->
            not <| List.isEmpty model.activities


commitNewActivity : QuadrantModel -> QuadrantModel
commitNewActivity model =
    let
        { activities, viewData, currentSeed } =
            model

        { newActivityName, newActivityImportant, newActivityUrgent, newActivityTimeSpan, newActivityTimeRange } =
            viewData

        ( newUuid, newSeed ) =
            step Uuid.uuidGenerator currentSeed

        time =
            timePerDay newActivityTimeSpan newActivityTimeRange

        newActivityQuadrant =
            quadrantTypeFrom newActivityUrgent newActivityImportant
    in
        { model
            | activities = Activity newUuid newActivityName newActivityQuadrant time :: activities
            , viewData = { viewData | numNewActivities = viewData.numNewActivities + 1 }
            , currentSeed = newSeed
        }


quadrantTypeFrom : Bool -> Bool -> QuadrantType
quadrantTypeFrom urgent important =
    case ( urgent, important ) of
        ( True, False ) ->
            UrgentNotImportant

        ( False, True ) ->
            ImportantNotUrgent

        ( True, True ) ->
            UrgentAndImportant

        ( False, False ) ->
            NotUrgentNotImportant


timePerDay : TimeSpan -> TimeRange -> TimeSpan
timePerDay span range =
    case range of
        Day ->
            span

        Week ->
            span / 7

        Month ->
            span / 30



{-
   User model :
    * list of activities
-}


type alias QuadrantView =
    { expanded : Bool
    }


type ViewMode
    = CreateActivityMode
    | ViewReportMode


type alias ViewData =
    { newActivityName : Name
    , newActivityImportant : Bool
    , newActivityUrgent : Bool
    , newActivityTimeSpan : TimeSpan
    , newActivityTimeRange : TimeRange
    , numNewActivities : Int
    , q1Quadrant : QuadrantView
    , q2Quadrant : QuadrantView
    , q3Quadrant : QuadrantView
    , q4Quadrant : QuadrantView
    , viewMode : ViewMode
    , raised : Int
    , showHelpMsg : Bool
    , mdl : Material.Model
    }


type alias QuadrantModel =
    { activities : List Activity
    , viewData : ViewData
    , currentSeed : Seed
    }


encodeModel : QuadrantModel -> JE.Value
encodeModel model =
    JE.object [ ( "activities", JE.list (List.map encodeActivity model.activities) ) ]


encodeActivity : Activity -> JE.Value
encodeActivity activity =
    JE.object
        [ ( "id", JE.string <| Uuid.toString activity.id )
        , ( "name", JE.string activity.name )
        , ( "quadrant", encodeQuadrantType activity.quadrant )
        , ( "timeSpent", JE.float activity.timeSpent )
        ]


type TimeRange
    = Day
    | Week
    | Month


timeRange : List TimeRange
timeRange =
    [ Day, Week, Month ]


timeRangeToName : TimeRange -> String
timeRangeToName =
    toString


quadrantTypes : List QuadrantType
quadrantTypes =
    [ UrgentAndImportant, ImportantNotUrgent, UrgentNotImportant, NotUrgentNotImportant ]


quadrantToName : QuadrantType -> String
quadrantToName quadrant =
    case quadrant of
        UrgentAndImportant ->
            "Crisis situations"

        ImportantNotUrgent ->
            "Productive and Planning"

        UrgentNotImportant ->
            "Interruptions"

        NotUrgentNotImportant ->
            "Time Waste"


newActivityTextInputIndex =
    [ 0 ]


newActivityMinsIndex =
    [ 1 ]


newActivityCreateButtonIndex =
    [ 2 ]


collapseQuadrantIndex =
    [ 4 ]


deleteActivityIndex =
    [ 5 ]


collapseReportIndex =
    [ 6 ]


generateReportIndex =
    [ 7 ]


q1RadioSelectIndex =
    [ 8 ]


q2RadioSelectIndex =
    [ 9 ]


q3RadioSelectIndex =
    [ 10 ]


q4RadioSelectIndex =
    [ 11 ]


timeRangeDropDownIndex =
    [ 12 ]


quadrantSelectIndex =
    [ 13 ]


urgentCheckboxIndex =
    [ 14 ]


importantCheckboxIndex =
    [ 15 ]


helpTextIndex =
    [ 16 ]


deleteForeverIndex =
    [ 17 ]


raiseQuadrantCardIndex : QuadrantType -> Int
raiseQuadrantCardIndex quadrantType =
    case quadrantType of
        UrgentNotImportant ->
            0

        ImportantNotUrgent ->
            1

        UrgentAndImportant ->
            2

        NotUrgentNotImportant ->
            3


isUrgent : QuadrantType -> Bool
isUrgent quadrantType =
    case quadrantType of
        UrgentNotImportant ->
            True

        ImportantNotUrgent ->
            False

        UrgentAndImportant ->
            True

        NotUrgentNotImportant ->
            False


isImportant : QuadrantType -> Bool
isImportant quadrantType =
    case quadrantType of
        UrgentNotImportant ->
            False

        ImportantNotUrgent ->
            True

        UrgentAndImportant ->
            True

        NotUrgentNotImportant ->
            False


encodeQuadrantType : QuadrantType -> JE.Value
encodeQuadrantType quadrantType =
    JE.string <| toString quadrantType


decodeModel : JD.Decoder (List Activity)
decodeModel =
    field "activities" (JD.list decodeActivity)


decodeActivity : JD.Decoder Activity
decodeActivity =
    JD.map4 Activity
        (field "id" stringToUuidDecoder)
        (field "name" JD.string)
        (field "quadrant" quadrantTypeDecoder)
        (field "timeSpent" JD.float)


stringToUuidDecoder : JD.Decoder Uuid.Uuid
stringToUuidDecoder =
    JD.map stringToUuid JD.string


stringToUuid : String -> Id
stringToUuid str =
    case Uuid.fromString str of
        Just v ->
            v

        Nothing ->
            Debug.crash "not possible"


quadrantTypeDecoder : JD.Decoder QuadrantType
quadrantTypeDecoder =
    JD.map
        (\qtStr ->
            case qtStr of
                "UrgentAndImportant" ->
                    UrgentAndImportant

                "ImportantNotUrgent" ->
                    ImportantNotUrgent

                "UrgentNotImportant" ->
                    UrgentNotImportant

                "NotUrgentNotImportant" ->
                    NotUrgentNotImportant

                _ ->
                    Debug.crash "Wrong quadrant type."
        )
        JD.string

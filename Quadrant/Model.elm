module Quadrant.Model exposing (..)

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


{-| TimeSpan : number of seconds
-}
type alias TimeSpan =
    Int


type alias Id =
    String


type alias Name =
    String


type alias Activity =
    { id : Id
    , name : Name
    , quadrant : QuadrantType
    , timeSpent : TimeSpan
    }


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
        [ { quadrant = UrgentAndImportant, ratio = q1Time // totalTimeSpent }
        , { quadrant = ImportantNotUrgent, ratio = q2Time // totalTimeSpent }
        , { quadrant = UrgentNotImportant, ratio = q3Time // totalTimeSpent }
        , { quadrant = NotUrgentNotImportant, ratio = q4Time // totalTimeSpent }
        ]


(//) : Int -> Int -> Float
(//) a b =
    Basics.toFloat a / Basics.toFloat b


totalTime : List Activity -> TimeSpan
totalTime activities =
    List.map .timeSpent activities
        |> List.sum



{-
   User model :
    * list of activities
-}


type alias ViewData =
    { newActivityName : Name
    , newActivityQuadrant : QuadrantType
    , newActivityTimeSpan : TimeSpan
    }


type alias QuadrantModel =
    { activities : List Activity
    , viewData : ViewData
    }

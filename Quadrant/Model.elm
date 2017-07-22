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

type Quadrant = UrgentAndImportant      -- Q1
              | ImportantNotUrgent      -- Q2
              | UrgentNotImportant      -- Q3
              | NotUrgentNotImportant   -- Q4

type Urgency = Urgent | NotUrgent
type Importance = Important | NotImportant

getQuadrant : Urgency -> Importance -> Quadrant
getQuadrant urgency importance =
    case (urgency, importance) of
        (Urgent, Important) -> UrgentAndImportant
        (NotUrgent, Important) -> ImportantNotUrgent
        (Urgent, NotImportant) -> UrgentNotImportant
        (NotUrgent, NotImportant) -> NotUrgentNotImportant

type TimeSpan = Int -- number of seconds

type alias Activity = { quadrant : Quadrant
                      , timeSpent : TimeSpan
                      }

type alias Result = { quadrant : Quadrant
                    , ratio : Float
                    }
quadrantRatioTimes : List Activity -> List Result
quadrantRatioTimes activities =
    []

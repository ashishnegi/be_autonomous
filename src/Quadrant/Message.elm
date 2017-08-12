module Quadrant.Message exposing (..)

import Quadrant.Model exposing (..)
import Material


type Msg
    = NewActivityText Name
    | NewActivityQuadrant QuadrantType
    | NewActivityTimeSpan String
    | NewActivity
    | ExpandQuadrant QuadrantType
    | GenerateReport
    | ToCreateActivityMode
    | DeleteActivity Id
    | TimeRangeMsg TimeRange
    | Mdl (Material.Msg Msg)

module Quadrant.Message exposing (..)

import Material
import Quadrant.Model exposing (..)


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
    | Raise Int
    | Mdl (Material.Msg Msg)

module Quadrant.Message exposing (..)

import Quadrant.Model exposing (..)
import Dropdown


type Msg
    = NewActivityText Name
    | NewActivityQuadrant QuadrantType
    | NewActivityTimeSpan String
    | NewActivity
    | ExpandQuadrant QuadrantType
    | GenerateReport
    | ToCreateActivityMode
    | DeleteActivity Id
    | TimeRangeMsg (Dropdown.Msg TimeRange)
    | TimeRangeSelect (Maybe TimeRange)


dropDownConfig : Dropdown.Config Msg TimeRange
dropDownConfig =
    Dropdown.newConfig TimeRangeSelect timeRangeToName

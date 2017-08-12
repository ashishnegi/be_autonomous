module Quadrant.Message exposing (..)

import Quadrant.Model exposing (..)
import Dropdown
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
    | TimeRangeMsg (Dropdown.Msg TimeRange)
    | TimeRangeSelect (Maybe TimeRange)
    | Mdl (Material.Msg Msg)


dropDownConfig : Dropdown.Config Msg TimeRange
dropDownConfig =
    Dropdown.newConfig TimeRangeSelect timeRangeToName

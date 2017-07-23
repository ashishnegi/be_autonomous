module Quadrant.Message exposing (..)

import Quadrant.Model exposing (..)


type Msg
    = NewActivityText Name
    | NewActivityQuadrant QuadrantType
    | NewActivityTimeSpan TimeSpan
    | NewActivity
    | ExpandQuadrant QuadrantType
    | GenerateReport

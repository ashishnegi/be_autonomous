module Quadrant.Message exposing (..)

import Quadrant.Model exposing (..)


type Msg
    = NewActivityText Name
    | NewActivityQuadrant Quadrant
    | NewActivityTimeSpan TimeSpan
    | NewActivity
    | GenerateReport

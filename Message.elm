module Message exposing (..)

import Quadrant.Message as QMsg
import Material

type Msg
    = Quadrant QMsg.Msg
    | Mdl (Material.Msg Msg)

module Message exposing (..)

import Material
import Quadrant.Message as QMsg


type Msg
    = Quadrant QMsg.Msg
    | Mdl (Material.Msg Msg)

module Message exposing (..)

import Json.Decode as JDecode
import Material
import Quadrant.Message as QMsg


type Msg
    = Quadrant QMsg.Msg
    | Mdl (Material.Msg Msg)

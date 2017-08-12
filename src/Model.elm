module Model exposing (..)

import Material
import Quadrant.Model as QM


type alias Model =
    { quadrant : QM.QuadrantModel
    , mdl : Material.Model
    }

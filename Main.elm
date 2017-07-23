module Main exposing (main)

import Html
import Quadrant.Model as QM
import Quadrant.Message as QMsg
import Quadrant.Update as QUpd
import Quadrant.View as QV

main =
    Html.div []
        [ Html.text "Quadrant view of life."
        , QV.view (QM.QuadrantModel  [] (QM.ViewData "" QM.UrgentAndImportant 200))]

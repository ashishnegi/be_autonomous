module Utils exposing (..)

import Material.Grid as Grid
import Material.Options as Options


grid css =
    Grid.grid (Options.css "padding" "0px" :: css)


cell css =
    Grid.cell
        (Options.css "margin-left" "0px"
            :: Options.css "margin-right" "0px"
            :: css
        )


cellUpDown css =
    Grid.cell
        (Options.css "margin-up" "0px"
            :: Options.css "margin-down" "0px"
            :: css
        )

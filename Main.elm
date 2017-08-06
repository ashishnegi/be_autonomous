module Main exposing (main)

import Html exposing (Html, program)
import Model exposing (Model)
import Update exposing (update)
import View exposing (view)

import Quadrant.Model as QM
import Quadrant.Message as QMsg
import Quadrant.Update as QUpd
import Quadrant.View as QV
import Random.Pcg exposing (initialSeed)
import Dropdown
import Material


main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

init =
    let
        collapseView =
            QM.QuadrantView False
    in
        ( Model
            (QM.QuadrantModel
                []
                (QM.ViewData ""
                    QM.UrgentAndImportant
                    30
                    (Dropdown.newState "new-activity-dropdown")
                    QM.Day
                    collapseView
                    collapseView
                    collapseView
                    collapseView
                    QM.CreateActivityMode
                )
                (initialSeed 0)
            )
            Material.model
        , Cmd.none
        )


subscriptions x =
    Sub.none

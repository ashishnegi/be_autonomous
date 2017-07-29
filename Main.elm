module Main exposing (main)

import Html exposing (Html, program)
import Quadrant.Model as QM
import Quadrant.Message as QMsg
import Quadrant.Update as QUpd
import Quadrant.View as QV
import Random.Pcg exposing (initialSeed)
import Dropdown

main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


view : QM.QuadrantModel -> Html QMsg.Msg
view model =
    Html.div []
        [ Html.text "Quadrant view of life."
        , QV.view model
        ]


init : ( QM.QuadrantModel, Cmd QMsg.Msg )
init =
    let
        collapseView =
            QM.QuadrantView False
    in
        ( QM.QuadrantModel
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
        , Cmd.none
        )


update : QMsg.Msg -> QM.QuadrantModel -> ( QM.QuadrantModel, Cmd QMsg.Msg )
update =
    QUpd.update


subscriptions x =
    Sub.none

module Update exposing (..)

import Json.Encode as JE
import Json.Encode as JE
import LocalStorage as LS
import Material
import Message as Msg
import Model exposing (Model)
import Quadrant.Model as QM
import Quadrant.Update as QU


update : Msg.Msg -> Model -> ( Model, Cmd Msg.Msg )
update msg model =
    case msg of
        Msg.Quadrant qmsg ->
            let
                ( quad, quadCmd ) =
                    QU.update qmsg model.quadrant
            in
                ( { model | quadrant = quad }
                , Cmd.batch
                    [ LS.setToLS (JE.encode 0 (QM.encodeModel quad))
                    , Cmd.map Msg.Quadrant quadCmd
                    ]
                )

        Msg.Mdl msg_ ->
            Material.update Msg.Mdl msg_ model

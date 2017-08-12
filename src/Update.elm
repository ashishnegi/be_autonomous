module Update exposing (..)

import Quadrant.Update as QU
import Model exposing (Model)
import Message as Msg
import Material


update : Msg.Msg -> Model -> ( Model, Cmd Msg.Msg )
update msg model =
    case msg of
        Msg.Quadrant qmsg ->
            let
                ( quad, quadCmd ) =
                    QU.update qmsg model.quadrant
            in
                ( { model | quadrant = quad }, Cmd.map Msg.Quadrant quadCmd )

        Msg.Mdl msg_ ->
            Material.update Msg.Mdl msg_ model

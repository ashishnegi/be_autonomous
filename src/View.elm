module View exposing (view)

import Model exposing (Model)
import Message as Msg
import Quadrant.View as QV
import Html exposing (Html, program, text)
import Material.Scheme
import Material.Color as Color
import Material.Grid as Grid
import Material.Layout as Layout


view : Model -> Html Msg.Msg
view model =
    Material.Scheme.topWithScheme Color.Teal Color.LightGreen <|
        Layout.render Msg.Mdl
            model.mdl
            [ Layout.scrolling ]
            { header =
                [ Layout.row []
                    [ Layout.title [] [ text "window of life" ] ]
                ]
            , drawer = []
            , tabs = ( [], [] )
            , main =
                [ Grid.grid
                    []
                    [ Grid.cell [ Grid.size Grid.All 2 ]
                        -- Todo: remove in mobile
                        []
                    , Grid.cell [ Grid.size Grid.All 10 ]
                        [ Html.map Msg.Quadrant (QV.view model.quadrant)
                        ]
                    , Grid.cell [ Grid.size Grid.All 2 ]
                        []
                    ]
                ]
            }

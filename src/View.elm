module View exposing (view)

import Html exposing (Html, program, text, p)
import Material.Color as Color
import Material.Footer as Footer
import Material.Grid as Grid
import Material.Layout as Layout
import Material.Options as Options
import Material.Options as Options
import Material.Scheme
import Material.Typography as Typo
import Message as Msg
import Model exposing (Model)
import Quadrant.View as QV


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
                [ Grid.grid []
                    [ Grid.cell
                        [ Grid.size Grid.All 12 ]
                        [ quadrantView model ]
                    , Grid.cell [ Grid.size Grid.All 12 ]
                        [ footerView ]
                    ]
                ]
            }


quadrantView : Model -> Html Msg.Msg
quadrantView model =
    Grid.grid
        []
        [ Grid.cell
            [ Grid.size Grid.All 2
            , Grid.size Grid.Phone 1
            ]
            -- Todo: remove in mobile
            []
        , Grid.cell
            [ Grid.size Grid.All 8
            , Grid.size Grid.Phone 10
            ]
            [ Html.map Msg.Quadrant (QV.view model.quadrant)
            ]
        , Grid.cell
            [ Grid.size Grid.All 2
            , Grid.size Grid.Phone 1
            ]
            []
        ]


footerView : Html Msg.Msg
footerView =
    Footer.mini []
        { left =
            Footer.left []
                [ Footer.logo [] [ Footer.html <| text "Track your life..." ]
                ]
        , right =
            Footer.right []
                [ Footer.logo [] [ Footer.html <| text "Like us @ " ]
                , Footer.socialButton [ Options.css "margin-right" "6px" ] []
                , Footer.socialButton [ Options.css "margin-right" "6px" ] []
                , Footer.socialButton [ Options.css "margin-right" "0px" ] []
                ]
        }

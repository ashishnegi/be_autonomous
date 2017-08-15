module View exposing (view)

import Html exposing (Html, program, text, p)
import Html.Attributes as Attrs exposing (class, attribute)
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
import Utils


view : Model -> Html Msg.Msg
view model =
    Material.Scheme.topWithScheme Color.Teal Color.LightGreen <|
        Layout.render Msg.Mdl
            model.mdl
            [ Layout.scrolling
            , Layout.fixedHeader
            ]
            { header =
                [ Layout.row []
                    [ Layout.title [] [ text "window of life" ] ]
                ]
            , drawer = []
            , tabs = ( [], [] )
            , main =
                [ Grid.grid []
                    [ Utils.cell
                        [ Grid.size Grid.All 12 ]
                        [ quadrantView model ]
                    , Grid.cell [ Grid.size Grid.All 12 ]
                        [ footerView ]
                    ]
                ]
            }


quadrantView : Model -> Html Msg.Msg
quadrantView model =
    Utils.grid
        []
        [ Grid.cell
            [ Grid.size Grid.All 2
            , Grid.hide Grid.Phone
            ]
            -- Todo: remove in mobile
            []
        , Utils.cell
            [ Grid.size Grid.All 8
            , Grid.size Grid.Phone 12
            ]
            [ Html.map Msg.Quadrant (QV.view model.quadrant)
            ]
        , Grid.cell
            [ Grid.size Grid.All 2
            , Grid.hide Grid.Phone
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
                [ Footer.logo [] [ Footer.html <| text "Love us @ " ]
                , Footer.html <|
                    Html.div
                        [ Attrs.class "fb-like"
                        , Attrs.attribute "data-action" "like"
                        , Attrs.attribute "data-href" "https://www.facebook.com/WindowOfLifeApp/"
                        , Attrs.attribute "data-layout" "button"
                        , Attrs.attribute "data-share" "true"
                        , Attrs.attribute "data-show-faces" "true"
                        , Attrs.attribute "data-size" "small"
                        ]
                        []
                ]
        }

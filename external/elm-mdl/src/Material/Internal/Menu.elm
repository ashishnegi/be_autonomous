module Material.Internal.Menu
  exposing (Msg(..), ItemInfo, KeyCode, ItemIndex)

import Material.Internal.Dropdown as Dropdown
import Material.Internal.Geometry exposing (Geometry)
import Mouse


{-| TODO
-}
type alias ItemConfig m =
    { enabled : Bool
    , divider : Bool
    , onSelect : Maybe m
    }


{-| TODO
-}
type Msg m
    = Open Geometry
    | Close
    | Key (Maybe ItemIndex) (List (ItemInfo m)) KeyCode Geometry
    | Click Dropdown.Alignment Mouse.Position
    | DropdownMsg (Dropdown.Msg m)


{-| TODO
-}
type alias ItemInfo m =
    { enabled : Bool
    , onSelect : Maybe m
    }


{-| TODO
-}
type alias KeyCode
    = Int


{-| TODO
-}
type alias ItemIndex
    = Int

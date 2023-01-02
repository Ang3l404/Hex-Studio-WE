module Components.App.Panels.PatternPanel exposing (patternPanel)

import Array exposing (Array)
import Components.App.Panels.Utils exposing (visibilityToDisplayStyle)
import Components.Icon.ParagraphDropdown exposing (paragraphDropdown)
import FontAwesome as Icon exposing (Icon)
import FontAwesome.Attributes as Icon
import FontAwesome.Brands as Icon
import FontAwesome.Layering as Icon
import FontAwesome.Solid as Icon
import FontAwesome.Styles as Icon
import Html exposing (..)
import Html.Attributes exposing (attribute, class, id, placeholder)
import Logic.App.Model exposing (Model)
import Logic.App.Types exposing (GridPoint, Panel(..), PatternType)
import Components.Icon.XButton exposing (xButton)
import Components.Icon.MoveButton exposing (moveButton)


patternPanel : Model -> Html msg
patternPanel model =
    let
        visibility =
            List.member PatternPanel model.ui.openPanels
    in
    div [ id "pattern_panel", class "panel", visibilityToDisplayStyle visibility ]
        [ h1
            [ class "panel_title"
            ]
            [ text "Pattern Order ∨" ]
        , div
            [ id "pattern_draggable_container"
            ]
            (renderPatternList model.patternList)
        , div
            [ id "add_pattern"
            , class "outer_box"
            ]
            [ div
                [ class "inner_box"
                ]
                [ paragraphDropdown
                , input
                    [ id "add_pattern_input"
                    , placeholder "Add a pattern"
                    , attribute "autocomplete" "off"
                    ]
                    []
                , div
                    [ id "add_pattern_button"
                    , class "add_button"
                    ]
                    [ Icon.css
                    , Icon.plus |> Icon.styled [ Icon.sm ] |> Icon.view
                    ]
                ]
            ]
        ]


renderPatternList : Array ( PatternType, List GridPoint ) -> List (Html msg)
renderPatternList patternList =
    let
        patterns : List PatternType
        patterns =
            Tuple.first <| List.unzip <| Array.toList patternList

        renderPattern : PatternType -> Html msg
        renderPattern pattern =
            div [ class "outer_box" ]
                [ div [ class "inner_box" ]
                    [ div [ class "x_button" ] [xButton]
                    , div [ class "text" ] [ text pattern.internalName ]
                    , div [ class "move_button" ] [moveButton]
                    ]
                ]
    in
    List.map renderPattern patterns

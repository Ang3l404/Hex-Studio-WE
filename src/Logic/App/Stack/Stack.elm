module Logic.App.Stack.Stack exposing (..)

import Array exposing (Array)
import List.Extra as List
import Logic.App.PatternList.PatternArray exposing (getPatternFromName)
import Logic.App.Types exposing (Iota(..), PatternType)
import Logic.App.Utils.Utils exposing (unshift)



-- untested; might not work properly


applyPatternsToStack : Array Iota -> List PatternType -> Array Iota
applyPatternsToStack stack patterns =
    case List.head patterns of
        Nothing ->
            stack

        Just pattern ->
            applyPatternsToStack (applyPatternToStack stack pattern) <| Maybe.withDefault [] <| List.tail patterns


applyPatternToStack : Array Iota -> PatternType -> Array Iota
applyPatternToStack stack pattern =
    let
        numberOfCloseParen =
            case Array.get 0 stack of
                Just (OpenParenthesis list) ->
                    Array.length
                        (Array.filter
                            (\iota ->
                                case iota of
                                    Pattern pat ->
                                        pat.internalName == "close_paren"

                                    _ ->
                                        False
                            )
                            list
                        )

                _ ->
                    0

        numberOfOpenParen =
            (+) 1 <|
                case Array.get 0 stack of
                    Just (OpenParenthesis list) ->
                        Array.length
                            (Array.filter
                                (\iota ->
                                    case iota of
                                        Pattern pat ->
                                            pat.internalName == "open_paren"

                                        _ ->
                                            False
                                )
                             <|
                                Debug.log "lisrt" list
                            )

                    _ ->
                        0

        addToIntroList =
            case Array.get 0 stack of
                Just (OpenParenthesis list) ->
                    Array.set 0 (OpenParenthesis (unshift (Pattern pattern) list)) stack

                _ ->
                    unshift (OpenParenthesis Array.empty) stack
    in
    if List.member Escape <| Array.toList stack then
        unshift (Pattern pattern) <| Array.slice 1 (Array.length stack) stack

    else if pattern.internalName == "close_paren" then
        if pattern.internalName == "close_paren" && (numberOfCloseParen + 1) >= numberOfOpenParen then
            Array.map
                (\iota ->
                    case iota of
                        OpenParenthesis list ->
                            IotaList list

                        otherIota ->
                            otherIota
                )
                stack

        else
            addToIntroList

    else if numberOfOpenParen > 0 then
        addToIntroList

    else
        pattern.action stack

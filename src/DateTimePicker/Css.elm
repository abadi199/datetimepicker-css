module DateTimePicker.Css exposing (css, cssWithNamespace)

{-| DateTimePicker.Css

Using [rtfeldman/elm-css](http://package.elm-lang.org/packages/rtfeldman/elm-css/latest)
Include this in your elm-css port module to be included in your project's css file.


# Css

@docs css, cssWithNamespace

-}

import Css exposing (..)
import Css.Foreign as Foreign exposing (..)
import DEPRECATED.Css.File exposing (Stylesheet, stylesheet)
import DEPRECATED.Css.Namespace as Namespace
import DateTimePicker.Config exposing (defaultNamespace)
import DateTimePicker.SharedStyles exposing (CssClasses(..))
import Html.CssHelpers


{-| DatePicker's Css Stylesheet with custom namespace
-}
cssWithNamespace : String -> Stylesheet
cssWithNamespace namespace =
    let
        datepickerNamespace =
            Html.CssHelpers.withNamespace namespace
    in
    (stylesheet << Namespace.namespace datepickerNamespace.name)
        [ class DatePicker
            [ position relative ]
        , class Dialog
            [ fontFamilies [ "Arial", "Helvetica", "sans-serif" ]
            , fontSize (px 14)
            , borderBoxStyle
            , position absolute
            , border3 (px 1) solid darkGray
            , boxShadow4 (px 0) (px 5) (px 10) (rgba 0 0 0 0.2)
            , children dialogCss
            , property "z-index" "1"
            , displayFlex
            ]
        ]


{-| DatePicker's Css Stylesheet
-}
css : Stylesheet
css =
    cssWithNamespace defaultNamespace


dialogCss : List Foreign.Snippet
dialogCss =
    [ class DatePickerDialog
        [ float left

        -- , height calendarHeight
        , children datePickerDialogCss
        ]
    , class TimePickerDialog
        [ float left

        -- , height calendarHeight
        , textAlign center
        , borderLeft3 (px 1) solid darkGray
        , withClass DigitalTime digitalTimePickerDialogStyle
        , withClass AnalogTime analogTimePickerDialogStyle
        ]
    ]


analogTimePickerDialogStyle : List Css.Style
analogTimePickerDialogStyle =
    let
        timeHeaderStyle =
            Css.batch
                [ padding2 (px 3) (px 10)
                , marginTop (px 3)
                , marginBottom (px 3)
                , display inlineBlock
                , cursor pointer
                ]

        amPmStyle =
            Css.batch
                [ fontSize (Css.em 1.2)
                , padding2 (Css.em 1) (Css.em 0)
                , cursor pointer
                , margin2 (px 0) auto
                , width (px 85)
                , hover [ backgroundColor highlightedDay ]
                ]
    in
    [ width (px 230)
    , descendants
        [ class Header
            [ headerStyle
            , fontSize (Css.em 1.2)
            , descendants
                [ class Hour [ timeHeaderStyle ]
                , class Minute [ timeHeaderStyle ]
                , class AMPM [ timeHeaderStyle ]
                , class Active
                    [ activeStyle ]
                ]
            ]
        , class Body [ backgroundColor (hex "#fff"), padding2 (px 12) (px 15), height (px 202) ]
        , class AMPMPicker [ padding2 (px 40) (px 0) ]
        , class AM
            [ amPmStyle
            , withClass SelectedAmPm [ highlightStyle, hover [ highlightStyle ] ]
            ]
        , class PM
            [ amPmStyle
            , withClass SelectedAmPm [ highlightStyle, hover [ highlightStyle ] ]
            ]
        ]
    ]


digitalTimePickerDialogStyle : List Css.Style
digitalTimePickerDialogStyle =
    [ children
        [ class Header
            [ headerStyle
            ]
        , class Body
            [ backgroundColor (hex "#fff")
            , descendants
                [ Foreign.table
                    [ tableStyle
                    , width (px 120)
                    , descendants
                        [ tr
                            [ verticalAlign top
                            , withClass ArrowUp
                                [ backgroundColor lightGray
                                , children
                                    [ td [ borderBottom3 (px 1) solid darkGray ]
                                    ]
                                ]
                            , withClass ArrowDown
                                [ backgroundColor lightGray
                                , children [ td [ borderTop3 (px 1) solid darkGray ] ]
                                ]
                            ]
                        , td
                            [ width (pct 33)
                            , cellStyle
                            , hover
                                [ backgroundColor highlightedDay
                                , highlightBorderStyle
                                ]
                            , withClass EmptyCell [ emptyCellStyle ]
                            ]
                        , class SelectedHour [ highlightStyle, hover [ highlightStyle ] ]
                        , class SelectedMinute [ highlightStyle, hover [ highlightStyle ] ]
                        , class SelectedAmPm [ highlightStyle, hover [ highlightStyle ] ]
                        ]
                    ]
                ]
            ]
        ]
    ]


datePickerDialogCss : List Foreign.Snippet
datePickerDialogCss =
    [ class Header
        [ borderBoxStyle
        , headerStyle
        , position relative
        , children
            [ class ArrowLeft
                [ arrowStyle
                , left (px 22)
                , withClass NoYearNavigation [ left (px 0) ]
                ]
            , class DoubleArrowLeft
                [ arrowStyle
                , left (px 0)
                ]
            , class ArrowRight
                [ arrowStyle
                , right (px 22)
                , withClass NoYearNavigation [ right (px 0) ]
                ]
            , class DoubleArrowRight
                [ arrowStyle
                , right (px 0)
                ]
            , class Title
                [ borderBoxStyle
                , display inlineBlock
                , width (pct 100)
                , textAlign center
                ]
            ]
        ]
    , class Calendar
        [ backgroundColor (hex "#ffffff")
        , tableStyle
        , width auto
        , margin (px 0)
        , descendants
            [ thead
                []
            , td
                [ dayStyle
                , hover
                    [ backgroundColor highlightedDay
                    , highlightBorderStyle
                    ]
                ]
            , th
                [ dayStyle
                , backgroundColor lightGray
                , fontWeight normal
                , borderBottom3 (px 1) solid darkGray
                ]
            , class PreviousMonth
                [ color fadeText ]
            , class NextMonth
                [ color fadeText
                ]
            , class SelectedDate
                [ highlightStyle
                , hover [ highlightStyle ]
                ]
            , class Today
                [ property "box-shadow" "inset 0 0 7px 0 #76abd9"
                , highlightBorderStyle
                , hover
                    [ backgroundColor highlightSelectedDay ]
                ]
            ]
        ]
    , class Footer
        [ textAlign center
        , backgroundColor lightGray
        , padding2 (px 7) (px 7)
        , borderTop3 (px 1) solid darkGray
        ]
    ]


highlightStyle : Css.Style
highlightStyle =
    Css.batch
        [ property "box-shadow" "inset 0 0 10px 3px #3276b1"
        , backgroundColor selectedDate
        , color (hex "#fff")
        , highlightBorderStyle
        ]


highlightSelectedDay : Css.Color
highlightSelectedDay =
    hex "#d5e5f3"


selectedDate : Css.Color
selectedDate =
    hex "#428bca"


fadeText : Css.Color
fadeText =
    hex "#a1a1a1"


lightGray : Css.Color
lightGray =
    hex "#f5f5f5"


darkGray : Css.Color
darkGray =
    hex "#ccc"


highlightedDay : Css.Color
highlightedDay =
    hex "#ebebeb"


dayStyle : Css.Style
dayStyle =
    Css.batch
        [ cellStyle
        , textAlign right
        ]


cellStyle : Css.Style
cellStyle =
    Css.batch
        [ padding4 (px 7) (px 7) (px 7) (px 9)
        , border (px 0)
        , cursor pointer
        ]


arrowStyle : Css.Style
arrowStyle =
    Css.batch
        [ borderBoxStyle
        , textAlign center
        , transform (scale 0.8)
        , position absolute
        , padding2 (px 0) (px 8)
        , cursor pointer
        ]


borderBoxStyle : Css.Style
borderBoxStyle =
    Css.batch [ boxSizing borderBox ]


highlightBorderStyle : Css.Style
highlightBorderStyle =
    Css.batch [ borderRadius (px 0) ]


headerStyle : Css.Style
headerStyle =
    Css.batch
        [ padding2 (px 10) (px 7)
        , backgroundColor lightGray
        ]


calendarHeight : Css.Px
calendarHeight =
    px 277


tableStyle : Css.Style
tableStyle =
    Css.batch
        [ property "border-spacing" "0"
        , property "border-width" "0"
        , property "table-layout" "fixed"
        , margin (px 0)
        ]


activeStyle : Css.Style
activeStyle =
    Css.batch
        [ backgroundColor (hex "#e0e0e0")
        , highlightBorderStyle
        ]


emptyCellStyle : Css.Style
emptyCellStyle =
    Css.batch [ hover [ backgroundColor unset ], cursor unset ]

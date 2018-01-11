module Demo exposing (main)

import DEPRECATED.Css.File
import Date exposing (Date)
import Date.Extra.Config.Config_en_us exposing (config)
import Date.Extra.Format
import DateParser
import DateTimePicker
import DateTimePicker.Config exposing (Config, CssConfig, DatePickerConfig, TimePickerConfig, defaultDatePickerConfig, defaultDateTimeI18n, defaultDateTimePickerConfig, defaultTimePickerConfig)
import DateTimePicker.Css
import DateTimePicker.SharedStyles
import Dict exposing (Dict)
import Html exposing (Html, div, form, h3, label, li, p, text, ul)
import Html.CssHelpers


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


type DemoPicker
    = DatePicker
    | DigitalDateTimePicker
    | AnalogDateTimePicker
    | CustomI18n
    | TimePicker
    | NoPicker


type alias Model =
    { dates : Dict String Date -- The key is actually a DemoPicker
    , datePickerState : Dict String DateTimePicker.State -- The key is actually a DemoPicker
    }


init : ( Model, Cmd Msg )
init =
    ( { dates = Dict.empty
      , datePickerState = Dict.empty
      }
    , Cmd.batch
        [ DateTimePicker.initialCmd (DatePickerChanged DatePicker) DateTimePicker.initialState
        , DateTimePicker.initialCmd (DatePickerChanged DigitalDateTimePicker) DateTimePicker.initialState
        , DateTimePicker.initialCmd (DatePickerChanged AnalogDateTimePicker) DateTimePicker.initialState
        , DateTimePicker.initialCmd (DatePickerChanged CustomI18n) DateTimePicker.initialState
        , DateTimePicker.initialCmd (DatePickerChanged TimePicker) DateTimePicker.initialState
        , DateTimePicker.initialCmd (DatePickerChanged NoPicker) DateTimePicker.initialState
        ]
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


{ id, class, classList } =
    Html.CssHelpers.withNamespace ""


analogDateTimePickerConfig : Config (CssConfig (DatePickerConfig TimePickerConfig) Msg DateTimePicker.SharedStyles.CssClasses) Msg
analogDateTimePickerConfig =
    let
        defaultDateTimeConfig =
            defaultDateTimePickerConfig (DatePickerChanged AnalogDateTimePicker)
    in
    { defaultDateTimeConfig
        | timePickerType = DateTimePicker.Config.Analog
        , allowYearNavigation = False
    }


timePickerConfig : Config (CssConfig TimePickerConfig Msg DateTimePicker.SharedStyles.CssClasses) Msg
timePickerConfig =
    let
        defaultDateTimeConfig =
            defaultTimePickerConfig (DatePickerChanged TimePicker)
    in
    { defaultDateTimeConfig
        | timePickerType = DateTimePicker.Config.Analog
    }


noPickerConfig : Config (CssConfig (DatePickerConfig {}) Msg DateTimePicker.SharedStyles.CssClasses) Msg
noPickerConfig =
    let
        defaultDateConfig =
            defaultDatePickerConfig (DatePickerChanged NoPicker)
    in
    { defaultDateConfig
        | usePicker = False
        , attributes = [ class [ "Test" ] ]
    }


customI18nConfig : Config (CssConfig (DatePickerConfig TimePickerConfig) Msg DateTimePicker.SharedStyles.CssClasses) Msg
customI18nConfig =
    let
        defaultDateTimeConfig =
            defaultDateTimePickerConfig (DatePickerChanged CustomI18n)
    in
    { defaultDateTimeConfig
        | timePickerType = DateTimePicker.Config.Analog
        , allowYearNavigation = False
        , i18n = { defaultDateTimeI18n | inputFormat = customInputFormat }
    }


customDatePattern : String
customDatePattern =
    "%d/%m/%Y %H:%M"


customInputFormat : DateTimePicker.Config.InputFormat
customInputFormat =
    { inputFormatter = Date.Extra.Format.format config customDatePattern
    , inputParser = DateParser.parse config customDatePattern >> Result.toMaybe
    }


digitalDateTimePickerConfig : Config (CssConfig (DatePickerConfig TimePickerConfig) Msg DateTimePicker.SharedStyles.CssClasses) Msg
digitalDateTimePickerConfig =
    let
        defaultDateTimeConfig =
            defaultDateTimePickerConfig (DatePickerChanged DigitalDateTimePicker)
    in
    { defaultDateTimeConfig
        | timePickerType = DateTimePicker.Config.Digital
    }


digitalTimePickerConfig : Config (CssConfig TimePickerConfig Msg DateTimePicker.SharedStyles.CssClasses) Msg
digitalTimePickerConfig =
    let
        defaultDateTimeConfig =
            defaultTimePickerConfig (DatePickerChanged TimePicker)
    in
    { defaultDateTimeConfig
        | timePickerType = DateTimePicker.Config.Digital
    }


viewPicker : DemoPicker -> Maybe Date -> DateTimePicker.State -> Html Msg
viewPicker which date state =
    p []
        [ label []
            [ text (toString which)
            , text ":"
            , case which of
                DatePicker ->
                    DateTimePicker.datePicker (DatePickerChanged which) [] state date

                DigitalDateTimePicker ->
                    DateTimePicker.dateTimePickerWithConfig digitalDateTimePickerConfig [] state date

                AnalogDateTimePicker ->
                    DateTimePicker.dateTimePickerWithConfig analogDateTimePickerConfig [] state date

                CustomI18n ->
                    DateTimePicker.dateTimePickerWithConfig customI18nConfig [] state date

                TimePicker ->
                    DateTimePicker.timePickerWithConfig digitalTimePickerConfig [] state date

                NoPicker ->
                    DateTimePicker.datePickerWithConfig noPickerConfig [] state date
            ]
        ]


view : Model -> Html Msg
view model =
    let
        { css } =
            DEPRECATED.Css.File.compile [ DateTimePicker.Css.css ]

        allPickers =
            [ DatePicker
            , DigitalDateTimePicker
            , AnalogDateTimePicker
            , CustomI18n
            , TimePicker
            , NoPicker
            ]
    in
    form []
        [ Html.node "style" [] [ Html.text css ]
        , allPickers
            |> List.map
                (\which ->
                    viewPicker which
                        (Dict.get (toString which) model.dates)
                        (Dict.get (toString which) model.datePickerState |> Maybe.withDefault DateTimePicker.initialState)
                )
            |> div []
        , h3 [] [ text "Selected values" ]
        , p []
            [ allPickers
                |> List.map
                    (\which ->
                        li [] [ text (toString which), text ": ", text <| toString <| Dict.get (toString which) model.dates ]
                    )
                |> ul []
            ]
        ]


type Msg
    = DatePickerChanged DemoPicker DateTimePicker.State (Maybe Date)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DatePickerChanged which state value ->
            ( { model
                | dates =
                    case value of
                        Nothing ->
                            Dict.remove (toString which) model.dates

                        Just date ->
                            Dict.insert (toString which) date model.dates
                , datePickerState = Dict.insert (toString which) state model.datePickerState
              }
            , Cmd.none
            )

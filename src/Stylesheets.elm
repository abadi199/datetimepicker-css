port module Stylesheets exposing (..)

import DEPRECATED.Css.File as File exposing (CssCompilerProgram, CssFileStructure)
import DateTimePicker.Css


port files : CssFileStructure -> Cmd msg


fileStructure : CssFileStructure
fileStructure =
    File.toFileStructure
        [ ( "styles.css", File.compile [ DateTimePicker.Css.css ] ) ]


main : CssCompilerProgram
main =
    File.compiler files fileStructure

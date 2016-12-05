port module Main exposing (..)

import Test.Runner.Node exposing (run, TestProgram)
import Json.Encode exposing (Value)
import InfixPolishConversionTest


main : TestProgram
main =
    run emit InfixPolishConversionTest.all


port emit : ( String, Value ) -> Cmd msg

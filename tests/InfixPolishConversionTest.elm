module InfixPolishConversionTest exposing (..)

import Test exposing (..)
import Expect
import Fuzz exposing (list, int, tuple, string)
import String

import InfixPolishConversion as IPC
import List as L

all : Test
all =
    describe "Test Evaluation and State Transitions"
      [ test "infixToPolishString" <|
          \() ->
              Expect.equal
                "34-5+"
                (IPC.infixToPolishString "" (L.map String.fromChar (String.toList "3-4+5")))
      , test "infixToPolish" <|
          \() ->
              Expect.equal
                ["3","4","-","5","+"]
                (IPC.infixToPolish (L.map String.fromChar (String.toList "3-4+5")))
      -- , test "This test should fail - you should remove it" <|
      --     \() ->
      --         Expect.fail "Failed as expected!"
      ]

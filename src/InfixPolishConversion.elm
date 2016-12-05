module InfixPolishConversion exposing
  ( infixToPolish
  , infixToPolishString
  )
{-| This library provides functions to convert a list of symbols from
infix notation to polish notation

# Define
@docs infixToPolish, infixToPolishString
-}

import List as L
import Array as A
import Html exposing(text)

type alias State =
  { output : List String
  , ops : List String }


newState : List String -> List String -> State
newState output ops =
  { output = output
  , ops = ops }

emptyNewState : State
emptyNewState =
  { output = []
  , ops = [] }

listPop : List a -> Maybe a
listPop l =
  L.head (L.reverse l)

pushOutput : String -> State -> State
pushOutput v acc = newState (L.append acc.output [v]) acc.ops

popOp : State -> State
popOp s =
  { output = s.output
  , ops = A.toList ((A.slice 0 ((L.length s.ops) - 1) (A.fromList s.ops)))
  }

pushOp : String -> State -> State
pushOp s acc =
  { output = acc.output
  , ops = L.append acc.ops [s]
  }

isSymbol : String -> Bool
isSymbol s =
  L.member s ["+", "-", "*", "/"]

processOps : String -> State -> State
processOps v acc =
  case listPop acc.ops of
    Just a -> processOps v (pushOutput a (popOp acc))
    Nothing -> pushOp v acc

processSymbol : String -> State -> State
processSymbol v acc =
  if isSymbol v
  then processOps v acc
  else pushOutput v acc


infixToPolishState : List String -> State
infixToPolishState l =
  L.foldl processSymbol emptyNewState l

{-| Converts a list of symbols in infix notation, to a list of symbols in
polish notation -}
infixToPolish : List String -> List String
infixToPolish l =
  let r = infixToPolishState l
  in L.append r.output r.ops

{-| Converts a list of symbols in infix notation, to a string of symbols in
polish notation -}
infixToPolishString : String  -> List String -> String
infixToPolishString seperator l =
  let r = infixToPolishState l
  in String.join (seperator) (L.append r.output r.ops)

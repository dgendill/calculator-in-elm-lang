module StringEvalUnsafe exposing (eval)

{-| An unsafe alternative to this:
https://en.wikipedia.org/wiki/Reverse_Polish_notation#Postfix_algorithm.

Safe version is Expression.elm

# Definition
@docs eval
-}

import Native.StringEval

{-| Run an infix expression through String.eval -}
eval : String -> Float
eval = Native.StringEval.eval

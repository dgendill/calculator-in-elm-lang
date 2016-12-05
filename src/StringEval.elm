module StringEval exposing (eval)
{-| It would be better to use this
https://en.wikipedia.org/wiki/Reverse_Polish_notation#Postfix_algorithm.  Maybe
in the future...

# Definition
@docs eval
-}

import Native.StringEval

{-| Run an infix expression through String.eval -}
eval : String -> Float
eval = Native.StringEval.eval

module Expression exposing (..)
-- exposing
--   ( infixToPostfix
--   , Symbol(..)
--   , Expression
--   , eval
--   , basicEval
--   , showExpr
--   , mergeNumbers
--   , evalInfix
--   )

{-| Provides a way to evaluate a list of arithmetic symbols into a final value.
# Definition
@docs infixToPostfix, Symbol, Expression, eval, basicEval, showExpr, mergeNumbers, ConversionStep, NewExpression, OldExpression, OpStack, compareOps, compareSy, eval_, getAt_, head_, infixToPostfix_, isOperand, isOperator, liftMaybes, popStack, tail_, testExp, evalInfix

-}

import List exposing(foldr, indexedMap, append, tail, head, reverse, length, drop)
import Maybe exposing (withDefault)
import List.Extra exposing (lift2, getAt, takeWhile)
import Result exposing (Result(..))

{-| Expression is an alias for a list of symbols -}
type alias Expression = List Symbol
{-| For testing -}
type alias NewExpression = List Symbol
{-| For testing -}
type alias OldExpression = List Symbol
{-| For testing -}
type alias OpStack = List Symbol
{-| For testing -}
type alias ConversionStep = (Expression, OpStack, NewExpression)

{-| Symbols you can use in expressions.  Add, Sub, Mult, Div, LParen,
RParen, and N -}
type Symbol
  = Add
  | Sub
  | Mult
  | Div
  | LParen
  | RParen
  | N Float
  | Nil


{-| For testing -}
isOperand : Symbol -> Bool
isOperand s =
  case s of
    (N a) -> True
    _     -> False


{-| For testing -}
isOperator : Symbol -> Bool
isOperator s =
  case s of
    Add  -> True
    Sub  -> True
    Mult -> True
    Div  -> True
    _    -> False


{-| For testing -}
compareSy : Symbol -> Symbol -> Order
compareSy s1 s2 =
  if (s1 == s2)
  then EQ
  else
    case (s1, s2) of
      (Add, Sub)  -> EQ
      (Sub, Add)  -> EQ
      (Mult, Div) -> EQ
      (Div, Mult) -> EQ
      (Mult, Add) -> GT
      (Div,  Add) -> GT
      (Mult, Sub) -> GT
      (Div,  Sub) -> GT
      (Add, Mult) -> LT
      (Sub, Mult) -> LT
      (Add, Div)  -> LT
      (Sub, Div)  -> LT
      (_  , _)    -> LT


{-| App specific -}
head_ : Expression -> Symbol
head_ e = withDefault Nil (head e)


{-| App specific -}
tail_ : Expression -> Expression
tail_ e = withDefault [Nil] (tail e)


{-| App specific -}
getAt_ : Int -> List Symbol -> Symbol
getAt_ idx xs = withDefault Nil (getAt idx xs)


{-| For testing -}
testExp : Expression
testExp = [N 5.0, Add, N 5.1]


{-| For testing -}
popStack : Expression -> OpStack -> NewExpression -> ConversionStep
popStack exp_ opstack_ nexp_ =
  if ((head_ opstack_) == LParen)
  then (exp_, (tail_ opstack_), nexp_)
  else popStack exp_ (tail_ opstack_) ((head_ opstack_) :: nexp_)


{-| For testing -}
compareOps : Expression -> OpStack -> NewExpression -> Symbol -> ConversionStep
compareOps exp_ opstack_ nexp_ symbol =
  if (compareSy (head_ opstack_) symbol == LT)
  then ((exp_),(symbol :: opstack_), nexp_)
  else compareOps exp_ (tail_ opstack_) ((head_ opstack_) :: nexp_) symbol


{-| Takes an expression in infix notation and turns it into postfix. -}
infixToPostfix : Expression -> Expression
infixToPostfix exp =
  case (mergeNumbers exp []) of
    (Ok merged) -> infixToPostfix_ merged [] []
    (Err s) -> []


{-| For testing -}
infixToPostfix_ : Expression -> OpStack -> NewExpression -> Expression
infixToPostfix_ exp opstack nexp =
  let
    symbol = head_ exp
  in
    if (isOperand symbol)
    then infixToPostfix_ (tail_ exp) opstack (symbol :: nexp)
    else
      if (symbol == LParen)
      then infixToPostfix_ (tail_ exp) (symbol :: opstack) nexp
      else
        if (symbol == RParen)
        then
          let (a, b, c) = popStack exp opstack nexp
          in infixToPostfix_ (tail_ a) b c
        else
          if (isOperator symbol)
          then
            let (a, b, c) = compareOps exp opstack nexp symbol
            in infixToPostfix_ (tail_ a) b c
          else append (reverse nexp) (reverse opstack)


{-| Evaluates the most basic of expressions, two operands and an operator. -}
basicEval : Symbol -> Symbol -> Symbol -> Maybe Symbol
basicEval a b c =
  --   (operand, operrand, opperator)
  case (a, b, c) of
    (N a, N b, Add)  -> Just (N (a + b))
    (N a, N b, Sub)  -> Just (N (a - b))
    (N a, N b, Mult) -> Just (N (a * b))
    (N a, N 0, Div)  -> Nothing
    (N a, N b, Div)  -> Just (N (a / b))
    (_  , _  ,   _)  -> Nothing


{-| For testing -}
liftMaybes : ( a -> List a -> List a) -> Maybe a -> Maybe (List a) -> List a
liftMaybes f c d = case (c, d) of
  ((Just a), (Just b)) -> f a b
  ((Just a),  Nothing)  -> [a]
  ( Nothing, (Just b))  -> b
  ( Nothing,  Nothing)  -> []

{-| Merges consecutive numbesr into a single number -}
mergeNumbers : Expression -> Expression -> Result String Expression
mergeNumbers exp stack =
  let numbers =
    takeWhile (\s -> case s of
        (N a) -> True
        _     -> False
      ) exp
  in
    if (length exp == 0 && length stack > 0)
    then Ok (reverse stack)
    else
      case numbers of
        [] -> mergeNumbers (tail_ exp) ((head_ exp) :: stack)
        _  ->
          let number =
            List.foldr (\n a ->
                case n of
                  (N nn) -> (toString nn) ++ a
                  _      -> a
              ) "" numbers
          in
            case (String.toFloat number) of
              (Ok a) -> mergeNumbers (drop (length numbers) exp) ((N a) :: stack)
              e      -> Err ("Could not parse " ++ number)

{-| Reduces a postfix expression (with sequential numbers merged)
to a final value (a reduced expression). Infix expressions and sequential numbers
will silently fail for now. :/ -}
eval : Expression -> Expression
eval exp =
  case (eval_ exp []) of
    Nothing -> []
    Just n  -> [n]

{-| Reduces a infix expression to a final value. -}
evalInfix : Expression -> Expression
evalInfix exp =
  case (mergeNumbers exp []) of
    (Ok merged) ->
      case (eval_ (infixToPostfix merged) []) of
        Nothing -> []
        Just n  -> [n]
    (Err s) -> []


{-| For testing -}
eval_ : Expression -> Expression -> Maybe Symbol
eval_ exp stack =
  if ( (length stack == 1) && (length exp == 0) )
  then Just (head_ stack)
  else
    case head_ exp of
      (Nil)   -> Nothing
      (N a) -> eval_ (tail_ exp) ((head_ exp) :: stack)
      op    ->
        if (length stack >= 2)
        then
          let result = basicEval (getAt_ 1 stack) (getAt_ 0 stack) op
          in
            if result == Nothing
            then Nothing
            else eval_ (tail_ exp) (liftMaybes (::) result (Just (drop 2 stack)))
        else Nothing


{-| Render and expression as a string. -}
showExpr : Expression -> String
showExpr e = foldr (\s acc -> case s of
    Add   -> acc ++ "+"
    Sub   -> acc ++ "-"
    Mult  -> acc ++ "*"
    Div   -> acc ++ "/"
    LParen-> acc ++ "("
    RParen-> acc ++ ")"
    (N f) -> acc ++ toString f
    Nil   -> acc ++ "Nil"
  ) "" e

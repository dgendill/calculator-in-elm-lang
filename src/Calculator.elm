module Calculator exposing (main)
{-| A simple calculator for the DOM
# Definition
@docs main
-}

import Html exposing (Html, button, div, text)
import Html.Attributes exposing (attribute, style)
import Html.Events exposing (onClick)
import Maybe
import StringEval exposing(eval)
import Regex
import Array
import Css as C exposing (pct, px, rgb, rgba, Mixin, width)
import InfixPolishConversion

{-| Render the component -}
main : Program Never Model Msg
main =
  Html.beginnerProgram
    { model = model
    , view = view
    , update = update
    }

{-| The Model is a list of symbols -}
type alias Model = {
  expr : List ExpressionSymbol
}

model : Model
model = { expr = [] }

{-| An Expression is a list of symbols. -}
type alias Expression = List ExpressionSymbol

{-| We support the following symbols currently.  N is for numeric symbols. -}
type ExpressionSymbol
  = Addition
  | Subtraction
  | N String

{-| These are the events that a user can trigger by interacting with the DOM -}
type Msg
  = Add
  | Subtract
  | Num Float
  | Clear
  | Evaluate

{-| This is evaluated with native String.eval -}
evalExpression : Expression -> Expression
evalExpression exprList =
  let v = (eval (showExpression exprList))
  in
    case v of
      0 -> []
      _ -> [N (toString v)]

{-| Update the view... -}
update : Msg -> Model -> Model
update msg model =
    case msg of
      Num 0.0 ->
        if (List.length model.expr == 0)
        then model
        else { expr = (::) (N "0") model.expr }

      Num a ->
        { expr = (::) (N (toString a)) model.expr }

      Add ->
        case (List.head model.expr) of
          Just (N b) -> { expr =  Addition ::  model.expr }
          Just (b)   -> model
          Nothing    -> model

      Subtract ->
        case (List.head model.expr) of
          Just (N b) -> { expr =  Subtraction :: model.expr }
          Just (b)   -> model
          Nothing    -> model

      Clear ->
        { expr = [] }

      Evaluate ->
        { expr = evalExpression model.expr }


{-| Render the expression in reverse polish notation. -}
showExpressionPolish : Expression -> String
showExpressionPolish expr =
  InfixPolishConversion.infixToPolishString " "
  (List.map String.fromChar (String.toList (showExpression expr)))

{-| Render the expression with infix notation. -}
showExpression : Expression -> String
showExpression expr =
  if (List.length(expr) == 0)
  then "0"
  else (List.foldr
    (\v acc ->
      case v of
        Addition -> acc  ++ "+"
        Subtraction -> acc ++ "-"
        N a -> acc ++ a
    ) "" expr)

styles =
  C.asPairs >> Html.Attributes.style

calcBorder : Mixin
calcBorder = C.border3 (px 1) C.solid (rgb 220 220 220)

viewportBackground : C.Color
viewportBackground = (rgb 240 240 240)

calcButton : List (Html.Attribute msg) -> List (Html msg) -> Html msg
calcButton attr html =
  button
  (List.append
    attr
    [styles [ width (pct 32)
            , C.marginBottom (px 10) ]])
  html

view : Model -> Html Msg
view model =
  div [ attribute "class" "calculator"
      , styles [ C.backgroundColor viewportBackground
               , calcBorder
               , C.padding (px 10)
               , width (px 200) ]
      ]
    [
      div [ attribute "class" "calculator__display"
          , styles [ calcBorder
                   , C.backgroundColor (rgb 220 220 220)
                   , C.marginBottom (px 10)] ]
          [ text ( showExpression model.expr) ]

    , div [ attribute "class" "calculator__controls"
          , styles [ C.displayFlex, C.alignItems C.center
                   , C.flexFlow2 C.row C.wrap
                   , C.property "justify-content" "space-between" ]
          ]

      [ calcButton [ onClick (Num 1.0) ] [ text "1" ]
      , calcButton [ onClick (Num 2.0) ] [ text "2" ]
      , calcButton [ onClick (Num 3.0) ] [ text "3" ]
      , calcButton [ onClick (Num 4.0) ] [ text "4" ]
      , calcButton [ onClick (Num 5.0) ] [ text "5" ]
      , calcButton [ onClick (Num 6.0) ] [ text "6" ]
      , calcButton [ onClick (Num 7.0) ] [ text "7" ]
      , calcButton [ onClick (Num 8.0) ] [ text "8" ]
      , calcButton [ onClick (Num 9.0) ] [ text "9" ]
      , calcButton [ onClick (Num 0.0) ] [ text "0" ]
      , calcButton [ onClick Subtract ] [ text "-" ]
      , calcButton [ onClick Add ] [ text "+" ]
      , calcButton [ onClick Clear ] [ text "X" ]
      , calcButton [ onClick Evaluate ] [ text "=" ]
      ]
    ]

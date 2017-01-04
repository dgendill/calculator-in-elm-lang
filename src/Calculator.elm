module Calculator exposing (main)
{-| A simple calculator for the DOM
# Definition
@docs main
-}

import Html exposing (Html, button, div, text)
import Html.Attributes exposing (attribute, style)
import Html.Events exposing (onClick)
import Css as C exposing (pct, px, rgb, rgba, Mixin, width)
import Expression exposing (Symbol(..), infixToPrefix, showExpr, eval)

type alias Expression = List Symbol

{-| Render the component -}
main : Program Never Model Msg
main =
  Html.beginnerProgram
    { model = model
    , view = view
    , update = update
    }


{-| The Model is a list of symbols -}
type alias Model =
  { expr : Expression }


model : Model
model = { expr = [] }



{-| These are the events that a user can trigger by interacting with the DOM -}
type Msg
  = MAdd
  | MSubtract
  | MNum Float
  | MClear
  | MEvaluate
  | MDivide
  | MMult


{-| Update the view... -}
update : Msg -> Model -> Model
update msg model =
  case msg of
    MNum 0.0 ->
      if (List.length model.expr == 0)
      then model
      else { expr = (::) (N 0) model.expr }

    MNum a ->
      { expr = (::) (N a) model.expr }

    MAdd ->
      case (List.head model.expr) of
        Just (N b) -> { expr =  Add ::  model.expr }
        Just (b)   -> model
        Nothing    -> model

    MSubtract ->
      case (List.head model.expr) of
        Just (N b) -> { expr =  Sub :: model.expr }
        Just (b)   -> model
        Nothing    -> model

    MMult ->
      case (List.head model.expr) of
        Just (N b) -> { expr =  Mult ::  model.expr }
        Just (b)   -> model
        Nothing    -> model

    MDivide ->
      case (List.head model.expr) of
        Just (N b) -> { expr =  Div :: model.expr }
        Just (b)   -> model
        Nothing    -> model

    MClear ->
      { expr = [] }

    MEvaluate ->
      { expr = eval (infixToPrefix model.expr) }


{-| Render the expression with infix notation. -}
showExpression : Expression -> String
showExpression exp =
  let r = showExpr exp
  in
    case r of
      "" -> "0"
      _ -> r


styles =
  C.asPairs >> Html.Attributes.style


calcBorder : Mixin
calcBorder =
  C.border3 (px 1) C.solid (rgb 220 220 220)


viewportBackground : C.Color
viewportBackground =
  (rgb 240 240 240)


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

      [ calcButton [ onClick (MNum 1.0) ] [ text "1" ]
      , calcButton [ onClick (MNum 2.0) ] [ text "2" ]
      , calcButton [ onClick (MNum 3.0) ] [ text "3" ]
      , calcButton [ onClick (MNum 4.0) ] [ text "4" ]
      , calcButton [ onClick (MNum 5.0) ] [ text "5" ]
      , calcButton [ onClick (MNum 6.0) ] [ text "6" ]
      , calcButton [ onClick (MNum 8.0) ] [ text "8" ]
      , calcButton [ onClick (MNum 7.0) ] [ text "7" ]
      , calcButton [ onClick (MNum 9.0) ] [ text "9" ]
      , calcButton [ onClick (MNum 0.0) ] [ text "0" ]
      , calcButton [ onClick MSubtract ] [ text "-" ]
      , calcButton [ onClick MAdd ] [ text "+" ]
      , calcButton [ onClick MMult ] [ text "*" ]
      , calcButton [ onClick MDivide ] [ text "/" ]
      , calcButton [ onClick MClear ] [ text "C" ]
      , calcButton [ onClick MEvaluate ] [ text "=" ]
      ]
    ]

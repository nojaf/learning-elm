import Html exposing (Html, div, text, button)
import Html.Events exposing (onClick)
import Html.App as Html
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, second)



main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
    { time : Time
    , paused: Bool
    }


init : (Model, Cmd Msg)
init =
  ({ time = 0, paused = False}, Cmd.none)



-- UPDATE


type Msg =
    Tick Time
    | Toggle


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      ({model | time = newTime}, Cmd.none)
    Toggle ->
        ({ model | paused = not(model.paused)}, Cmd.none)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  if model.paused then
    Sub.none
  else
    Time.every second Tick



-- VIEW

renderClock: Float -> String -> String -> Html msg
renderClock angle handX handY =
    svg [ viewBox "0 0 100 100", width "300px" ]
      [ circle [ cx "50", cy "50", r "45", fill "#0B79CE" ] []
      , line [ x1 "50", y1 "50", x2 handX, y2 handY, stroke "#023963" ] []
      ]

view : Model -> Html Msg
view model =
  let
    angle =
      turns (Time.inMinutes model.time)

    handX =
      toString (50 + 40 * cos angle)

    handY =
      toString (50 + 40 * sin angle)
  in
    div [class "container"] [
        (renderClock angle handX handY)
        ,div [class ""] [button [class "btn btn-info", onClick Toggle] [Html.text (if model.paused then "Resume" else "Stop")]]
    ]

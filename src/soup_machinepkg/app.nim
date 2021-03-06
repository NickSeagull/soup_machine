import ./domain
import patty
from strformat import fmt
import math

type Model* = object
  counter*: int
  keyPressed*: int
  keyValue*: int
  buttonPressed*: int

let initial* = Model(counter: 0, keyPressed: 0, keyValue: 0)

proc update*(message: Message, model: Model): (Model, seq[Cmd]) =
  match message:
    EncoderChanged(encoder, isIncreased, isShiftPressed):
      let increment = if isIncreased: 1 else: -1
      let multiplier = if isShiftPressed: 10 else: 1
      var newModel = model
      newModel.counter += (encoder * increment * multiplier)
      (newModel, @[CmdNone()])
    KeyPressed(index, value, _):
      (
        model,
        @[
          SetKeyLed(index, value),
          PlaySound(
            round(440.0 * pow(1.059463, float64(3 + index - 12)), 2),
            value.float64
          )
        ]
      )
    KeyReleased(index, _):
      (model, @[SetKeyLed(index, 0.0)])
    ButtonChanged(btn, on):
      (model, @[SetButtonLed(btn, on)])
    _:
      (model, @[CmdNone()])


proc view*(model: Model): View =
  Rectangle(false, @[
    Text(fmt"Counter {$model.counter}")
  ])
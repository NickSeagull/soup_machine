import ./cabl
from strformat import fmt
import patty
import options


let white = newColor(0xff)

variant Event:
  EncoderChanged(ecEncoder: int, ecIncreased: bool, ecShift: bool)

# vdom mocks

variant Node:
  Rectangle(rFilled: bool, rChildren: seq[Node])
  Text(tText: string)

type Model = int

var models: Channel[Model]
var events: Channel[Event]

proc foldp(updateFn: proc(model: Model, event: Event): Model, initial: Model): void =
  models.send(initial)
  var model = initial
  var event = events.recv()
  while true: # TODO: close channel to close loop
    let newModel = updateFn(model, event)
    models.send(newModel)
    model = newModel
    event = events.recv()

var gDevice: Option[DevicePtr] = none(DevicePtr)

proc view(model: Model): Node =
  Text(fmt"Counter {$model}")

proc doRender(): void =
  while true:
    let model: Model = models.recv()
    let node: Node = view(model)
    gDevice.map do (device: DevicePtr) -> void:
      device.graphicDisplay(0).black()
      match node:
        Text(tText):
          device.textDisplay(0).putText(tText, 0)
          device.graphicDisplay(0).putText(10, 10, tText, white)
        Rectangle(_, _):
          echo "This is rectangle"

proc update(model: Model, event: Event): Model =
  match event:
    EncoderChanged(ecChanged, ecIncremented, ecShift):
      let increment = if ecIncremented: 1 else: -1
      let multiplier = if ecShift: 10 else: 1
      result = model + (ecChanged * increment * multiplier)

proc updateWorker() =
  foldp(update, 0)

var renderThread: Thread[void]
var updateThread: Thread[void]

# Device stuff
proc initDevice*(device: DevicePtr): void =
  gDevice = some(device)
  models.open()
  events.open()
  createThread(renderThread, doRender)
  createThread(updateThread, updateWorker)

proc buttonChanged*(device: DevicePtr, button: DeviceButton, state: bool, shift: bool): void =
  let white = newColor(255)
  let black = newColor(0)
  device.setButtonLed(button, if state: white
                                  else: black)

proc encoderChanged*(device: DevicePtr, encoder: int, increased: bool, shift: bool): void =
  events.send(EncoderChanged(encoder, increased, shift))

proc keyChanged*(device: DevicePtr, index: int, value: float64, shift: bool): void =
  device.setKeyLed(index, int(value * 0xff))

proc render*(): void = discard

proc controlChanged*(device: DevicePtr, pot: int, value: float64, shift: bool): void = discard
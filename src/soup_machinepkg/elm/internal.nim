import ../cabl
import patty
import options
import ../elm
import ../app as app


# Thread globals

var device: Option[DevicePtr] = none(DevicePtr)
var models: Channel[app.Model]
var messages: Channel[Message]
var commands: Channel[Cmd]
var renderThread: Thread[void]
var updateThread: Thread[void]
var commandsThread: Thread[void]

proc foldp(updateFn: proc(event: Message, model: app.Model): (app.Model, Cmd), initial: app.Model): void =
  models.send(initial)
  var model = initial
  var message = messages.recv()
  while true: # TODO: close channel to close loop
    let (newModel, cmd) = updateFn(message, model)
    commands.send(cmd)
    models.send(newModel)
    model = newModel
    message = messages.recv()


proc renderNode(d: DevicePtr, node: View, hOffset = 0): void =
  match node:
    Text(tText):
      d.textDisplay(0).putText(tText, 0)
      d.graphicDisplay(0).putText(10, hOffset, tText, newColor(0xff))
    Rectangle(_, children):
      let w = d.graphicDisplay(0).width()
      let h = d.graphicDisplay(0).height()
      d.graphicDisplay(0).rectangle(0, 0, w, h, newColor(0xff))
      for child in children:
        renderNode(d, child, 10)

proc renderWorker(): void =
  while true:
    let model: app.Model = models.recv()
    let node: View = app.view(model)
    device.map do (d: DevicePtr) -> void:
      d.graphicDisplay(0).black()
      renderNode(d, node)

proc updateWorker() =
  foldp(app.update, app.initial)

proc commandWorker() =
  while true:
    device.map do (d: DevicePtr) -> void:
      let cmd: Cmd = commands.recv()
      match cmd:
        SetButtonLed(btn, on):
          d.setButtonLed(btn, if on: newColor(255) else: newColor(0))
        SetKeyLed(index, value):
          d.setKeyLed(index, int(value * 0xff))
        CmdNone:
          discard

proc runApp*(dPtr: DevicePtr): void =
  device = some(dPtr)
  models.open()
  messages.open()
  commands.open()
  createThread(renderThread, renderWorker)
  createThread(updateThread, updateWorker)
  createThread(commandsThread, commandWorker)

proc submitMessage*(message: Message): void =
  messages.send(message)
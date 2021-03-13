import ../lib/cabl
import patty
import options
import ./io
import ../app as app
import ./state_updater
import ../domain


var thread: Thread[void]

proc renderNode(device: DevicePtr, node: View, hOffset = 0): void =
  match node:
    Text(tText):
      device.textDisplay(0).putText(tText, 0)
      device.graphicDisplay(0).putText(10, hOffset, tText, newColor(0xff))
    Rectangle(_, children):
      let w = device.graphicDisplay(0).width()
      let h = device.graphicDisplay(0).height()
      device.graphicDisplay(0).rectangle(0, 0, w, h, newColor(0xff))
      for child in children:
        renderNode(device, child, 10)

proc worker(): void =
  while true:
    let model: app.Model = models.recv()
    let node: View = app.view(model)
    optionIO.map do (io: IO) -> void:
      io.device.graphicDisplay(0).black()
      renderNode(io.device, node)

proc start*(): void =
  createThread(thread, worker)
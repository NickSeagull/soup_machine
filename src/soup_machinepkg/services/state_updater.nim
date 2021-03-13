import ../app as app
import ./command_dispatcher
import ../domain

var thread: Thread[void]
var models*: Channel[app.Model]
var messages*: Channel[Message]

proc foldp(updateFn: proc(event: Message, model: app.Model): (app.Model, Cmd), initial: app.Model): void =
  models.send(initial)
  var model = initial
  var message = messages.recv()
  while true: # TODO: close channel to close loop
    let (newModel, cmd) = updateFn(message, model)
    submitCommand(cmd)
    models.send(newModel)
    model = newModel
    message = messages.recv()


proc worker() =
  foldp(app.update, app.initial)

proc start*(): void =
  models.open()
  messages.open()
  createThread(thread, worker)

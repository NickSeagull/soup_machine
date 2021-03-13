import ../lib/cabl
import ./io as io
import ./command_dispatcher as CommandDispatcher
import ./state_updater as StateUpdater
import ./view_renderer as ViewRenderer
import ../domain


proc init*(dPtr: DevicePtr): void =
  io.init(dPtr)
  CommandDispatcher.start()
  StateUpdater.start()
  ViewRenderer.start()

proc submitMessage*(message: Message): void =
  StateUpdater.messages.send(message)
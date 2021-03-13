import options
import patty
import ./io
import ./sound
import ../lib/cabl
import ../domain

var thread: Thread[void]
var channel*: Channel[Cmd]

proc dispatch(io: IO, cmd: Cmd): void =
  match cmd:
    SetButtonLed(btn, on):
      io.device.setButtonLed(btn, if on: newColor(255) else: newColor(0))
    SetKeyLed(index, value):
      io.device.setKeyLed(index, int(value * 0xff))
    PlaySound:
      io.sound.playSound()
    CmdNone:
      discard

proc worker() =
  while true:
    optionIO.map do (io: IO) -> void:
      let cmd: Cmd = channel.recv()
      dispatch(io, cmd)

proc start*(): void =
  channel.open()
  createThread(thread, worker)

proc submitCommand*(cmd: Cmd): void =
  channel.send(cmd)
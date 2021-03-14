import options
import patty
import ./io
import ./sound
import ../lib/cabl
import ../domain
import os
from strformat import fmt

var thread: Thread[void]
var channel*: Channel[Cmd]

proc dispatch(io: IO, cmd: Cmd): void =
  match cmd:
    SetButtonLed(btn, on):
      io.device.setButtonLed(btn, if on: newColor(255) else: newColor(0))
    SetKeyLed(index, value):
      io.device.setKeyLed(index, int(value * 0xff))
    PlaySound(freq, volume):
      # io.sound.playSound()
      discard execShellCmd "oscsend localhost 5510 /noise/gate f 1"
      discard execShellCmd fmt"oscsend localhost 5510 /noise/gain f {$volume}"
      echo fmt"Running  oscsend localhost 5510 /noise/freq f {$freq}"
      discard execShellCmd fmt"oscsend localhost 5510 /noise/freq f {$freq}"
    MuteSound:
      discard execShellCmd "oscsend localhost 5510 /noise/gate f 0"
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
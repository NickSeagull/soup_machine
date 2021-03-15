import options
import patty
import ./io
import ../lib/cabl
import ../domain
import os
import nimosc

var thread: Thread[void]
var channel*: Channel[Cmd]

proc dispatch(io: IO, cmd: Cmd): void =
  match cmd:
    SetButtonLed(btn, on):
      io.device.setButtonLed(btn, if on: newColor(255) else: newColor(0))
    SetKeyLed(index, value):
      io.device.setKeyLed(index, int(value * 0xff))
    PlaySound(freq, volume):
      let client = io.osc
      client.send("/ding", freq.float32, volume.float32)
    MuteSound:
      discard execShellCmd "oscsend {ip} {port} /noise/gate f 0"
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
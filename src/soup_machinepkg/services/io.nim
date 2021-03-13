import ../lib/cabl
import ./sound as sound
import options

type IO* = object
  device*: DevicePtr
  sound*: SoundService

var optionIO*: Option[IO] = none(IO)

proc init*(devicePtr: DevicePtr): void =
  let soundService = sound.init()
  optionIO = IO(
    device: devicePtr,
    sound: soundService
  ).some
import ../lib/cabl
import options
import nimosc as OSC

const ip = "192.168.86.34"
const port = 7771

type Client* = typeof (newClient(ip, port))

type IO* = object
  device*: DevicePtr
  osc*: Client

var optionIO*: Option[IO] = none(IO)

proc init*(devicePtr: DevicePtr): void =
  let oscClient = newClient(ip, port)
  optionIO = IO(
    device: devicePtr,
    osc: oscClient
  ).some
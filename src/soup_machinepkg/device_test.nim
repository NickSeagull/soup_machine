from strformat import fmt
import patty
import options
import ./cabl
import ./elm/internal
import ./elm


let white = newColor(0xff)


# Device stuff
proc initDevice*(device: DevicePtr): void =
  runApp(device)

proc buttonChanged*(device: DevicePtr, button: DeviceButton, state: bool, shift: bool): void =
  # let white = newColor(255)
  # let black = newColor(0)
  # device.setButtonLed(button, if state: white
  #                                 else: black)
  submitMessage(ButtonChanged(button, state, shift))

proc encoderChanged*(device: DevicePtr, encoder: int, increased: bool, shift: bool): void =
  submitMessage(EncoderChanged(encoder, increased, shift))

proc keyChanged*(device: DevicePtr, index: int, value: float64, shift: bool): void =
  # device.setKeyLed(index, int(value * 0xff))
  submitMessage(KeyChanged(index, value, shift))

# These down here aren't used by the Maschine MK1
proc render*(): void = discard
proc controlChanged*(device: DevicePtr, pot: int, value: float64, shift: bool): void = discard
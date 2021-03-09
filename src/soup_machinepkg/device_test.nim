import ./cabl
from strformat import fmt

proc initDevice*(): void =
  echo "Init Device"

proc render*(): void =
  echo "Render"

proc buttonChanged*(device: DevicePtr, button: DeviceButton, state: bool, shift: bool): void =
  let white = newColor(255)
  let black = newColor(0)
  device.setButtonLed(button, if state: white
                                  else: black)

proc encoderChanged*(device: DevicePtr, encoder: int, increased: bool, shift: bool): void =
  let incMsg = if increased: "increased" else: "decreased"
  let white = newColor(0xff)
  let value = fmt"Encoder {$encoder} {incMsg}"
  device.textDisplay(0).putText(value, 0)
  device.graphicDisplay(0).black()
  device.graphicDisplay(0).putText(10, 10, value, white)

proc keyChanged*(device: DevicePtr, index: int, value: float64, shift: bool): void =
  device.setKeyLed(index, int(value * 0xff))

proc controlChanged*(device: DevicePtr, pot: int, value: float64, shift: bool): void =
  echo "Control changed"
import ./cabl

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
  echo "Encoder changed"

proc keyChanged*(device: DevicePtr, index: int, value: float64, shift: bool): void =
  device.setKeyLed(index, int(value * 0xff))

proc controlChanged*(device: DevicePtr, pot: int, value: float64, shift: bool): void =
  echo "Control changed"
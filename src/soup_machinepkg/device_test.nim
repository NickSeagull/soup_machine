import ./cabl

proc initDevice*(): void =
  echo "Init Device"

proc render*(): void =
  echo "Render"

proc buttonChanged*(device: DevicePtr, button: DeviceButton, state: bool, shift: bool): void =
  echo "Button changed"

proc encoderChanged*(device: DevicePtr, encoder: int, increased: bool, shift: bool): void =
  echo "Encoder changed"

proc keyChanged*(device: DevicePtr, index: int, value: float64, shift: bool): void =
  echo "Key changed"

proc controlChanged*(device: DevicePtr, index: int, value: float64, shift: bool): void =
  echo "Control changed"
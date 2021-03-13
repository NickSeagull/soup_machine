import patty
import ./lib/cabl

variantp View:
  Rectangle(rFilled: bool, rChildren: seq[View])
  Text(tText: string)

variantp Message:
  EncoderChanged(ecEncoder: int, ecIncreased: bool, ecShift: bool)
  KeyPressed(kpIndex: int, kpValue: float64, kpShift: bool)
  KeyReleased(krIndex: int, krShift: bool)
  KeyChanged(kcIndex: int, kcValue: float64, kcShift: bool)
  ButtonChanged(bcIndex: DeviceButton, bcPressed: bool, bcShift: bool)

variantp Cmd:
  SetButtonLed(sblButton: DeviceButton, on: bool)
  SetKeyLed(sklIndex: int, sklValue: float64)
  PlaySound
  CmdNone

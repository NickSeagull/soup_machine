import patty
import ./cabl

variantp Message:
  EncoderChanged(ecEncoder: int, ecIncreased: bool, ecShift: bool)
  KeyChanged(kcIndex: int, kcValue: float64, kcShift: bool)
  ButtonChanged(bcIndex: DeviceButton, bcPressed: bool, bcShift: bool)

variantp Cmd:
  SetButtonLed(sblButton: DeviceButton, on: bool)
  SetKeyLed(sklIndex: int, sklValue: float64)
  PlaySound
  CmdNone

variantp View:
  Rectangle(rFilled: bool, rChildren: seq[View])
  Text(tText: string)
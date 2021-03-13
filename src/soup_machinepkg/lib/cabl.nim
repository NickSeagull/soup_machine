############################################################
#                                                          #
#  You're looking at some FFI wrappers for the cabl        #
#  library.                                                #
#                                                          #
############################################################
const cabl_h = "<cabl/cabl.h>"



type DeviceButton* {.header: cabl_h, importcpp: "sl::cabl::Device::Button".} = object


# Color
type Color* {.header: cabl_h, importcpp: "sl::cabl::Color".} = object


proc newColor*(mono: uint8): Color {.header: cabl_h, importcpp: "sl::cabl::Color(@)".}

proc newColor*(red: uint8, green: uint8, blue: uint8): Color {.header: cabl_h, importcpp: "sl::cabl::Color(@)".}

proc newColor*(red: uint8, green: uint8, blue: uint8, mono: uint8): Color {.header: cabl_h, importcpp: "sl::cabl::Color(@)".}


# Text Display
type TextDisplayObj* {.header: cabl_h, importcpp: "sl::cabl::TextDisplay".} = object

type TextDisplay* = ptr TextDisplayObj

proc c_putText(this: TextDisplay, str: cstring, row: uint): void {.importcpp: "#->putText(@)".}

proc putText*(this: TextDisplay, str: string, row: int): void =
  c_putText(this, str.cstring, row.uint)


# Canvas
type CanvasObj* {.header: cabl_h, importcpp: "sl::cabl::Canvas".} = object

type Canvas* = ptr CanvasObj


proc black*(this: Canvas): void {.importcpp: "#->black()".}
proc c_putText(this: Canvas, x: uint, y: uint, str: cstring, color: Color): void {.importcpp: "#->putText(@)".}

proc putText*(this: Canvas, x: int, y:int, str: string, color: Color): void =
  c_putText(this, x.uint, y.uint, str.cstring, color)

proc width*(this: Canvas): uint {.importcpp: "#->width()".}
proc height*(this: Canvas): uint {.importcpp: "#->height()".}
proc rectangle*(this: Canvas, x: uint, y: uint, w: uint, h: uint, color: Color): void {.importcpp: "#->rectangle(@)".}


# DevicePtr
type DevicePtr* {.header: cabl_h, importcpp: "sl::cabl::Coordinator::tDevicePtr".} = object


proc c_setKeyLed(this: DevicePtr, index: uint, value: uint8): cint {.importcpp: "#->setKeyLed(@)".}

proc setKeyLed*(this: DevicePtr, index: int, value: int): void =
  discard c_setKeyLed(this, index.uint, value.uint8)


proc setButtonLed*(this: DevicePtr, button: DeviceButton, color: Color): void {.importcpp: "#->setButtonLed(@)".}


proc textDisplay*(this: DevicePtr, index: int): TextDisplay {.importcpp: "#->textDisplay(@)".}


proc graphicDisplay*(this: DevicePtr, index: int): Canvas {.importcpp: "#->graphicDisplay(@)".}
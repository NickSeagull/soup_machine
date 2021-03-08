const cabl_h = "<cabl/cabl.h>"



type DeviceButton* {.header: cabl_h, importcpp: "sl::cabl::Device::Button".} = object


type Color* {.header: cabl_h, importcpp: "sl::cabl::Color".} = object


proc newColor*(mono: uint8): Color {.header: cabl_h, importcpp: "sl::cabl::Color(@)".}

proc newColor*(red: uint8, green: uint8, blue: uint8): Color {.header: cabl_h, importcpp: "sl::cabl::Color(@)".}

proc newColor*(red: uint8, green: uint8, blue: uint8, mono: uint8): Color {.header: cabl_h, importcpp: "sl::cabl::Color(@)".}


type DevicePtr* {.header: cabl_h, importcpp: "sl::cabl::Coordinator::tDevicePtr".} = object


proc c_setKeyLed(this: DevicePtr, index: uint, value: uint8): cint {.importcpp: "#->setKeyLed(@)".}


proc setKeyLed*(this: DevicePtr, index: int, value: int): void =
  discard c_setKeyLed(this, index.uint, value.uint8)


proc setButtonLed*(this: DevicePtr, button: DeviceButton, color: Color): void {.importcpp: "#->setButtonLed(@)".}
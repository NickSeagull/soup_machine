const cabl = "cabl/cabl.h"

type DeviceButton* {.header: cabl,
  importcpp: "sl::Device::Button".} = object


############################################################
#                                                          #
# Device operations                                        #
#                                                          #
############################################################
type DevicePtr* {.importcpp: "sl::Coordinator::tDevicePtr".} = object

proc c_setKeyLed(this: DevicePtr, index: uint, value: uint8): cint {.importcpp: "#->setKeyLed(@)".}

proc setKeyLed*(this: DevicePtr, index: int, value: int): void =
  discard c_setKeyLed(this, index.uint, value.uint8)
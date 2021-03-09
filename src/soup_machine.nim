import ./soup_machinepkg/device_test as dt
import ./soup_machinepkg/cabl

############################################################
#                                                          #
#  Client definition for Cabl                              #
#                                                          #
############################################################
{.emit: """
#include <thread>
#include <future>
#include <cstdint>
#include <cstdio>
#include <cmath>
#include <algorithm>
#include <sstream>
#include <cabl/cabl.h>
#include <cabl/gfx/TextDisplay.h>

namespace sl
{
using namespace cabl;
class DeviceTest : public Client
{
public:

  void initDevice() override;
  void render() override;
  void buttonChanged(Device::Button button_, bool buttonState_, bool shiftState_) override;
  void encoderChanged(unsigned encoder_, bool valueIncreased_, bool shiftPressed_) override;
  void keyChanged(unsigned index_, double value_, bool shiftPressed) override;
  void controlChanged(unsigned pot_, double value_, bool shiftPressed) override;
};
} // namespace sl
using namespace sl::cabl;
""".}

############################################################
#                                                          #
# FFI types and functions                                  #
#                                                          #
############################################################
type DeviceTest* {.importcpp: "sl::DeviceTest".} = object
proc newDeviceTest*: ptr DeviceTest {.importcpp: "new sl::DeviceTest".}
proc thisThreadYield*: void {.importcpp: "std::this_thread::yield()".}


############################################################
#                                                          #
#  Nim callbacks that cast C types                         #
#                                                          #
############################################################
proc nimInitDevice(): cint {.exportc.} =
  dt.initDevice()

proc nimRender(): cint {.exportc.} =
  dt.render()

proc nimButtonChanged(device: DevicePtr, button: DeviceButton, buttonState: bool, shiftState: bool): cint {.exportc.} =
  dt.buttonChanged(device, button, buttonState, shiftState)

proc nimEncoderChanged(device: DevicePtr, encoder: cint, valueIncreased: bool, shiftPressed: bool): cint {.exportc.} =
  dt.encoderChanged(device, encoder.int, valueIncreased, shiftPressed)

proc nimKeyChanged(device: DevicePtr, index: uint, value: cdouble, shiftPressed: bool): void {.exportc.} =
  dt.keyChanged(device, index.int, value.float64, shiftPressed)

proc nimControlChanged(device: DevicePtr, pot: cint, value: cdouble, shiftPressed: bool): cint {.exportc.} =
  dt.controlChanged(device, pot.int, value.float64, shiftPressed)

############################################################
#                                                          #
# Implementation of the Client class (calls Nim functions) #
#                                                          #
############################################################
{.emit: """
void sl::DeviceTest::initDevice() { ::nimInitDevice(); }

void sl::DeviceTest::render() { ::nimRender(); }

void sl::DeviceTest::buttonChanged(Device::Button button_, bool buttonState_, bool shiftState_) { ::nimButtonChanged(device(), button_, buttonState_, shiftState_); }

void sl::DeviceTest::encoderChanged(unsigned encoder_, bool valueIncreased_, bool shiftPressed_) { ::nimEncoderChanged(device(), encoder_, valueIncreased_, shiftPressed_); }

void sl::DeviceTest::keyChanged(unsigned index_, double value_, bool shiftPressed_) { ::nimKeyChanged(device(), index_, value_, shiftPressed_); }

void sl::DeviceTest::controlChanged(unsigned pot_, double value_, bool shiftPressed_) { ::nimControlChanged(device(), pot_, value_, shiftPressed_); }
""".}

############################################################
#                                                          #
# Main loop                                                #
#                                                          #
############################################################
when isMainModule:
  let _: ptr DeviceTest = newDeviceTest()
  while true:
    thisThreadYield()

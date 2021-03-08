# Main wrapper that interfaces with Cabl, start looking
# inside of soup_machinepkg/device_test

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

type DeviceButton* {.importcpp: "sl::Device::Button".} = object
type Device* {.importcpp: "sl::Device".} = object

proc toDeviceTest(x: pointer): DeviceTest {.importcpp: "((sl::DeviceTest *) @)".}
proc device(this: DeviceTest): Device {.importcpp: "#->device(@)".}
proc setKeyLed(this: Device, index: cint, value: cdouble): cint {.importcpp: "setKeyLed".}

############################################################
#                                                          #
#  Nim callbacks that cast C types                         #
#                                                          #
############################################################
proc nimInitDevice(): cint {.exportc.} =
  echo "Init Device"

proc nimRender(): cint {.exportc.} =
  echo "Render"


proc nimButtonChanged(button: DeviceButton, buttonState: bool, shiftState: bool): cint {.exportc.} =
  echo "Button Changed"

proc nimEncoderChanged(encoder: cint, valueIncreased: bool, shiftPressed: bool): cint {.exportc.} =
  echo "encoder Changed"


proc nimKeyChanged(this: pointer, index: cint, value: cdouble, shiftPressed: bool): void {.exportc.} =
  echo "key Changed"
  # discard this.toDeviceTest.device().setKeyLed(index, value * 0xff)

proc nimControlChanged(pot: cint, value: cdouble, shiftPressed: bool): cint {.exportc.} =
  echo "control Changed"

############################################################
#                                                          #
# Implementation of the Client class (calls Nim functions) #
#                                                          #
############################################################
{.emit: """
void sl::DeviceTest::initDevice() { ::nimInitDevice(); }

void sl::DeviceTest::render() { ::nimRender(); }

void sl::DeviceTest::buttonChanged(Device::Button button_, bool buttonState_, bool shiftState_) { ::nimButtonChanged(button_, buttonState_, shiftState_); }

void sl::DeviceTest::encoderChanged(unsigned encoder_, bool valueIncreased_, bool shiftPressed_) { ::nimEncoderChanged(encoder_, valueIncreased_, shiftPressed_); }

void sl::DeviceTest::keyChanged(unsigned index_, double value_, bool shiftPressed_) { ::nimKeyChanged(this, index_, value_, shiftPressed_); }

void sl::DeviceTest::controlChanged(unsigned pot_, double value_, bool shiftPressed_) { ::nimControlChanged(pot_, value_, shiftPressed_); }
""".}

############################################################
#                                                          #
# Main loop                                                #
#                                                          #
############################################################
when isMainModule:
  let _: ptr DeviceTest = newDeviceTest()
  echo("Type q then enter to quit")
  while stdin.readLine != "q":
    thisThreadYield()

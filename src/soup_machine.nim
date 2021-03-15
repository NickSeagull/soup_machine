############################################################
#                                                          #
#  This is some initialization code that wires up Nim      #
#  with Cabl, the library for connecting to the Maschine   #
#                                                          #
#  For the implementation, you should probably start       #
#  looking at soup_machinepkg/app.nim                      #
#                                                          #
############################################################

# import ./soup_machinepkg/device_test as dt
import ./soup_machinepkg/lib/cabl
import ./soup_machinepkg/services/reactive_manager as ReactiveManager
import ./soup_machinepkg/domain

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
proc thisThreadYield*: void {.importcpp: "std::this_thread::yield()".}


############################################################
#                                                          #
#  Nim callbacks that cast C types                         #
#                                                          #
############################################################
proc nimInitDevice(device: DevicePtr): cint {.exportc.} =
  ReactiveManager.init(device)

proc nimRender(): cint {.exportc.} =
  discard  # This is not used in the maschine mk1

proc nimButtonChanged(device: DevicePtr, button: DeviceButton, buttonState: bool, shiftState: bool): cint {.exportc.} =
  ReactiveManager.submitMessage(ButtonChanged(button, buttonState, shiftState))

proc nimEncoderChanged(device: DevicePtr, encoder: cint, valueIncreased: bool, shiftPressed: bool): cint {.exportc.} =
  ReactiveManager.submitMessage(EncoderChanged(encoder, valueIncreased, shiftPressed))

var pressedKeys: set[uint8] = {}

proc nimKeyChanged(device: DevicePtr, index: uint, value: cdouble, shiftPressed: bool): void {.exportc.} =
  if value <= 0.1:
    pressedKeys.excl(index.uint8)
    ReactiveManager.submitMessage(KeyReleased(index.int, shiftPressed))
    return
  if pressedKeys.contains(index.uint8):
    ReactiveManager.submitMessage(KeyChanged(index.int, value, shiftPressed))
  else:
    pressedKeys.incl(index.uint8)
    ReactiveManager.submitMessage(KeyPressed(index.int, value, shiftPressed))

proc nimControlChanged(device: DevicePtr, pot: cint, value: cdouble, shiftPressed: bool): cint {.exportc.} =
  discard  # This is not used in the maschine mk1

############################################################
#                                                          #
# Implementation of the Client class (calls Nim functions) #
#                                                          #
############################################################
{.emit: """
void sl::DeviceTest::initDevice() { ::nimInitDevice(device()); }

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
  {.emit: "sl::DeviceTest dt;".}
  while stdin.readLine() != "q":
    thisThreadYield()

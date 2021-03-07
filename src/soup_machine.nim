# This is just an example to get you started. A typical hybrid package
# uses this file as the main entry point of the application.

{.emit: """
#include <future>
#include <cstdint>

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
""".}

proc initDevice(): cint {.exportc.} =
  echo "Init Device"

proc render(): cint {.exportc.} =
  echo "Render"

proc buttonChanged(): cint {.exportc.} =
  echo "Button Changed"

proc encoderChanged(): cint {.exportc.} =
  echo "encoder Changed"

proc keyChanged(): cint {.exportc.} =
  echo "key Changed"

proc controlChanged(): cint {.exportc.} =
  echo "control Changed"

{.emit: """
void sl::DeviceTest::initDevice() { ::initDevice(); }
void sl::DeviceTest::render() { ::render(); }
void sl::DeviceTest::buttonChanged(Device::Button button_, bool buttonState_, bool shiftState_) { ::buttonChanged(); }
void sl::DeviceTest::encoderChanged(unsigned encoder_, bool valueIncreased_, bool shiftPressed_) { ::encoderChanged(); }
void sl::DeviceTest::keyChanged(unsigned index_, double value_, bool shiftPressed) { ::keyChanged(); }
void sl::DeviceTest::controlChanged(unsigned pot_, double value_, bool shiftPressed) { ::controlChanged(); }
""".}

when isMainModule:
  echo("hi")

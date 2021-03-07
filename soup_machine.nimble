# Package

version       = "0.1.0"
author        = "Nikita Tchayka"
description   = "Software for Soup Machine"
license       = "Apache-2.0"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["soup_machine"]


# Dependencies

requires "nim >= 1.4.4"
requires "nimline >= 0.1.7"
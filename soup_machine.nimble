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

task memcheck, "Memory check with Valgrind":
  exec "sudo valgrind --tool=memcheck --leak-check=yes --show-reachable=yes --num-callers=20 --track-fds=yes --track-origins=yes --suppressions=valgrind/minimal.supp --log-file=valgrind/log.txt nimble run soup_machine"

task start, "Start soup machine":
  exec "nimble build && sudo ./soup_machine"
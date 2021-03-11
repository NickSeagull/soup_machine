<div align="center">
  <img src="./assets/banner.png"></img>
</div>

---

Soup Machine is a _**work-in-progress**_ project to create a hardware
[Digital Audio Workstation](https://en.wikipedia.org/wiki/Digital_audio_workstation),
similar to the
[Teenage Engineering OP-1](https://en.wikipedia.org/wiki/Teenage_Engineering_OP-1).

As the hardware used, a
[Maschine (the first version a.k.a. MK1)](https://en.wikipedia.org/wiki/Maschine),
is hooked into a [Raspberry Pi v3](https://en.wikipedia.org/wiki/Raspberry_Pi),
which acts as the computer for the software DAW.

![demo](https://user-images.githubusercontent.com/7448243/110777458-0b680a00-8259-11eb-8a98-f24ce719608f.gif)

> As you can see, its in very early state 😅

# Development Setup

1. Install Raspbian Lite on the Raspberry Pi
2. Install the required libraries and software
   ```shell
   sudo apt-get install libusb-1.0-0-dev libhidapi-dev librtmidi-dev
   sudo apt -y install build-essential openssl curl
   ```
3. Install the [Cabl library](https://github.com/shaduzlabs/cabl/tree/develop) from source
   ```shell
   # Get source
   git clone https://github.com/shaduzlabs/cabl.git
   cd cabl
   git checkout -b develop && git pull origin develop
   git submodule update --init --recursive
   mkdir build && cd build
   # Build and install
   cmake ..
   make
   sudo make install
   ```
4. Install Nim (make sure you download the latest version)
   ```shell
   # Get Nim sources
   cd ~
   mkdir tmp
   cd tmp
   curl https://nim-lang.org/download/nim-VERSION.tar.xz -O
   tar -xJvf nim-VERSION.tar.xz
   cd nim-VERSION

   # Build Nim
   ./build.sh

   # Build Nim tooling
   ./bin/nim c koch
   ./koch tools
   ./kock nimble

   # Install Nim
   sh ./install.sh $HOME/.nimble
   cp ./bin/* $HOME/.nimble/nim/bin/

   # Add to path
   export PATH="${PATH}":$HOME/.nimble/nim/bin:$HOME/.nimble/bin

   # Upgrade nimble
   nimble refresh -y
   nimble install -y nimble
   mv $HOME/.nimble/nim/bin/nimble $HOME/.nimble/nim/bin/nimble-orig
   ```

5. If you want to do memory checks with Valgrind, make sure you
   install it from sources, as Raspbian comes with a buggy one:

   ```shell
   sudo apt install autotools-dev automake
   git clone git://sourceware.org/git/valgrind.git
   cd valgrind
   ./autogen.sh
   ./configure
   make
   sudo make install
   ```

# Common Tasks

* To compile and build, run `nimble start`
* To perform a memory check, run `nimble memcheck`
  * Logs will be saved to `./valgrind/log.txt`

# Road map

- [x] Use Cabl from Nim
- [ ] Elm-ish API
  - [ ] Controls create events
  - [ ] Declarative view
  - [ ] Cmd-style actions like sound and lights
- [ ] Musical keyboard with pads
- [ ] Drum sampler

As an inspiration, use the [OP-1 user manual](https://teenage.engineering/guides/op-1) and the [OP-1 explainer playlist on YouTube](https://www.youtube.com/playlist?list=PLcaEIjiwaCmS4RmJKZkLRIngREV8o_BCz)

# Attributions

> Icons made by <a href="https://www.freepik.com" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a>

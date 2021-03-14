thisProcess.openUDPPort(7771);
n = NetAddr.new("0.0.0.0", 7771);    // create the NetAddr
// o = OSCFunc({|...msg| msg.postln}, '/trigger', n); // this will post the message whenever it gets a trigger
OSCFunc.trace(false);
o.free;    // remove the OSCFunc when you are done.

// Cool way of defining SynthDefs for OSC
(
OSCdef(\dinger,
    {
    // a simple function that triggers an envelope
        {Pulse.ar(1000,rrand(0.01,0.5),0.3)!2 * EnvGen.ar(Env.perc,doneAction:2)}.play
}, '/ding')
)
declare options "[osc:on]";
import("stdfaust.lib");
process = g * a * os.oscrs(f*b) <: _,_;
a = hslider("gain",1,0,1,0.001);
f = hslider("freq",392.0,200.0,2000.0,0.01);
b = ba.semi2ratio(hslider("bend",0,-2,2,0.001));
g = button("gate");

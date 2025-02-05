Basic elements of the Server architecture:

Unit Generators -  UGen
	Unit Generators are the building blocks used for sound generation within the server framework.
In the language, they are represented with UGen classes.

SynthDefs - SynthDef
	SynthDefs specify different interconnections of Unit Generators that actually produce sound.
In the language, the are represented with SynthDef objects.  Instances of the UGen classes represent
the different Unit Generators used by the SynthDef.

Synths - Synth
	Synths are instances of SynthDefs that actually produce sound on the server.  In the language,
Synth objects are often used to represent those synths.

Groups
	these are used to group together Synths and to establish the order in which they run
Sound generating synths generally need to run before sound processing synths and
the

Buses - Bus
	Buses are used for Synths to move sound to and from the outside world and other Synths
	there are Input Buses, Output Buses and Internal Buses.  Buses are identified by a numerical
	index that begins at 0.  Output Buses come first, followed by Input Buses, followed by Internal
	buses.  For a stereo configuration it would
		0, 1 - output buses
		2, 3 - input buses
		4...  - internal buses
NOTE: SoundIn manages this offset automatically,  so SoundIn.ar(0) is always the first channel of
audio input, no matter how many output buses are in use.
NOTE: For reasons of efficiency, sound is computed in small array of samples.  The size of that array
is set by the Server 'blockSize' parameter which defaults to 64. Each Audio bus is  a set of blockSize
memory locations to which different Synths can add their samples.
"Control rate" UGens compute one sample per block while audio rate compute the entire block.
Control rate buses are a single memory location.

Buffers - Buffer
	Buffers are used to store sound files, waveforms and other data used in producing sound

-------------------------------------------------------------------------------------------------------------------------------
NodeProxy is an organizing tool for sound production that iprovides access to the features of the Server
architecture while insulating us from many of the details.

Creating a NodeProxy involves specifying what server it runs on,  the how many channels  it uses and whether its synths run at audio or control rate:

NodeProxy.audio(server, numChannels)
NodeProxy.control(server, numChannels)

For the time being, we will limit our attention to audio NodeProxy's.

Here is a line that creates a stereo NodeProxy on the default server and assigns it to the variable n.

n = NodeProxy.audio(s, 2);  // audio rate NP runing on the default server with two internal channels

To hear the NodeProxy, we must connect its internal bus to audio output buses.
The simplest way to do this is with the 'play' message,

play(out: 0 );

Synths are inserted into the NodeProxy with the put mesage
put(index, obj, channelOffset, extraArgs)

They can also be inserted using the square bracket syntax of Array.

Here is an example;
(
n = NodeProxy.audio(s, 2);  // audio rate NP runing on the default server with two internal channels
n.fadeTime = 4;
n.play;
n.put(0, { SinOsc.ar([3000, 3100]) * LFTri.kr(0.1, 1).range(-60, -30).dbamp });
n.put(1, { SinOsc.ar([3030, 3060]) * LFTri.kr(0.23, 1).range(-60, -30).dbamp });

n[0] = { LFPulse.ar([30, 30.2]) * 0.02 };

n[0] = { LFPulse.ar((0, 0.2 ..10) + 30) * 0.02 };
n[0] = { LFPulse.ar((0, 0.2 ..10) + 30, {3.0.rand}.dup(50), 0.1) * 0.02 };
n[0] = { LFPulse.ar((0, 0.2 ..10) + 30, {3.0.rand}.dup(50), 0.01) * 0.02 };
n[0] = { LFPulse.ar((0, 0.2 ..10) + 30, {3.0.rand}.dup(50), 0.001) * 0.02 };
n[0] = { LFPulse.ar((0, 0.2 ..10) + 30, {3.0.rand}.dup(50), LFNoise1.kr(0.1.dup(5)).exprange(0.001, 0.5)) * 0.02 };
n.source = nil;
)

One of the really useful features of NodeProxy is that you can replace one synthesis function by another:

n[0] = { LFTri.ar([200, 200.1]) * 0.2 };

And the truly magical feature is that you can set a fadeTime to have transitions occur as a crossfade.
n.fadeTime = 10;
n[0] = { LFTri.ar([230, 240.1]) * 0.2 };

And yet another great feature is that it will "wrap" extra channels of output so that they remain audible:
n[0] = { LFTri.ar([230, 240.1, 255, 190]) * 0.2 };

n[0] = { LFTri.ar([230, 240.1, 255, 190]) * 0.2 * LFPulse.ar([4,5,6,7]/10).lag(0.1) };

n.source = { var a = SinOsc.ar(LFTri.kr(1/100).range(50, 1600)) * 0.05;
	a = CombC.ar(a, 0.01,0.01, 4);
	Limiter.ar(a, 0.01)
}

A SHORT BREAK TO TRY SOME STUFF OUT WITH NODEPROXY


 while the 'playN' message allows
internal buses to be routed to any combination of output channels.
playN(outs, amps, ins, vol, fadeTime, group, addAction)

n.playN(outs: [0,1]);  			// playN allows you to define what channels of the NodeProxy are heard on which speakers

n.put(2, {PinkNoise.ar(0.1)},1)
n.playN([0,1])
n[0] = { SinOsc.ar * 0.1 }

n.playN([0,[0,1]]);

A NodePro
	Using it, we can focus our attenion on UGens and largely ignore the intricacies of buses,  groups and even synthdefs.

A NodeProxy can run at either audio rate or control rate.  For now, we will focus on control rate.



New synths can be added t

which can then

be played to audio output buses

A NodeProxy is a bit like a mixer

Array and Order

at, put
[] and [] =

Buses

a = [33, 55, 6];

a.at(0)
a[0];
a[2];
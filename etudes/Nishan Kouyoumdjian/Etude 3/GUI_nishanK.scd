s.boot;

//Synth
SynthDef.new(\modSynth, {
	arg freq = 440, amp = 0.5, attack = 0.01, release = 5.0;
	var env, osc;

	env = EnvGen.kr(Env.perc(attack, release), doneAction: 2);
	osc = SinOsc.ar(freq, 0, amp) * env;

	Out.ar(0, osc.dup);
}).add;

//GUI
(
var win, freqSlider, ampSlider, attackSlider, releaseSlider, playButton;

win = Window("Mod Synth", Rect(100, 100, 300, 200)).front;

freqSlider = Slider(win, Rect(10, 10, 280, 20))
.value_(440/1000)
.action_({
	|s|
	~freq = s.value * 1000;
});

ampSlider = Slider(win, Rect(10, 40, 280, 20))
.value_(0.5)
.action_({
	|s|
	~amp = s.value;
});

attackSlider = Slider(win, Rect(10, 70, 280, 20))
.value_(0.01)
.action_({
	|s|
	~attack = s.value * 2;
});

releaseSlider = Slider(win, Rect(10, 100, 280, 20))
.value_(5.0)
.action_({
	|s|
	~release = s.value * 4;
});

playButton = Button(win, Rect(10, 130, 280, 30))
.states_([["Play", Color.black, Color.green]])
.action_({
	Synth(\modSynth, [
		\freq, ~freq,
		\amp, ~amp,
		\attack, ~attack,
		\release, ~release
	]);
});
)



s.boot; //boots the server

// where did I leave my keys?
(
var n = 20, m = 10; //two local variables within this block, n and m

Ndef.clear(2); //stops sound by clearing node index 2

Ndef.ar(\x, n); //creates a node called x with source n

Ndef(\y, { Splay.ar(Ndef.ar(\x, m, LFNoise1.kr(1/m).range(0, n - m - 1))).clip2 * 0.5 }).play; //creates a node that takes the modulated output of node \x, spatializes it into stereo, clips it, reduces the amplitude, and plays it

Ndef(\x, { //create new node for synth identified by \x

	var env = Env([0, 1, 1, 0], [0.1, 2.0, 1], 'lin'); //define the envelope

	var envGen = EnvGen.kr(env, doneAction: 2); //generate envelope and apply to the sound

	{
		var a = Ndef.ar(\x, 1, LFNoise0.kr(Rand()) * Rand() + Rand() * n); //local variable, a, stores the output of the modulated, randomized node \x

		(a + 0.3 * SinOsc.ar(ExpRand(0.1, 600))) * envGen //a sine wave with a random frequency from 0.1-600hz is reduced in amplitude and summed with the existing signal, a

	} ! n //creates n parallel instances of the resulting signal, each uniquely random
});
)

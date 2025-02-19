s.boot;

//Synth
SynthDef.new(\modSynth, {
	arg freq = 440, amp = 0.5, attack = 0.01, release = 1.0;
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
.value_(1.0)
.action_({
	|s|
	~release = s.value * 5;
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
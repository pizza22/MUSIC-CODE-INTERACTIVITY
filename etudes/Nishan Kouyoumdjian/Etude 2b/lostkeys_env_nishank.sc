s.boot; //boots the server lol

// where did I leave my keys?
(
var n = 20, m = 10; //two local variables within this block, n and m
Ndef.clear(2); //stops sound by clearing node index 2
Ndef.ar(\x, n); //creates a node associated with \x with source n
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

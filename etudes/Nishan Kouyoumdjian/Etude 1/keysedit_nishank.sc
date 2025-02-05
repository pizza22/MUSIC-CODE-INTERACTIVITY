s.boot;

// where did I leave my keys?
(
var n = 20, m = 10;
Ndef.clear(2);
Ndef.ar(\x, n);
Ndef(\y, { Splay.ar(Ndef.ar(\x, m, LFNoise1.kr(1/m).range(0, n - m - 1))).clip2 * 0.5 }).play;
Ndef(\x, {
	{
		var a = Ndef.ar(\x, 1, LFNoise0.kr(Rand()) * Rand() + Rand() * n);
		a + 0.3 * SinOsc.ar(ExpRand(0.1, 600))
	} ! n
});
)

// where did I put my keys?
(
var n = 30, m = 5;
Ndef.clear(3);
Ndef.ar(\x, n);
Ndef(\y, { Splay.ar(Ndef.ar(\x, m, LFNoise1.kr(1/m).range(0.1, n - m - 1))).clip2 * 1 }).play;
Ndef(\x, {
	{
		var a = Ndef.ar(\x, 1, LFNoise0.kr(Rand()) * Rand() + Rand() * n);
		SinOsc.ar(ExpRand(0.2, 880), a)
	} ! n
});
)
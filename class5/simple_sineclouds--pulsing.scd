(
SynthDef(\randomSineShiver, {
    arg freq = 440, rhy = 0.4, amp = 0.1, pan = 0;
    var sig, puls;
    puls = LFTri.kr(rhy).range(0, 1);  // Changed to use .range for smoother modulation
    sig = SinOsc.ar(freq) * puls * amp;
    Out.ar(0, Pan2.ar(sig, pan));
}).add;

~numOscs = 20;
~freqRange = [20, 16000]; // Minimum and maximum frequency in Hz
~pulsRange = [0.4, 10.0]; // Adjusted minimum to allow for slower modulations

~pulsingSines = Array.fill(~numOscs, {
    var freq = exprand(~freqRange[0], ~freqRange[1]);
    var rhy = exprand(~pulsRange[0], ~pulsRange[1]);  // Changed to exprand for more natural distribution
    var pan = rrand(-1.0, 1.0);
    Synth(\randomSineShiver, [
        \freq, freq,
		\rhy, rhy,
        \amp, 0.5 / ~numOscs,  // Adjusted amplitude calculation
        \pan, pan
    ]);
});
)


// To stop all synths:
 ~sines.do(_.free);

{v = SinOsc.ar(440, 1.0, LFTri.ar(1, 0, 0.25, 0.75))}.scope;






{
     a = MouseX.kr(0, 30);
     c = MouseY.kr(200, 2000);
     d = SinOsc.ar(a, 0);
     x = SinOsc.ar(c, 0, d)!2;
}.play
 
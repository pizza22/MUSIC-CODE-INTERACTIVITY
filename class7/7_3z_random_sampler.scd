//first, run this, it sets up the directory inside whatever this file is saved inside.
(
~dirpath = "piano and accordian/*".resolveRelative;
~filepaths = ~dirpath.pathMatch;
~buffers = ~filepaths.collect { |path| Buffer.read(s, path) };
~np = NodeProxy.audio(s, 2).play;
~np.clear;
)

// Define the slow section
~slow = {
    "Playing slow section...".postln;
    50.do { |i|
        var buf = ~buffers.choose;
        ~np.add({
            Pan2.ar(
                PlayBuf.ar(buf.numChannels, buf.bufnum,
                    rate: (1..12).choose.midiratio,
                    doneAction: 2) * rrand(-40, 0).dbamp,
                Rand(-1.0, 1.0)
            )
        });
        (buf.duration/4).wait;
    };
};

// Define the speedy section
~fast = {
    "Playing speedy section...".postln;
    100.do { |i|
        var buf = ~buffers.choose;
        ~np.add({
            Pan2.ar(
                PlayBuf.ar(buf.numChannels, buf.bufnum,
                    rate: (1..12).choose.midiratio,
                    doneAction: 2) * rrand(-40, 0).dbamp,
                Rand(-1.0, 1.0)
            )
        });
        rrand(0.05, 0.3).wait;
    };
};

// Create the looping task
~loopingTask = Task({
    inf.do { |cycle|
        "Starting cycle %...".format(cycle + 1).postln;

        // Play slow section
        ~slow.value;

        // Play fast section
        ~fast.value;

        "Completed cycle %".format(cycle + 1).postln;
    };
});

// Simple controls
~start = { ~loopingTask.play; "Starting the loop...".postln; };
~stop = { ~loopingTask.stop; "Stopping the loop...".postln; };

// Show instructions
"SIMPLE CONTROLS:".postln;
"~start.value - Start the loop".postln;
"~stop.value - Stop the loop".postln;

//In SuperCollider, when you use .value on a variable that contains a function, you're saying "read whatever function is stored in this variable, and execute it now."

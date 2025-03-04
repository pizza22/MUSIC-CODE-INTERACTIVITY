
//first, run this, it sets up the directory inside whatever this file is saved inside.
(
~dirpath = "MySounds/*".resolveRelative;
~filepaths = ~dirpath.pathMatch;
~buffers = ~filepaths.collect { |path| Buffer.read(s, path) };
~np = NodeProxy.audio(s, 2).play;
~np.clear;


// Define the slow section
~slow = {
    var totalEvents = 50;
    "Starting slow section (%/% events)...".format(totalEvents, totalEvents).postln;

    totalEvents.do { |i|
        var eventsLeft = totalEvents - i;
        var buf = ~buffers.choose;

        // Post countdown for every event
        "Slow section: % events remaining".format(eventsLeft).postln;

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

    "Slow section complete.".postln;
};

// Define the speedy section
~fast = {
    var totalEvents = 100;
    "Starting speedy section (%/% events)...".format(totalEvents, totalEvents).postln;

    totalEvents.do { |i|
        var eventsLeft = totalEvents - i;
        var buf = ~buffers.choose;

        // Post countdown for every event
        "Speedy section: % events remaining".format(eventsLeft).postln;

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

    "Speedy section complete.".postln;
};

// Create the looping task
~loopingTask = Task({
    inf.do { |cycle|

        // Play slow section
        ~slow.value;

        // Play fast section
        ~fast.value;

    };
});

// Simple controls
~start = {
    if(~loopingTask.isPlaying.not) {
        ~loopingTask.play;
        "Starting the loop...".postln;
    } {
        "The loop is already running.".postln;
    };
};

~stop = {
    if(~loopingTask.isPlaying) {
        ~loopingTask.stop;
        "Stopping the loop...".postln;
    } {
        "The loop is not running.".postln;
    };
};

// Show instructions
"SIMPLE CONTROLS:".postln;
"~start.value - Start the loop".postln;
"~stop.value - Stop the loop".postln;
)

~start.value

(
~dirpath = "MySounds/*".resolveRelative;
~filepaths = ~dirpath.pathMatch;
~buffers = ~filepaths.collect { |path|  Buffer.readChannel(s, path, channels: [0]);};

s.boot;

s.waitForBoot({
  ~np = NodeProxy.audio(s, 2);
  ~np.source = nil;
  ~np.play;
});


~checkAndClearServer = {
    var defCount = s.numSynthDefs;
    var maxDefs = s.options.maxSynthDefs;

    if(defCount > (maxDefs * 0.9)) {
        "WARNING: SynthDef count high (%/%), clearing NodeProxy...".format(defCount, maxDefs).postln;
		~np[2..2048]=nil;
        0.1.wait;
        "NodeProxy cleared.".postln;
        true
    } {
        false
    };
};


// slow section
~slow = {
    var totalEvents = 50;
    "Starting slow section (%/% events)...".format(totalEvents, totalEvents).postln;

    totalEvents.do { |i|
        var eventsLeft = totalEvents - i;
		var buf = ~buffers[0..9].choose;

        // Post countdown for every event
        "Slow section: % events remaining".format(eventsLeft).postln;

        ~np.add({
            Pan2.ar(
                PlayBuf.ar(buf.numChannels, buf.bufnum,
                    rate: (1..12).choose.midiratio,
                    doneAction: 2) * rrand(-40, -1).dbamp,
                Rand(-1.0, 1.0)
            )
        });
        (buf.duration/1.7).wait;
    };

    "Slow section complete.".postln;
};

// speedy section
~fast = {
    var totalEvents = 100;
    "Starting speedy section (%/% events)...".format(totalEvents, totalEvents).postln;

    totalEvents.do { |i|
        var eventsLeft = totalEvents - i;
		var buf = ~buffers[10..17].choose;

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
        rrand(0.03, 0.2).wait;
    };

    "Speedy section complete.".postln;
};


// glitchy section
~glitchy= {
    var totalEvents = 100;
	"Starting glitchy section (%/% events)...".format(totalEvents, totalEvents).postln;
	totalEvents.do { |i|
		var eventsLeft = totalEvents - i;
		var buf = ~buffers[6..14].choose;
            var rate = [-2, -1, 1, 2, 4].choose;
            var start = rrand(0, 0.8);

		 // Post countdown for every event
        "glitchy section: % events remaining".format(eventsLeft).postln;

            ~np.add({
                Pan2.ar(
                    PlayBuf.ar(buf.numChannels, buf.bufnum,
                        rate: rate,
                        startPos: start * buf.numFrames,
                        doneAction: 2) * rrand(-30, -5).dbamp,
                    Rand(-1.0, 1.0)
                )
            });
            rrand(0.1, 0.4).wait;
        };
        "Glitchy section complete.".postln;
    }
;


// solo
~solo = {
    var totalEvents = 100;
    var eventsLeft, buf, ping;  // Declare all variables at the beginning
    "Starting SOLO section (%/% events)...".format(totalEvents, totalEvents).postln;
    totalEvents.do { |i|
        eventsLeft = totalEvents - i;
        buf = ~buffers[7..9].choose;
        "SOLO section: % events remaining".format(eventsLeft).postln;
		ping = {
			var mouse =  MouseX.kr(0.01, 0.2);
            var signal = PlayBuf.ar(
                buf.numChannels,
                buf.bufnum,
                rate: (1..12).choose.midiratio,
                doneAction: 2
            ) * rrand(-20, -4).dbamp;
            // Apply processing within the function
            signal = Wrap.ar(signal, -1*mouse, mouse) * 2;
            signal = Limiter.ar(0.8 * signal, 0.3, 0.05);
            Pan2.ar(signal, Rand(-1.0, 1.0))
        };
		~np.add(ping);
        rrand(0.01, 0.25).wait;
    };

    "SOLO section complete.".postln;
};


~loopingTask = Task({
    inf.do { |cycle|

		~slow.value;
		~checkAndClearServer.value;

        ~glitchy.value;
		~checkAndClearServer.value;

        //~fast.value;
		~checkAndClearServer.value;

		//~solo.value;
		~checkAndClearServer.value;
    };
});

// controls
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

~reset = {
	~loopingTask.reset;
 "Reset the loop".postln;
};


//
"SIMPLE CONTROLS:".postln;
"~start.value - Start the loop".postln;
"~stop.value - Stop the loop".postln;
)



~start.value
~stop.value
~reset.value
~np.source=nil  //run if overflow
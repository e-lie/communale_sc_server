// ##### OSC Events and SynthDefs #####

// Define a basic FM synth with envelope
SynthDef(\fmSynth, {
	arg out=0, freq=440, modFreq=200, modIndex=2,
	    amp=0.3, pan=0, atk=0.01, rel=0.3;

	var carrier, modulator, env, sig;

	// Envelope with doneAction:2 to free the synth after release
	env = EnvGen.kr(
		Env.perc(atk, rel),
		doneAction: 2
	);

	// FM synthesis
	modulator = SinOsc.ar(modFreq) * modIndex * freq;
	carrier = SinOsc.ar(freq + modulator);

	sig = carrier * env * amp;
	sig = Pan2.ar(sig, pan);

	Out.ar(out, sig);
}).add;

// Function to create OSC event handlers
~makeEvents = {

	// OSC responder for playing FM synth
	// Usage: send OSC message to /fm with arguments
	// Examples:
	//   /fm 440           -> play with default params
	//   /fm 440 200 3 0.5 -> freq, modFreq, modIndex, amp
	OSCdef(\fmTrigger, {
		arg msg, time, addr, recvPort;
		var freq, modFreq, modIndex, amp, pan, atk, rel;

		// Parse OSC arguments with defaults
		freq = msg[1] ? 440;
		modFreq = msg[2] ? (freq * 0.5);
		modIndex = msg[3] ? 2;
		amp = msg[4] ? 0.3;
		pan = msg[5] ? 0.0;
		atk = msg[6] ? 0.01;
		rel = msg[7] ? 0.3;

		// Create the synth
		Synth(\fmSynth, [
			\freq, freq,
			\modFreq, modFreq,
			\modIndex, modIndex,
			\amp, amp,
			\pan, pan,
			\atk, atk,
			\rel, rel
		]);

		"FM synth triggered: freq=% modFreq=% modIndex=% amp=%".format(
			freq, modFreq, modIndex, amp
		).postln;

	}, '/fm');

	// OSC responder for random FM synth
	// Usage: send OSC message to /fmRandom
	OSCdef(\fmRandom, {
		arg msg, time, addr, recvPort;
		var freq, modFreq, modIndex, amp, pan;

		// Random parameters
		freq = exprand(200, 1200);
		modFreq = freq * exprand(0.3, 3.0);
		modIndex = exprand(0.5, 5.0);
		amp = exprand(0.1, 0.4);
		pan = rrand(-0.8, 0.8);

		Synth(\fmSynth, [
			\freq, freq,
			\modFreq, modFreq,
			\modIndex, modIndex,
			\amp, amp,
			\pan, pan
		]);

		"Random FM synth: freq=% modFreq=% modIndex=%".format(
			freq.round(0.1), modFreq.round(0.1), modIndex.round(0.1)
		).postln;

	}, '/fmRandom');

	// OSC responder for FM chord
	// Usage: send OSC message to /fmChord with base frequency
	OSCdef(\fmChord, {
		arg msg, time, addr, recvPort;
		var baseFreq, intervals, amp;

		baseFreq = msg[1] ? 220;
		amp = (msg[2] ? 0.3) / 4; // Divide by number of notes
		intervals = [0, 4, 7, 12]; // Major chord (root, maj3, 5th, octave)

		intervals.do { |interval|
			var freq = baseFreq * (2 ** (interval/12));
			Synth(\fmSynth, [
				\freq, freq,
				\modFreq, freq * 0.5,
				\modIndex, 1.5,
				\amp, amp,
				\pan, rrand(-0.3, 0.3),
				\atk, 0.02,
				\rel, 0.5
			]);
		};

		"FM chord played at base freq=%".format(baseFreq).postln;

	}, '/fmChord');

	"OSC event handlers initialized (/fm, /fmRandom, /fmChord)".postln;
};

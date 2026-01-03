
// Function to create OSC event handlers
~makeEvents = {

	OSCdef(\fmTrigger, {
		arg msg, time, addr, recvPort;
		var sampleDir, sampleIndex, retrig, dbAmp, panPos, rate, leBuf;

		// Parse OSC arguments with defaults
		sampleDir = msg[1];
		sampleIndex = msg[2] ? 0;
		retrig = msg[3] ? 0;
		rate = 1;

		leBuf = ~buffers['\\'++sampleDir][sampleIndex]

		// Create the synth
		// ~jeu1Synth.set(\kill, 1)
		~jeu1Synth = Synth(\le_player, [
			\buf, leBuf,
			\amp, -3,
			\out, ~bus[\jeu_1_samples],
			\rate, rate,
			\kill, retrig
		]);

		"FM synth triggered: sampleDir=% sampleIndex=% retrig=%".format(
			sampleDir, sampleIndex, retrig
		).postln;

	}, '/jeu1');

	"OSC event handlers initialized (/fm, /fmRandom, /fmChord)".postln;
};

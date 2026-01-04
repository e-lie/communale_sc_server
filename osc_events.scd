
// Function to create OSC event handlers
~makeEvents = {

	OSCdef(\fmTrigger, {
		arg msg, time, addr, recvPort;
		var sampleDir, sampleIndex, retrig, rate, leBuf, jeu1Synth, sampleName;

		// Parse OSC arguments with defaults
		sampleDir = msg[1];
		sampleIndex = msg[2] ? 0;
		retrig = msg[3] ? 0;
		rate = msg[4] ? 1;

		leBuf = ~buffers[sampleDir][sampleIndex];

		"Sample player triggered: sampleDir=% sampleIndex=% retrig=%".format(
			sampleDir, sampleIndex, retrig
		).postln;

		// Create the synth
		jeu1Synth = Synth(\le_player, [
			\buf, leBuf,
			\amp, -3,
			\out, ~bus[\jeu1_samples],
			\rate, rate,
			\kill, retrig
		]);



	}, '/jeu1');

	"OSC event handlers initialized (/jeu1)".postln;
};

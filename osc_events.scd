
// Function to create OSC event handlers
~makeEvents = {

	OSCdef(\jeu_1_buf_trig, {
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
			\out, ~bus[\jeu_1_samples],
			\rate, rate,
			\kill, retrig
		]);



	}, '/jeu1_buf_trig');

	"OSC event handlers initialized (/jeu1)".postln;


	OSCdef(\alarm, {
		arg msg, time, addr, recvPort;

		// Create the synth
		~virgule = Routine{
			var atk=0.25, rel=12, freq=440, rate=1;
			~spat = Synth(\alarm, [\amp, 0, \atk, atk, \rel, rel, \freq,freq, \rate, rate, \out, ~bus[\master_multichannel]]);
			(atk*2).wait;
			~spat.set(\freq, freq/2);
			~spat.set(\rate, rate/2);
			(rel/3).wait;
			~spat.set(\rate, rate*10);
			0.1.wait;
			~spat.set(\rate, rate*100);
			(rel/12).wait;
			10.do{
				arg i;
				~spat.set(\rate, rate*(100 + (i*10)));
				~spat.set(\freq, freq * i);

				0.2.wait;
			}
		}.play;

	}, '/alarm');

	"OSC event handlers initialized (/alarm)".postln;
};

// ~makeEvents.print;
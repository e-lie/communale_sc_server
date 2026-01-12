
// Function to create OSC event handlers
~makeEvents = {

	// -----________--------_______--------_
	// JEU 1 --
	// -----________--------_______--------_

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
		jeu1Synth = Synth(\sample_player_mono, [
			\buf, leBuf,
			\amp, -3,
			\out, ~bus[\jeu_1_samples],
			\rate, rate,
			\kill, retrig
		]);



	}, '/jeu1_buf_trig');

	"OSC event handlers initialized (/jeu1)".postln;

	// -----________--------_______--------_
	// JEU 2 --
	// -----________--------_______--------_

	OSCdef(\jeu_2_buf_trig, {
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
			\out, ~bus[\jeu_2_samples],
			\rate, rate,
			\kill, retrig
		]);



	}, '/jeu2_buf_trig');

	"OSC event handlers initialized (/jeu2)".postln;

	// -----________--------_______--------_
	// JEU 3 --
	// -----________--------_______--------_

	OSCdef(\jeu_3_buf_trig, {
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
			\out, ~bus[\jeu_3_samples],
			\rate, rate,
			\kill, retrig
		]);



	}, '/jeu3_buf_trig');

	"OSC event handlers initialized (/jeu3)".postln;

	// -----________--------_______--------_
	// ALARM --
	// -----________--------_______--------_

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

	// ===== INPUT STEREO OSC HANDLER =====
	OSCdef(\inputStereoControl, {
		arg msg, time, addr, recvPort;
		var amp, inBus, pos;

		// Parse OSC arguments
		amp = msg[1] ? 0;
		inBus = msg[2] ? 0;
		pos = msg[3] ? 0;

		// Mettre à jour le synth d'input
		~input_stereo_synth.set(\amp, amp, \inBus, inBus);

		// Mettre à jour la spatialisation
		~spat_input_stereo.set(\amp, amp, \pos, pos);

		"Input Stereo: amp=% inBus=% pos=%".format(amp, inBus, pos).postln;

	}, '/input_stereo');

	"OSC event handlers initialized (/input_stereo)".postln;

	// ===== INPUT QUAD OSC HANDLER =====
	OSCdef(\inputQuadControl, {
		arg msg, time, addr, recvPort;
		var amp, inBus, pos;

		// Parse OSC arguments
		amp = msg[1] ? 0;
		inBus = msg[2] ? 0;
		pos = msg[3] ? 0;

		// Mettre à jour le synth d'input
		~input_quad_synth.set(\amp, amp, \inBus, inBus);

		// Mettre à jour la spatialisation
		~spat_input_quad.set(\amp, amp, \pos, pos);

		"Input Quad: amp=% inBus=% pos=%".format(amp, inBus, pos).postln;

	}, '/input_quad');

	"OSC event handlers initialized (/input_quad)".postln;

	// ===== INPUT OCTO OSC HANDLER =====
	OSCdef(\inputOctoControl, {
		arg msg, time, addr, recvPort;
		var amp, inBus, pos;

		// Parse OSC arguments
		amp = msg[1] ? 0;
		inBus = msg[2] ? 0;
		pos = msg[3] ? 0;

		// Mettre à jour le synth d'input
		~input_octo_synth.set(\amp, amp, \inBus, inBus);

		// Mettre à jour la spatialisation
		~spat_input_octo.set(\amp, amp, \pos, pos);

		"Input Octo: amp=% inBus=% pos=%".format(amp, inBus, pos).postln;

	}, '/input_octo');

	"OSC event handlers initialized (/input_octo)".postln;
};

// ~makeEvents.print;
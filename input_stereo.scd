(
// ===== INPUT STEREO =====
// Bus, synth d'input audio stéréo, spat, et OSC trigger

// Créer le bus et le synth de spatialisation
~makeNode_input_stereo = {
	s.bind({
		// Créer le bus audio stéréo
		~bus_input_stereo = Bus.audio(s, 2);

		// Créer le synth d'input audio
		~input_stereo_synth = Synth.new(
			\audio_in_stereo,
			[
				\amp, 0,
				\inBus, 0,  // Hardware input bus (canaux 0-1)
				\out, ~bus_input_stereo
			],
			~mainGrp
		);

		// Créer le synth de spatialisation
		~spat_input_stereo = Synth.new(
			\spat_stereo,
			[
				\amp, 0,
				\in, ~bus_input_stereo,
				\out, ~bus_master
			],
			~spatGrp
		);

		"Input Stereo: Bus, input synth and spat synth created".postln;
	});
};

// OSC trigger pour contrôler l'input stéréo
~makeEvent_input_stereo = {
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

	"Input Stereo: OSC handler /input_stereo initialized".postln;
};

)

(
// ===== INPUT OCTO =====
// Bus, synth d'input audio octophonique, spat, et OSC trigger

// Créer le bus et le synth de spatialisation
~makeNode_input_octo = {
	s.bind({
		// Créer le bus audio octophonique
		~bus_input_octo = Bus.audio(s, 8);

		// Créer le synth d'input audio
		~input_octo_synth = Synth.new(
			\audio_in_octo,
			[
				\amp, 0,
				\inBus, 0,  // Hardware input bus (canaux 0-7)
				\out, ~bus_input_octo
			],
			~mainGrp
		);

		// Créer le synth de spatialisation (8 canaux -> 12 canaux)
		~spat_input_octo = Synth.new(
			\spat_octo,
			[
				\amp, 0,
				\in, ~bus_input_octo,
				\out, ~bus_master
			],
			~spatGrp
		);

		"Input Octo: Bus, input synth and spat synth created".postln;
	});
};

// OSC trigger pour contrôler l'input octo
~makeEvent_input_octo = {
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

	"Input Octo: OSC handler /input_octo initialized".postln;
};

)

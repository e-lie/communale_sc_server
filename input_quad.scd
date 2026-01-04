(
// ===== INPUT QUAD =====
// Bus, synth d'input audio quadriphonique, spat, et OSC trigger

// Créer le bus et le synth de spatialisation
~makeNode_input_quad = {
	s.bind({
		// Créer le bus audio quadriphonique
		~bus_input_quad = Bus.audio(s, 4);

		// Créer le synth d'input audio
		~input_quad_synth = Synth.new(
			\audio_in_quad,
			[
				\amp, 0,
				\inBus, 0,  // Hardware input bus (canaux 0-3)
				\out, ~bus_input_quad
			],
			~mainGrp
		);

		// Créer le synth de spatialisation (4 canaux -> 12 canaux)
		~spat_input_quad = Synth.new(
			\spat_quad,
			[
				\amp, 0,
				\in, ~bus_input_quad,
				\out, ~bus_master
			],
			~spatGrp
		);

		"Input Quad: Bus, input synth and spat synth created".postln;
	});
};

// OSC trigger pour contrôler l'input quad
~makeEvent_input_quad = {
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

	"Input Quad: OSC handler /input_quad initialized".postln;
};

)

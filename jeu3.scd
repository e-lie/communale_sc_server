(
// ===== JEU 3 =====
// Bus, synth de spat, et OSC trigger

// Créer le bus et le synth de spatialisation
~makeNode_jeu3 = {
	s.bind({
		// Créer le bus audio
		~bus_jeu3 = Bus.audio(s, 1);

		// Créer le synth de spatialisation
		~spat_jeu3 = Synth.new(
			\spat_mono,
			[
				\amp, 0,
				\in, ~bus_jeu3,
				\out, ~bus_master
			],
			~spatGrp
		);
		"Jeu3: Bus and spat synth created".postln;
	});
};

// OSC trigger pour jeu3
~makeEvent_jeu3 = {
	OSCdef(\jeu3Trigger, {
		arg msg, time, addr, recvPort;
		var sampleDir, sampleIndex, retrig, rate, leBuf, jeu3Synth;

		// Parse OSC arguments avec defaults
		sampleDir = msg[1] ? "jeu3";
		sampleIndex = msg[2] ? 0;
		retrig = msg[3] ? 0;
		rate = msg[4] ? 1;

		// Récupérer le buffer
		leBuf = ~buffers[sampleDir][sampleIndex];

		"Jeu3 triggered: sampleDir=% sampleIndex=% retrig=% rate=%".format(
			sampleDir, sampleIndex, retrig, rate
		).postln;

		// Créer le synth de lecture
		jeu3Synth = Synth(\sample_player_mono, [
			\buf, leBuf,
			\amp, -3,
			\out, ~bus_jeu3,
			\rate, rate,
			\kill, retrig,
		], ~mainGrp);

	}, '/jeu3');

	"Jeu3: OSC handler /jeu3 initialized".postln;
};

)

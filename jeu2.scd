(
// ===== JEU 2 =====
// Bus, synth de spat, et OSC trigger

// Créer le bus et le synth de spatialisation
~makeNode_jeu2 = {
	s.bind({
		// Créer le bus audio
		~bus_jeu2 = Bus.audio(s, 1);

		// Créer le synth de spatialisation
		~spat_jeu2 = Synth.new(
			\spat_mono,
			[
				\amp, 0,
				\in, ~bus_jeu2,
				\out, ~bus_master
			],
			~spatGrp
		);
		"Jeu2: Bus and spat synth created".postln;
	});
};

// OSC trigger pour jeu2
~makeEvent_jeu2 = {
	OSCdef(\jeu2Trigger, {
		arg msg, time, addr, recvPort;
		var sampleDir, sampleIndex, retrig, rate, leBuf, jeu2Synth;

		// Parse OSC arguments avec defaults
		sampleDir = msg[1] ? "jeu2";
		sampleIndex = msg[2] ? 0;
		retrig = msg[3] ? 0;
		rate = msg[4] ? 1;

		// Récupérer le buffer
		leBuf = ~buffers[sampleDir][sampleIndex];

		"Jeu2 triggered: sampleDir=% sampleIndex=% retrig=% rate=%".format(
			sampleDir, sampleIndex, retrig, rate
		).postln;

		// Créer le synth de lecture
		jeu2Synth = Synth(\sample_player, [
			\buf, leBuf,
			\amp, -3,
			\out, ~bus_jeu2,
			\rate, rate,
			\kill, retrig,
			\numChan, 1
		], ~mainGrp);

	}, '/jeu2');

	"Jeu2: OSC handler /jeu2 initialized".postln;
};

)

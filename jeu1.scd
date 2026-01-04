(
// ===== JEU 1 =====
// Bus, synth de spat, et OSC trigger

// Créer le bus et le synth de spatialisation
~makeNode_jeu1 = {
	s.bind({
		// Créer le bus audio
		~bus_jeu1 = Bus.audio(s, 1);

		// Créer le synth de spatialisation
		~spat_jeu1 = Synth.new(
			\spat_mono,
			[
				\amp, 0,
				\in, ~bus_jeu1,
				\out, ~bus_master
			],
			~spatGrp
		);
		"Jeu1: Bus and spat synth created".postln;
	});
};

// 4. OSC trigger pour jeu1
~makeEvent_jeu1 = {
	OSCdef(\jeu1Trigger, {
		arg msg, time, addr, recvPort;
		var sampleDir, sampleIndex, retrig, rate, leBuf, jeu1Synth;

		// Parse OSC arguments avec defaults
		sampleDir = msg[1] ? "jeu1";
		sampleIndex = msg[2] ? 0;
		retrig = msg[3] ? 0;
		rate = msg[4] ? 1;

		// Récupérer le buffer
		leBuf = ~buffers[sampleDir][sampleIndex];

		"Jeu1 triggered: sampleDir=% sampleIndex=% retrig=% rate=%".format(
			sampleDir, sampleIndex, retrig, rate
		).postln;

		// Créer le synth de lecture
		jeu1Synth = Synth(\sample_player, [
			\buf, leBuf,
			\amp, -3,
			\out, ~bus_jeu1,
			\rate, rate,
			\kill, retrig,
			\numChan, 1
		], ~mainGrp);

	}, '/jeu1');

	"Jeu1: OSC handler /jeu1 initialized".postln;
};

)

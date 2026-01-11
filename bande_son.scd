(
// ===== BANDE SON =====
// Bus, synth de spat, et OSC trigger

// Créer le bus et le synth de spatialisation
~makeNode_bande_son = {
	s.bind({
		// Créer le bus audio stéréo
		~bus_bande_son = Bus.audio(s, 2);

		// Créer le synth de spatialisation
		~spat_bande_son = Synth.new(
			\spat_stereo,
			[
				\amp, 0,
				\in, ~bus_bande_son,
				\out, ~bus_master
			],
			~spatGrp
		);
		"Bande son: Bus and spat synth created".postln;
	});
};

// 4. OSC trigger pour bande son
~makeEvent_bande_son = {
	OSCdef(\bandeSonTrigger, {
		arg msg, time, addr, recvPort;
		var sampleDir, sampleIndex, retrig, rate, leBuf, bandeSonSynth;

		// Parse OSC arguments avec defaults
		sampleDir = msg[1] ? "bande_son";
		sampleIndex = msg[2] ? 0;
		retrig = msg[3] ? 0;
		rate = msg[4] ? 1;

		// Récupérer le buffer
		leBuf = ~buffers[sampleDir][sampleIndex];

		"Bande son triggered: sampleDir=% sampleIndex=% retrig=% rate=%".format(
			sampleDir, sampleIndex, retrig, rate
		).postln;

		// Créer le synth de lecture (stéréo)
		bandeSonSynth = Synth(\sample_player_stereo, [
			\buf, leBuf,
			\amp, -5,
			\out, ~bus_bande_son,
			\rate, rate,
			\kill, retrig,
		], ~mainGrp);

	}, '/bande_son');

	"Bande son: OSC handler /bande_son initialized".postln;
};

)

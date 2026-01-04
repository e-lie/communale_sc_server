(
// ===== JEU 2 =====
// Bus, SynthDef de spatialisation, Synth de spat, et OSC trigger

// 1. Créer le bus audio
~makeBus_jeu2 = {
	~bus[\jeu2_samples] = Bus.audio(s, 1);
	"Jeu2: Bus created".postln;
};

// 2. SynthDef de spatialisation pour jeu2
SynthDef(\spat_jeu2, {
	arg bus, out=0, amp=0, pos=0, orientation=0.5, width=2;
	var sig;

	sig = In.ar(bus, 1);
	sig = PanAz.ar(12, sig, pos, 1.0, width, orientation);

	Out.ar(out, sig);
}).add;

// 3. Créer le synth de spatialisation
~makeNode_jeu2 = {
	s.bind({
		~spat_jeu2 = Synth.new(
			\spat_jeu2,
			[
				\amp, 0,
				\bus, ~bus[\jeu2_samples],
				\out, ~bus[\master_multichannel]
			],
			~spatGrp
		);
		"Jeu2: Spat synth created".postln;
	});
};

// 4. OSC trigger pour jeu2
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
		leBuf = ~toBuf.value(sampleDir, sampleIndex);

		"Jeu2 triggered: sampleDir=% sampleIndex=% retrig=% rate=%".format(
			sampleDir, sampleIndex, retrig, rate
		).postln;

		// Créer le synth de lecture
		jeu2Synth = Synth(\le_player, [
			\buf, leBuf,
			\amp, -3,
			\out, ~bus[\jeu2_samples],
			\rate, rate,
			\kill, retrig
		], ~mainGrp);

	}, '/jeu2');

	"Jeu2: OSC handler /jeu2 initialized".postln;
};

)

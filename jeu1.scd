(
// ===== JEU 1 =====
// Bus, SynthDef de spatialisation, Synth de spat, et OSC trigger

// 1. Créer le bus audio
~makeBus_jeu1 = {
	~bus[\jeu1_samples] = Bus.audio(s, 1);
	"Jeu1: Bus created".postln;
};

// 2. SynthDef de spatialisation pour jeu1
SynthDef(\spat_jeu1, {
	arg bus, out=0, amp=0, pos=0, orientation=0.5, width=2;
	var sig;

	sig = In.ar(bus, 1);
	sig = PanAz.ar(12, sig, pos, 1.0, width, orientation);

	Out.ar(out, sig);
}).add;

// 3. Créer le synth de spatialisation
~makeNode_jeu1 = {
	s.bind({
		~spat_jeu1 = Synth.new(
			\spat_jeu1,
			[
				\amp, 0,
				\bus, ~bus[\jeu1_samples],
				\out, ~bus[\master_multichannel]
			],
			~spatGrp
		);
		"Jeu1: Spat synth created".postln;
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
		leBuf = ~toBuf.value(sampleDir, sampleIndex);

		"Jeu1 triggered: sampleDir=% sampleIndex=% retrig=% rate=%".format(
			sampleDir, sampleIndex, retrig, rate
		).postln;

		// Créer le synth de lecture
		jeu1Synth = Synth(\le_player, [
			\buf, leBuf,
			\amp, -3,
			\out, ~bus[\jeu1_samples],
			\rate, rate,
			\kill, retrig
		], ~mainGrp);

	}, '/jeu1');

	"Jeu1: OSC handler /jeu1 initialized".postln;
};

)

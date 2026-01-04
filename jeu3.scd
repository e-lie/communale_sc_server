(
// ===== JEU 3 =====
// Bus, SynthDef de spatialisation, Synth de spat, et OSC trigger

// 1. Créer le bus audio
~makeBus_jeu3 = {
	~bus[\jeu3_samples] = Bus.audio(s, 1);
	"Jeu3: Bus created".postln;
};

// 2. SynthDef de spatialisation pour jeu3
SynthDef(\spat_jeu3, {
	arg bus, out=0, amp=0, pos=0, orientation=0.5, width=2;
	var sig;

	sig = In.ar(bus, 1);
	sig = PanAz.ar(12, sig, pos, 1.0, width, orientation);

	Out.ar(out, sig);
}).add;

// 3. Créer le synth de spatialisation
~makeNode_jeu3 = {
	s.bind({
		~spat_jeu3 = Synth.new(
			\spat_jeu3,
			[
				\amp, 0,
				\bus, ~bus[\jeu3_samples],
				\out, ~bus[\master_multichannel]
			],
			~spatGrp
		);
		"Jeu3: Spat synth created".postln;
	});
};

// 4. OSC trigger pour jeu3
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
		leBuf = ~toBuf.value(sampleDir, sampleIndex);

		"Jeu3 triggered: sampleDir=% sampleIndex=% retrig=% rate=%".format(
			sampleDir, sampleIndex, retrig, rate
		).postln;

		// Créer le synth de lecture
		jeu3Synth = Synth(\le_player, [
			\buf, leBuf,
			\amp, -3,
			\out, ~bus[\jeu3_samples],
			\rate, rate,
			\kill, retrig
		], ~mainGrp);

	}, '/jeu3');

	"Jeu3: OSC handler /jeu3 initialized".postln;
};

)

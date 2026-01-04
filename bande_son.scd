(
// ===== BANDE SON =====
// Bus, SynthDef de spatialisation, Synth de spat, et OSC trigger

// 1. SynthDef lecteur de bande son stéréo
SynthDef(\bande_son, {
	arg buf, amp=(-5), out=0, rate=1, kill=0;
	var sig, envout;

	envout = EnvGen.kr(Env([1, 0], [0.2], -4), kill, doneAction:2);
	sig = PlayBuf.ar(2, buf, rate, doneAction:2);
	sig = sig * envout;
	sig = sig * amp.dbamp;

	Out.ar(out, sig);
}).add;

// 2. SynthDef de spatialisation pour bande son (stéréo)
SynthDef(\spat_bande_son, {
	arg bus, out=0, amp=0, pos=0, orientation=0.5, width=2;
	var sig;

	sig = In.ar(bus, 2);
	sig =
	[
		PanAz.ar(6, sig[0], pos, 1.0, width, orientation),
		PanAz.ar(6, sig[1], pos, 1.0, width, orientation)
	];

	sig = sig * amp.dbamp;

	Out.ar(out, sig);
}).add;

// 3. Créer le bus et le synth de spatialisation
~makeNode_bande_son = {
	s.bind({
		// Créer le bus audio stéréo
		~bus_bande_son = Bus.audio(s, 2);

		// Créer le synth de spatialisation
		~spat_bande_son = Synth.new(
			\spat_bande_son,
			[
				\amp, 0,
				\bus, ~bus_bande_son,
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
		bandeSonSynth = Synth(\bande_son, [
			\buf, leBuf,
			\amp, -5,
			\out, ~bus_bande_son,
			\rate, rate,
			\kill, retrig
		], ~mainGrp);

	}, '/bande_son');

	"Bande son: OSC handler /bande_son initialized".postln;
};

)

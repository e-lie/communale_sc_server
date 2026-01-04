(
// ===== JEU 1 =====
// Bus, SynthDef de spatialisation, Synth de spat, et OSC trigger

// 1. SynthDef lecteur de sample pour jeu1
SynthDef(\le_player_jeu1, {
	arg buf, amp=(-5), out=0, rate=1, kill=0;
	var sig, envout;

	envout = EnvGen.kr(Env([1, 0], [0.2], -4), kill, doneAction:2);
	sig = PlayBuf.ar(1, buf, rate, doneAction:2);
	sig = sig * envout;
	sig = sig * amp.dbamp;

	Out.ar(out, sig);
}).add;

// 2. SynthDef de spatialisation pour jeu1
SynthDef(\spat_jeu1, {
	arg in, out=0, amp=0, pos=0, orientation=0.5, width=2;
	var sig;

	sig = In.ar(in, 1);
	sig = PanAz.ar(12, sig, pos, 1.0, width, orientation);

	Out.ar(out, sig);
}).add;

// 3. Créer le bus et le synth de spatialisation
~makeNode_jeu1 = {
	s.bind({
		// Créer le bus audio
		~bus_jeu1 = Bus.audio(s, 1);

		// Créer le synth de spatialisation
		~spat_jeu1 = Synth.new(
			\spat_jeu1,
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
		jeu1Synth = Synth(\le_player_jeu1, [
			\buf, leBuf,
			\amp, -3,
			\out, ~bus_jeu1,
			\rate, rate,
			\kill, retrig
		], ~mainGrp);

	}, '/jeu1');

	"Jeu1: OSC handler /jeu1 initialized".postln;
};

)

(
// ===== JEU 2 =====
// Bus, SynthDef de spatialisation, Synth de spat, et OSC trigger

// 1. SynthDef lecteur de sample pour jeu2
SynthDef(\le_player_jeu2, {
	arg buf, amp=(-5), out=0, rate=1, kill=0;
	var sig, envout;

	envout = EnvGen.kr(Env([1, 0], [0.2], -4), kill, doneAction:2);
	sig = PlayBuf.ar(1, buf, rate, doneAction:2);
	sig = sig * envout;
	sig = sig * amp.dbamp;

	Out.ar(out, sig);
}).add;

// 2. SynthDef de spatialisation pour jeu2
SynthDef(\spat_jeu2, {
	arg in, out=0, amp=0, pos=0, orientation=0.5, width=2;
	var sig;

	sig = In.ar(in, 1);
	sig = PanAz.ar(12, sig, pos, 1.0, width, orientation);

	Out.ar(out, sig);
}).add;

// 3. Créer le bus et le synth de spatialisation
~makeNode_jeu2 = {
	s.bind({
		// Créer le bus audio
		~bus_jeu2 = Bus.audio(s, 1);

		// Créer le synth de spatialisation
		~spat_jeu2 = Synth.new(
			\spat_jeu2,
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
		leBuf = ~buffers[sampleDir][sampleIndex];

		"Jeu2 triggered: sampleDir=% sampleIndex=% retrig=% rate=%".format(
			sampleDir, sampleIndex, retrig, rate
		).postln;

		// Créer le synth de lecture
		jeu2Synth = Synth(\le_player_jeu2, [
			\buf, leBuf,
			\amp, -3,
			\out, ~bus_jeu2,
			\rate, rate,
			\kill, retrig
		], ~mainGrp);

	}, '/jeu2');

	"Jeu2: OSC handler /jeu2 initialized".postln;
};

)

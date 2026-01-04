(
// ===== COMMON SYNTHDEFS =====
// SynthDefs partagés entre tous les domaines

// Lecteur de sample générique (mono ou stéréo)
SynthDef(\sample_player, {
	arg buf, amp=(-5), out=0, rate=1, kill=0, numChan=1;
	var sig, envout;

	envout = EnvGen.kr(Env([1, 0], [0.2], -4), kill, doneAction:2);
	sig = PlayBuf.ar(numChan, buf, rate, doneAction:2);
	sig = sig * envout;
	sig = sig * amp.dbamp;

	Out.ar(out, sig);
}).add;

// Spatialisateur générique mono
SynthDef(\spat_mono, {
	arg in, out=0, amp=0, pos=0, orientation=0.5, width=2;
	var sig;

	sig = In.ar(in, 1);
	sig = PanAz.ar(12, sig, pos, 1.0, width, orientation);

	Out.ar(out, sig);
}).add;

// Spatialisateur générique stéréo
SynthDef(\spat_stereo, {
	arg in, out=0, amp=0, pos=0, orientation=0.5, width=2;
	var sig;

	sig = In.ar(in, 2);
	sig = [
		PanAz.ar(6, sig[0], pos, 1.0, width, orientation),
		PanAz.ar(6, sig[1], pos, 1.0, width, orientation)
	];

	sig = sig * amp.dbamp;

	Out.ar(out, sig);
}).add;

)

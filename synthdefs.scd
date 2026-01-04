(
// ===== SYNTHDEFS DE BASE =====
// SynthDefs communs utilisés par tous les domaines

// Lecteur de sample mono
SynthDef(\le_player, {
	arg buf, amp=(-5), out=0, rate=1, kill=0;
	var sig, envout;

	envout = EnvGen.kr(Env([1, 0], [0.2], -4), kill, doneAction:2);
	sig = PlayBuf.ar(1, buf, rate, doneAction:2);
	sig = sig * envout;
	sig = sig * amp.dbamp;

	Out.ar(out, sig);
}).add;

// Lecteur de bande son stéréo
SynthDef(\bande_son, {
	arg buf, amp=(-5), out=0, rate=1, kill=0;
	var sig, envout;

	envout = EnvGen.kr(Env([1, 0], [0.2], -4), kill, doneAction:2);
	sig = PlayBuf.ar(2, buf, rate, doneAction:2);
	sig = sig * envout;
	sig = sig * amp.dbamp;

	Out.ar(out, sig);
}).add;

// Master multichannel output
SynthDef(\master_multichannel, {
	arg bus, out=0, amp=0;
	var sig;

	sig = In.ar(bus, 12);
	sig = sig * amp.dbamp.lag(2);
	Out.ar(out, sig);
}).add;

)
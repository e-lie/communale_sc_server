(
// ~pwew.set(\kill, 1);
// ~pwew = Synth(\le_player, [\buf, 0]);

//lecteur sample jeux vidéos mono
SynthDef(\le_player, {
	arg buf, amp=(-5), out=0, rate=1, kill=0;
	var sig, envout;

	envout = EnvGen.kr(Env([1, 0], [0.2], -4), kill, doneAction:2); // pour retrig le sample on veux le kill d'abord
	sig = PlayBuf.ar(1, buf, rate, doneAction:2);
	sig = sig * envout;
	sig = sig * amp.dbamp;

	Out.ar(out, sig);
}).add;

//spatialisation samples jeux vidéos
SynthDef(\spat_samples, {
	arg bus, out=0, amp=0, pos=0, orientation=0.5, width=2;
	var sig;

	sig = In.ar(bus, 1);
	sig = PanAz.ar(12, sig, pos, 1.0, width, orientation);

	Out.ar(out, sig);
}).add;

//lecteur bande son
SynthDef(\bande_son, {
	arg buf, amp=(-5), out=0, rate=1, kill=0;
	var sig, envout;

	envout = EnvGen.kr(Env([1, 0], [0.2], -4), kill, doneAction:2); // pour retrig le sample on veux le kill d'abord
	sig = PlayBuf.ar(2, buf, rate, doneAction:2);
	sig = sig * envout;
	sig = sig * amp.dbamp;

	Out.ar(out, sig);
}).add;

//spatialisation bande son
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

SynthDef(\master_multichannel, {
	arg bus, out=0, amp=0;
	var sig;

	sig = In.ar(bus, 12);
	sig = sig * amp.dbamp.lag(2);
	Out.ar(out, sig);
}).add;

)
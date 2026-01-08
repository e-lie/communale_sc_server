(
// -----________--------_______--------_
// INSTRUMENTS
// -----________--------_______--------_

SynthDef(\alarm, {
	arg freq= 220, out=0, amp=(-5), rate=1, pos=0.0, shape=0.5, atk=1, rel=2;
	var sig, mod, wave, env;


	env = EnvGen.ar(Env([0,1,0], [atk, rel], [4, -2]), doneAction:2);

	freq = freq.lag(5);
	rate = rate.lag(5);
	// alterne deux hauteurs
	sig = SinOsc.ar((freq/2) * ((LFSaw.ar(rate).linlin(-1,1,0,2)%1)+1).round(1), mul:0.6);
	// sirene haute
	wave = SinOsc.ar((freq*2) * SinOsc.ar(rate).linlin(-1,1,1,2), mul:0.6);
	wave = SineShaper.ar(wave,shape.lag(2));

	sig = (sig +
		Limiter.ar(
			Ringz.ar(sig, SinOsc.ar(rate/8).linlin(-1,1,freq, freq*2), 0.5, mul:1)))
	* 0.2;
	// les faire jouer ensemble
	sig = Splay.ar(sig + wave).sum;
	sig = sig * amp.dbamp * env;
	// circulaire
	sig = PanAz.ar(12, sig, LFSaw.ar(rate).linlin(-1,1,0.0,2.0));
	Out.ar(out,sig);
}).add;

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

OSCdef

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

// -----________--------_______--------_
// SPATIALISATION
// -----________--------_______--------_

SynthDef(\bande_son_multichannel, {
	arg buf, amp=(-5), out=0, rate=1, kill=0;
	var sig, envout;

	envout = EnvGen.kr(Env([1, 0], [0.2], -4), kill, doneAction:2); // pour retrig le sample on veux le kill d'abord
	sig = PlayBuf.ar(12, buf, rate, doneAction:2);
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
	sig = sig * amp.dbamp.lag(10);
	Out.ar(out, sig);
}).add;

)
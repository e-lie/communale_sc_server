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

// ===== COMMON SYNTHDEFS =====
// SynthDefs partagés entre tous les domaines

// Lecteur de sample mono
SynthDef(\sample_player_mono, {
	arg buf, amp=(-5), out=0, rate=1, kill=0;
	var sig, envout;

	envout = EnvGen.kr(Env([1, 0], [0.2], -4), kill, doneAction:2);
	sig = PlayBuf.ar(1, buf, rate, doneAction:2);
	sig = sig * envout;
	sig = sig * amp.dbamp;

	Out.ar(out, sig);
}).add;

// Lecteur de sample stéréo
SynthDef(\sample_player_stereo, {
	arg buf, amp=(-5), out=0, rate=1, kill=0;
	var sig, envout;

	envout = EnvGen.kr(Env([1, 0], [0.2], -4), kill, doneAction:2);
	sig = PlayBuf.ar(2, buf, rate, doneAction:2);
	sig = sig * envout;
	sig = sig * amp.dbamp;

	Out.ar(out, sig);
}).add;

// Lecteur de sample multicanal (12 canaux)
SynthDef(\bande_son_multichannel, {
	arg buf, amp=(-5), out=0, rate=1, kill=0;
	var sig, envout;

	envout = EnvGen.kr(Env([1, 0], [0.2], -4), kill, doneAction:2); // pour retrig le sample on veux le kill d'abord
	sig = PlayBuf.ar(12, buf, rate, doneAction:2);
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

// ===== INPUT AUDIO SYNTHDEFS =====

// Entrée audio stéréo
SynthDef(\audio_in_stereo, {
	arg out=0, amp=0, inBus=0;
	var sig;

	sig = SoundIn.ar([inBus, inBus+1]);
	sig = sig * amp.dbamp;

	Out.ar(out, sig);
}).add;

// Entrée audio quadriphonique
SynthDef(\audio_in_quad, {
	arg out=0, amp=0, inBus=0;
	var sig;

	sig = SoundIn.ar([inBus, inBus+1, inBus+2, inBus+3]);
	sig = sig * amp.dbamp;

	Out.ar(out, sig);
}).add;

// Entrée audio octophonique
SynthDef(\audio_in_octo, {
	arg out=0, amp=0, inBus=0;
	var sig;

	sig = SoundIn.ar([inBus, inBus+1, inBus+2, inBus+3, inBus+4, inBus+5, inBus+6, inBus+7]);
	sig = sig * amp.dbamp;

	Out.ar(out, sig);
}).add;

// ===== SPATIALISATION POUR INPUTS MULTICANAUX =====

// Spatialisateur quadriphonique (4 canaux -> 12 canaux)
SynthDef(\spat_quad, {
	arg in, out=0, amp=0, pos=0, orientation=0.5, width=2;
	var sig;

	sig = In.ar(in, 4);
	sig = [
		PanAz.ar(3, sig[0], pos, 1.0, width, orientation),  // Canal 1 sur 3 HP
		PanAz.ar(3, sig[1], pos, 1.0, width, orientation),  // Canal 2 sur 3 HP
		PanAz.ar(3, sig[2], pos, 1.0, width, orientation),  // Canal 3 sur 3 HP
		PanAz.ar(3, sig[3], pos, 1.0, width, orientation)   // Canal 4 sur 3 HP
	];

	sig = Mix(sig);  // Mixer les 4 sorties panoramisées
	sig = sig * amp.dbamp;

	Out.ar(out, sig);
}).add;

// Spatialisateur octophonique (8 canaux -> 12 canaux)
SynthDef(\spat_octo, {
	arg in, out=0, amp=0, pos=0, orientation=0.5, width=2;
	var sig, spatSig;

	sig = In.ar(in, 8);

	// Distribuer les 8 canaux sur 12 sorties
	spatSig = sig.collect({ |chan, i|
		var chanPos = pos + (i / 8 * 2 - 1);  // Répartir autour de la position
		PanAz.ar(12, chan, chanPos, 1.0, width, orientation)
	});

	spatSig = Mix(spatSig) * amp.dbamp;

	Out.ar(out, spatSig);
}).add;

)

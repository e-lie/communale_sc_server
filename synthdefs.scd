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


SynthDef(\test, {
	arg amp=(-5), out=0;
	var sig;

	sig = PinkNoise.ar(0.3)!12 * amp.dbamp;

	Out.ar(out,sig);
}).add;
// ===== SAMPLE PLAYERS =====

//lecteur sample jeux vidéos mono
SynthDef(\sample_player_mono, {
	arg buf, amp=(-5), out=0, rate=1, kill=0, rel=0.2, loop=0, atk=0.001;
	var sig, envout;

	envout = EnvGen.kr(Env([0, 1, 0], [atk, rel], -4), kill, doneAction:2); // pour retrig le sample on veux le kill d'abord
	sig = PlayBuf.ar(1, buf, rate, loop:loop, doneAction:2);
	sig = sig * envout;
	sig = sig * amp.dbamp;

	Out.ar(out, sig);
}).add;


//lecteur bande son notamment
SynthDef(\sample_player_stereo, {
	arg buf, amp=(-5), out=0, rate=1, kill=0;
	var sig, envout;

	envout = EnvGen.kr(Env([1, 0], [0.2], -4), kill, doneAction:2); // pour retrig le sample on veux le kill d'abord
	sig = PlayBuf.ar(2, buf, rate, doneAction:2);
	sig = sig * envout;
	sig = sig * amp.dbamp;

	Out.ar(out, sig);
}).add;


// lecteur bande son multichannel
SynthDef(\sample_player_multichannel, {
	arg buf, amp=(-5), out=0, rate=1, kill=0;
	var sig, envout;

	envout = EnvGen.kr(Env([1, 0], [0.2], -4), kill, doneAction:2); // pour retrig le sample on veux le kill d'abord
	sig = PlayBuf.ar(12, buf, rate, doneAction:2);
	sig = sig * envout;
	sig = sig * amp.dbamp;

	Out.ar(out, sig);
}).add;


// -----________--------_______--------_
// SPATIALISATION
// -----________--------_______--------_


// Spatialisateur mono (pour les jeux videos notamment)
SynthDef(\spat_mono, {
	arg bus, out=0, amp=0, pos=0, orientation=0.5, width=2;
	var sig;

	sig = In.ar(bus,  1);
	sig = PanAz.ar(12, sig, pos, 1.0, width, orientation);

	sig = sig * amp.dbamp;

	Out.ar(out, sig);
}).add;

// Spatialisateur stéréo avec positionnement indépendant pour chaque canal
SynthDef(\spat_stereo, {
	arg bus, out=0, amp=0, pos0=0, pos1=0.5, orientation=0.5, width=2;
	var sig, left, right, spatSig;

	sig = In.ar(bus, 2);

	// Spatialiser chaque canal indépendamment sur 12 HP
	sig = [
		sig[0],     // Enceinte 0 (canal gauche)
		sig[0],     // Enceinte 1 (canal gauche)
		sig[0],     // Enceinte 2 (canal gauche)
		sig[0],     // Enceinte 3 (canal gauche)
		sig[0],     // Enceinte 4 (canal gauche)
		sig[1],     // Enceinte 5 (canal gauche)
		sig[1],     // Enceinte 6 (canal gauche)
		sig[1],     // Enceinte 7 (canal gauche)
		sig[1],     // Enceinte 8 (canal gauche)
		sig[1],    // Enceinte 9 (canal droit)
		sig[1],   // Enceinte 10 (canal droit)
		sig[0]    // Enceinte 11 (canal droit)
	];
	//right = PanAz.ar(12, sig[1], pos1, 1.0, width, orientation);

	// Mixer les deux spatialisations
	// spatSig = left + right;
	sig = sig * amp.dbamp;

	Out.ar(out, sig);
}).add;

// Spatialisateur stéréo acousmonium avec routage manuel par enceinte
SynthDef(\spat_stereo_acousmonium, {
	arg bus, out=0, amp=0,
	    hp0_1=(-60), hp1_2=(-60), hp2_3=(-60), hp3_4=(-60),
	    hp4_5=(-60), hp5_6=(-60), hp6_7=(-60), hp7_8=(-60),
	    hp8_9=(-60), hp9_10=(-60), hp10_11=(-60), hp11_12=(-60);
	var sig, spatSig;

	sig = In.ar(bus, 2);

	// Créer 12 canaux avec routage manuel
	// Par défaut, aucun signal (tous à -60dB)
	// Canal gauche (sig[0]) -> HP 0-8
	// Canal droit (sig[1]) -> HP 9-11
	spatSig = [
		sig[0] * hp0_1.dbamp,     // Enceinte 0 (canal gauche)
		sig[0] * hp1_2.dbamp,     // Enceinte 1 (canal gauche)
		sig[0] * hp2_3.dbamp,     // Enceinte 2 (canal gauche)
		sig[0] * hp3_4.dbamp,     // Enceinte 3 (canal gauche)
		sig[0] * hp4_5.dbamp,     // Enceinte 4 (canal gauche)
		sig[0] * hp5_6.dbamp,     // Enceinte 5 (canal gauche)
		sig[0] * hp6_7.dbamp,     // Enceinte 6 (canal gauche)
		sig[0] * hp7_8.dbamp,     // Enceinte 7 (canal gauche)
		sig[0] * hp8_9.dbamp,     // Enceinte 8 (canal gauche)
		sig[1] * hp9_10.dbamp,    // Enceinte 9 (canal droit)
		sig[1] * hp10_11.dbamp,   // Enceinte 10 (canal droit)
		sig[1] * hp11_12.dbamp    // Enceinte 11 (canal droit)
	];

	spatSig = spatSig * amp.dbamp;

	Out.ar(out, spatSig);
}).add;


// ===== INPUT AUDIO SYNTHDEFS =====

// Entrée audio stéréo
// Version directe sans spatialisation - route vers les 2 premiers canaux du master
SynthDef(\audio_in_stereo_direct, {
	arg out=0, amp=0, inBus=0;
	var sig, outSig;

	sig = SoundIn.ar([inBus, inBus+1]);
	sig = sig * amp.dbamp;

	// Créer un signal de 12 canaux avec le stéréo sur les 2 premiers canaux
	outSig = [sig[0], sig[1]] ++ Silent.ar(10);

	Out.ar(out, outSig);
}).add;

// Version avec bus intermédiaire (commentée pour le moment)
SynthDef(\audio_in_stereo, {
	arg out=0, amp=0, inBus=0;
	var sig;

	sig = SoundIn.ar([inBus, inBus+1]);
	sig = sig * amp.dbamp;

	Out.ar(out, sig);
}).add;

// Entrée audio baya stéréo (inputs 14-15) -> bus mono
SynthDef(\audio_in_baya_mono, {
	arg out=0, amp=0, inBus=15;
	var sig;

	sig = SoundIn.ar(inBus);
	sig = sig * amp.dbamp;

	Out.ar(out, sig);
}).add;

// Spatialisateur mono pour baya avec PanAz
SynthDef(\spat_baya, {
	arg bus, out=0, amp=0, pos=0, width=2, orientation=0.5;
	var sig, spatSig;

	sig = In.ar(bus, 1);

	// Spatialiser le signal mono sur 12 HP avec PanAz
	spatSig = PanAz.ar(12, sig, pos, 1.0, width, orientation);
	spatSig = spatSig * amp.dbamp;

	Out.ar(out, spatSig);
}).add;

// Entrée audio multichannel (inputs 0-11) -> direct vers master
SynthDef(\audio_in_multichannel, {
	arg out=0, amp=0, inBus=0;
	var sig;

	// Lire 12 canaux depuis les entrées hardware
	sig = SoundIn.ar(Array.series(12, inBus, 1));
	sig = sig * amp.dbamp;

	Out.ar(out, sig);
}).add;

// ===== MASTER =====

// master qui fait la sommation et le filtrage des pistes vers les sub
// CF shema d'implémentation

SynthDef(\master_multichannel, {
	arg bus, out=0, amp=0, cross=120, fxon = 0;
	var sig, sub1, sub2, sub3, sub4, fx;

	sig = In.ar(bus, 12);
	// filtrage des subs en groupant des enceintes entre elles
	// en suivant le plan, mais aussi arbitrairement par groupement de 3
	// 13 == sub1 (enceintes 10, 11, 12)
	sub1 = ([sig[9], sig[10], sig[11]] * -10.dbamp).sum;
	sub1 = LPF.ar(sub1,cross);
	// 14 == sub2 (enceintes 1, 2, 9)
	sub2 = ([sig[0], sig[1], sig[8]] * -10.dbamp).sum;
	sub2 = LPF.ar(sub2,cross);
	// 15 == sub3 (enceintes 3, 7, 8)
	sub3 = ([sig[2], sig[6], sig[7]] * -10.dbamp).sum;
	sub3 = LPF.ar(sub3,cross);
	// 16 == sub4 (enceintes 4, 5, 6)
	sub4 = ([sig[9], sig[10], sig[11]] * -10.dbamp).sum;
	sub4 = LPF.ar(sub4,cross);

	sig = HPF.ar(sig, cross);

	// ajout d'un effet
	// fx = Decimator.ar(sig, 48000, 16);
	fx = CombC.ar(sig, 0.125, LFNoise2.ar(0.89).linlin(-1,1,0.01,0.75), 1, 0.8);
	fx = fx + DelayN.ar(CombC.ar(fx, 1,0.075*4, 1, 0.8), 0.2, 0.1);
	fx = GlitchBRF.ar(fx, LFNoise2.ar(1.5).linlin(-1,1,250,5000), 0.05);


	sig = sig + (fx * fxon.lag(0.99));
	sig = sig ++ sub1 ++ sub2 ++ sub3 ++ sub4;

	sig = sig * amp.dbamp.lag(1);
	Out.ar(out, sig);
}).add;

)

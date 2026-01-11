(
// ===== MASTER MULTICHANNEL =====
// Bus master et synth de sortie

// SynthDef master multichannel output
// master qui fait la sommation et le filtrage des pistes vers les sub
// CF shema d'implémentation

SynthDef(\master_multichannel, {
	arg in, out=0, amp=0, cross=120;
	var sig, sub1, sub2, sub3, sub4;

	sig = In.ar(in, 12);
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
	sig = sig ++ sub1 ++ sub2 ++ sub3 ++ sub4;

	sig = sig * amp.dbamp.lag(10);
	Out.ar(out, sig);
}).add;

// Créer le bus et le synth master
~makeNode_master = {
	s.bind({
		// Créer le bus master (12 canaux)
		~bus_master = Bus.audio(s, 12);

		// Créer le synth master (sort sur 16 canaux: 12 HP + 4 subs)
		~master_multichannel = Synth.new(
			\master_multichannel,
			[
				\amp, 0,
				\in, ~bus_master,
				\out, 0
			],
			~masterGrp
		);
		"Master: Bus and synth created (12 channels -> 16 outputs with subs)".postln;
	});
};

)

(
// ===== MASTER MULTICHANNEL =====
// Bus master et synth de sortie

// 1. Créer le bus master (12 canaux)
~makeBus_master = {
	~bus[\master_multichannel] = Bus.audio(s, 12);
	"Master: Bus created (12 channels)".postln;
};

// 2. SynthDef master déjà défini dans synthdefs.scd

// 3. Créer le synth master
~makeNode_master = {
	s.bind({
		~master_multichannel = Synth.new(
			\master_multichannel,
			[
				\amp, 0,
				\bus, ~bus[\master_multichannel],
				\out, 0
			],
			~masterGrp
		);
		"Master: Master synth created".postln;
	});
};

)

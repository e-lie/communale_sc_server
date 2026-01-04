(
// ===== MASTER MULTICHANNEL =====
// Bus master et synth de sortie

// SynthDef master déjà défini dans synthdefs.scd

// Créer le bus et le synth master
~makeNode_master = {
	s.bind({
		// Créer le bus master (12 canaux)
		~bus_master = Bus.audio(s, 12);

		// Créer le synth master
		~master_multichannel = Synth.new(
			\master_multichannel,
			[
				\amp, 0,
				\bus, ~bus_master,
				\out, 0
			],
			~masterGrp
		);
		"Master: Bus and synth created (12 channels)".postln;
	});
};

)

(
// ===== MASTER MULTICHANNEL =====
// Bus master et synth de sortie

// SynthDef master multichannel output
SynthDef(\master_multichannel, {
	arg bus, out=0, amp=0;
	var sig;

	sig = In.ar(bus, 12);
	sig = sig * amp.dbamp.lag(2);
	Out.ar(out, sig);
}).add;

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

(
~makeNodes = {
	// OSCFunc.trace(false)
	s.bind({
		~mainGrp = Group.new;
		~spatGrp = Group.after(~mainGrp);
		~masterGrp = Group.after(~spatGrp);

// pos -- jeu popup 0.35
		~spat_jeu_1 = Synth.new(
			\spat_mono,
			[
				\amp, 0,
				\pos, 0.35,
				\bus, ~bus[\popup_samples],
				\out, ~bus[\master_multichannel]
			],
			~spatGrp
		);
// pos 0 -- jeu mirror
		~spat_jeu_2 = Synth.new(
			\spat_mono,
			[
				\amp, 0,
				\pos, 0,
				\bus, ~bus[\mirror_samples],
				\out, ~bus[\master_multichannel]
			],
			~spatGrp
		);

		~spat_jeu_3 = Synth.new(
			\spat_mono,
			[
				\amp, 0,
				\pos, 0.9,
				\bus, ~bus[\words_samples],
				\out, ~bus[\master_multichannel]
			],
			~spatGrp
		);
		// ~spat_jeu_3.set(\pos, 0.9);

		~spat_jeu_cursed = Synth.new(
			\spat_mono,
			[
				\amp, 0,
				\pos, 0.7,
				\bus, ~bus[\cursed_samples],
				\out, ~bus[\master_multichannel]
			],
			~spatGrp
		);

		~spat_stereo = Synth.new(
			\spat_stereo,
			[
				\amp, 0,
				\bus, ~bus[\sample_player_stereo],
				\out, ~bus[\master_multichannel]
			],
			~spatGrp
		);

		~master_multichannel = Synth.new(
			\master_multichannel,
			[
				\amp, 0,
				\bus, ~bus[\master_multichannel],
				\out, 0,
			],
			~masterGrp
		);

		// ===== INPUT AUDIO SYNTHS =====

		// Input stereo avec spatialisation (deux chaînes parallèles)
		~input_stereo_synth = Synth.new(
			\audio_in_stereo,
			[
				\amp, 0,
				\inBus, 0,  // Hardware input bus (canaux 0-1)
				\out, ~bus[\input_stereo]
			],
			~mainGrp
		);

		// Chaîne de spatialisation 1 (initiale)
		~spat_input_stereo = Synth.new(
			\spat_stereo,
			[
				\amp, 0,      // Commence à 0dB (chaîne initiale active par défaut)
				\pos0, 0,     // Position du canal gauche (0-2)
				\pos1, 0.5,   // Position du canal droit (0-2)
				\bus, ~bus[\input_stereo],
				\out, ~bus[\master_multichannel]
			],
			~spatGrp
		);

		// Chaîne de spatialisation 2 (acousmonium)
		~spat_input_stereo_acousmonium = Synth.new(
			\spat_stereo_acousmonium,
			[
				\amp, -60,    // Commence silencieux
				\pos0, 0,     // Position du canal gauche (0-2)
				\pos1, 0.5,   // Position du canal droit (0-2)
				\bus, ~bus[\input_stereo],
				\out, ~bus[\master_multichannel]
			],
			~spatGrp
		);

		// ===== INPUT BAYA SYNTHS =====

		// Input baya mono (hardware input 15)
		~input_baya_synth = Synth.new(
			\audio_in_baya_mono,
			[
				\amp, 0,
				\inBus, 15,
				\out, ~bus[\input_baya]
			],
			~mainGrp
		);

		// Chaîne de spatialisation baya
		~spat_baya = Synth.new(
			\spat_baya,
			[
				\amp, 0,      // Commence à 0dB
				\pos, 0,      // Position initiale (0-2)
				\bus, ~bus[\input_baya],
				\out, ~bus[\master_multichannel]
			],
			~spatGrp
		);

		// ===== INPUT MULTICHANNEL SYNTH =====

		// Input multichannel direct (hardware inputs 0-11)
		~input_multichannel_synth = Synth.new(
			\audio_in_multichannel,
			[
				\amp, 0,
				\inBus, 0,  // Hardware input bus (canaux 0-11)
				\out, ~bus[\master_multichannel]
			],
			~mainGrp
		);

		// Version directe (commentée)
		// ~input_stereo_synth = Synth.new(
		// 	\audio_in_stereo_direct,
		// 	[
		// 		\amp, 0,
		// 		\inBus, 0,
		// 		\out, ~bus[\master_multichannel]
		// 	],
		// 	~mainGrp
		// );

	});
};
)


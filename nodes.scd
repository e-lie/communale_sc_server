(
~makeNodes = {

	s.bind({
		~mainGrp = Group.new;
		~spatGrp = Group.after(~mainGrp);
		~masterGrp = Group.after(~spatGrp);

		~spat_jeu_1 = Synth.new(
			\spat_mono,
			[
				\amp, 0,
				\bus, ~bus[\jeu_1_samples],
				\out, ~bus[\master_multichannel]
			],
			~spatGrp
		);

		~spat_jeu_2 = Synth.new(
			\spat_mono,
			[
				\amp, 0,
				\bus, ~bus[\jeu_2_samples],
				\out, ~bus[\master_multichannel]
			],
			~spatGrp
		);

		~spat_jeu_3 = Synth.new(
			\spat_mono,
			[
				\amp, 0,
				\bus, ~bus[\jeu_3_samples],
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


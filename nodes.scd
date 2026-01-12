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

		// Input stereo synth and spat
		~input_stereo_synth = Synth.new(
			\audio_in_stereo,
			[
				\amp, 0,
				\inBus, 0,  // Hardware input bus (canaux 0-1)
				\out, ~bus[\input_stereo]
			],
			~mainGrp
		);

		~spat_input_stereo = Synth.new(
			\spat_stereo,
			[
				\amp, 0,
				\in, ~bus[\input_stereo],
				\out, ~bus[\master_multichannel]
			],
			~spatGrp
		);

		// Input quad synth and spat
		~input_quad_synth = Synth.new(
			\audio_in_quad,
			[
				\amp, 0,
				\inBus, 0,  // Hardware input bus (canaux 0-3)
				\out, ~bus[\input_quad]
			],
			~mainGrp
		);

		~spat_input_quad = Synth.new(
			\spat_quad,
			[
				\amp, 0,
				\in, ~bus[\input_quad],
				\out, ~bus[\master_multichannel]
			],
			~spatGrp
		);

		// Input octo synth and spat
		~input_octo_synth = Synth.new(
			\audio_in_octo,
			[
				\amp, 0,
				\inBus, 0,  // Hardware input bus (canaux 0-7)
				\out, ~bus[\input_octo]
			],
			~mainGrp
		);

		~spat_input_octo = Synth.new(
			\spat_octo,
			[
				\amp, 0,
				\in, ~bus[\input_octo],
				\out, ~bus[\master_multichannel]
			],
			~spatGrp
		);


	});
};
)


(
~makeNodes = {

	s.bind({
		~mainGrp = Group.new;
		~spatGrp = Group.after(~mainGrp);
		~masterGrp = Group.after(~spatGrp);

		~spat_jeu_1 = Synth.new(
			\spat_samples,
			[
				\amp, 0,
				\bus, ~bus[\jeu_1_samples],
				\out, ~bus[\master_multichannel]
			],
			~spatGrp
		);

		~spat_jeu_2 = Synth.new(
			\spat_samples,
			[
				\amp, 0,
				\bus, ~bus[\jeu_2_samples],
				\out, ~bus[\master_multichannel]
			],
			~spatGrp
		);

		~spat_jeu_3 = Synth.new(
			\spat_samples,
			[
				\amp, 0,
				\bus, ~bus[\jeu_3_samples],
				\out, ~bus[\master_multichannel]
			],
			~spatGrp
		);

		~spat_bande_son = Synth.new(
			\spat_bande_son,
			[
				\amp, 0,
				\bus, ~bus[\bande_son],
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


	});
};
)


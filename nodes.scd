(
~makeNodes = {

	s.bind({
		~mainGrp = Group.new;
		~spatGrp = Group.after(~mainGrp);
		~masterGrp = Group.after(~spatGrp);



		~master_multichannel = Synth.new(
			\master_multichannel,
			[
				\amp, 0,
				\in, ~bus[\master_multichannel],
				\out, 0,
			],
			~masterGrp
		);


	});
};
)


(

~makeBusses = {

	~bus = Dictionary.new;
	~bus.add(\jeu_1_samples -> Bus.audio(s,1));
	~bus.add(\jeu_2_samples -> Bus.audio(s,1));
	~bus.add(\jeu_3_samples -> Bus.audio(s,1));

	~bus.add(\sample_player_stereo -> Bus.audio(s,2));

	// Input audio buses
	~bus.add(\input_stereo -> Bus.audio(s,2));
	~bus.add(\input_quad -> Bus.audio(s,4));
	~bus.add(\input_octo -> Bus.audio(s,8));

	~bus.add(\master_multichannel -> Bus.audio(s,12));
};

)



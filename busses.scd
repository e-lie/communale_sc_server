(

~makeBusses = {

	~bus = Dictionary.new;
	~bus.add(\popup_samples -> Bus.audio(s,1));
	~bus.add(\mirror_samples -> Bus.audio(s,1));
	~bus.add(\words_samples -> Bus.audio(s,1));
	~bus.add(\cursed_samples -> Bus.audio(s,1));

	~bus.add(\sample_player_stereo -> Bus.audio(s,2));

	// Input audio buses
	~bus.add(\input_stereo -> Bus.audio(s,2));
	~bus.add(\input_baya -> Bus.audio(s,1));

	~bus.add(\master_multichannel -> Bus.audio(s,12));
};

)



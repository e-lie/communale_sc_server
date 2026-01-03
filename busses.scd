(

~makeBusses = {

	~bus = Dictionary.new;
	~bus.add(\jeu_1_samples -> Bus.audio(s,1));
	~bus.add(\jeu_2_samples -> Bus.audio(s,1));
	~bus.add(\jeu_3_samples -> Bus.audio(s,1));

	~bus.add(\bande_son -> Bus.audio(s,2));

	~bus.add(\master_multichannel -> Bus.audio(s,12));
};

)

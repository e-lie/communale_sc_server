(

~makeBusses = {

	~bus = Dictionary.new;
	~bus.add(\samples -> Bus.audio(s,1));
	~bus.add(\bande_son -> Bus.audio(s,2));

	~bus.add(\master_multichannel -> Bus.audio(s,12));

};

)

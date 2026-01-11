(
// ===== ALARM =====
// OSC trigger pour alarme (pas de bus ni spat, sort directement sur master)

// OSC trigger pour alarme
~makeEvent_alarm = {
	OSCdef(\alarm, {
		arg msg, time, addr, recvPort;

		// Create the synth
		~virgule = Routine{
			var atk=0.25, rel=12, freq=440, rate=1;
			~spat = Synth(\alarm, [\amp, 0, \atk, atk, \rel, rel, \freq,freq, \rate, rate, \out, ~bus_master]);
			(atk*2).wait;
			~spat.set(\freq, freq/2);
			~spat.set(\rate, rate/2);
			(rel/3).wait;
			~spat.set(\rate, rate*10);
			0.1.wait;
			~spat.set(\rate, rate*100);
			(rel/12).wait;
			10.do{
				arg i;
				~spat.set(\rate, rate*(100 + (i*10)));
				~spat.set(\freq, freq * i);

				0.2.wait;
			}
		}.play;

	}, '/alarm');

	"Alarm: OSC handler /alarm initialized".postln;
};

)

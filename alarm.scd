(
SynthDef(\alarm, {
	arg freq= 220, out=0, amp=(-5), rate=1, pos=0.0, shape=0.5, atk=1, rel=2;
	var sig, mod, wave, env;


	env = EnvGen.ar(Env([0,1,0], [atk, rel], [4, -2]), doneAction:2);


	freq = freq.lag(5);
	rate = rate.lag(5);
	// alterne deux hauteurs
	sig = SinOsc.ar((freq/2) * ((LFSaw.ar(rate).linlin(-1,1,0,2)%1)+1).round(1), mul:0.6);
	// sirene haute
	wave = SinOsc.ar((freq*2) * SinOsc.ar(rate).linlin(-1,1,1,2), mul:0.6);
	wave = SineShaper.ar(wave,shape.lag(2));

	sig = (sig +
		Limiter.ar(
			Ringz.ar(sig, SinOsc.ar(rate/8).linlin(-1,1,freq, freq*2), 0.5, mul:1)))
	* 0.2;
	// les faire jouer ensemble
	sig = Splay.ar(sig + wave).sum;
	sig = sig * amp.dbamp * env;
	// circulaire
	sig = PanAz.ar(12, sig, LFSaw.ar(rate).linlin(-1,1,0.0,2.0));
	Out.ar(out,sig);
}).add;
)

s.record(numChannels:12);

~spat = Synth(\alarm, [\amp, -35]);
~spat = Synth(\alarm, [\amp, -35]);
~spat.set(\rate, 1);
~spat.set(\freq, 200);
~spat.set(\shape, 0.2);

(
~virgule = Routine{
	var atk=0.25, rel=12, freq=440, rate=1;
	~spat = Synth(\alarm, [\amp, 0, \atk, atk, \rel, rel, \freq,freq, \rate, rate]);
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
)

/*

TESTS MULTICHANNEL
s.options.numOutputBusChannels_(8);

{LFSaw.ar(1)}.plot(1)

(
SynthDef(\demo_train, {
	arg rate=1, out1=0, out2=4, amp=(-35), freq=220, rel=0.5, atk=0.1;
	var sig1, sig2, env, pos;

	// pos = LFSaw.ar(rate);

	pos = EnvGen.ar(Env([0,1,1], [atk, rel], [4, -4]));
	env = Env.perc(atk*1.5, rel).ar(Done.freeSelf);

	sig1 = PinkNoise.ar(0.3) * env;
	sig2 = PinkNoise.ar(0.3) * env;

	sig1 = PanAz.ar(4, sig1, pos);
	sig2 = PanAz.ar(4, sig2, 1-pos, 1, 2.0);


	Out.ar(out1, sig1 * amp.dbamp);
	Out.ar(out2, sig2 * amp.dbamp);
}).add;
)

~train = Synth(\demo_train, [\atk,1.05, \rel, 0.005]);
~train.set(\amp, 0);
~train.set(\rate, );

(
SynthDef(\ping_pong, {
	arg rate=1, out=0, amp=(-5), freq=440, rel=0.5, atk=0.01;
	var sig, env, pos, delay;

	env = EnvGen.ar(Env([0,1,0], [atk, rel], [-4, 4]), doneAction:2);

	sig = Pulse.ar(freq * LFNoise2.ar(10).linlin(-1,1,0.95,1.05));
	sig = sig!4;
	sig = sig * env;

	Out.ar(out, sig * amp.dbamp);
}).add;
)

~gauche = Synth(\ping_pong, [\out, 0, \amp, -5,\atk, 0.1, \freq, 220, \rel, 0.5]);
(
~routine.stop;
~routine = Routine{
	inf.do{
		var w = 0.5, n=[60,60,60*1.5, 60, 120, 240];

		w.wait;
		~gauche = Synth(\ping_pong, [\out, 0, \amp, -35,\atk, 0.01, \freq, n.choose, \rel, w/4]);
		(w*[1,2].choose).wait;
		~droite = Synth(\ping_pong, [\out, 4, \amp, -35,\atk, 0.05, \freq, n.choose, \rel, w/rrand(2,4)]);

	}
}.play;
)

*/

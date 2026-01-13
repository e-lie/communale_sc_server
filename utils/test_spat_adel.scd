(
~route = Routine{
	inf.do{
		arg i;
		i = ((i*rrand(0.01,1.99))%2).postln;

		// i= 1.75;

		// ~adel.sendMsg("/space", 0.2);
			~adel.sendMsg("/space", i);

		~spat_jeu_3.set(\pos, i);
		~spat_jeu_3.set(\width, 1.5);


			// Créer le synth
			~jeu1Synth = Synth(\sample_player_mono, [
			\buf, ~buffers[\words_win][rrand(0,3)],
				\amp, -10,
				\out, ~bus[\words_samples],
			\rate, rrand(10.0,0.15),
			], ~mainGrp);



		0.125.wait;
	}
}.play;
)
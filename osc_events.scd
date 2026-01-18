
// Function to create OSC event handlers
~makeEvents = {

	// -----________--------_______--------_
	// JEU 1 --
	// -----________--------_______--------_

	OSCdef(\popup, {
		arg msg, time, addr, recvPort;
		var sampleDir, sampleIndex, retrig, rate, leBuf, jeu1Synth, numSamples;

		// Parse OSC arguments with defaults
		// Concaténer "popup_" avec msg[1] pour former le nom du dossier
		sampleDir = ("popup_" ++ msg[1]).asSymbol;  // Convertir en Symbol pour l'accès au dictionnaire

		// Vérifier si le dossier existe dans ~buffers
		if (~buffers[sampleDir].notNil, {
			// Obtenir le nombre de samples dans ce dossier
			numSamples = ~buffers[sampleDir].size;

			// Si msg[2] est fourni, l'utiliser, sinon prendre un index aléatoire
			sampleIndex = msg[2] ? numSamples.rand;
			retrig = msg[3] ? 0;
			rate = msg[4] ? 1;

			// Récupérer le buffer
			leBuf = ~buffers[sampleDir][sampleIndex];

			~adel.sendMsg("/popup", msg[0], msg[1], msg[2], msg[3], msg[4]);

			"Sample player triggered: sampleDir=% sampleIndex=% (of %) retrig=% rate=%".format(
				sampleDir, sampleIndex, numSamples, retrig, rate
			).postln;

			// Créer le synth
			jeu1Synth = Synth(\sample_player_mono, [
				\buf, leBuf,
				\amp, -3,
				\out, ~bus[\popup_samples],
				\rate, rate,
				\kill, retrig
			], ~mainGrp);

		}, {
			"Error: Sample directory '%' not found in buffers!".format(sampleDir).postln;
		});

	}, '/popup');

	"OSC event handlers initialized (/popup)".postln;


	// -----________--------_______--------_
	// JEU 2 --
	// -----________--------_______--------_

	///
	//color -- params -- crash > créer les dossier de samples
	OSCdef(\mirror, {
		arg msg, time, addr, recvPort;
		var sampleDir, sampleIndex, retrig, rate, leBuf, jeu1Synth, numSamples;

		// Parse OSC arguments with defaults
		// Concaténer "popup_" avec msg[1] pour former le nom du dossier
		sampleDir = ("mirror_" ++ msg[1]).asSymbol;  // Convertir en Symbol pour l'accès au dictionnaire

		// Vérifier si le dossier existe dans ~buffers
		if (~buffers[sampleDir].notNil, {
			// Obtenir le nombre de samples dans ce dossier
			numSamples = ~buffers[sampleDir].size;

			// Si msg[2] est fourni, l'utiliser, sinon prendre un index aléatoire
			sampleIndex = msg[2] ? numSamples.rand;
			retrig = msg[3] ? 0;
			rate = msg[4] ? 1;

			// Récupérer le buffer
			leBuf = ~buffers[sampleDir][sampleIndex];

			"Sample player triggered: sampleDir=% sampleIndex=% (of %) retrig=% rate=%".format(
				sampleDir, sampleIndex, numSamples, retrig, rate
			).postln;

			// if (msg[1] == "crash", {
			~adel.sendMsg("/mirror", msg[0], msg[1], msg[2], msg[3], msg[4]);

			// Créer le synth
			jeu1Synth = Synth(\sample_player_mono, [
				\buf, leBuf,
				\amp, -3,
				\out, ~bus[\mirror_samples],
				\rate, rate,
				\kill, retrig
			], ~mainGrp);

		}, {
			"Error: Sample directory '%' not found in buffers!".format(sampleDir).postln;
		});

	}, '/mirror');

	"OSC event handlers initialized (/popup)".postln;

	// -----________--------_______--------_
	// JEU 3 --
	// -----________--------_______--------_

	OSCdef(\words, {
		arg msg, time, addr, recvPort;
		var sampleDir, sampleIndex, retrig, rate, leBuf, jeu1Synth, numSamples;

		// Parse OSC arguments with defaults
		// Concaténer "popup_" avec msg[1] pour former le nom du dossier
		sampleDir = ("words_" ++ msg[1]).asSymbol;  // Convertir en Symbol pour l'accès au dictionnaire

		// Vérifier si le dossier existe dans ~buffers
		if (~buffers[sampleDir].notNil, {
			// Obtenir le nombre de samples dans ce dossier
			numSamples = ~buffers[sampleDir].size;

			// Si msg[2] est fourni, l'utiliser, sinon prendre un index aléatoire
			sampleIndex = msg[2] ? numSamples.rand;
			retrig = msg[3] ? 0;
			rate = msg[4] ? 1;

			// Récupérer le buffer
			leBuf = ~buffers[sampleDir][sampleIndex];

			~adel.sendMsg("/words", msg[0], msg[1], msg[2], msg[3], msg[4]);

			"Sample player triggered: sampleDir=% sampleIndex=% (of %) retrig=% rate=%".format(
				sampleDir, sampleIndex, numSamples, retrig, rate
			).postln;

			// Créer le synth
			jeu1Synth = Synth(\sample_player_mono, [
				\buf, leBuf,
				\amp, -3,
				\out, ~bus[\words_samples],
				\rate, rate,
				\kill, retrig
			], ~mainGrp);

		}, {
			"Error: Sample directory '%' not found in buffers!".format(sampleDir).postln;
		});

	}, '/words');

	"OSC event handlers initialized (/word)".postln;

	// -----________--------_______--------_
	// JEU CURSED --
	// -----________--------_______--------_

	OSCdef(\cursed, {
		arg msg, time, addr, recvPort;
		var sampleDir, sampleIndex, retrig, rate, leBuf, jeu1Synth, numSamples;

		// Parse OSC arguments with defaults
		// Concaténer "cursed_" avec msg[1] pour former le nom du dossier
		sampleDir = ("cursed_" ++ msg[1]).asSymbol;  // Convertir en Symbol pour l'accès au dictionnaire

		// Vérifier si le dossier existe dans ~buffers
		if (~buffers[sampleDir].notNil, {
			// Obtenir le nombre de samples dans ce dossier
			numSamples = ~buffers[sampleDir].size;

			// Si msg[2] est fourni, l'utiliser, sinon prendre un index aléatoire
			sampleIndex = msg[2] ? numSamples.rand;
			retrig = msg[3] ? 0;
			rate = msg[4] ? 1;

			// Récupérer le buffer
			leBuf = ~buffers[sampleDir][sampleIndex];

			~adel.sendMsg("/cursed", msg[0], msg[1], msg[2], msg[3], msg[4]);

			"Sample player triggered: sampleDir=% sampleIndex=% (of %) retrig=% rate=%".format(
				sampleDir, sampleIndex, numSamples, retrig, rate
			).postln;

			// Créer le synth
			jeu1Synth = Synth(\sample_player_mono, [
				\buf, leBuf,
				\amp, -3,
				\out, ~bus[\cursed_samples],
				\rate, rate,
				\kill, retrig
			], ~mainGrp);

		}, {
			"Error: Sample directory '%' not found in buffers!".format(sampleDir).postln;
		});

	}, '/cursed');

	"OSC event handlers initialized (/cursed)".postln;


	// -----________--------_______--------_
	// les mots de baya --
	// -----________--------_______--------_

	OSCdef(\lesmotsdebaya, {
		arg msg, time, addr, recvPort;
		var pos;

		pos = msg[0];

		~spat_baya.set(\pos, pos);

	}, '/lesmots');

	"OSC event handlers initialized (/lesmots)".postln;



	// -----________--------_______--------_
	// ALARM -- main bouton -- jackpot tout part à volo
	// -----________--------_______--------_

	OSCdef(\alarm, {
		arg msg, time, addr, recvPort;
		var virgule;

		// Create the synth
		virgule = Routine{
			var atk=0.25, rel=12, freq=440, rate=1;
			~spat = Synth(\alarm, [\amp, -30, \atk, atk, \rel, rel, \freq,freq, \rate, rate, \out, ~bus[\master_multichannel]]);
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

	"OSC event handlers initialized (/alarm)".postln;

	// -----________--------_______--------_
	// LEVIER -- levier principale -- basculement du décor
	// -----________--------_______--------_

	OSCdef(\levier, {
		arg msg, time, addr, recvPort, posPopup = 0.35, posMirror=0.0, posWords = 0.9, posCursed = 0.7;
		var virgule, panic_popup, panic_mirror, panic_words, panic_cursed;

		// déplacement simple dans l'espace des réaction des jeux
		~spat_jeu_1.set(\pos, posPopup + msg[1]);
		~spat_jeu_2.set(\pos, posMirror + msg[1]);
		~spat_jeu_3.set(\pos, posWords + msg[1]);
		~spat_jeu_cursed.set(\pos, posCursed + msg[1]);

		panic_popup = Synth(\sample_player_mono, [
			\buf, ~buffers[\panic][(0..4).choose],
			\amp, -3,
			\out, ~bus[\popup_samples],
			\rate, rrand(0.5, 1.8),
			\atk, 0.001,
			\rel, rrand(0.05,0.15),
			\loop, 1,
			\kill, 1
		], ~mainGrp);

		panic_mirror = Synth(\sample_player_mono, [
			\buf, ~buffers[\panic][(0..4).choose],
			\amp, -3,
			\out, ~bus[\mirror_samples],
			\rate, rrand(0.5, 1.8),
			\atk, 0.001,
			\rel, rrand(0.05,0.15),
			\loop, 1,
			\kill, 1
		], ~mainGrp);

		panic_words = Synth(\sample_player_mono, [
			\buf, ~buffers[\panic][(0..4).choose],
			\amp, -3,
			\out, ~bus[\words_samples],
			\rate, rrand(0.5, 1.3),
			\atk, 0.001,
			\rel, rrand(0.05,0.15),
			\loop, 1,
			\kill, 1
		], ~mainGrp);

		panic_cursed = Synth(\sample_player_mono, [
			\buf, ~buffers[\panic][(0..4).choose],
			\amp, -3,
			\out, ~bus[\cursed_samples],
			\rate, rrand(0.5, 1.2),
			\atk, 0.001,
			\rel, rrand(0.05,0.15),
			\loop, 1,
			\kill, 1
		], ~mainGrp);

	}, '/levier');

	"OSC event handlers initialized (/levier)".postln;
};

// ~makeEvents.print;
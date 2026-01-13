
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
				\out, ~bus[\popup_samples],
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
	// ALARM --
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

};

// ~makeEvents.print;
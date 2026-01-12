(
// ===== MIDI CONNECTION =====
// Gestion des connexions MIDI et des contrôleurs

~connect_midi_devices = {
	arg deviceName;

	MIDIClient.init;
	MIDIIn.connectAll;

	"MIDI: Devices connected".postln;
	"Available MIDI sources:".postln;
	MIDIClient.sources.do { |src, i|
		"  %: %".format(i, src.name).postln;
	};

	// ===== MASTER VOLUME - CC 84 =====
	MIDIdef.cc(\masterVolume, {
		arg val, num, chan, src;
		var dbVal, sliderVal;

		// Convertir la valeur MIDI (0-127) en dB (-30 à 0)
		dbVal = val.linlin(0, 127, -30, 0);
		sliderVal = val.linlin(0, 127, 0, 1);

	
		~master_multichannel.set(\amp, dbVal);


		// Mettre à jour le GUI si il existe
		if (~guiMasterVolSlider.notNil, {
			{
				~guiMasterVolSlider.value = sliderVal;
				~guiMasterVolLabel.string = dbVal.round(0.1).asString ++ "dB";
				~guiMasterVolNumBox.value = dbVal;
			}.defer;
		});

	}, 20); // CC number 84

	"MIDI: CC 20 mapped to Master Volume (-30dB to 0dB)".postln;

	// ===== INPUT STEREO VOLUME - CC 36 =====
	MIDIdef.cc(\inputStereoVolume, {
		arg val, num, chan, src;
		var dbVal, sliderVal;

		// Convertir la valeur MIDI (0-127) en dB (-30 à 0)
		dbVal = val.linlin(0, 127, -30, 0);
		sliderVal = val.linlin(0, 127, 0, 1);

		// Mettre à jour le synth spat input stereo
		~spat_input_stereo.set(\amp, dbVal);

		// Mettre à jour le GUI si il existe
		if (~guiInputStereoSlider.notNil, {
			{
				~guiInputStereoSlider.value = sliderVal;
				~guiInputStereoLabel.string = dbVal.round(0.1).asString ++ "dB";
				~guiInputStereoNumBox.value = dbVal;
			}.defer;
		});

	}, 36); // CC number 36

	"MIDI: CC 36 mapped to Input Stereo Volume (-30dB to 0dB)".postln;

	// ===== INPUT BAYA VOLUME - CC 19 =====
	MIDIdef.cc(\inputBayaVolume, {
		arg val, num, chan, src;
		var dbVal, sliderVal;

		// Convertir la valeur MIDI (0-127) en dB (-30 à 0)
		dbVal = val.linlin(0, 127, -30, 0);
		sliderVal = val.linlin(0, 127, 0, 1);

		// Mettre à jour le synth spat baya
		~spat_baya.set(\amp, dbVal);

		// Mettre à jour le GUI si il existe
		if (~guiInputBayaSlider.notNil, {
			{
				~guiInputBayaSlider.value = sliderVal;
				~guiInputBayaLabel.string = dbVal.round(0.1).asString ++ "dB";
				~guiInputBayaNumBox.value = dbVal;
			}.defer;
		});

	}, 19); // CC number 19

	"MIDI: CC 19 mapped to Input Baya Volume (-30dB to 0dB)".postln;

	// ===== INPUT STEREO POS0 (LEFT) - CC 13 =====
	MIDIdef.cc(\inputStereoPos0, {
		arg val, num, chan, src;
		var posVal;

		// Convertir la valeur MIDI (0-127) en position PanAz (0 à 2)
		posVal = val.linlin(0, 127, 0, 2);

		// Mettre à jour la position du canal gauche
		~spat_input_stereo.set(\pos0, posVal);

	}, 13); // CC number 13

	"MIDI: CC 13 mapped to Input Stereo Position 0 (Left channel, 0 to 2)".postln;

	// ===== INPUT STEREO POS1 (RIGHT) - CC 29 =====
	MIDIdef.cc(\inputStereoPos1, {
		arg val, num, chan, src;
		var posVal;

		// Convertir la valeur MIDI (0-127) en position PanAz (0 à 2)
		posVal = val.linlin(0, 127, 0, 2);

		// Mettre à jour la position du canal droit
		~spat_input_stereo.set(\pos1, posVal);

	}, 29); // CC number 29

	"MIDI: CC 29 mapped to Input Stereo Position 1 (Right channel, 0 to 2)".postln;

	// ===== INPUT BAYA POS - CC 35 =====
	MIDIdef.cc(\inputBayaPos, {
		arg val, num, chan, src;
		var posVal;

		// Convertir la valeur MIDI (0-127) en position PanAz (0 à 2)
		posVal = val.linlin(0, 127, 0, 2);

		// Mettre à jour la position baya
		~spat_baya.set(\pos, posVal);

	}, 35); // CC number 35

	"MIDI: CC 35 mapped to Input Baya Position (0 to 2)".postln;

	// ===== INPUT STEREO CROSSFADE - CC 49 =====
	MIDIdef.cc(\inputStereoCrossfade, {
		arg val, num, chan, src;
		var amp1, amp2, crossfade;

		// Convertir la valeur MIDI (0-127) en crossfade (0.0 à 1.0)
		// 0 = chaîne initiale, 63 = mix 50/50, 127 = acousmonium
		crossfade = val.linlin(0, 127, 0.0, 1.0);

		// Calculer les amplitudes avec un crossfade de puissance égale
		// chaîne initiale: pleine amplitude à 0, silence à 127
		amp1 = ((1.0 - crossfade) * 60).linlin(0, 60, -60, 0);
		// chaîne acousmonium: silence à 0, pleine amplitude à 127
		amp2 = (crossfade * 60).linlin(0, 60, -60, 0);

		// Mettre à jour les amplitudes des deux chaînes
		~spat_input_stereo.set(\amp, amp1);
		~spat_input_stereo_acousmonium.set(\amp, amp2);

	}, 49); // CC number 49

	"MIDI: CC 49 mapped to Input Stereo Crossfade (0=initial, 63=mix, 127=acousmonium)".postln;

	// ===== ACOUSMONIUM HP 0 & 11 - CC 77 =====
	MIDIdef.cc(\acousmoniumHP0_11, {
		arg val, num, chan, src;
		var dbVal;

		// Convertir la valeur MIDI (0-127) en dB (-50 à 0)
		dbVal = val.linlin(0, 127, -50, 0);

		// Mettre à jour les enceintes 0 (left->HP0) et 11 (right->HP11)
		~spat_input_stereo_acousmonium.set(\hp0_1, dbVal);
		~spat_input_stereo_acousmonium.set(\hp11_12, dbVal);

	}, 77); // CC number 77

	"MIDI: CC 77 mapped to Acousmonium HP 0 & 11 (-50dB to 0dB)".postln;

	// ===== ACOUSMONIUM HP 1, 2, 9, 10 - CC 78 =====
	MIDIdef.cc(\acousmoniumHP1_2_9_10, {
		arg val, num, chan, src;
		var dbVal;

		// Convertir la valeur MIDI (0-127) en dB (-50 à 0)
		dbVal = val.linlin(0, 127, -50, 0);

		// Mettre à jour les enceintes:
		// Canal 0 (left) -> HP 1 et 2
		~spat_input_stereo_acousmonium.set(\hp1_2, dbVal);
		~spat_input_stereo_acousmonium.set(\hp2_3, dbVal);
		// Canal 1 (right) -> HP 9 et 10
		~spat_input_stereo_acousmonium.set(\hp9_10, dbVal);
		~spat_input_stereo_acousmonium.set(\hp10_11, dbVal);

	}, 78); // CC number 78

	"MIDI: CC 78 mapped to Acousmonium HP 1, 2, 9, 10 (-50dB to 0dB)".postln;

	// ===== ACOUSMONIUM HP 3, 4, 7, 8 - CC 79 =====
	MIDIdef.cc(\acousmoniumHP3_4_7_8, {
		arg val, num, chan, src;
		var dbVal;

		// Convertir la valeur MIDI (0-127) en dB (-50 à 0)
		dbVal = val.linlin(0, 127, -50, 0);

		// Mettre à jour les enceintes:
		// Canal 0 (left) -> HP 3 et 4
		~spat_input_stereo_acousmonium.set(\hp3_4, dbVal);
		~spat_input_stereo_acousmonium.set(\hp4_5, dbVal);
		// Canal 1 (right) -> HP 7 et 8
		~spat_input_stereo_acousmonium.set(\hp7_8, dbVal);
		~spat_input_stereo_acousmonium.set(\hp8_9, dbVal);

	}, 79); // CC number 79

	"MIDI: CC 79 mapped to Acousmonium HP 3, 4, 7, 8 (-50dB to 0dB)".postln;

	// ===== ACOUSMONIUM HP 5, 6 - CC 80 =====
	MIDIdef.cc(\acousmoniumHP5_6, {
		arg val, num, chan, src;
		var dbVal;

		// Convertir la valeur MIDI (0-127) en dB (-50 à 0)
		dbVal = val.linlin(0, 127, -50, 0);

		// Mettre à jour les enceintes:
		// Canal 0 (left) -> HP 5
		~spat_input_stereo_acousmonium.set(\hp5_6, dbVal);
		// Canal 1 (right) -> HP 6
		~spat_input_stereo_acousmonium.set(\hp6_7, dbVal);

	}, 80); // CC number 80

	"MIDI: CC 80 mapped to Acousmonium HP 5, 6 (-50dB to 0dB)".postln;

	// ===== ACOUSMONIUM HP 0-1-2, 3-4-5 - CC 81 =====
	MIDIdef.cc(\acousmoniumHP0_1_2_3_4_5, {
		arg val, num, chan, src;
		var dbVal;

		// Convertir la valeur MIDI (0-127) en dB (-50 à 0)
		dbVal = val.linlin(0, 127, -50, 0);

		// Mettre à jour les enceintes:
		// Canal 0 (left) -> HP 0, 1, 2
		~spat_input_stereo_acousmonium.set(\hp0_1, dbVal);
		~spat_input_stereo_acousmonium.set(\hp1_2, dbVal);
		~spat_input_stereo_acousmonium.set(\hp2_3, dbVal);
		// Canal 1 (right) -> HP 3, 4, 5
		~spat_input_stereo_acousmonium.set(\hp3_4, dbVal);
		~spat_input_stereo_acousmonium.set(\hp4_5, dbVal);
		~spat_input_stereo_acousmonium.set(\hp5_6, dbVal);

	}, 81); // CC number 81

	"MIDI: CC 81 mapped to Acousmonium HP 0-1-2 (left), 3-4-5 (right) (-50dB to 0dB)".postln;

	// ===== ACOUSMONIUM HP 11-10-9, 8-7-6 - CC 82 =====
	MIDIdef.cc(\acousmoniumHP11_10_9_8_7_6, {
		arg val, num, chan, src;
		var dbVal;

		// Convertir la valeur MIDI (0-127) en dB (-50 à 0)
		dbVal = val.linlin(0, 127, -50, 0);

		// Mettre à jour les enceintes:
		// Canal 0 (left) -> HP 11, 10, 9
		~spat_input_stereo_acousmonium.set(\hp11_12, dbVal);
		~spat_input_stereo_acousmonium.set(\hp10_11, dbVal);
		~spat_input_stereo_acousmonium.set(\hp9_10, dbVal);
		// Canal 1 (right) -> HP 8, 7, 6
		~spat_input_stereo_acousmonium.set(\hp8_9, dbVal);
		~spat_input_stereo_acousmonium.set(\hp7_8, dbVal);
		~spat_input_stereo_acousmonium.set(\hp6_7, dbVal);

	}, 82); // CC number 82

	"MIDI: CC 82 mapped to Acousmonium HP 11-10-9 (left), 8-7-6 (right) (-50dB to 0dB)".postln;

	// ===== ACOUSMONIUM HP 0-5, 6-11 - CC 83 =====
	MIDIdef.cc(\acousmoniumHP0_5_6_11, {
		arg val, num, chan, src;
		var dbVal;

		// Convertir la valeur MIDI (0-127) en dB (-50 à 0)
		dbVal = val.linlin(0, 127, -50, 0);

		// Mettre à jour les enceintes:
		// Canal 0 (left) -> HP 0 à 5
		~spat_input_stereo_acousmonium.set(\hp0_1, dbVal);
		~spat_input_stereo_acousmonium.set(\hp1_2, dbVal);
		~spat_input_stereo_acousmonium.set(\hp2_3, dbVal);
		~spat_input_stereo_acousmonium.set(\hp3_4, dbVal);
		~spat_input_stereo_acousmonium.set(\hp4_5, dbVal);
		~spat_input_stereo_acousmonium.set(\hp5_6, dbVal);
		// Canal 1 (right) -> HP 6 à 11
		~spat_input_stereo_acousmonium.set(\hp6_7, dbVal);
		~spat_input_stereo_acousmonium.set(\hp7_8, dbVal);
		~spat_input_stereo_acousmonium.set(\hp8_9, dbVal);
		~spat_input_stereo_acousmonium.set(\hp9_10, dbVal);
		~spat_input_stereo_acousmonium.set(\hp10_11, dbVal);
		~spat_input_stereo_acousmonium.set(\hp11_12, dbVal);

	}, 83); // CC number 83

	"MIDI: CC 83 mapped to Acousmonium HP 0-5 (left), 6-11 (right) (-50dB to 0dB)".postln;
};

)

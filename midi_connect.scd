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

	// ===== MASTER VOLUME =====
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

	}, 58);

	"MIDI: CC 58 mapped to Master Volume (-30dB to 0dB)".postln; // 58midimix 20lcxl

	// ===== INPUT STEREO VOLUME =====
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

	}, 59);

	"MIDI: CC 59 mapped to Input Stereo Volume (-30dB to 0dB)".postln; // 59midimix 36 lcxl

	// ===== INPUT BAYA VOLUME =====
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

	}, 54);

	"MIDI: CC 54 mapped to Input Baya Volume (-30dB to 0dB)".postln; // midimix 54 lcxl 19

	// ===== INPUT MULTICHANNEL VOLUME =====
	MIDIdef.cc(\inputMultichannelVolume, {
		arg val, num, chan, src;
		var dbVal, sliderVal;

		// Convertir la valeur MIDI (0-127) en dB (-30 à 0)
		dbVal = val.linlin(0, 127, -30, 0);
		sliderVal = val.linlin(0, 127, 0, 1);

		// Mettre à jour le synth input multichannel
		~input_multichannel_synth.set(\amp, dbVal);

		// Mettre à jour le GUI si il existe
		if (~guiInputMultichannelSlider.notNil, {
			{
				~guiInputMultichannelSlider.value = sliderVal;
				~guiInputMultichannelLabel.string = dbVal.round(0.1).asString ++ "dB";
				~guiInputMultichannelNumBox.value = dbVal;
			}.defer;
		});

	}, 60);

	"MIDI: CC 60 mapped to Input Multichannel Volume (-30dB to 0dB)".postln; // midimix 60 lcxl 56

	// ===== INPUT STEREO POS0 (LEFT) =====
	MIDIdef.cc(\inputStereoPos0, {
		arg val, num, chan, src;
		var posVal, sliderVal;

		// Convertir la valeur MIDI (0-127) en position PanAz (0 à 2)
		posVal = val.linlin(0, 127, 0, 2);
		sliderVal = val.linlin(0, 127, 0, 1);

		// Mettre à jour la position du canal gauche
		~spat_input_stereo.set(\pos0, posVal);

		// Mettre à jour le GUI si il existe
		if (~guiPosLeftSlider.notNil, {
			{
				~guiPosLeftSlider.value = sliderVal;
				~guiPosLeftLabel.string = posVal.round(0.01).asString;
				~guiPosLeftNumBox.value = posVal;
			}.defer;
		});

	}, 16);

	"MIDI: CC 16 mapped to Input Stereo Position 0 (Left channel, 0 to 2)".postln; // midimix 16 lcxl 13

	// ===== INPUT STEREO POS1 (RIGHT) =====
	MIDIdef.cc(\inputStereoPos1, {
		arg val, num, chan, src;
		var posVal, sliderVal;

		// Convertir la valeur MIDI (0-127) en position PanAz (0 à 2)
		posVal = val.linlin(0, 127, 0, 2);
		sliderVal = val.linlin(0, 127, 0, 1);

		// Mettre à jour la position du canal droit
		~spat_input_stereo.set(\pos1, posVal);

		// Mettre à jour le GUI si il existe
		if (~guiPosRightSlider.notNil, {
			{
				~guiPosRightSlider.value = sliderVal;
				~guiPosRightLabel.string = posVal.round(0.01).asString;
				~guiPosRightNumBox.value = posVal;
			}.defer;
		});

	}, 17);

	"MIDI: CC 17 mapped to Input Stereo Position 1 (Right channel, 0 to 2)".postln; // midimix 17 lcxl 29

	// ===== INPUT BAYA POS - CC 35 =====
	MIDIdef.cc(\inputBayaPos, {
		arg val, num, chan, src;
		var posVal, sliderVal;

		// Convertir la valeur MIDI (0-127) en position PanAz (0 à 2)
		posVal = val.linlin(0, 127, 0, 2);
		sliderVal = val.linlin(0, 127, 0, 1);

		// Mettre à jour la position baya
		~spat_baya.set(\pos, posVal);

		// Mettre à jour le GUI si il existe
		if (~guiBayaPosSlider.notNil, {
			{
				~guiBayaPosSlider.value = sliderVal;
				~guiBayaPosLabel.string = posVal.round(0.01).asString;
				~guiBayaPosNumBox.value = posVal;
			}.defer;
		});

	}, 35); // CC number 35

	"MIDI: CC 35 mapped to Input Baya Position (0 to 2)".postln;

	// ===== INPUT STEREO CROSSFADE =====
	MIDIdef.cc(\inputStereoCrossfade, {
		arg val, num, chan, src;
		var amp1, amp2, crossfade, sliderVal;

		// Convertir la valeur MIDI (0-127) en crossfade (0.0 à 1.0)
		// 0 = chaîne initiale, 63 = mix 50/50, 127 = acousmonium
		crossfade = val.linlin(0, 127, 0.0, 1.0);
		sliderVal = val.linlin(0, 127, 0, 1);

		// Calculer les amplitudes avec un crossfade de puissance égale
		// chaîne initiale: pleine amplitude à 0, silence à 127
		amp1 = ((1.0 - crossfade) * 60).linlin(0, 60, -60, 0);
		// chaîne acousmonium: silence à 0, pleine amplitude à 127
		amp2 = (crossfade * 60).linlin(0, 60, -60, 0);

		// Mettre à jour les amplitudes des deux chaînes
		~spat_input_stereo.set(\amp, amp1);
		~spat_input_stereo_acousmonium.set(\amp, amp2);

		// Mettre à jour le GUI si il existe
		if (~guiCrossfadeSlider.notNil, {
			{
				~guiCrossfadeSlider.value = sliderVal;
				~guiCrossfadeLabel.string = crossfade.round(0.01).asString;
				~guiCrossfadeNumBox.value = crossfade;
			}.defer;
		});

	}, 18);

	"MIDI: CC 18 mapped to Input Stereo Crossfade (0=initial, 63=mix, 127=acousmonium)".postln; //midimix 18 lcxl 49

	// ===== ACOUSMONIUM HP 0 & 11 - CC 77 =====
	MIDIdef.cc(\acousmoniumHP0_11, {
		arg val, num, chan, src;
		var dbVal, sliderVal;

		// Convertir la valeur MIDI (0-127) en dB (-50 à 0)
		dbVal = val.linlin(0, 127, -50, 0);
		sliderVal = val.linlin(0, 127, 0, 1);

		// Mettre à jour les enceintes 0 (left->HP0) et 11 (right->HP11)
		~spat_input_stereo_acousmonium.set(\hp0_1, dbVal);
		~spat_input_stereo_acousmonium.set(\hp11_12, dbVal);

		// Mettre à jour le GUI si il existe
		if (~guiAcousHP0_11Slider.notNil, {
			{
				~guiAcousHP0_11Slider.value = sliderVal;
				~guiAcousHP0_11Label.string = dbVal.round(0.1).asString ++ "dB";
				~guiAcousHP0_11NumBox.value = dbVal;
			}.defer;
		});

	}, 77); // CC number 77

	"MIDI: CC 77 mapped to Acousmonium HP 0 & 11 (-50dB to 0dB)".postln;

	// ===== ACOUSMONIUM HP 1, 2, 9, 10 - CC 78 =====
	MIDIdef.cc(\acousmoniumHP1_2_9_10, {
		arg val, num, chan, src;
		var dbVal, sliderVal;

		// Convertir la valeur MIDI (0-127) en dB (-50 à 0)
		dbVal = val.linlin(0, 127, -50, 0);
		sliderVal = val.linlin(0, 127, 0, 1);

		// Mettre à jour les enceintes:
		// Canal 0 (left) -> HP 1 et 2
		~spat_input_stereo_acousmonium.set(\hp1_2, dbVal);
		~spat_input_stereo_acousmonium.set(\hp2_3, dbVal);
		// Canal 1 (right) -> HP 9 et 10
		~spat_input_stereo_acousmonium.set(\hp9_10, dbVal);
		~spat_input_stereo_acousmonium.set(\hp10_11, dbVal);

		// Mettre à jour le GUI si il existe
		if (~guiAcousHP1_2_9_10Slider.notNil, {
			{
				~guiAcousHP1_2_9_10Slider.value = sliderVal;
				~guiAcousHP1_2_9_10Label.string = dbVal.round(0.1).asString ++ "dB";
				~guiAcousHP1_2_9_10NumBox.value = dbVal;
			}.defer;
		});

	}, 78); // CC number 78

	"MIDI: CC 78 mapped to Acousmonium HP 1, 2, 9, 10 (-50dB to 0dB)".postln;

	// ===== ACOUSMONIUM HP 3, 4, 7, 8 - CC 79 =====
	MIDIdef.cc(\acousmoniumHP3_4_7_8, {
		arg val, num, chan, src;
		var dbVal, sliderVal;

		// Convertir la valeur MIDI (0-127) en dB (-50 à 0)
		dbVal = val.linlin(0, 127, -50, 0);
		sliderVal = val.linlin(0, 127, 0, 1);

		// Mettre à jour les enceintes:
		// Canal 0 (left) -> HP 3 et 4
		~spat_input_stereo_acousmonium.set(\hp3_4, dbVal);
		~spat_input_stereo_acousmonium.set(\hp4_5, dbVal);
		// Canal 1 (right) -> HP 7 et 8
		~spat_input_stereo_acousmonium.set(\hp7_8, dbVal);
		~spat_input_stereo_acousmonium.set(\hp8_9, dbVal);

		// Mettre à jour le GUI si il existe
		if (~guiAcousHP3_4_7_8Slider.notNil, {
			{
				~guiAcousHP3_4_7_8Slider.value = sliderVal;
				~guiAcousHP3_4_7_8Label.string = dbVal.round(0.1).asString ++ "dB";
				~guiAcousHP3_4_7_8NumBox.value = dbVal;
			}.defer;
		});

	}, 79); // CC number 79

	"MIDI: CC 79 mapped to Acousmonium HP 3, 4, 7, 8 (-50dB to 0dB)".postln;

	// ===== ACOUSMONIUM HP 5, 6 - CC 80 =====
	MIDIdef.cc(\acousmoniumHP5_6, {
		arg val, num, chan, src;
		var dbVal, sliderVal;

		// Convertir la valeur MIDI (0-127) en dB (-50 à 0)
		dbVal = val.linlin(0, 127, -50, 0);
		sliderVal = val.linlin(0, 127, 0, 1);

		// Mettre à jour les enceintes:
		// Canal 0 (left) -> HP 5
		~spat_input_stereo_acousmonium.set(\hp5_6, dbVal);
		// Canal 1 (right) -> HP 6
		~spat_input_stereo_acousmonium.set(\hp6_7, dbVal);

		// Mettre à jour le GUI si il existe
		if (~guiAcousHP5_6Slider.notNil, {
			{
				~guiAcousHP5_6Slider.value = sliderVal;
				~guiAcousHP5_6Label.string = dbVal.round(0.1).asString ++ "dB";
				~guiAcousHP5_6NumBox.value = dbVal;
			}.defer;
		});

	}, 80); // CC number 80

	"MIDI: CC 80 mapped to Acousmonium HP 5, 6 (-50dB to 0dB)".postln;

	// ===== ACOUSMONIUM HP 0-1-2, 3-4-5 - CC 81 =====
	MIDIdef.cc(\acousmoniumHP0_1_2_3_4_5, {
		arg val, num, chan, src;
		var dbVal, sliderVal;

		// Convertir la valeur MIDI (0-127) en dB (-50 à 0)
		dbVal = val.linlin(0, 127, -50, 0);
		sliderVal = val.linlin(0, 127, 0, 1);

		// Mettre à jour les enceintes:
		// Canal 0 (left) -> HP 0, 1, 2
		~spat_input_stereo_acousmonium.set(\hp0_1, dbVal);
		~spat_input_stereo_acousmonium.set(\hp1_2, dbVal);
		~spat_input_stereo_acousmonium.set(\hp2_3, dbVal);
		// Canal 1 (right) -> HP 3, 4, 5
		~spat_input_stereo_acousmonium.set(\hp3_4, dbVal);
		~spat_input_stereo_acousmonium.set(\hp4_5, dbVal);
		~spat_input_stereo_acousmonium.set(\hp5_6, dbVal);

		// Mettre à jour le GUI si il existe
		if (~guiAcousHP0_1_2_3_4_5Slider.notNil, {
			{
				~guiAcousHP0_1_2_3_4_5Slider.value = sliderVal;
				~guiAcousHP0_1_2_3_4_5Label.string = dbVal.round(0.1).asString ++ "dB";
				~guiAcousHP0_1_2_3_4_5NumBox.value = dbVal;
			}.defer;
		});

	}, 81); // CC number 81

	"MIDI: CC 81 mapped to Acousmonium HP 0-1-2 (left), 3-4-5 (right) (-50dB to 0dB)".postln;

	// ===== ACOUSMONIUM HP 11-10-9, 8-7-6 - CC 82 =====
	MIDIdef.cc(\acousmoniumHP11_10_9_8_7_6, {
		arg val, num, chan, src;
		var dbVal, sliderVal;

		// Convertir la valeur MIDI (0-127) en dB (-50 à 0)
		dbVal = val.linlin(0, 127, -50, 0);
		sliderVal = val.linlin(0, 127, 0, 1);

		// Mettre à jour les enceintes:
		// Canal 0 (left) -> HP 11, 10, 9
		~spat_input_stereo_acousmonium.set(\hp11_12, dbVal);
		~spat_input_stereo_acousmonium.set(\hp10_11, dbVal);
		~spat_input_stereo_acousmonium.set(\hp9_10, dbVal);
		// Canal 1 (right) -> HP 8, 7, 6
		~spat_input_stereo_acousmonium.set(\hp8_9, dbVal);
		~spat_input_stereo_acousmonium.set(\hp7_8, dbVal);
		~spat_input_stereo_acousmonium.set(\hp6_7, dbVal);

		// Mettre à jour le GUI si il existe
		if (~guiAcousHP11_10_9_8_7_6Slider.notNil, {
			{
				~guiAcousHP11_10_9_8_7_6Slider.value = sliderVal;
				~guiAcousHP11_10_9_8_7_6Label.string = dbVal.round(0.1).asString ++ "dB";
				~guiAcousHP11_10_9_8_7_6NumBox.value = dbVal;
			}.defer;
		});

	}, 82); // CC number 82

	"MIDI: CC 82 mapped to Acousmonium HP 11-10-9 (left), 8-7-6 (right) (-50dB to 0dB)".postln;

	// ===== ACOUSMONIUM HP 0-5, 6-11 - CC 83 =====
	MIDIdef.cc(\acousmoniumHP0_5_6_11, {
		arg val, num, chan, src;
		var dbVal, sliderVal;

		// Convertir la valeur MIDI (0-127) en dB (-50 à 0)
		dbVal = val.linlin(0, 127, -50, 0);
		sliderVal = val.linlin(0, 127, 0, 1);

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

		// Mettre à jour le GUI si il existe
		if (~guiAcousHP0_5_6_11Slider.notNil, {
			{
				~guiAcousHP0_5_6_11Slider.value = sliderVal;
				~guiAcousHP0_5_6_11Label.string = dbVal.round(0.1).asString ++ "dB";
				~guiAcousHP0_5_6_11NumBox.value = dbVal;
			}.defer;
		});

	}, 83); // CC number 83

	"MIDI: CC 83 mapped to Acousmonium HP 0-5 (left), 6-11 (right) (-50dB to 0dB)".postln;
};

)

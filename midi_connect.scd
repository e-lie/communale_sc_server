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

		// Mettre à jour le synth master
		~master_multichannel.set(\amp, dbVal);

		// Mettre à jour le GUI si il existe
		if (~guiMasterVolSlider.notNil, {
			{
				~guiMasterVolSlider.value = sliderVal;
				~guiMasterVolLabel.string = dbVal.round(0.1).asString ++ "dB";
				~guiMasterVolNumBox.value = dbVal;
			}.defer;
		});

		// "Master Volume (CC 84): MIDI=% -> %dB".format(val, dbVal.round(0.1)).postln;

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
};

)

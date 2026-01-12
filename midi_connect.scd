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

		// Convertir la valeur MIDI (0-127) en dB (-60 à +12)
		dbVal = val.linlin(0, 127, -60, 12);
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

	}, 84); // CC number 84

	"MIDI: CC 84 mapped to Master Volume (-60dB to +12dB)".postln;
};

)

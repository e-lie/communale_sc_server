(
// ===== GUI - Interface graphique de contrôle =====

~makeGUI = {
	var win, masterVolSlider, masterVolLabel, masterVolNumBox;
	var inputStereoSlider, inputStereoLabel, inputStereoNumBox;

	// Créer la fenêtre principale
	win = Window("Communale SC Server - Control", Rect(100, 100, 400, 600))
		.front
		.onClose_({
			"GUI closed".postln;
		});

	win.layout = VLayout(
		// ===== MASTER VOLUME =====
		HLayout(
			StaticText().string_("MASTER VOLUME").font_(Font.default.boldVariant),
		),
		HLayout(
			StaticText().string_("Volume:").minWidth_(80),
			masterVolSlider = Slider()
				.orientation_(\horizontal)
				.value_(0.5)
				.action_({ |sl|
					var dbVal = sl.value.linlin(0, 1, -60, 12);
					~master_multichannel.set(\amp, dbVal);
					masterVolNumBox.value = dbVal;
					masterVolLabel.string = dbVal.round(0.1) + "dB";
				}),
			masterVolLabel = StaticText().string_("0.0 dB").minWidth_(60),
			masterVolNumBox = NumberBox()
				.value_(0)
				.minWidth_(60)
				.action_({ |nb|
					var slVal = nb.value.linlin(-60, 12, 0, 1);
					masterVolSlider.value = slVal;
					~master_multichannel.set(\amp, nb.value);
					masterVolLabel.string = nb.value.round(0.1) + "dB";
				})
		),

		// Séparateur
		StaticText().string_("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"),

		// ===== INPUTS AUDIO =====
		HLayout(
			StaticText().string_("INPUT STEREO").font_(Font.default.boldVariant),
		),
		HLayout(
			StaticText().string_("Volume:").minWidth_(80),
			inputStereoSlider = Slider()
				.orientation_(\horizontal)
				.value_(0.5)
				.action_({ |sl|
					var dbVal = sl.value.linlin(0, 1, -30, 0);
					~spat_input_stereo.set(\amp, dbVal);
					inputStereoNumBox.value = dbVal;
					inputStereoLabel.string = dbVal.round(0.1) + "dB";
				}),
			inputStereoLabel = StaticText().string_("0.0 dB").minWidth_(60),
			inputStereoNumBox = NumberBox()
				.value_(0)
				.minWidth_(60)
				.action_({ |nb|
					var slVal = nb.value.linlin(-30, 0, 0, 1);
					inputStereoSlider.value = slVal;
					~spat_input_stereo.set(\amp, nb.value);
					inputStereoLabel.string = nb.value.round(0.1) + "dB";
				})
		),

		// Espace vide pour pousser tout en haut
		nil
	);

	// Stocker la fenêtre et les widgets pour pouvoir les fermer/modifier plus tard
	~guiWindow = win;
	~guiMasterVolSlider = masterVolSlider;
	~guiMasterVolLabel = masterVolLabel;
	~guiMasterVolNumBox = masterVolNumBox;
	~guiInputStereoSlider = inputStereoSlider;
	~guiInputStereoLabel = inputStereoLabel;
	~guiInputStereoNumBox = inputStereoNumBox;

	"GUI created and displayed".postln;
};

)

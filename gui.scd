(
// ===== GUI - Interface graphique de contrôle =====

~makeGUI = {
	var win, masterVolSlider, masterVolLabel, masterVolNumBox;
	var inputStereoSlider, inputQuadSlider, inputOctoSlider;
	var jeu1Slider, jeu2Slider, jeu3Slider, bandeSonSlider;

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
			StaticText().string_("INPUTS AUDIO").font_(Font.default.boldVariant),
		),
		HLayout(
			StaticText().string_("Input Stereo:").minWidth_(80),
			inputStereoSlider = Slider()
				.orientation_(\horizontal)
				.value_(0.5)
				.action_({ |sl|
					var dbVal = sl.value.linlin(0, 1, -60, 12);
					~spat_input_stereo.set(\amp, dbVal);
				})
		),
		HLayout(
			StaticText().string_("Input Quad:").minWidth_(80),
			inputQuadSlider = Slider()
				.orientation_(\horizontal)
				.value_(0.5)
				.action_({ |sl|
					var dbVal = sl.value.linlin(0, 1, -60, 12);
					~spat_input_quad.set(\amp, dbVal);
				})
		),
		HLayout(
			StaticText().string_("Input Octo:").minWidth_(80),
			inputOctoSlider = Slider()
				.orientation_(\horizontal)
				.value_(0.5)
				.action_({ |sl|
					var dbVal = sl.value.linlin(0, 1, -60, 12);
					~spat_input_octo.set(\amp, dbVal);
				})
		),

		// Séparateur
		StaticText().string_("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"),

		// ===== JEUX & BANDE SON =====
		HLayout(
			StaticText().string_("JEUX & BANDE SON").font_(Font.default.boldVariant),
		),
		HLayout(
			StaticText().string_("Jeu 1:").minWidth_(80),
			jeu1Slider = Slider()
				.orientation_(\horizontal)
				.value_(0.5)
				.action_({ |sl|
					var dbVal = sl.value.linlin(0, 1, -60, 12);
					~spat_jeu1.set(\amp, dbVal);
				})
		),
		HLayout(
			StaticText().string_("Jeu 2:").minWidth_(80),
			jeu2Slider = Slider()
				.orientation_(\horizontal)
				.value_(0.5)
				.action_({ |sl|
					var dbVal = sl.value.linlin(0, 1, -60, 12);
					~spat_jeu2.set(\amp, dbVal);
				})
		),
		HLayout(
			StaticText().string_("Jeu 3:").minWidth_(80),
			jeu3Slider = Slider()
				.orientation_(\horizontal)
				.value_(0.5)
				.action_({ |sl|
					var dbVal = sl.value.linlin(0, 1, -60, 12);
					~spat_jeu3.set(\amp, dbVal);
				})
		),
		HLayout(
			StaticText().string_("Bande Son:").minWidth_(80),
			bandeSonSlider = Slider()
				.orientation_(\horizontal)
				.value_(0.5)
				.action_({ |sl|
					var dbVal = sl.value.linlin(0, 1, -60, 12);
					~spat_stereo.set(\amp, dbVal);
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

	"GUI created and displayed".postln;
};

)

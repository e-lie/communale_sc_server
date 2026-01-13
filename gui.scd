(
// ===== GUI - Interface graphique de contrôle =====

~makeGUI = {
	var win, scroll, container;
	var masterVolSlider, masterVolLabel, masterVolNumBox;
	var inputStereoSlider, inputStereoLabel, inputStereoNumBox;
	var inputBayaSlider, inputBayaLabel, inputBayaNumBox;
	var inputMultichannelSlider, inputMultichannelLabel, inputMultichannelNumBox;
	var inputStereoPos0Slider, inputStereoPos0Label, inputStereoPos0NumBox;
	var inputStereoPos1Slider, inputStereoPos1Label, inputStereoPos1NumBox;
	var inputBayaPosSlider, inputBayaPosLabel, inputBayaPosNumBox;
	var inputCrossfadeSlider, inputCrossfadeLabel, inputCrossfadeNumBox;
	var acousHP0_11Slider, acousHP0_11Label, acousHP0_11NumBox;
	var acousHP1_2_9_10Slider, acousHP1_2_9_10Label, acousHP1_2_9_10NumBox;
	var acousHP3_4_7_8Slider, acousHP3_4_7_8Label, acousHP3_4_7_8NumBox;
	var acousHP5_6Slider, acousHP5_6Label, acousHP5_6NumBox;
	var acousHP0_1_2_3_4_5Slider, acousHP0_1_2_3_4_5Label, acousHP0_1_2_3_4_5NumBox;
	var acousHP11_10_9_8_7_6Slider, acousHP11_10_9_8_7_6Label, acousHP11_10_9_8_7_6NumBox;
	var acousHP0_5_6_11Slider, acousHP0_5_6_11Label, acousHP0_5_6_11NumBox;

	// Créer la fenêtre principale avec scroll
	win = Window("Communale SC Server - Control", Rect(100, 100, 550, 800))
		.front
		.onClose_({
			"GUI closed".postln;
		});

	// Créer un ScrollView pour contenir tous les contrôles
	scroll = ScrollView(win, win.bounds.moveTo(0,0).insetBy(5,5))
		.hasVerticalScroller_(true)
		.hasHorizontalScroller_(false);

	container = View();
	container.layout = VLayout(
		// ===== MASTER VOLUME (CC 20) =====
		StaticText().string_("MASTER VOLUME (CC 20)").font_(Font.default.boldVariant),
		HLayout(
			StaticText().string_("Volume:").minWidth_(120),
			masterVolSlider = Slider()
				.orientation_(\horizontal)
				.value_(0.5)
				.action_({ |sl|
					var dbVal = sl.value.linlin(0, 1, -30, 0);
					~master_multichannel.set(\amp, dbVal);
					masterVolNumBox.value = dbVal;
					masterVolLabel.string = dbVal.round(0.1) + "dB";
				}),
			masterVolLabel = StaticText().string_("-15.0 dB").minWidth_(60),
			masterVolNumBox = NumberBox()
				.value_(-15)
				.minWidth_(60)
				.action_({ |nb|
					var slVal = nb.value.linlin(-30, 0, 0, 1);
					masterVolSlider.value = slVal;
					~master_multichannel.set(\amp, nb.value);
					masterVolLabel.string = nb.value.round(0.1) + "dB";
				})
		),

		// Séparateur
		StaticText().string_("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"),

		// ===== INPUT STEREO =====
		StaticText().string_("INPUT STEREO").font_(Font.default.boldVariant),
		HLayout(
			StaticText().string_("Volume (CC 36):").minWidth_(120),
			inputStereoSlider = Slider()
				.orientation_(\horizontal)
				.value_(0.5)
				.action_({ |sl|
					var dbVal = sl.value.linlin(0, 1, -30, 0);
					~spat_input_stereo.set(\amp, dbVal);
					inputStereoNumBox.value = dbVal;
					inputStereoLabel.string = dbVal.round(0.1) + "dB";
				}),
			inputStereoLabel = StaticText().string_("-15.0 dB").minWidth_(60),
			inputStereoNumBox = NumberBox()
				.value_(-15)
				.minWidth_(60)
				.action_({ |nb|
					var slVal = nb.value.linlin(-30, 0, 0, 1);
					inputStereoSlider.value = slVal;
					~spat_input_stereo.set(\amp, nb.value);
					inputStereoLabel.string = nb.value.round(0.1) + "dB";
				})
		),
		HLayout(
			StaticText().string_("Pos Left (CC 13):").minWidth_(120),
			inputStereoPos0Slider = Slider()
				.orientation_(\horizontal)
				.value_(0)
				.action_({ |sl|
					var posVal = sl.value.linlin(0, 1, 0, 2);
					~spat_input_stereo.set(\pos0, posVal);
					inputStereoPos0NumBox.value = posVal;
					inputStereoPos0Label.string = posVal.round(0.01);
				}),
			inputStereoPos0Label = StaticText().string_("0.00").minWidth_(60),
			inputStereoPos0NumBox = NumberBox()
				.value_(0)
				.minWidth_(60)
				.action_({ |nb|
					var slVal = nb.value.linlin(0, 2, 0, 1);
					inputStereoPos0Slider.value = slVal;
					~spat_input_stereo.set(\pos0, nb.value);
					inputStereoPos0Label.string = nb.value.round(0.01);
				})
		),
		HLayout(
			StaticText().string_("Pos Right (CC 29):").minWidth_(120),
			inputStereoPos1Slider = Slider()
				.orientation_(\horizontal)
				.value_(0.25)
				.action_({ |sl|
					var posVal = sl.value.linlin(0, 1, 0, 2);
					~spat_input_stereo.set(\pos1, posVal);
					inputStereoPos1NumBox.value = posVal;
					inputStereoPos1Label.string = posVal.round(0.01);
				}),
			inputStereoPos1Label = StaticText().string_("0.50").minWidth_(60),
			inputStereoPos1NumBox = NumberBox()
				.value_(0.5)
				.minWidth_(60)
				.action_({ |nb|
					var slVal = nb.value.linlin(0, 2, 0, 1);
					inputStereoPos1Slider.value = slVal;
					~spat_input_stereo.set(\pos1, nb.value);
					inputStereoPos1Label.string = nb.value.round(0.01);
				})
		),
		HLayout(
			StaticText().string_("Crossfade (CC 49):").minWidth_(120),
			inputCrossfadeSlider = Slider()
				.orientation_(\horizontal)
				.value_(0)
				.action_({ |sl|
					var crossfade = sl.value;
					var amp1 = ((1.0 - crossfade) * 60).linlin(0, 60, -60, 0);
					var amp2 = (crossfade * 60).linlin(0, 60, -60, 0);
					~spat_input_stereo.set(\amp, amp1);
					~spat_input_stereo_acousmonium.set(\amp, amp2);
					inputCrossfadeNumBox.value = (crossfade * 100);
					inputCrossfadeLabel.string = (crossfade * 100).round(1) ++ "%";
				}),
			inputCrossfadeLabel = StaticText().string_("0%").minWidth_(60),
			inputCrossfadeNumBox = NumberBox()
				.value_(0)
				.minWidth_(60)
				.action_({ |nb|
					var crossfade = nb.value / 100;
					var amp1 = ((1.0 - crossfade) * 60).linlin(0, 60, -60, 0);
					var amp2 = (crossfade * 60).linlin(0, 60, -60, 0);
					inputCrossfadeSlider.value = crossfade;
					~spat_input_stereo.set(\amp, amp1);
					~spat_input_stereo_acousmonium.set(\amp, amp2);
					inputCrossfadeLabel.string = nb.value.round(1) ++ "%";
				})
		),

		// Séparateur
		StaticText().string_("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"),

		// ===== INPUT BAYA =====
		StaticText().string_("INPUT BAYA").font_(Font.default.boldVariant),
		HLayout(
			StaticText().string_("Volume (CC 19):").minWidth_(120),
			inputBayaSlider = Slider()
				.orientation_(\horizontal)
				.value_(0.5)
				.action_({ |sl|
					var dbVal = sl.value.linlin(0, 1, -30, 0);
					~spat_baya.set(\amp, dbVal);
					inputBayaNumBox.value = dbVal;
					inputBayaLabel.string = dbVal.round(0.1) + "dB";
				}),
			inputBayaLabel = StaticText().string_("-15.0 dB").minWidth_(60),
			inputBayaNumBox = NumberBox()
				.value_(-15)
				.minWidth_(60)
				.action_({ |nb|
					var slVal = nb.value.linlin(-30, 0, 0, 1);
					inputBayaSlider.value = slVal;
					~spat_baya.set(\amp, nb.value);
					inputBayaLabel.string = nb.value.round(0.1) + "dB";
				})
		),
		HLayout(
			StaticText().string_("Position (CC 35):").minWidth_(120),
			inputBayaPosSlider = Slider()
				.orientation_(\horizontal)
				.value_(0)
				.action_({ |sl|
					var posVal = sl.value.linlin(0, 1, 0, 2);
					~spat_baya.set(\pos, posVal);
					inputBayaPosNumBox.value = posVal;
					inputBayaPosLabel.string = posVal.round(0.01);
				}),
			inputBayaPosLabel = StaticText().string_("0.00").minWidth_(60),
			inputBayaPosNumBox = NumberBox()
				.value_(0)
				.minWidth_(60)
				.action_({ |nb|
					var slVal = nb.value.linlin(0, 2, 0, 1);
					inputBayaPosSlider.value = slVal;
					~spat_baya.set(\pos, nb.value);
					inputBayaPosLabel.string = nb.value.round(0.01);
				})
		),

		// Séparateur
		StaticText().string_("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"),

		// ===== INPUT MULTICHANNEL =====
		StaticText().string_("INPUT MULTICHANNEL").font_(Font.default.boldVariant),
		HLayout(
			StaticText().string_("Volume (CC 56):").minWidth_(120),
			inputMultichannelSlider = Slider()
				.orientation_(\horizontal)
				.value_(0.5)
				.action_({ |sl|
					var dbVal = sl.value.linlin(0, 1, -30, 0);
					~input_multichannel_synth.set(\amp, dbVal);
					inputMultichannelNumBox.value = dbVal;
					inputMultichannelLabel.string = dbVal.round(0.1) + "dB";
				}),
			inputMultichannelLabel = StaticText().string_("-15.0 dB").minWidth_(60),
			inputMultichannelNumBox = NumberBox()
				.value_(-15)
				.minWidth_(60)
				.action_({ |nb|
					var slVal = nb.value.linlin(-30, 0, 0, 1);
					inputMultichannelSlider.value = slVal;
					~input_multichannel_synth.set(\amp, nb.value);
					inputMultichannelLabel.string = nb.value.round(0.1) + "dB";
				})
		),

		// Séparateur
		StaticText().string_("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"),

		// ===== ACOUSMONIUM CONTROLS =====
		StaticText().string_("ACOUSMONIUM SPEAKER GROUPS").font_(Font.default.boldVariant),
		HLayout(
			StaticText().string_("HP 0&11 (CC 77):").minWidth_(120),
			acousHP0_11Slider = Slider()
				.orientation_(\horizontal)
				.value_(0)
				.action_({ |sl|
					var dbVal = sl.value.linlin(0, 1, -50, 0);
					~spat_input_stereo_acousmonium.set(\hp0_1, dbVal);
					~spat_input_stereo_acousmonium.set(\hp11_12, dbVal);
					acousHP0_11NumBox.value = dbVal;
					acousHP0_11Label.string = dbVal.round(0.1) + "dB";
				}),
			acousHP0_11Label = StaticText().string_("-50.0 dB").minWidth_(60),
			acousHP0_11NumBox = NumberBox()
				.value_(-50)
				.minWidth_(60)
				.action_({ |nb|
					var slVal = nb.value.linlin(-50, 0, 0, 1);
					acousHP0_11Slider.value = slVal;
					~spat_input_stereo_acousmonium.set(\hp0_1, nb.value);
					~spat_input_stereo_acousmonium.set(\hp11_12, nb.value);
					acousHP0_11Label.string = nb.value.round(0.1) + "dB";
				})
		),
		HLayout(
			StaticText().string_("HP 1,2,9,10 (CC 78):").minWidth_(120),
			acousHP1_2_9_10Slider = Slider()
				.orientation_(\horizontal)
				.value_(0)
				.action_({ |sl|
					var dbVal = sl.value.linlin(0, 1, -50, 0);
					~spat_input_stereo_acousmonium.set(\hp1_2, dbVal);
					~spat_input_stereo_acousmonium.set(\hp2_3, dbVal);
					~spat_input_stereo_acousmonium.set(\hp9_10, dbVal);
					~spat_input_stereo_acousmonium.set(\hp10_11, dbVal);
					acousHP1_2_9_10NumBox.value = dbVal;
					acousHP1_2_9_10Label.string = dbVal.round(0.1) + "dB";
				}),
			acousHP1_2_9_10Label = StaticText().string_("-50.0 dB").minWidth_(60),
			acousHP1_2_9_10NumBox = NumberBox()
				.value_(-50)
				.minWidth_(60)
				.action_({ |nb|
					var slVal = nb.value.linlin(-50, 0, 0, 1);
					acousHP1_2_9_10Slider.value = slVal;
					~spat_input_stereo_acousmonium.set(\hp1_2, nb.value);
					~spat_input_stereo_acousmonium.set(\hp2_3, nb.value);
					~spat_input_stereo_acousmonium.set(\hp9_10, nb.value);
					~spat_input_stereo_acousmonium.set(\hp10_11, nb.value);
					acousHP1_2_9_10Label.string = nb.value.round(0.1) + "dB";
				})
		),
		HLayout(
			StaticText().string_("HP 3,4,7,8 (CC 79):").minWidth_(120),
			acousHP3_4_7_8Slider = Slider()
				.orientation_(\horizontal)
				.value_(0)
				.action_({ |sl|
					var dbVal = sl.value.linlin(0, 1, -50, 0);
					~spat_input_stereo_acousmonium.set(\hp3_4, dbVal);
					~spat_input_stereo_acousmonium.set(\hp4_5, dbVal);
					~spat_input_stereo_acousmonium.set(\hp7_8, dbVal);
					~spat_input_stereo_acousmonium.set(\hp8_9, dbVal);
					acousHP3_4_7_8NumBox.value = dbVal;
					acousHP3_4_7_8Label.string = dbVal.round(0.1) + "dB";
				}),
			acousHP3_4_7_8Label = StaticText().string_("-50.0 dB").minWidth_(60),
			acousHP3_4_7_8NumBox = NumberBox()
				.value_(-50)
				.minWidth_(60)
				.action_({ |nb|
					var slVal = nb.value.linlin(-50, 0, 0, 1);
					acousHP3_4_7_8Slider.value = slVal;
					~spat_input_stereo_acousmonium.set(\hp3_4, nb.value);
					~spat_input_stereo_acousmonium.set(\hp4_5, nb.value);
					~spat_input_stereo_acousmonium.set(\hp7_8, nb.value);
					~spat_input_stereo_acousmonium.set(\hp8_9, nb.value);
					acousHP3_4_7_8Label.string = nb.value.round(0.1) + "dB";
				})
		),
		HLayout(
			StaticText().string_("HP 5,6 (CC 80):").minWidth_(120),
			acousHP5_6Slider = Slider()
				.orientation_(\horizontal)
				.value_(0)
				.action_({ |sl|
					var dbVal = sl.value.linlin(0, 1, -50, 0);
					~spat_input_stereo_acousmonium.set(\hp5_6, dbVal);
					~spat_input_stereo_acousmonium.set(\hp6_7, dbVal);
					acousHP5_6NumBox.value = dbVal;
					acousHP5_6Label.string = dbVal.round(0.1) + "dB";
				}),
			acousHP5_6Label = StaticText().string_("-50.0 dB").minWidth_(60),
			acousHP5_6NumBox = NumberBox()
				.value_(-50)
				.minWidth_(60)
				.action_({ |nb|
					var slVal = nb.value.linlin(-50, 0, 0, 1);
					acousHP5_6Slider.value = slVal;
					~spat_input_stereo_acousmonium.set(\hp5_6, nb.value);
					~spat_input_stereo_acousmonium.set(\hp6_7, nb.value);
					acousHP5_6Label.string = nb.value.round(0.1) + "dB";
				})
		),
		HLayout(
			StaticText().string_("HP 0-2&3-5 (CC 81):").minWidth_(120),
			acousHP0_1_2_3_4_5Slider = Slider()
				.orientation_(\horizontal)
				.value_(0)
				.action_({ |sl|
					var dbVal = sl.value.linlin(0, 1, -50, 0);
					~spat_input_stereo_acousmonium.set(\hp0_1, dbVal);
					~spat_input_stereo_acousmonium.set(\hp1_2, dbVal);
					~spat_input_stereo_acousmonium.set(\hp2_3, dbVal);
					~spat_input_stereo_acousmonium.set(\hp3_4, dbVal);
					~spat_input_stereo_acousmonium.set(\hp4_5, dbVal);
					~spat_input_stereo_acousmonium.set(\hp5_6, dbVal);
					acousHP0_1_2_3_4_5NumBox.value = dbVal;
					acousHP0_1_2_3_4_5Label.string = dbVal.round(0.1) + "dB";
				}),
			acousHP0_1_2_3_4_5Label = StaticText().string_("-50.0 dB").minWidth_(60),
			acousHP0_1_2_3_4_5NumBox = NumberBox()
				.value_(-50)
				.minWidth_(60)
				.action_({ |nb|
					var slVal = nb.value.linlin(-50, 0, 0, 1);
					acousHP0_1_2_3_4_5Slider.value = slVal;
					~spat_input_stereo_acousmonium.set(\hp0_1, nb.value);
					~spat_input_stereo_acousmonium.set(\hp1_2, nb.value);
					~spat_input_stereo_acousmonium.set(\hp2_3, nb.value);
					~spat_input_stereo_acousmonium.set(\hp3_4, nb.value);
					~spat_input_stereo_acousmonium.set(\hp4_5, nb.value);
					~spat_input_stereo_acousmonium.set(\hp5_6, nb.value);
					acousHP0_1_2_3_4_5Label.string = nb.value.round(0.1) + "dB";
				})
		),
		HLayout(
			StaticText().string_("HP 11-9&8-6 (CC 82):").minWidth_(120),
			acousHP11_10_9_8_7_6Slider = Slider()
				.orientation_(\horizontal)
				.value_(0)
				.action_({ |sl|
					var dbVal = sl.value.linlin(0, 1, -50, 0);
					~spat_input_stereo_acousmonium.set(\hp11_12, dbVal);
					~spat_input_stereo_acousmonium.set(\hp10_11, dbVal);
					~spat_input_stereo_acousmonium.set(\hp9_10, dbVal);
					~spat_input_stereo_acousmonium.set(\hp8_9, dbVal);
					~spat_input_stereo_acousmonium.set(\hp7_8, dbVal);
					~spat_input_stereo_acousmonium.set(\hp6_7, dbVal);
					acousHP11_10_9_8_7_6NumBox.value = dbVal;
					acousHP11_10_9_8_7_6Label.string = dbVal.round(0.1) + "dB";
				}),
			acousHP11_10_9_8_7_6Label = StaticText().string_("-50.0 dB").minWidth_(60),
			acousHP11_10_9_8_7_6NumBox = NumberBox()
				.value_(-50)
				.minWidth_(60)
				.action_({ |nb|
					var slVal = nb.value.linlin(-50, 0, 0, 1);
					acousHP11_10_9_8_7_6Slider.value = slVal;
					~spat_input_stereo_acousmonium.set(\hp11_12, nb.value);
					~spat_input_stereo_acousmonium.set(\hp10_11, nb.value);
					~spat_input_stereo_acousmonium.set(\hp9_10, nb.value);
					~spat_input_stereo_acousmonium.set(\hp8_9, nb.value);
					~spat_input_stereo_acousmonium.set(\hp7_8, nb.value);
					~spat_input_stereo_acousmonium.set(\hp6_7, nb.value);
					acousHP11_10_9_8_7_6Label.string = nb.value.round(0.1) + "dB";
				})
		),
		HLayout(
			StaticText().string_("HP 0-5&6-11 (CC 83):").minWidth_(120),
			acousHP0_5_6_11Slider = Slider()
				.orientation_(\horizontal)
				.value_(0)
				.action_({ |sl|
					var dbVal = sl.value.linlin(0, 1, -50, 0);
					~spat_input_stereo_acousmonium.set(\hp0_1, dbVal);
					~spat_input_stereo_acousmonium.set(\hp1_2, dbVal);
					~spat_input_stereo_acousmonium.set(\hp2_3, dbVal);
					~spat_input_stereo_acousmonium.set(\hp3_4, dbVal);
					~spat_input_stereo_acousmonium.set(\hp4_5, dbVal);
					~spat_input_stereo_acousmonium.set(\hp5_6, dbVal);
					~spat_input_stereo_acousmonium.set(\hp6_7, dbVal);
					~spat_input_stereo_acousmonium.set(\hp7_8, dbVal);
					~spat_input_stereo_acousmonium.set(\hp8_9, dbVal);
					~spat_input_stereo_acousmonium.set(\hp9_10, dbVal);
					~spat_input_stereo_acousmonium.set(\hp10_11, dbVal);
					~spat_input_stereo_acousmonium.set(\hp11_12, dbVal);
					acousHP0_5_6_11NumBox.value = dbVal;
					acousHP0_5_6_11Label.string = dbVal.round(0.1) + "dB";
				}),
			acousHP0_5_6_11Label = StaticText().string_("-50.0 dB").minWidth_(60),
			acousHP0_5_6_11NumBox = NumberBox()
				.value_(-50)
				.minWidth_(60)
				.action_({ |nb|
					var slVal = nb.value.linlin(-50, 0, 0, 1);
					acousHP0_5_6_11Slider.value = slVal;
					~spat_input_stereo_acousmonium.set(\hp0_1, nb.value);
					~spat_input_stereo_acousmonium.set(\hp1_2, nb.value);
					~spat_input_stereo_acousmonium.set(\hp2_3, nb.value);
					~spat_input_stereo_acousmonium.set(\hp3_4, nb.value);
					~spat_input_stereo_acousmonium.set(\hp4_5, nb.value);
					~spat_input_stereo_acousmonium.set(\hp5_6, nb.value);
					~spat_input_stereo_acousmonium.set(\hp6_7, nb.value);
					~spat_input_stereo_acousmonium.set(\hp7_8, nb.value);
					~spat_input_stereo_acousmonium.set(\hp8_9, nb.value);
					~spat_input_stereo_acousmonium.set(\hp9_10, nb.value);
					~spat_input_stereo_acousmonium.set(\hp10_11, nb.value);
					~spat_input_stereo_acousmonium.set(\hp11_12, nb.value);
					acousHP0_5_6_11Label.string = nb.value.round(0.1) + "dB";
				})
		),

		// Espace vide pour pousser tout en haut
		nil
	);

	scroll.canvas = container;

	// Stocker TOUTES les références pour synchronisation MIDI bidirectionnelle
	~guiWindow = win;
	~guiMasterVolSlider = masterVolSlider;
	~guiMasterVolLabel = masterVolLabel;
	~guiMasterVolNumBox = masterVolNumBox;
	~guiInputStereoSlider = inputStereoSlider;
	~guiInputStereoLabel = inputStereoLabel;
	~guiInputStereoNumBox = inputStereoNumBox;
	~guiPosLeftSlider = inputStereoPos0Slider;
	~guiPosLeftLabel = inputStereoPos0Label;
	~guiPosLeftNumBox = inputStereoPos0NumBox;
	~guiPosRightSlider = inputStereoPos1Slider;
	~guiPosRightLabel = inputStereoPos1Label;
	~guiPosRightNumBox = inputStereoPos1NumBox;
	~guiCrossfadeSlider = inputCrossfadeSlider;
	~guiCrossfadeLabel = inputCrossfadeLabel;
	~guiCrossfadeNumBox = inputCrossfadeNumBox;
	~guiInputBayaSlider = inputBayaSlider;
	~guiInputBayaLabel = inputBayaLabel;
	~guiInputBayaNumBox = inputBayaNumBox;
	~guiBayaPosSlider = inputBayaPosSlider;
	~guiBayaPosLabel = inputBayaPosLabel;
	~guiBayaPosNumBox = inputBayaPosNumBox;
	~guiInputMultichannelSlider = inputMultichannelSlider;
	~guiInputMultichannelLabel = inputMultichannelLabel;
	~guiInputMultichannelNumBox = inputMultichannelNumBox;
	~guiAcousHP0_11Slider = acousHP0_11Slider;
	~guiAcousHP0_11Label = acousHP0_11Label;
	~guiAcousHP0_11NumBox = acousHP0_11NumBox;
	~guiAcousHP1_2_9_10Slider = acousHP1_2_9_10Slider;
	~guiAcousHP1_2_9_10Label = acousHP1_2_9_10Label;
	~guiAcousHP1_2_9_10NumBox = acousHP1_2_9_10NumBox;
	~guiAcousHP3_4_7_8Slider = acousHP3_4_7_8Slider;
	~guiAcousHP3_4_7_8Label = acousHP3_4_7_8Label;
	~guiAcousHP3_4_7_8NumBox = acousHP3_4_7_8NumBox;
	~guiAcousHP5_6Slider = acousHP5_6Slider;
	~guiAcousHP5_6Label = acousHP5_6Label;
	~guiAcousHP5_6NumBox = acousHP5_6NumBox;
	~guiAcousHP0_1_2_3_4_5Slider = acousHP0_1_2_3_4_5Slider;
	~guiAcousHP0_1_2_3_4_5Label = acousHP0_1_2_3_4_5Label;
	~guiAcousHP0_1_2_3_4_5NumBox = acousHP0_1_2_3_4_5NumBox;
	~guiAcousHP11_10_9_8_7_6Slider = acousHP11_10_9_8_7_6Slider;
	~guiAcousHP11_10_9_8_7_6Label = acousHP11_10_9_8_7_6Label;
	~guiAcousHP11_10_9_8_7_6NumBox = acousHP11_10_9_8_7_6NumBox;
	~guiAcousHP0_5_6_11Slider = acousHP0_5_6_11Slider;
	~guiAcousHP0_5_6_11Label = acousHP0_5_6_11Label;
	~guiAcousHP0_5_6_11NumBox = acousHP0_5_6_11NumBox;

	"GUI created and displayed with all MIDI controls (bidirectional sync)".postln;
};

)

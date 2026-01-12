(
// Load modules
"sample_loader.scd".loadRelative;
"busses.scd".loadRelative;
"nodes.scd".loadRelative;
"osc_events.scd".loadRelative;
"server.scd".loadRelative;
"gui.scd".loadRelative;
// s.plotTree;
// ###### <initialise global var ######/

// 4 register functions
ServerBoot.add(~loadSamples); // fill up the ~buffers dict
ServerBoot.add(~makeBusses);
ServerQuit.add(~cleanup);

// 5 boot serv
s.waitForBoot({

	s.sync; //wait the server to be ok
	"synthdefs.scd".loadRelative;
	// "midi_connect.scd".loadRelative;
	s.sync;
	ServerTree.add(~makeNodes);
	~makeEvents.value; // Call the function directly instead of adding to ServerTree
	s.freeAll;
	s.sync;
	// ~connect_midi_devices.("Launch Control XL", "Launch Control XL");

	// Create GUI
	~makeGUI.value;

	"=== Communale SC Server ready ===".postln;
	"OSC handlers: /jeu1_buf_trig, /alarm, /input_stereo, /input_quad, /input_octo".postln;
	"GUI displayed".postln;
});
)

///

s.record(numChannels:12);

(
// ===== CONFIGURATION =====
// Port OSC pour la réception des messages (par défaut: 57120)
~oscPort = 4646;  // Changez cette valeur pour utiliser un autre port
~adel = NetAddr.new("192.168.1.4", 4646);    // create the NetAddr

// Load modules
"sample_loader.scd".loadRelative;
"busses.scd".loadRelative;
"nodes.scd".loadRelative;
"osc_events.scd".loadRelative;
"server.scd".loadRelative;
"gui.scd".loadRelative;
"midi_connect.scd".loadRelative;
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
	s.sync;
	ServerTree.add(~makeNodes);
	~makeEvents.value; // Call the function directly instead of adding to ServerTree
	s.freeAll;
	s.sync;

	// Configure OSC port
	thisProcess.openUDPPort(~oscPort);
	"OSC: Listening on port %".format(~oscPort).postln;

	// Connect MIDI devices
	~connect_midi_devices.value;

	// Create GUI
	~makeGUI.value;

	"=== Communale SC Server ready ===".postln;
	//"OSC handlers: /popup, /alarm, /input_stereo, /input_quad, /input_octo".postln;
	"OSC port: %".format(~oscPort).postln;
	"MIDI: CC 84 -> Master Volume".postln;
});
)

///

s.record(numChannels:12);

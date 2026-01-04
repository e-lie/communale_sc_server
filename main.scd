(
// ===== MAIN - Communale SC Server =====

// Load modules
"sample_loader.scd".loadRelative;
"nodeGroups.scd".loadRelative;
"jeu1.scd".loadRelative;
"jeu2.scd".loadRelative;
"jeu3.scd".loadRelative;
"bande_son.scd".loadRelative;
"master.scd".loadRelative;
"server.scd".loadRelative;

// Initialize global variables
~projectPath = PathName(thisProcess.nowExecutingPath).parentPath;
~sampleDirPath = ~projectPath++"samples/";
~bus = Dictionary.new;

// Register ServerBoot callbacks
ServerBoot.add(~loadSamples);           // Load samples into ~buffers
ServerBoot.add(~makeBus_jeu1);          // Create jeu1 bus
ServerBoot.add(~makeBus_jeu2);          // Create jeu2 bus
ServerBoot.add(~makeBus_jeu3);          // Create jeu3 bus
ServerBoot.add(~makeBus_bande_son);     // Create bande_son bus
ServerBoot.add(~makeBus_master);        // Create master bus

// Register cleanup
ServerQuit.add(~cleanup);

// Boot server
s.waitForBoot({

	s.sync;
	"synthdefs.scd".loadRelative;       // Load SynthDefs
	s.sync;

	// Create node groups
	ServerTree.add(~makeNodeGroups);

	// Create synths for each domain
	ServerTree.add(~makeNode_jeu1);
	ServerTree.add(~makeNode_jeu2);
	ServerTree.add(~makeNode_jeu3);
	ServerTree.add(~makeNode_bande_son);
	ServerTree.add(~makeNode_master);

	s.freeAll;
	s.sync;

	// Initialize OSC handlers
	~makeEvent_jeu1.value;
	~makeEvent_jeu2.value;
	~makeEvent_jeu3.value;
	~makeEvent_bande_son.value;

	"=== Communale SC Server ready ===".postln;
	"OSC handlers: /jeu1, /jeu2, /jeu3, /bande_son".postln;
});

)

///

// s.record(numChannels:4);

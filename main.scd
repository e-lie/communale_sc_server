(
// ===== MAIN - Communale SC Server =====

// Server options configuration
s.options.numInputBusChannels_(12);
s.options.numOutputBusChannels_(14);
s.options.sampleRate_(48000);
s.options.memSize_(2.pow(20)); // ~1 GB of active memory
s.options.blockSize_(256);

// Load modules
"sample_loader.scd".loadRelative;
"jeu1.scd".loadRelative;
"jeu2.scd".loadRelative;
"jeu3.scd".loadRelative;
"bande_son.scd".loadRelative;
"master.scd".loadRelative;

// Initialize global variables
~projectPath = PathName(thisProcess.nowExecutingPath).parentPath;
~sampleDirPath = ~projectPath++"samples/";

// Node groups creation function
~makeNodeGroups = {
	s.bind({
		~mainGrp = Group.new;
		~spatGrp = Group.after(~mainGrp);
		~masterGrp = Group.after(~spatGrp);
		"Node groups created: mainGrp -> spatGrp -> masterGrp".postln;
	});
};

// Register ServerBoot callbacks
ServerBoot.add(~loadSamples);           // Load samples into ~buffers

// Register cleanup
ServerQuit.add(~cleanup);

// Boot server
s.waitForBoot({

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

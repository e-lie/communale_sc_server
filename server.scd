(
// ServerOptions.outDevices;
s.options.outDevice_(
// 	"Focusrite USB Au"
	// "ASIO4ALL v2"
	// "ASIO : JackRouter"
	// "MME : Ligne (4- ZOOM U-22 Driver)"
	// "MME : Ligne (4- ZOOM U-22 Audio)"
	);
s.options.inDevice_(
	// "ASIO4ALL v2"
	// "ASIO : JackRouter"
	// "MME : Ligne (4- ZOOM U-22 Driver)"
	);

s.options.numInputBusChannels_(12);
s.options.numOutputBusChannels_(14);
s.options.sampleRate_(48000);
s.options.memSize_(2.pow(20)); // ~1 GB of active memory
s.options.blockSize_(256); // ~1 GB of active memory
// s.newBusAllocators;
// 2.pow(20)
)
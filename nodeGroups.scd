(
// ===== NODE GROUPS =====
// Création des groupes de nodes pour organiser le signal flow

~makeNodeGroups = {
	s.bind({
		~mainGrp = Group.new;
		~spatGrp = Group.after(~mainGrp);
		~masterGrp = Group.after(~spatGrp);

		"Node groups created: mainGrp -> spatGrp -> masterGrp".postln;
	});
};

)


local rules = {
	{
		matches = {
			{
				{
					"node.name",
					"equals",
					"alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp__sink",
				},
			},
		},
		apply_properties = {
			["node.description"] = "Speaker",
		},
	},
	{
		matches = {
			{
				{
					"node.name",
					"equals",
					"alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp_3__sink",
				},
			},
		},
		apply_properties = {
			["node.description"] = "HDMI/DP Output 1",
		},
	},
	{
		matches = {
			{
				{
					"node.name",
					"equals",
					"alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp_4__sink",
				},
			},
		},
		apply_properties = {
			["node.description"] = "HDMI/DP Output 2",
		},
	},
	{
		matches = {
			{
				{
					"node.name",
					"equals",
					"alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp_5__sink",
				},
			},
		},
		apply_properties = {
			["node.description"] = "HDMI/DP Output 3",
		},
	},
}

for _, rule in ipairs(rules) do
	table.insert(alsa_monitor.rules, rule)
end

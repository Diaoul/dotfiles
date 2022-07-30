
pulseaudio-control \
    --format "\$ICON_NODE \$NODE_NICKNAME" \
    --node-nicknames-from "device.description" \
    --node-blacklist "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp_5__sink" \
    --node-nickname "bluez_output.14_3F_A6_10_80_39.a2dp-sink: %{F#a89984}%{F-} WH-1000XM4" \
    --node-nickname "bluez_output.88_C9_E8_1D_2E_33.a2dp-sink: %{F#a89984}%{F-} WF-1000XM4" \
    --node-nickname "alsa_output.usb-0b0e_Jabra_Link_370_3050756D9E4B-00.analog-stereo: %{F#a89984}%{F-} Jabra" \
    --node-nickname "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp__sink: %{F#a89984}蓼 %{F-}Speaker" \
    --node-nickname "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp_3__sink: %{F#a89984}蓼 %{F-}Output 1" \
    --node-nickname "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp_4__sink: %{F#a89984}蓼 %{F-}Output 2" \
    --node-nickname "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp_5__sink: %{F#a89984}蓼 %{F-}Output 3" \
    $1

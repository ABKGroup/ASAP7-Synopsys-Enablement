for DESIGN in aes_cipher_top jpeg_encoder ariane bsg_chip; do
	for CASE in 1 2 all; do
		make DESIGN=$DESIGN PEX_TOOL1=quantus STA_TOOL1=tempus CC1=true SI1=true PEX_TOOL2=starRC STA_TOOL2=primetime CC2=true SI2=true CASE=$CASE 
		make DESIGN=$DESIGN PEX_TOOL1=starRC STA_TOOL1=primetime CC1=true SI1=true PEX_TOOL2=quantus STA_TOOL2=tempus CC2=true SI2=true CASE=$CASE 

		make DESIGN=$DESIGN PEX_TOOL1=quantus STA_TOOL1=tempus CC1=true SI1=true PEX_TOOL2=quantus STA_TOOL2=primetime CC2=true SI2=true CASE=$CASE 
		make DESIGN=$DESIGN PEX_TOOL1=starRC STA_TOOL1=tempus CC1=true SI1=true PEX_TOOL2=starRC STA_TOOL2=primetime CC2=true SI2=true CASE=$CASE 

		make DESIGN=$DESIGN PEX_TOOL1=quantus STA_TOOL1=tempus CC1=true SI1=true PEX_TOOL2=starRC STA_TOOL2=tempus CC2=true SI2=true CASE=$CASE 
		make DESIGN=$DESIGN PEX_TOOL1=quantus STA_TOOL1=primetime CC1=true SI1=true PEX_TOOL2=starRC STA_TOOL2=primetime CC2=true SI2=true CASE=$CASE 

		make DESIGN=$DESIGN PEX_TOOL1=none STA_TOOL1=tempus CC1=true SI1=true PEX_TOOL2=none STA_TOOL2=primetime CC2=true SI2=true CASE=$CASE
		make DESIGN=$DESIGN PEX_TOOL1=none STA_TOOL1=primetime CC1=true SI1=true PEX_TOOL2=none STA_TOOL2=tempus CC2=true SI2=true CASE=$CASE
	done
done

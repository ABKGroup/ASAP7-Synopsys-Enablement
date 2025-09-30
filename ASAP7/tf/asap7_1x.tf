
Technology	{
		name				= ""
		date				= "Oct 27 2021"
		dielectric			= 3.45e-05
		unitTimeName			= "ns"
		timePrecision			= 1000
		unitLengthName			= "micron"
		lengthPrecision			= 1000
		gridResolution			= 1
		unitVoltageName			= "V"
		voltagePrecision		= 1000000
		unitCurrentName			= "mA"
		currentPrecision		= 1000000
		unitPowerName			= "mw"
		powerPrecision			= 1000000
		unitResistanceName		= "kohm"
		resistancePrecision		= 1000000
		unitCapacitanceName		= "pf"
		capacitancePrecision		= 1000000
		unitInductanceName		= "nh"
		inductancePrecision		= 100
		minBaselineTemperature		= 25
		nomBaselineTemperature		= 25
		maxBaselineTemperature		= 25
		minEdgeMode			= 1
}

Color		27 {
		name				= "27"
		rgbDefined			= 1
		redIntensity			= 90
		greenIntensity			= 175
		blueIntensity			= 255
}

Color		43 {
		name				= "43"
		rgbDefined			= 1
		redIntensity			= 180
		greenIntensity			= 175
		blueIntensity			= 255
}

Color		47 {
		name				= "47"
		rgbDefined			= 1
		redIntensity			= 180
		greenIntensity			= 255
		blueIntensity			= 255
}

Tile		"unit" {
		width				= 0.036
		height				= 0.288
}

Layer		"nwell" {
		layerNumber			= 2
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "white"
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"pwell" {
		layerNumber			= 3
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "white"
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"Gate" {
		layerNumber			= 4
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "white"
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"Active" {
		layerNumber			= 5
		maskName			= "poly"
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "white"
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"V0" {
		layerNumber			= 6
		maskName			= "polyCont"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "27"
		lineStyle			= "solid"
		pattern				= "solid"
		pitch				= 0
		defaultWidth			= 0.018
		minWidth			= 0.018
		minSpacing			= 0.018
}

Layer		"M1" {
		layerNumber			= 7
		maskName			= "metal1"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "cyan"
		lineStyle			= "solid"
		pattern				= "dot"
		pitch				= 0.036
		defaultWidth			= 0.018
		minWidth			= 0.018
		minSpacing			= 0.018
		fatTblDimension			= 2
		fatTblThreshold			= (0,0.036)
		fatTblSpacing			= (0.018,0.018,
						   0.018,0.018)
		minArea				= 0.002664
}

Layer		"V1" {
		layerNumber			= 8
		maskName			= "via1"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "43"
		lineStyle			= "solid"
		pattern				= "rectangleX"
		pitch				= 0
		defaultWidth			= 0.018
		minWidth			= 0.018
		minSpacing			= 0.018
}

Layer		"M2" {
		layerNumber			= 9
		maskName			= "metal2"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "yellow"
		lineStyle			= "solid"
		pattern				= "dot"
		pitch				= 0.036
		defaultWidth			= 0.018
		minWidth			= 0.018
		minSpacing			= 0.018
		minArea				= 0.002664
}

Layer		"V2" {
		layerNumber			= 10
		maskName			= "via2"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "blue"
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0.018
		minWidth			= 0.018
		minSpacing			= 0.018
}

Layer		"M3" {
		layerNumber			= 11
		maskName			= "metal3"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "red"
		lineStyle			= "solid"
		pattern				= "wave"
		pitch				= 0.036
		defaultWidth			= 0.018
		minWidth			= 0.018
		minSpacing			= 0.018
		minArea				= 0.002664
}

Layer		"V3" {
		layerNumber			= 12
		maskName			= "via3"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "yellow"
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0.018
		minWidth			= 0.018
		minSpacing			= 0
}

Layer		"M4" {
		layerNumber			= 13
		maskName			= "metal4"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "green"
		lineStyle			= "solid"
		pattern				= "slash"
		pitch				= 0.048
		defaultWidth			= 0.024
		minWidth			= 0.024
		minSpacing			= 0.024
		fatTblDimension			= 2
		fatTblThreshold			= (0,0.026)
		fatTblParallelLengthDimension	= 1
		fatTblParallelLength		= (0)
		fatTblSpacing			= (0.024,
						   0.072)
		minArea				= 0.008
}

Layer		"V4" {
		layerNumber			= 14
		maskName			= "via4"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "white"
		lineStyle			= "solid"
		pattern				= "rectangleX"
		pitch				= 0
		defaultWidth			= 0.024
		minWidth			= 0.024
		minSpacing			= 0
}

Layer		"M5" {
		layerNumber			= 15
		maskName			= "metal5"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "magenta"
		lineStyle			= "solid"
		pattern				= "backSlash"
		pitch				= 0.048
		defaultWidth			= 0.024
		minWidth			= 0.024
		minSpacing			= 0.024
		fatTblDimension			= 2
		fatTblThreshold			= (0,0.026)
		fatTblParallelLengthDimension	= 1
		fatTblParallelLength		= (0)
		fatTblSpacing			= (0.024,
						   0.072)
		minArea				= 0.008
}

Layer		"V5" {
		layerNumber			= 16
		maskName			= "via5"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "47"
		lineStyle			= "solid"
		pattern				= "rectangleX"
		pitch				= 0
		defaultWidth			= 0.024
		minWidth			= 0.024
		minSpacing			= 0
}

Layer		"M6" {
		layerNumber			= 17
		maskName			= "metal6"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "47"
		lineStyle			= "solid"
		pattern				= "dot"
		pitch				= 0.064
		defaultWidth			= 0.032
		minWidth			= 0.032
		minSpacing			= 0.032
		fatTblDimension			= 2
		fatTblThreshold			= (0,0.026)
		fatTblParallelLengthDimension	= 1
		fatTblParallelLength		= (0)
		fatTblSpacing			= (0.024,
						   0.072)
		minArea				= 0.00875
}

Layer		"V6" {
		layerNumber			= 18
		maskName			= "via6"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "43"
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0.032
		minWidth			= 0.032
		minSpacing			= 0
}

Layer		"M7" {
		layerNumber			= 19
		maskName			= "metal7"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "purple"
		lineStyle			= "solid"
		pattern				= "backSlash"
		pitch				= 0.064
		defaultWidth			= 0.032
		minWidth			= 0.032
		minSpacing			= 0.032
		fatTblDimension			= 2
		fatTblThreshold			= (0,0.026)
		fatTblParallelLengthDimension	= 1
		fatTblParallelLength		= (0)
		fatTblSpacing			= (0.024,
						   0.072)
		minArea				= 0.00875
}

Layer		"V7" {
		layerNumber			= 20
		maskName			= "via7"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "43"
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0.032
		minWidth			= 0.032
		minSpacing			= 0.046
		minCutsTblSize			= 1
		minCutsTbl			= (2,*,-1.000,1.806,-1.000000,-1.000)
}

Layer		"M8" {
		layerNumber			= 21
		maskName			= "metal8"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "orange"
		lineStyle			= "solid"
		pattern				= "backSlash"
		pitch				= 0.08
		defaultWidth			= 0.04
		minWidth			= 0.04
		minSpacing			= 0.04
		maxWidth			= 2
		fatTblDimension			= 6
		fatTblThreshold			= (0,0.061,0.081,0.121,0.501,1.001)
		fatTblParallelLengthDimension	= 4
		fatTblParallelLength		= (0,0.401,1.201,1.801)
		fatTblSpacing			= (0.04,0.04,0.04,0.04,
						   0.04,0.04,0.04,0.04,
						   0.04,0.04,0.04,0.04,
						   0.04,0.04,0.04,0.04,
						   0.04,0.04,0.04,0.5,
						   0.04,0.04,0.04,1)
		minArea				= 7.52
		maxNumMinEdge			= 1
		minEdgeLength			= 0.04
}

Layer		"V8" {
		layerNumber			= 22
		maskName			= "via8"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "white"
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0.04
		minWidth			= 0.04
		minSpacing			= 0.057
		minCutsTblSize			= 1
		minCutsTbl			= (2,*,1.806,-1.000,-1.000000,-1.000)
}

Layer		"M9" {
		layerNumber			= 23
		maskName			= "metal9"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "white"
		lineStyle			= "solid"
		pattern				= "slash"
		pitch				= 0.08
		defaultWidth			= 0.04
		minWidth			= 0.04
		minSpacing			= 0.04
		fatTblDimension			= 6
		fatTblThreshold			= (0,0.061,0.081,0.121,0.501,1.001)
		fatTblParallelLengthDimension	= 4
		fatTblParallelLength		= (0,0.401,1.201,1.801)
		fatTblSpacing			= (0.04,0.04,0.04,0.04,
						   0.04,0.04,0.04,0.04,
						   0.04,0.04,0.04,0.04,
						   0.04,0.04,0.04,0.04,
						   0.04,0.04,0.04,0.5,
						   0.04,0.04,0.04,1)
		minArea				= 7.52
		maxNumMinEdge			= 1
		minEdgeLength			= 0.04
}

Layer		"V9" {
		layerNumber			= 24
		maskName			= "via9"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "white"
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0.04
		minWidth			= 0.04
		minSpacing			= 0.057
		minCutsTblSize			= 3
		minCutsTbl			= (1,*,-1.000,0.041,-1.000000,-1.000,
						   1,*,-1.000,0.361,-1.000000,-1.000,
						   2,*,1.806,1.806,-1.000000,-1.000)
}

Layer		"Pad" {
		layerNumber			= 25
		maskName			= "metal10"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "white"
		lineStyle			= "solid"
		pattern				= "slash"
		pitch				= 0.08
		defaultWidth			= 0.04
		minWidth			= 0.04
		minSpacing			= 2
		fatTblDimension			= 2
		fatTblThreshold			= (0,12.001)
		fatTblParallelLengthDimension	= 2
		fatTblParallelLength		= (0,12.001)
		fatTblSpacing			= (2,2,
						   2,3)
}

ContactCode	"VIA9Pad" {
		contactCodeNumber		= 1
		cutLayer			= "V9"
		lowerLayer			= "M9"
		upperLayer			= "Pad"
		isDefaultContact		= 1
		cutWidth			= 0.1
		cutHeight			= 0.1
		upperLayerEncWidth		= 0
		upperLayerEncHeight		= 0
		lowerLayerEncWidth		= 0
		lowerLayerEncHeight		= 0
		minCutSpacing			= 0.057
}

ContactCode	"VIA89" {
		contactCodeNumber		= 2
		cutLayer			= "V8"
		lowerLayer			= "M8"
		upperLayer			= "M9"
		isDefaultContact		= 1
		cutWidth			= 0.04
		cutHeight			= 0.04
		upperLayerEncWidth		= 0
		upperLayerEncHeight		= 0
		lowerLayerEncWidth		= 0
		lowerLayerEncHeight		= 0
		minCutSpacing			= 0.057
}

ContactCode	"VIA78" {
		contactCodeNumber		= 3
		cutLayer			= "V7"
		lowerLayer			= "M7"
		upperLayer			= "M8"
		isDefaultContact		= 1
		cutWidth			= 0.032
		cutHeight			= 0.032
		upperLayerEncWidth		= 0.011
		upperLayerEncHeight		= 0.004
		lowerLayerEncWidth		= 0
		lowerLayerEncHeight		= 0.011
		minCutSpacing			= 0.046
}

ContactCode	"VIA67" {
		contactCodeNumber		= 4
		cutLayer			= "V6"
		lowerLayer			= "M6"
		upperLayer			= "M7"
		isDefaultContact		= 1
		cutWidth			= 0.032
		cutHeight			= 0.032
		upperLayerEncWidth		= 0
		upperLayerEncHeight		= 0.011
		lowerLayerEncWidth		= 0.011
		lowerLayerEncHeight		= 0
		minCutSpacing			= 0
}

ContactCode	"VIA56" {
		contactCodeNumber		= 5
		cutLayer			= "V5"
		lowerLayer			= "M5"
		upperLayer			= "M6"
		isDefaultContact		= 1
		cutWidth			= 0.024
		cutHeight			= 0.032
		upperLayerEncWidth		= 0.011
		upperLayerEncHeight		= 0
		lowerLayerEncWidth		= 0
		lowerLayerEncHeight		= 0.011
		minCutSpacing			= 0
}

ContactCode	"VIA45" {
		contactCodeNumber		= 6
		cutLayer			= "V4"
		lowerLayer			= "M4"
		upperLayer			= "M5"
		isDefaultContact		= 1
		cutWidth			= 0.024
		cutHeight			= 0.024
		upperLayerEncWidth		= 0
		upperLayerEncHeight		= 0.011
		lowerLayerEncWidth		= 0.011
		lowerLayerEncHeight		= 0
		minCutSpacing			= 0
}

ContactCode	"VIA34" {
		contactCodeNumber		= 7
		cutLayer			= "V3"
		lowerLayer			= "M3"
		upperLayer			= "M4"
		isDefaultContact		= 1
		cutWidth			= 0.018
		cutHeight			= 0.024
		upperLayerEncWidth		= 0.011
		upperLayerEncHeight		= 0
		lowerLayerEncWidth		= 0
		lowerLayerEncHeight		= 0.005
		minCutSpacing			= 0
}

ContactCode	"VIA23" {
		contactCodeNumber		= 8
		cutLayer			= "V2"
		lowerLayer			= "M2"
		upperLayer			= "M3"
		isDefaultContact		= 1
		cutWidth			= 0.018
		cutHeight			= 0.018
		upperLayerEncWidth		= 0
		upperLayerEncHeight		= 0.005
		lowerLayerEncWidth		= 0.005
		lowerLayerEncHeight		= 0
		minCutSpacing			= 0.018
}

ContactCode	"VIA12" {
		contactCodeNumber		= 9
		cutLayer			= "V1"
		lowerLayer			= "M1"
		upperLayer			= "M2"
		isDefaultContact		= 1
		cutWidth			= 0.018
		cutHeight			= 0.018
		upperLayerEncWidth		= 0.005
		upperLayerEncHeight		= 0
		lowerLayerEncWidth		= 0
		lowerLayerEncHeight		= 0.002
		minCutSpacing			= 0.018
}

ContactCode	"Pad_M9" {
		contactCodeNumber		= 10
		cutLayer			= "V9"
		lowerLayer			= "M9"
		upperLayer			= "Pad"
		isDefaultContact		= 1
		contactSourceType		= 1
		cutWidth			= 0.032
		cutHeight			= 0.032
		upperLayerEncWidth		= 0.011
		upperLayerEncHeight		= 0
		lowerLayerEncWidth		= 0
		lowerLayerEncHeight		= 0
		minCutSpacing			= 0.046
}

ContactCode	"M9_M8" {
		contactCodeNumber		= 11
		cutLayer			= "V8"
		lowerLayer			= "M8"
		upperLayer			= "M9"
		isDefaultContact		= 1
		contactSourceType		= 1
		cutWidth			= 0.04
		cutHeight			= 0.04
		upperLayerEncWidth		= 0
		upperLayerEncHeight		= 0.02
		lowerLayerEncWidth		= 0
		lowerLayerEncHeight		= 0
		minCutSpacing			= 0.057
}

ContactCode	"M8_M7" {
		contactCodeNumber		= 12
		cutLayer			= "V7"
		lowerLayer			= "M7"
		upperLayer			= "M8"
		isDefaultContact		= 1
		contactSourceType		= 1
		cutWidth			= 0.032
		cutHeight			= 0.032
		upperLayerEncWidth		= 0.011
		upperLayerEncHeight		= 0
		lowerLayerEncWidth		= 0
		lowerLayerEncHeight		= 0
		minCutSpacing			= 0.046
}

ContactCode	"M7_M6" {
		contactCodeNumber		= 13
		cutLayer			= "V6"
		lowerLayer			= "M6"
		upperLayer			= "M7"
		isDefaultContact		= 1
		contactSourceType		= 1
		cutWidth			= 0.032
		cutHeight			= 0.032
		upperLayerEncWidth		= 0
		upperLayerEncHeight		= 0.011
		lowerLayerEncWidth		= 0.011
		lowerLayerEncHeight		= 0
		minCutSpacing			= 0.046
}

ContactCode	"M7_M6_Enc" {
		contactCodeNumber		= 14
		cutLayer			= "V6"
		lowerLayer			= "M6"
		upperLayer			= "M7"
		isDefaultContact		= 1
		contactSourceType		= 1
		cutWidth			= 0.032
		cutHeight			= 0.032
		upperLayerEncWidth		= 0.011
		upperLayerEncHeight		= 0
		lowerLayerEncWidth		= 0.011
		lowerLayerEncHeight		= 0
		minCutSpacing			= 0.046
}

ContactCode	"M6_M5" {
		contactCodeNumber		= 15
		cutLayer			= "V5"
		lowerLayer			= "M5"
		upperLayer			= "M6"
		isDefaultContact		= 1
		contactSourceType		= 1
		cutWidth			= 0.024
		cutHeight			= 0.032
		upperLayerEncWidth		= 0.011
		upperLayerEncHeight		= 0
		lowerLayerEncWidth		= 0.011
		lowerLayerEncHeight		= 0
		minCutSpacing			= 0.034
}

ContactCode	"M6_M5_Enc" {
		contactCodeNumber		= 16
		cutLayer			= "V5"
		lowerLayer			= "M5"
		upperLayer			= "M6"
		isDefaultContact		= 1
		contactSourceType		= 1
		cutWidth			= 0.024
		cutHeight			= 0.032
		upperLayerEncWidth		= 0
		upperLayerEncHeight		= 0.011
		lowerLayerEncWidth		= 0.011
		lowerLayerEncHeight		= 0
		minCutSpacing			= 0.034
}

ContactCode	"M3_M2widePWR0p936" {
		contactCodeNumber		= 17
		cutLayer			= "V2"
		lowerLayer			= "M2"
		upperLayer			= "M3"
		contactSourceType		= 5
		isFatContact			= 1
		cutWidth			= 0.234
		cutHeight			= 0.018
		upperLayerEncWidth		= 0
		upperLayerEncHeight		= 0
		lowerLayerEncWidth		= 0
		lowerLayerEncHeight		= 0
		minCutSpacing			= 0.018
}

ContactCode	"M4_M3widePWR0p864" {
		contactCodeNumber		= 18
		cutLayer			= "V3"
		lowerLayer			= "M3"
		upperLayer			= "M4"
		contactSourceType		= 5
		isFatContact			= 1
		cutWidth			= 0.018
		cutHeight			= 0.216
		upperLayerEncWidth		= 0
		upperLayerEncHeight		= 0
		lowerLayerEncWidth		= 0
		lowerLayerEncHeight		= 0
		minCutSpacing			= 0.018
}

ContactCode	"M5_M4widePWR0p864" {
		contactCodeNumber		= 19
		cutLayer			= "V4"
		lowerLayer			= "M4"
		upperLayer			= "M5"
		contactSourceType		= 5
		isFatContact			= 1
		cutWidth			= 0.216
		cutHeight			= 0.024
		upperLayerEncWidth		= 0
		upperLayerEncHeight		= 0
		lowerLayerEncWidth		= 0
		lowerLayerEncHeight		= 0
		minCutSpacing			= 0.072
}

ContactCode	"M6_M5widePWR1p152" {
		contactCodeNumber		= 20
		cutLayer			= "V5"
		lowerLayer			= "M5"
		upperLayer			= "M6"
		contactSourceType		= 5
		isFatContact			= 1
		cutWidth			= 0.024
		cutHeight			= 0.288
		upperLayerEncWidth		= 0
		upperLayerEncHeight		= 0
		lowerLayerEncWidth		= 0
		lowerLayerEncHeight		= 0
		minCutSpacing			= 0.072
}

ContactCode	"M7_M6widePWR1p152" {
		contactCodeNumber		= 21
		cutLayer			= "V6"
		lowerLayer			= "M6"
		upperLayer			= "M7"
		contactSourceType		= 5
		isFatContact			= 1
		cutWidth			= 0.288
		cutHeight			= 0.032
		upperLayerEncWidth		= 0
		upperLayerEncHeight		= 0
		lowerLayerEncWidth		= 0
		lowerLayerEncHeight		= 0
		minCutSpacing			= 0.064
}

ContactCode	"M2_M1" {
		contactCodeNumber		= 22
		cutLayer			= "V1"
		lowerLayer			= "M1"
		upperLayer			= "M2"
		isDefaultContact		= 1
		contactSourceType		= 1
		cutWidth			= 0.018
		cutHeight			= 0.018
		upperLayerEncWidth		= 0.002
		upperLayerEncHeight		= 0
		lowerLayerEncWidth		= 0
		lowerLayerEncHeight		= 0
		minCutSpacing			= 0.018
}

DensityRule	{
		layer				= "M5"
		windowSize			= 20
		minDensity			= 15
		maxDensity			= 90
}

DensityRule	{
		layer				= "Pad"
		windowSize			= 100
		minDensity			= 20
		maxDensity			= 80
}

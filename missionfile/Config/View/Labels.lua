-- Label parameters
-- Copyright (C) 2018, Eagle Dynamics.



-- labels =  0  -- NONE
-- labels =  1  -- FULL
-- labels =  2  -- ABBREVIATED
-- labels =  3  -- DOT ONLY

-- Off: No labels are used
-- Full: As we have now
-- Abbreviated: Only red or blue dot and unit type name based on side
-- Dot Only: Only red or blue dot based on unit side



local IS_DOT 		 = labels and labels ==  3
local IS_ABBREVIATED = labels and labels ==  2

AirOn			 		= true
GroundOn 		 		= true
NavyOn		 	 		= true
WeaponOn 		 		= true
labels_format_version 	= 1 -- labels format vesrion
---------------------------------
-- Label text format symbols
-- %N - name of object
-- %D - distance to object
-- %P - pilot name
-- %n - new line 
-- %% - symbol '%'
-- %x, where x is not NDPn% - symbol 'x'
-- %C - extended info for vehicle's and ship's weapon systems
------------------------------------------
-- Example
-- labelFormat[5000] = {"Name: %N%nDistance: %D%n Pilot: %P","LeftBottom",0,0}
-- up to 5km label is:
--       Name: Su-33
--       Distance: 30km
--       Pilot: Pilot1


-- alignment options 
--"RightBottom"
--"LeftTop"
--"RightTop"
--"LeftCenter"
--"RightCenter"
--"CenterBottom"
--"CenterTop"
--"CenterCenter"
--"LeftBottom"


-- labels font properties {font_file_name, font_size_in_pixels, text_shadow_offset_x, text_shadow_offset_y, text_blur_type}
-- text_blur_type = 0 - none
-- text_blur_type = 1 - 3x3 pixels
-- text_blur_type = 2 - 5x5 pixels
font_properties =  {"DejaVuLGCSans.ttf", 13, 0, 0, 0}


local accent = "˙" --U+02C6
local dot  =  "˙" --U+02D9
local triangle  =  "ˑ" --U+02D1

local aircraft_symbol_near  =  accent
local aircraft_symbol_far   =  accent
local aircraft_symbol_dot  =  dot

local ground_symbol_near    = "ˉ"  --U+02C9
local ground_symbol_far     = "ˉ"  --U+02C9

local navy_symbol_near      = "˜"  --U+02DC
local navy_symbol_far       = "˜"  --U+02DC

local weapon_symbol_near    = triangle --"ˈ"  --U+02C8
local weapon_symbol_far     = triangle --"ˈ"  --U+02C8

local function dot_symbol(blending,opacity)
    return {"˙","CenterCenter", blending or 1.0 , opacity  or 0.1}
end

local NAME 				   = "%N"
local NAME_DISTANCE_PLAYER = "%N%n %D%n %P"
local NAME_DISTANCE        = "%N%n %D"
local DISTANCE             =   "%n %D"

-- Text shadow color in {red, green, blue, alpha} format, volume from 0 up to 255
-- alpha will by multiplied by opacity value for corresponding distance
local text_shadow_color = {128, 128, 128, 255}
local text_blur_color 	= {0, 0, 255, 255}

local EMPTY = {"", "LeftBottom", 1, 1, 0, 0}


if IS_DOT then

AirFormat = {
--[distance]		= {format, alignment, color_blending_k, opacity, shift_in_pixels_x, shift_in_pixels_y}
[100]	= EMPTY,
[500]  = {aircraft_symbol_near , "LeftBottom"  ,0.75 , 0.05 , -3  , 4},
[1000]  = {aircraft_symbol_near , "LeftBottom"  ,0.75 , 0.25 , -3  , 4},
[1500]  = {aircraft_symbol_near , "LeftBottom"  ,0.75 , 0.5 , -3  , 4},
[2500]	= {aircraft_symbol_far	, "LeftBottom"	,0.60	, 0.60	, -3	, 4},
[3000]	= {aircraft_symbol_far	, "LeftBottom"	,0.60	, 0.70	, -3	, 4},
[4000]	= {aircraft_symbol_far	, "LeftBottom"	,0.60	, 0.60	, -3	, 4},
[5000]	= {aircraft_symbol_far	, "LeftBottom"	,0.60	, 0.50	, -3	, 4},
[6000]	= {aircraft_symbol_far	, "LeftBottom"	,0.50	, 0.25	, -3	, 4},
[7000]	= {aircraft_symbol_far 	, "LeftBottom"	,0.25	, 0.15	, -3	, 4},
[8000]	= {aircraft_symbol_dot 	, "LeftBottom"	,1.0	, 0.05	, -3	, 2},
}

GroundFormat = {
--[distance]		= {format , alignment, color_blending_k, opacity, shift_in_pixels_x, shift_in_pixels_y}
[1000]	= EMPTY,
[1500]	= dot_symbol(0.25, 0.25),
[1750]	= dot_symbol(0.75, 0.5),
[2000]	= dot_symbol(0.75, 0.25),
[3000]	=  dot_symbol(0.75, 0.1),
}

NavyFormat = {
--[distance]		= {format, alignment, color_blending_k, opacity, shift_in_pixels_x, shift_in_pixels_y}
[10]	= EMPTY,
[2000] = EMPTY,
[5000] = EMPTY,
[6000]	= {navy_symbol_far 				,"LeftBottom"	,0.75	, 0.1	, -3	, 0},
[6500]	= {navy_symbol_far 				,"LeftBottom"	,0.75	, 0.2	, -3	, 0},
[7000]	= {navy_symbol_far 				,"LeftBottom"	,0.75	, 0.3	, -3	, 0},
[7500]	= {navy_symbol_far 				,"LeftBottom"	,0.75	, 0.4	, -3	, 0},
[8000]	= {navy_symbol_far 				,"LeftBottom"	,0.75	, 0.5	, -3	, 0},
[8250]	= {navy_symbol_far 				,"LeftBottom"	,0.75	, 0.4	, -3	, 0},
[8500]	= {navy_symbol_far 				,"LeftBottom"	,0.75	, 0.3	, -3	, 0},
[8750]	= {navy_symbol_far 				,"LeftBottom"	,0.75	, 0.2	, -3	, 0},
[9000]	= {navy_symbol_far 				,"LeftBottom"	,0.75	, 0.1	, -3	, 0},
}

WeaponFormat = {
[100]	= EMPTY,
[250]  = {aircraft_symbol_near , "LeftBottom"  ,0.75 , 0.75 , -3  , 4},
[500]  = {aircraft_symbol_near , "LeftBottom"  ,0.75 , 0.7 , -3  , 4},
[750]  = {aircraft_symbol_near , "LeftBottom"  ,0.75 , 0.6 , -3  , 4},
[1000]	= {aircraft_symbol_far	, "LeftBottom"	,0.60	, 0.55	, -3	, 4},
[1500]	= {aircraft_symbol_far	, "LeftBottom"	,0.60	, 0.50	, -3	, 4},
[2000]	= {aircraft_symbol_far	, "LeftBottom"	,0.60	, 0.40	, -3	, 4},
[2500]	= {aircraft_symbol_far	, "LeftBottom"	,0.60	, 0.30	, -3	, 4},
[3000]	= {aircraft_symbol_far	, "LeftBottom"	,0.50	, 0.25	, -3	, 4},
[3500]	= {aircraft_symbol_far 	, "LeftBottom"	,0.25	, 0.15	, -3	, 4},
[4000]	= {aircraft_symbol_dot 	, "LeftBottom"	,1.0	, 0.05	, -3	, 2},
}

elseif IS_ABBREVIATED then 
AirFormat = {
--[distance]		= {format, alignment, color_blending_k, opacity, shift_in_pixels_x, shift_in_pixels_y}
[100]	= EMPTY,
[500]  = {aircraft_symbol_near , "LeftBottom"  ,0.75 , 0.05 , -3  , 4},
[1000]  = {aircraft_symbol_near , "LeftBottom"  ,0.75 , 0.25 , -3  , 4},
[1500]  = {aircraft_symbol_near , "LeftBottom"  ,0.75 , 0.5 , -3  , 4},
[2500]	= {aircraft_symbol_far	, "LeftBottom"	,0.60	, 0.60	, -3	, 4},
[3000]	= {aircraft_symbol_far	, "LeftBottom"	,0.60	, 0.70	, -3	, 4},
[4000]	= {aircraft_symbol_far	, "LeftBottom"	,0.60	, 0.60	, -3	, 4},
[5000]	= {aircraft_symbol_far	, "LeftBottom"	,0.60	, 0.50	, -3	, 4},
[6000]	= {aircraft_symbol_far	, "LeftBottom"	,0.50	, 0.25	, -3	, 4},
[7000]	= {aircraft_symbol_far 	, "LeftBottom"	,0.25	, 0.15	, -3	, 4},
[8000]	= {aircraft_symbol_dot 	, "LeftBottom"	,1.0	, 0.05	, -3	, 2},
}

GroundFormat = {
--[distance]		= {format , alignment, color_blending_k, opacity, shift_in_pixels_x, shift_in_pixels_y}
[1000]	= EMPTY,
[1500]	= dot_symbol(0.25, 0.25),
[1750]	= dot_symbol(0.75, 0.5),
[2000]	= dot_symbol(0.75, 0.25),
[3000]	=  dot_symbol(0.75, 0.1),
}

NavyFormat = {
--[distance]		= {format, alignment, color_blending_k, opacity, shift_in_pixels_x, shift_in_pixels_y}
[10]	= EMPTY,
[2000] = EMPTY,
[5000] = EMPTY,
[6000]	= {navy_symbol_far 				,"LeftBottom"	,0.75	, 0.1	, -3	, 0},
[6500]	= {navy_symbol_far 				,"LeftBottom"	,0.75	, 0.2	, -3	, 0},
[7000]	= {navy_symbol_far 				,"LeftBottom"	,0.75	, 0.3	, -3	, 0},
[7500]	= {navy_symbol_far 				,"LeftBottom"	,0.75	, 0.4	, -3	, 0},
[8000]	= {navy_symbol_far 				,"LeftBottom"	,0.75	, 0.5	, -3	, 0},
[8250]	= {navy_symbol_far 				,"LeftBottom"	,0.75	, 0.4	, -3	, 0},
[8500]	= {navy_symbol_far 				,"LeftBottom"	,0.75	, 0.3	, -3	, 0},
[8750]	= {navy_symbol_far 				,"LeftBottom"	,0.75	, 0.2	, -3	, 0},
[9000]	= {navy_symbol_far 				,"LeftBottom"	,0.75	, 0.1	, -3	, 0},
}

WeaponFormat = {
[100]	= EMPTY,
[250]  = {aircraft_symbol_near , "LeftBottom"  ,0.75 , 0.75 , -3  , 4},
[500]  = {aircraft_symbol_near , "LeftBottom"  ,0.75 , 0.7 , -3  , 4},
[750]  = {aircraft_symbol_near , "LeftBottom"  ,0.75 , 0.6 , -3  , 4},
[1000]	= {aircraft_symbol_far	, "LeftBottom"	,0.60	, 0.55	, -3	, 4},
[1500]	= {aircraft_symbol_far	, "LeftBottom"	,0.60	, 0.50	, -3	, 4},
[2000]	= {aircraft_symbol_far	, "LeftBottom"	,0.60	, 0.40	, -3	, 4},
[2500]	= {aircraft_symbol_far	, "LeftBottom"	,0.60	, 0.30	, -3	, 4},
[3000]	= {aircraft_symbol_far	, "LeftBottom"	,0.50	, 0.25	, -3	, 4},
[3500]	= {aircraft_symbol_far 	, "LeftBottom"	,0.25	, 0.15	, -3	, 4},
[4000]	= {aircraft_symbol_dot 	, "LeftBottom"	,1.0	, 0.05	, -3	, 2},
}
else 
AirFormat = {
--[distance]		= {format, alignment, color_blending_k, opacity, shift_in_pixels_x, shift_in_pixels_y}
[100]	= EMPTY,
[500]  = {aircraft_symbol_near , "LeftBottom"  ,0.75 , 0.05 , -3  , 4},
[1000]  = {aircraft_symbol_near , "LeftBottom"  ,0.75 , 0.25 , -3  , 4},
[1500]  = {aircraft_symbol_near , "LeftBottom"  ,0.75 , 0.5 , -3  , 4},
[2500]	= {aircraft_symbol_far	, "LeftBottom"	,0.60	, 0.60	, -3	, 4},
[3000]	= {aircraft_symbol_far	, "LeftBottom"	,0.60	, 0.70	, -3	, 4},
[4000]	= {aircraft_symbol_far	, "LeftBottom"	,0.60	, 0.60	, -3	, 4},
[5000]	= {aircraft_symbol_far	, "LeftBottom"	,0.60	, 0.50	, -3	, 4},
[6000]	= {aircraft_symbol_far	, "LeftBottom"	,0.50	, 0.25	, -3	, 4},
[7000]	= {aircraft_symbol_far 	, "LeftBottom"	,0.25	, 0.15	, -3	, 4},
[8000]	= {aircraft_symbol_dot 	, "LeftBottom"	,1.0	, 0.05	, -3	, 2},
}

GroundFormat = {
--[distance]		= {format , alignment, color_blending_k, opacity, shift_in_pixels_x, shift_in_pixels_y}
[1000]	= EMPTY,
[1500]	= dot_symbol(0.25, 0.25),
[1750]	= dot_symbol(0.75, 0.5),
[2000]	= dot_symbol(0.75, 0.25),
[3000]	=  dot_symbol(0.75, 0.1),
}

NavyFormat = {
--[distance]		= {format, alignment, color_blending_k, opacity, shift_in_pixels_x, shift_in_pixels_y}
[10]	= EMPTY,
[2000] = EMPTY,
[5000] = EMPTY,
[6000]	= {navy_symbol_far 				,"LeftBottom"	,0.75	, 0.1	, -3	, 0},
[6500]	= {navy_symbol_far 				,"LeftBottom"	,0.75	, 0.2	, -3	, 0},
[7000]	= {navy_symbol_far 				,"LeftBottom"	,0.75	, 0.3	, -3	, 0},
[7500]	= {navy_symbol_far 				,"LeftBottom"	,0.75	, 0.4	, -3	, 0},
[8000]	= {navy_symbol_far 				,"LeftBottom"	,0.75	, 0.5	, -3	, 0},
[8250]	= {navy_symbol_far 				,"LeftBottom"	,0.75	, 0.4	, -3	, 0},
[8500]	= {navy_symbol_far 				,"LeftBottom"	,0.75	, 0.3	, -3	, 0},
[8750]	= {navy_symbol_far 				,"LeftBottom"	,0.75	, 0.2	, -3	, 0},
[9000]	= {navy_symbol_far 				,"LeftBottom"	,0.75	, 0.1	, -3	, 0},
}

WeaponFormat = {
[100]	= EMPTY,
[250]  = {aircraft_symbol_near , "LeftBottom"  ,0.75 , 0.75 , -3  , 4},
[500]  = {aircraft_symbol_near , "LeftBottom"  ,0.75 , 0.7 , -3  , 4},
[750]  = {aircraft_symbol_near , "LeftBottom"  ,0.75 , 0.6 , -3  , 4},
[1000]	= {aircraft_symbol_far	, "LeftBottom"	,0.60	, 0.55	, -3	, 4},
[1500]	= {aircraft_symbol_far	, "LeftBottom"	,0.60	, 0.50	, -3	, 4},
[2000]	= {aircraft_symbol_far	, "LeftBottom"	,0.60	, 0.40	, -3	, 4},
[2500]	= {aircraft_symbol_far	, "LeftBottom"	,0.60	, 0.30	, -3	, 4},
[3000]	= {aircraft_symbol_far	, "LeftBottom"	,0.50	, 0.25	, -3	, 4},
[3500]	= {aircraft_symbol_far 	, "LeftBottom"	,0.25	, 0.15	, -3	, 4},
[4000]	= {aircraft_symbol_dot 	, "LeftBottom"	,1.0	, 0.05	, -3	, 2},
}
end

PointFormat = {
[100000]	= {"%N%n%D", "LeftBottom"},
}


-- Colors in {red, green, blue} format, volume from 0 up to 255

ColorAliesSide   = {50, 50,50}
ColorEnemiesSide = {50, 50, 50}
ColorUnknown     = {50, 50, 50} -- will be blend at distance with coalition color



ShadowColorNeutralSide 	= {0,0,0,0}
ShadowColorAliesSide	= {0,0,0,0}
ShadowColorEnemiesSide 	= {0,0,0,0}
ShadowColorUnknown 		= {0,0,0,0}

BlurColorNeutralSide 	= {255,255,255,255}
BlurColorAliesSide		= {50 ,50 ,50 ,255}
BlurColorEnemiesSide	= {50 ,50 ,50 ,255}
BlurColorUnknown		= {50 ,50 ,50 ,255}

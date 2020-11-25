local data =
{
	name = "siexis" ,
	settings =
	{
		enable_param = { "bool" , "startup" , true } ,
		during_tool = { "double" , "startup" , 1 , 0 , 1000000000 } ,
		during_tool_r = { "double" , "startup" , 1 , 0 , 1000000000 } ,
		speed_tool_r = { "double" , "startup" , 1 , 0 , 1000000000 } ,
		speed_lab = { "double" , "startup" , 1 , 0 , 1000000000 } ,
		magazine_ammo = { "double" , "startup" , 1 , 0 , 1000000000 } ,
		distance_circuit = { "double" , "startup" , 1 , 0 , 1000000000 } ,
		distance_undergrund_belt = { "double" , "startup" , 1 , 0 , 1000000000 } ,
		distance_undergrund_pipe = { "double" , "startup" , 1 , 0 , 1000000000 } ,
	}
}
for key , value in pairs{ mult = 1 , size = 0 } do
	data.settings["enable_"..key] = { "bool" , "startup" , true }
	data.settings[key.."_min"] = { "int" , "startup" , 0 , 0 , 1000000000 }
	data.settings[key.."_max"] = { "int" , "startup" , 0 , 0 , 1000000000 }
	for name , type in pairs( SITypes.stackableItem ) do data.settings[key.."_"..type] = { "double" , "startup" , value , 0 , 1000000000 } end
end

return data
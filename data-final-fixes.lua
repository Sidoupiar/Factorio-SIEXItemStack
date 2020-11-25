if SIStartup.SIEXIS.enable_param() then
	local min = 1
	local max = 1000000000
	local minFloat = 0.01
	local maxFloat = 1000000000
	
	local duringTool = SIStartup.SIEXIS.during_tool()
	if duringTool ~= 1 then for k , v in pairs( SIGen.GetList( SITypes.item.tool ) ) do v.durability = math.Cnum_i( v.durability*duringTool , max , min ) end end
	
	local duringToolRepair = SIStartup.SIEXIS.during_tool_repair()
	local speedToolRepair = SIStartup.SIEXIS.speed_tool_repair()
	if duringToolRepair ~= 1 or speedToolRepair ~= 1 then
		for k , v in pairs( SIGen.GetList( SITypes.item.toolRepair ) ) do
			if duringToolRepair ~= 1 then v.durability = math.Cnum_i( v.durability*duringToolRepair , max , min ) end
			if speedToolRepair ~= 1 then v.speed = math.Cnum( v.speed*speedToolRepair , maxFloat , minFloat ) end
		end
	end
	
	local speedLab = SIStartup.SIEXIS.speed_lab()
	if speedLab ~= 1 then for k , v in pairs( SIGen.GetList( SITypes.entity.lab ) ) do v.researching_speed = math.Cnum( v.researching_speed*speedLab , maxFloat , minFloat ) end end
	
	local magazineAmmo = SIStartup.SIEXIS.magazine_ammo()
	if magazineAmmo ~= 1 then
		for k , v in pairs( SIGen.GetList( SITypes.item.ammo ) ) do
			local newmagazine = 1
			if v.magazine_size then newmagazine = v.magazine_size end
			v.magazine_size = math.Cnum_i( newmagazine*magazineAmmo , max , min )
		end
	end
	
	local distanceCircuit = SIStartup.SIEXIS.distance_circuit()
	if distanceCircuit ~= 1 then for i , v in pairs( SITypes.entity ) do for n , m in pairs( SIGen.GetList( v ) ) do if m.circuit_wire_max_distance then m.circuit_wire_max_distance = math.Cnum_i( m.circuit_wire_max_distance*distanceCircuit , max , min ) end end end end
	
	local distanceUndergrundBelt = SIStartup.SIEXIS.distance_undergrund_belt()
	if distanceUndergrundBelt ~= 1 then for k , v in pairs( SIGen.GetList( SITypes.entity.belt_g ) ) do v.max_distance = math.Cnum_i( v.max_distance*distanceUndergrundBelt , max , min ) end end
	
	local distanceUndergrundPipe = SIStartup.SIEXIS.distance_undergrund_pipe()
	if distanceUndergrundPipe ~= 1 then for k , v in pairs( SIGen.GetList( SITypes.entity.pipe_g ) ) do for n , m in pairs( v.fluid_box.pipe_connections ) do if m.max_underground_distance then m.max_underground_distance = math.Cnum_i( m.max_underground_distance*distanceUndergrundPipe , max , min ) end end end end
end

for key , value in pairs{ mult = { 1 , function( base , size ) return base * size end } , size = { 0 , function( base , size ) return base + size end} } do
	if SIStartup.SIEXIS["enable_"..key]() then
		local min = SIStartup.SIEXIS[key.."_min"]()
		local max = SIStartup.SIEXIS[key.."_max"]()
		if min == 0 then min = 1 end
		if max == 0 then max = 1000000000 end
		
		for name , type in pairs( SITypes.stackableItem ) do
			local size = SIStartup.SIEXIS[key.."_"..type]()
			if size ~= value[1] then
				for n , m in pairs( SIGen.GetList( type ) ) do
					m.stack_size = math.Cnum_i( value[2]( m.stack_size , size ) , max , min )
				end
			end
		end
	end
end
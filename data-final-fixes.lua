if SIStartup.SIEXIS.enable_param() then
	local min = 1
	local max = 1000000000
	local min_f = 0.01
	local max_f = 1000000000
	
	local during_tool = SIStartup.SIEXIS.during_tool()
	if during_tool ~= 1 then for k , v in pairs( SIGen.GetList( SITypes.item.tool ) ) do v.durability = math.c_num_i( v.durability*during_tool , max , min ) end end
	
	local during_tool_r = SIStartup.SIEXIS.during_tool_r()
	local speed_tool_r = SIStartup.SIEXIS.speed_tool_r()
	if during_tool_r ~= 1.0 or speed_tool_r ~= 1.0 then
		for k , v in pairs( SIGen.GetList( SITypes.item.tool_r ) ) do
			if during_tool_r ~= 1.0 then v.durability = math.c_num_i( v.durability*during_tool_r , max , min ) end
			if speed_tool_r ~= 1.0 then v.speed = math.c_num( v.speed*speed_tool_r , max_f , min_f ) end
		end
	end
	
	local speed_lab = SIStartup.SIEXIS.speed_lab()
	if speed_lab ~= 1.0 then for k , v in pairs( SIGen.GetList( SITypes.entity.lab ) ) do v.researching_speed = math.c_num( v.researching_speed*speed_lab , max_f , min_f ) end end
	
	local magazine_ammo = SIStartup.SIEXIS.magazine_ammo()
	if magazine_ammo ~= 1.0 then
		for k , v in pairs( SIGen.GetList( SITypes.item.ammo ) ) do
			local newmagazine = 1
			if v.magazine_size then newmagazine = v.magazine_size end
			v.magazine_size = math.c_num_i( newmagazine*magazine_ammo , max , min )
		end
	end
	
	local distance_circuit = SIStartup.SIEXIS.distance_circuit()
	if distance_circuit ~= 1.0 then for i , v in pairs( SITypes.entity ) do for n , m in pairs( SIGen.GetList( v ) ) do if m.circuit_wire_max_distance then m.circuit_wire_max_distance = math.c_num_i( m.circuit_wire_max_distance*distance_circuit , max , min ) end end end end
	
	local distance_undergrund_belt = SIStartup.SIEXIS.distance_undergrund_belt()
	if distance_undergrund_belt ~= 1.0 then for k , v in pairs( SIGen.GetList( SITypes.entity.belt_g ) ) do v.max_distance = math.c_num_i( v.max_distance*distance_undergrund_belt , max , min ) end end
	
	local distance_undergrund_pipe = SIStartup.SIEXIS.distance_undergrund_pipe()
	if distance_undergrund_pipe ~= 1.0 then for k , v in pairs( SIGen.GetList( SITypes.entity.pipe_g ) ) do for n , m in pairs( v.fluid_box.pipe_connections ) do if m.max_underground_distance then m.max_underground_distance = math.c_num_i( m.max_underground_distance*distance_undergrund_pipe , max , min ) end end end end
end

if SIStartup.SIEXIS.enable_size() then
	local min = SIStartup.SIEXIS.size_min()
	local max = SIStartup.SIEXIS.size_max()
	if min == 0 then min = 1 end
	if max == 0 then max = 1000000000 end
	
	for k , v in pairs( SITypes.stackable_item ) do
		local size = SIStartup.SIEXIS["size_"..k]()
		if size ~= 1.0 then for n , m in pairs( SIGen.GetList( v ) ) do m.stack_size = math.c_num_i( m.stack_size*size , max , min ) end end
	end
	
	local list = SIStartup.SIEXIS.custom_size():toABlist()
	local item
	for k , v in pairs( list ) do
		for n , m in pairs( SITypes.stackable_item ) do
			item = SICF.data( m , k )
			if item then item.stack_size = v end
		end
	end
end
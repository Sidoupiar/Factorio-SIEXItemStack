if SIStartup.SIEXIS.enable_param() then
	local min = 1
	local max = 1000000000
	local minFloat = 0.01
	local maxFloat = 1000000000
	
	local duringTool = SIStartup.SIEXIS.during_tool()
	if duringTool ~= 1 then for k , v in pairs( SIGen.GetList( SITypes.item.tool ) ) do v.durability = math.Cnum( v.durability*duringTool , min , max ) end end
	
	local duringToolRepair = SIStartup.SIEXIS.during_tool_repair()
	local speedToolRepair = SIStartup.SIEXIS.speed_tool_repair()
	if duringToolRepair ~= 1 or speedToolRepair ~= 1 then
		for k , v in pairs( SIGen.GetList( SITypes.item.toolRepair ) ) do
			if duringToolRepair ~= 1 then v.durability = math.Cnum( v.durability*duringToolRepair , min , max ) end
			if speedToolRepair ~= 1 then v.speed = math.Range( v.speed*speedToolRepair , minFloat , maxFloat ) end
		end
	end
	
	local speedLab = SIStartup.SIEXIS.speed_lab()
	if speedLab ~= 1 then for k , v in pairs( SIGen.GetList( SITypes.entity.lab ) ) do v.researching_speed = math.Range( (v.researching_speed or 1)*speedLab , minFloat , maxFloat ) end end
	
	local magazineAmmo = SIStartup.SIEXIS.magazine_ammo()
	if magazineAmmo ~= 1 then
		for k , v in pairs( SIGen.GetList( SITypes.item.ammo ) ) do
			local newmagazine = 1
			if v.magazine_size then newmagazine = v.magazine_size end
			v.magazine_size = math.Cnum( newmagazine*magazineAmmo , min , max )
		end
	end
	
	local distanceCircuit = SIStartup.SIEXIS.distance_circuit()
	if distanceCircuit ~= 1 then for i , v in pairs( SITypes.entity ) do for n , m in pairs( SIGen.GetList( v ) ) do if m.circuit_wire_max_distance then m.circuit_wire_max_distance = math.Cnum( m.circuit_wire_max_distance*distanceCircuit , min , max ) end end end end
	
	local distanceUndergrundBelt = SIStartup.SIEXIS.distance_undergrund_belt()
	if distanceUndergrundBelt ~= 1 then for k , v in pairs( SIGen.GetList( SITypes.entity.beltGround ) ) do v.max_distance = math.Cnum( v.max_distance*distanceUndergrundBelt , min , max ) end end
	
	local distanceUndergrundPipe = SIStartup.SIEXIS.distance_undergrund_pipe()
	if distanceUndergrundPipe ~= 1 then for k , v in pairs( SIGen.GetList( SITypes.entity.pipeGround ) ) do for n , m in pairs( v.fluid_box.pipe_connections ) do if m.max_underground_distance then m.max_underground_distance = math.Cnum( m.max_underground_distance*distanceUndergrundPipe , min , max ) end end end end
end

local ignoreNotStackable = SIStartup.SIEXIS.ignore_not_stackable()
local baseStackSize = SIStartup.SIEXIS.total_stack_size()
local baseEnabled = false -- 判断是否启用了按类别增加堆叠数量
for key , value in pairs{ mult = { 1 , function( base , number ) return base * number end } , size = { 0 , function( base , number ) return base + number end } } do
	local enabled = SIStartup.SIEXIS["enable_"..key]()
	baseEnabled = baseEnabled or enabled
	if enabled then
		local min = SIStartup.SIEXIS[key.."_min"]()
		local max = SIStartup.SIEXIS[key.."_max"]()
		if min == 0 then min = 1 end
		if max == 0 then max = 1000000000 end
		
		for name , type in pairs( SITypes.stackableItem ) do
			local size = SIStartup.SIEXIS[key.."_"..type]()
			if key == "mult" and size == value[1] then size = baseStackSize end
			if size ~= value[1] then
				for n , m in pairs( SIGen.GetList( type ) ) do
					local flags = m.flags or {}
					if table.Has( flags , SIFlags.itemFlags.notStackable ) then
						if ignoreNotStackable and max > 1 then
							local newFlags = {}
							for i , flag in pairs( flags ) do if flag ~= SIFlags.itemFlags.notStackable then table.insert( newFlags , flag ) end end
							m.flags = newFlags
							m.stack_size = math.Cnum( value[2]( m.stack_size , size ) , min , max )
						end
					else m.stack_size = math.Cnum( value[2]( m.stack_size , size ) , min , max ) end
				end
			end
		end
	end
end
if not baseEnabled and baseStackSize ~= 1 then
	local min = 1
	local max = 1000000000
	for name , type in pairs( SITypes.stackableItem ) do
		for n , m in pairs( SIGen.GetList( type ) ) do
			local flags = m.flags or {}
			if table.Has( flags , SIFlags.itemFlags.notStackable ) then
				if ignoreNotStackable and max > 1 then
					local newFlags = {}
					for i , flag in pairs( flags ) do if flag ~= SIFlags.itemFlags.notStackable then table.insert( newFlags , flag ) end end
					m.flags = newFlags
					m.stack_size = math.Cnum( m.stack_size*baseStackSize , min , max )
				end
			else m.stack_size = math.Cnum( m.stack_size*baseStackSize , min , max ) end
		end
	end
end
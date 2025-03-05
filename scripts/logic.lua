function has(item, amount)
    local count = Tracker:ProviderCountForCode(item)
    if not amount then
        return count > 0
    else
        amount = tonumber(amount)
        return count >= amount
    end
end

function hasnot(item)
	local count2 = Tracker:ProviderCountForCode(item)
    if count2 > 0 then
		return false
	else return true
	end
end

function prismatic_logic(current_trade)
	local max_trade = Tracker:FindObjectForCode("Prismatic").CurrentStage
	current_trade = tonumber(current_trade)
	if max_trade >= current_trade then
		return true
	else 
		return false
	end

end


function access_nameless_coast()
	return has("Castaways", 6) or has("Grip_Gloves")
end

function access_great_river_valley()
	return has("Castaways", 8) or (access_nameless_coast() and has("Archaeopteryx_Wing"))
end

function access_jungle()
	return access_great_river_valley() and has("Dina")
end

function access_jungle()
	return access_great_river_valley() and has("Dina")
end

function access_nostalgia_cape()
	return access_jungle() and has("Archaeopteryx_Wing")
end

function access_weathervane_hills()
	return has("Castaways", 11) and has("Grip_Gloves")
end

function access_mountain()
	return (access_great_river_valley() and has("Grip_Gloves") and has("maiden_journal")) or has("NorthSideOpen")
end

function access_eternia()
	return access_mountain() and (has("blue_seal") or (has("Dana") and has("green_seal")))
end

function access_temple()
	return access_mountain() and (has("Dana") or (has("blue_seal") and has("green_seal")))
end

function access_valley_of_kings()
	return access_temple() and has("Floating_Shoes")  and has("Treasure_Chest_Key") and has("Grip_Gloves")
end

function access_submerged_cemetery()
	return access_temple() and (has("Floating_Shoes") or has("Archaeopteryx_Wing"))  and has("Treasure_Chest_Key") and has("Grip_Gloves") and has("Hermits_Scale") and has("Castaways", 22)
end

function access_octus()
	if not access_temple() then
		return false
	end

	if has("Escape") then
		return true
	end
	if has("Castaways_toggle") then
		local Castaways_to_access = Tracker:ProviderCountForCode("Castaways_Octus")
		return has("Castaways", Castaways_to_access)
	end
	if has("Psyches_toggle") then
		local Psyches_to_access = Tracker:ProviderCountForCode("Psyches_Octus")
		return has("psyches", Psyches_to_access)
	end
	
end

function access_final_boss()
	if not access_octus() then
		return false
	end
	
	if has("Escape") then
		return has("mistilteinn") and has("seiren_map") and has("ship_blueprints")
	end
	
	if has("Castaways_toggle") then
		local Castaways_to_finish = Tracker:ProviderCountForCode("Castaways_Goal")
		return has("Castaways", Castaways_to_finish)
	end
	
	if has("Psyches_toggle") then
		local Psyches_to_finish = Tracker:ProviderCountForCode("Psyches_Goal")
		return has("Psyches", Psyches_to_finish)
	end
	
end



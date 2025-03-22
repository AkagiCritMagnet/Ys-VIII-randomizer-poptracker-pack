function has(item, amount)
    local count = Tracker:ProviderCountForCode(item)
    if not amount then
        return count > 0
    else
        amount = tonumber(amount)
        return count >= amount
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

function hasnot(item)
	local count2 = Tracker:ProviderCountForCode(item)
    if count2 > 0 then
		return false
	else return true
	end
end


function access_nameless_coast()
	return has("Castaways", 6) or has("Grip_Gloves")
end

function access_nameless_coast_landmarks()
	if has("landmark_sanity") then
		return has("birdsong_rock") or access_towering_coral_forest_landmarks() or access_great_river_valley_landmarks()
	end
	return false
end


function access_towering_coral_forest_landmarks()
	if has("landmark_sanity") then
		return has("rainbow_falls") or access_roaring_seashore_lower_landmarks()
	end
	return false
end

function access_roaring_seashore_lower_landmarks()
	if has("landmark_sanity") then
	 return has("metavolicalis") or (has("parasequoia") and has("Castaways", 14))
	end
	return false
end

function access_roaring_seashore_upper_landmarks()
	if has("Grip_Gloves") and has("Castaways", 14) then
		return true
	end
	if has("landmark_sanity") then
		return has("parasequoia") or (has("metavolicalis") and has("Castaways", 14))
	end
	return false
end

function access_great_river_valley()
	return has("Castaways", 8) or ((access_nameless_coast() or access_nameless_coast_landmarks()) and has("Archaeopteryx_Wing"))
end

function access_great_river_valley_landmarks()
	if has("landmark_sanity") then
		return has("chimney_rock") or has("milky_white_vein") or access_eroded_valley_landmarks() or (access_longhorn_coast_landmarks() and has("Dina")) 
			or (access_jungle_landmarks() and has("Dina")) or (access_mountain_landmarks() and has("maiden_journal")) or (has("airs_cairn") and has("Floating_Shoes") and has("Castaways", 11))
	end
	return false
end

function access_eroded_valley_landmarks()
	if has("landmark_sanity") then
		return has("indigo_mineral_vein") or has("beached_remains")
	end
	return false
end

function access_jungle_landmarks()
	if has("landmark_sanity") then
		return has("field_of_medicinal_herbs")
	end
	return false
end

function access_longhorn_coast_landmarks()
	if has("landmark_sanity") then
		return has("beehive") or access_nostalgia_cape_landmarks()
	end
	return false
end

function access_nostalgia_cape_landmarks()
	if has("landmark_sanity") then
		return has("ship_graveyard") or has("hidden_pirates_storehouse")
	end
	return false
end

function access_weathervane_hills()
	return has("Castaways", 11) and has("Grip_Gloves")
end

function access_weathervane_hills_landmarks()
	if has("landmark_sanity") then
		return has("zephyr_hill") or (has("lapis_mineral_vein") and has("Hermits_Scale"))
	end
	return false
end

function access_mountain()
	return ((access_great_river_valley() or access_great_river_valley_landmarks()) and has("Grip_Gloves") and has("maiden_journal")) or access_mountain_landmarks()
end

function access_mountain_landmarks()
	if has("landmark_sanity") then
		return has("prismatic_mineral_vein")
	end
	return false
end

function access_temple_approach()
	return access_mountain() or has("NorthSideOpen")
end

function access_temple_approach_landmarks()
	if has("landmark_sanity") then
		return has("ancient_tree") or has("breath_fountain") or has("unicalamites") or (access_eternia_landmarks() and has("blue_seal")) or (access_temple_landmarks() and has("Dana"))
	end
	return false
end

function access_eternia_landmarks()
	if has("landmark_sanity") then
		return access_temple_landmarks() and has("green_seal")	
	end
	return false
end

function access_temple_landmarks()
	if has("landmark_sanity") then
		return ((access_valley_of_kings_landmarks() or has("sky_garden")) and has("Floating_Shoes")) or (has("soundless_hall") and has("Hermits_Scale") and has("Castaways", 22))	
	end
	return false
end

function access_lodinia_marsh_landmarks()
	if has("landmark_sanity") then
		return access_valley_of_kings_landmarks() or has("sky_garden") or (has("soundless_hall") and has("Hermits_Scale") and has("Castaways", 22))
	end
	return false
end

function access_valley_of_kings()
	return access_temple() and has("Floating_Shoes")  and has("Treasure_Chest_Key") and has("Grip_Gloves")
end

function access_valley_of_kings_landmarks()
	if has("landmark_sanity") then
		return has("graves_of_ancient_heroes") and has("maiden_amulet")
	end
	return false
end

function access_submerged_cemetery_landmarks()
	if has("landmark_sanity") then
		return ((access_valley_of_kings_landmarks() or has("sky_garden")) and Floating_Shoes and has("Castaways", 22)) or has("soundless_hall")
	end
	return false
end

function access_octus()
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



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

function canSB()
    return AccessibilityLevel.SequenceBreak
end

function turnBlue()
	return AccessibilityLevel.Inspect
end

function intercept_access(stage)
	local interceptAvailable = Tracker:FindObjectForCode("Dogi").CurrentStage
	stage = tonumber(stage)
	if interceptAvailable >= stage then
		return true
	else return false
	end

end



function access_octus()
	if has("Escape") or has("Untouchable") then
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
	
	if has("Untouchable") then
		return false
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




require("scripts/autotracking/item_mapping")
require("scripts/autotracking/location_mapping")
require("scripts/autotracking/tab_mapping")


CUR_INDEX = -1
--SLOT_DATA = nil

SLOT_DATA = {}


function onClearHandler(slot_data)
    local clear_timer = os.clock()
    
    -- ScriptHost:RemoveWatchForCode("StateChange")
    -- Disable tracker updates.
    Tracker.BulkUpdate = true
    -- Use a protected call so that tracker updates always get enabled again, even if an error occurred.
    local ok, err = pcall(onClear, slot_data)
    -- Enable tracker updates again.
    if ok then
        -- Defer re-enabling tracker updates until the next frame, which doesn't happen until all received items/cleared
        -- locations from AP have been processed.
        local handlerName = "AP onClearHandler"
        local function frameCallback()
            -- ScriptHost:AddWatchForCode("StateChange", "*", StateChange)
            ScriptHost:RemoveOnFrameHandler(handlerName)
            Tracker.BulkUpdate = false
            print(string.format("Time taken total: %.2f", os.clock() - clear_timer))
        end
        ScriptHost:AddOnFrameHandler(handlerName, frameCallback)
    else
        Tracker.BulkUpdate = false
        print("Error: onClear failed:")
        print(err)
    end
end

function onClear(slot_data)
    CUR_INDEX = -1

    -- Reset locations
    for _, location_array in pairs(LOCATION_MAPPING) do
        for _, location in pairs(location_array) do
            if location then
                local location_obj = Tracker:FindObjectForCode(location)
                if location_obj then
                    if location:sub(1, 1) == "@" then
                        location_obj.AvailableChestCount = location_obj.ChestCount
                    else
                        location_obj.Active = false
                    end
                end
            end
        end
    end

    -- Reset items
    for _, item_tuples in pairs(ITEM_MAPPING) do
        for _, item_pair in pairs(item_tuples) do
            local item_code = item_pair[1]
            local item_type = item_pair[2]

            -- Find object for the item_code
            local item_obj = Tracker:FindObjectForCode(item_code)
            if item_obj then
                if item_obj.Type == "toggle" then
                    item_obj.Active = false
                elseif item_obj.Type == "progressive" then
                    item_obj.CurrentStage = 0
                    item_obj.Active = false
                elseif item_obj.Type == "consumable" then
                    if item_obj.MinCount then
                        item_obj.AcquiredCount = item_obj.MinCount
                    else
                        item_obj.AcquiredCount = 0
                    end
                elseif item_obj.Type == "progressive_toggle" then
                    item_obj.CurrentStage = 0
                    item_obj.Active = false
                end
            end
        end
    end

    


    PLAYER_ID = Archipelago.PlayerNumber or -1
	TEAM_NUMBER = Archipelago.TeamNumber or 0
    SLOT_DATA = slot_data

	DATA_STORAGE_ID = "Ys8_"..TEAM_NUMBER.."_"..PLAYER_ID.."_current_map"
	

	if Archipelago.PlayerNumber>-1 then
		print("Current slot data is", PLAYER_ID, TEAM_NUMBER)
		EVENT_ID="Ys8_"..TEAM_NUMBER.."_"..PLAYER_ID.."_current_map"
		print(string.format("SET NOTIFY %s",EVENT_ID))
		Archipelago:SetNotify({EVENT_ID})
		Archipelago:Get({EVENT_ID})
	end

    Tracker:FindObjectForCode("tab_switch").Active = 1



    local slotdata = dump(slot_data)
    print("Slot data print")
    print (slotdata)
    
    if slot_data["options"]['final_boss_access'] then
        local goal=slot_data["options"]['final_boss_access']
        if goal == 3 then
            Tracker:FindObjectForCode("Untouchable").Active = true 
        
        else
            if goal == 2 then
                Tracker:FindObjectForCode("Psyches_toggle").Active = true
                if slot_data["options"]["octus_count_psyches_mode"] and slot_data["options"]["goal_count_psyches_final_boss"] then
                    local octus_psyche = Tracker:FindObjectForCode("Psyches_Octus")
                    octus_psyche.AcquiredCount = slot_data["options"]["octus_count_psyches_mode"]
                    local goal_psyche = Tracker:FindObjectForCode("Psyches_Goal")
                    goal_psyche.AcquiredCount = slot_data["options"]["goal_count_psyches_final_boss"]
                else print("Missing information fo Psyche objectives")
                end

            else
                if goal == 1 then
                    Tracker:FindObjectForCode("Escape").Active = true

                else
                    if goal == 0 then
                        Tracker:FindObjectForCode("Castaways_toggle").Active = true
                        
                        if slot_data["options"]["octus_count_crew_mode"] and slot_data["options"]["goal_count_crew_final_boss"] then
                            local octus_psyche = Tracker:FindObjectForCode("Castaways_Octus")
                            octus_psyche.AcquiredCount = slot_data["options"]["octus_count_crew_mode"]
                            local goal_psyche = Tracker:FindObjectForCode("Castaways_Goal")
                            goal_psyche.AcquiredCount = slot_data["options"]["goal_count_crew_final_boss"]
                        else print("Missing information fo Crew objectives")
                        end
                    end
                
                
                end
            
            end
        end
    end




    if slot_data["options"]['jewel_trade_items'] then
        local jewels_max=slot_data["options"]['jewel_trade_items']
        if jewels_max==0 then
            Tracker:FindObjectForCode("Prismatic").CurrentStage = 0
        end
        if jewels_max==1 then
            Tracker:FindObjectForCode("Prismatic").CurrentStage = 1
        end
        if jewels_max==2 then
            Tracker:FindObjectForCode("Prismatic").CurrentStage = 2
        end
        if jewels_max==3 then
            Tracker:FindObjectForCode("Prismatic").CurrentStage = 3
        end
        if jewels_max==10 then
            Tracker:FindObjectForCode("Prismatic").CurrentStage = 4
        end
        if jewels_max==25 then
            Tracker:FindObjectForCode("Prismatic").CurrentStage = 5
        end
    
    end


    if slot_data["options"]['fish_trades'] then
        Tracker:FindObjectForCode("fishes").AcquiredCount = slot_data["options"]['fish_trades']
    end

    if slot_data["options"]['food_trades'] then
        Tracker:FindObjectForCode("foods").AcquiredCount = slot_data["options"]['food_trades']
    end

    if slot_data["options"]['map_completion'] then
        Tracker:FindObjectForCode("exploration").AcquiredCount = slot_data["options"]['map_completion']
    end

    if slot_data["options"]['discoveries'] then
        Tracker:FindObjectForCode("discoveries").AcquiredCount = slot_data["options"]['discoveries']*12
    end

    if slot_data["options"]['dogi_intercept_rewards'] then
        if slot_data["options"]['dogi_intercept_rewards'] == 1 then
            Tracker:FindObjectForCode("intercept_rewards").Active = true
        else Tracker:FindObjectForCode("intercept_rewards").Active = false
        end
    end

    if slot_data["options"]['master_kong_rewards'] then
        if slot_data["options"]['master_kong_rewards'] == 1 then
            Tracker:FindObjectForCode("kong_rewards").Active = true
        else Tracker:FindObjectForCode("kong_rewards").Active = false
        end
    end

    if slot_data["options"]['silvia_progression'] then
        if slot_data["options"]['silvia_progression'] == 1 then
            Tracker:FindObjectForCode("silvia_fight").Active = true
        else Tracker:FindObjectForCode("silvia_fight").Active = false
        end
    end

    if slot_data["options"]['mephorash_progression'] then
        if slot_data["options"]['mephorash_progression'] == 1 then
            Tracker:FindObjectForCode("mephorash_fight").Active = true
        else Tracker:FindObjectForCode("mephorash_fight").Active = false
        end
    end

    if slot_data["options"]['former_sanctuary_crypt'] then
        if slot_data["options"]['former_sanctuary_crypt'] == 1 then
            Tracker:FindObjectForCode("FSC Access").Active = true
        else Tracker:FindObjectForCode("FSC Access").Active = false
        end
    end

    if slot_data["options"]['north_side_open'] then
        if slot_data["options"]['north_side_open'] == 1 then
            Tracker:FindObjectForCode("NorthSideOpen").Active = true
        else Tracker:FindObjectForCode("NorthSideOpen").Active = false
        end
    end

    if slot_data["options"]['discovery_sanity'] then
        if slot_data["options"]['discovery_sanity'] == 1 then
            Tracker:FindObjectForCode("landmark_sanity").Active = true
        else Tracker:FindObjectForCode("landmark_sanity").Active = false
        end
    end


    
end



function onItem(index, item_id, item_name, player_number)
    if index <= CUR_INDEX then
        return
    end
    local is_local = player_number == Archipelago.PlayerNumber
    CUR_INDEX = index
    local item = ITEM_MAPPING[item_id]
    
    if not item or not item[1] then
        -- print(string.format("onItem: could not find item mapping for id %s", item_id))
        return
    end
    
    -- Loop through item mappings
    for _, item_tuple in pairs(item) do
        local item_code = item_tuple[1]
        local item_type = item_tuple[2]
        
        -- Debugging prints to check the item_code and item_type
        if not item_code then
            print("Error: item_code is nil")
        else
            print(string.format("Processing item_code: %s", item_code))
        end

        local item_obj = Tracker:FindObjectForCode(item_code)
        if item_obj then
            if item_obj.Type == "toggle" then
                item_obj.Active = true
            elseif item_obj.Type == "progressive" then
                item_obj.CurrentStage = item_obj.CurrentStage + 1
            elseif item_obj.Type == "consumable" then
                item_obj.AcquiredCount = item_obj.AcquiredCount + item_obj.Increment * (item_tuple[3] or 1)
            elseif item_obj.Type == "progressive_toggle" then
                item_obj.CurrentStage = item_obj.CurrentStage + 1
            end
        else
            print(string.format("onItem: could not find object for code %s", item_code))
        end
    end
    Tracker:FindObjectForCode("recipes").AcquiredCount = Tracker:ProviderCountForCode("recipe_books")+1
    Tracker:FindObjectForCode("Castaways").AcquiredCount = Tracker:ProviderCountForCode("castaway_count")
end


--called when a location gets cleared
function onLocation(location_id, location_name)
    local location_array = LOCATION_MAPPING[location_id]
    if not location_array or not location_array[1] then
        print(string.format("onLocation: could not find location mapping for id %s", location_id))
        return
    end

    for _, location in pairs(location_array) do
        local location_obj = Tracker:FindObjectForCode(location)
        -- print(location, location_obj)
        if location_obj then
            if location:sub(1, 1) == "@" then
                location_obj.AvailableChestCount = location_obj.AvailableChestCount - 1
            else
                location_obj.Active = true
            end
        else
            print(string.format("onLocation: could not find location_object for code %s", location))
        end
    end
end

function onEvent(key, value, old_value)
    updateEvents(value)
end

function onEventsLaunch(key, value)
    updateEvents(value)
end

function onNotify(key, value, old_value)
	print(string.format("called onNotify: %s, %s, %s",key,value,old_value))
	if key == DATA_STORAGE_ID then
		updateTab(value)
	end
end

function onNotifyLaunch(key, value)
	print(string.format("called onNotifyLaunch: %s, %s",key,value))
	if key == DATA_STORAGE_ID then
		updateTab(value)
	end
end

function updateTab(value)
	if value ~= nil then
	    print("updateTab", value)
		local tabswitch = Tracker:FindObjectForCode("tab_switch")
		if tabswitch.Active then
            print ("value")
            print (value)
            print ("TAB_MAPPING[value]")
            print (TAB_MAPPING[value])
			if TAB_MAPPING[value] then
				CURRENT_MAP = TAB_MAPPING[value]
                 do
					Tracker:UiHint("ActivateTab", CURRENT_MAP)
					print(string.format("Updating  Tab to %s",CURRENT_MAP))
                end
			else
				CURRENT_ROOM = TAB_MAPPING[0x00]
				print(string.format("Failed to find ID %s",value))
			end
		end
	end
end






-- ScriptHost:AddWatchForCode("settings autofill handler", "autofill_settings", autoFill)
Archipelago:AddClearHandler("clear handler", onClearHandler)
Archipelago:AddItemHandler("item handler", onItem)
Archipelago:AddLocationHandler("location handler", onLocation)
Archipelago:AddSetReplyHandler("notify handler", onNotify)
Archipelago:AddRetrievedHandler("notify launch handler", onNotifyLaunch)


function dump(o, depth)
    if depth == nil then
        depth = 0
    end
    if type(o) == 'table' then
        local tabs = ('\t'):rep(depth)
        local tabs2 = ('\t'):rep(depth + 1)
        local s = '{\n'
        for k, v in pairs(o) do
            if type(k) ~= 'number' then
                k = '"' .. k .. '"'
            end
            s = s .. tabs2 .. '[' .. k .. '] = ' .. dump(v, depth + 1) .. ',\n'
        end
        return s .. tabs .. '}'
    else
        return tostring(o)
    end
end


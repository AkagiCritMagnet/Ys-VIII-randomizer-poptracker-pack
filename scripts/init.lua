-- entry point for all lua code of the pack
-- more info on the lua API: https://github.com/black-sliver/PopTracker/blob/master/doc/PACKS.md#lua-interface
ENABLE_DEBUG_LOG = true

if ENABLE_DEBUG_LOG then
    print("Debug logging is enabled!")
end

-- Logic
ScriptHost:LoadScript("scripts/logic.lua")

-- Items
Tracker:AddItems("items/items.json")
Tracker:AddItems("items/options.json")



-- Layout
Tracker:AddLayouts("layouts/items.json")
Tracker:AddLayouts("layouts/options.json")
Tracker:AddLayouts("layouts/tracker.json")


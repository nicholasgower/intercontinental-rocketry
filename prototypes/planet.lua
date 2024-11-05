local planets={"nauvis","vulcanus","gleba","fulgora","aquilo"}
if mods["naufulglebunusilo"] then --Other known modded planets should be appended in this section. This mod appears to be one of the first modded planets.
    table.insert(planets,"naufulglebunusilo")
end
    

data.raw["space-location"]["solar-system-edge"].distance=data.raw["space-location"]["solar-system-edge"].distance*4
data.raw["space-location"]["shattered-planet"].distance=data.raw["space-location"]["shattered-planet"].distance*3.5
Planet_Locations={"north","west","east","south","temperate-south","temperate-north"}
Planet_Locations_temperature={-2,0,0,-2,-1,-1}
Planet_Locations_seed_offset={2^24,2^12,2^16,2^20,2^28,2^27}
Planet_Locations_orientation_mod={0.5,0,0,-0.5,-0.25,0.25}
Planet_Locations_label_orientation_mod={-0.125,-0.25,0.25,0.125,-0.75,-0.25}
Planet_Locations_distance_mod={0,-3,3,0,0,0}
Planet_label_mod={0.125,0.125,0.125,-0.125,-0.25}
--Planet_label_mult={1,1,1,-1,1}
--data.raw["planet"]["nauvis"].orientation=-0.5
--data.raw["planet"]["gleba"].orientation=-0.5
for i,planet in ipairs(planets) do
    local old_planet=data.raw["planet"][planet]
    old_planet.distance=old_planet.distance*4
    old_planet.magnitude=old_planet.magnitude*3
    for j,direction in ipairs(Planet_Locations) do
        local new_planet=table.deepcopy(data.raw["planet"][planet])
        new_planet.localised_name={"",{"space-location-name."..planet}," ",{"subplanet-name."..direction}}
        new_planet.localised_description={"",{"space-location-name."..planet},", ",{"subplanet-description."..direction}}
        new_planet.draw_orbit = false
        new_planet.name=old_planet.name .. "-"..direction
        new_planet.magnitude=old_planet.magnitude/2

        local solar_modifier
        if Planet_Locations_temperature[j]==-1 then

            solar_modifier=0.5
            new_planet.map_gen_settings.autoplace_controls["crude-oil"] = nil --Removes Crude oil from map_gen_settings generation 
            new_planet.map_gen_settings.autoplace_settings["entity"]["crude-oil"] = nil --Removes Crude oil from map_gen_settings generation 
        elseif Planet_Locations_temperature[j]==-2 then
            solar_modifier=0.25
            new_planet.map_gen_settings.autoplace_controls["crude-oil"] = nil --Removes Crude oil from map_gen_settings generation 
            new_planet.map_gen_settings.autoplace_controls["coal"] = nil --Removes coal from map_gen_settings generation
            new_planet.map_gen_settings.autoplace_controls["enemy-base"] = nil --Removes enemies from map_gen_settings generation
            new_planet.map_gen_settings.autoplace_controls["uranium-ore"] = nil --Removes Crude oil from map_gen_settings generation 
            new_planet.map_gen_settings.autoplace_controls["trees"] = nil --Removes enemies from map_gen_settings generation
            new_planet.map_gen_settings.autoplace_settings["entity"].settings["crude-oil"] = nil --Removes Crude oil from map_gen_settings generation 
            new_planet.map_gen_settings.autoplace_settings["entity"].settings["coal"] = nil --Removes coal from map_gen_settings generation
            new_planet.map_gen_settings.autoplace_settings["entity"].settings["enemy-base"] = nil --Removes enemies from map_gen_settings generation
            new_planet.map_gen_settings.autoplace_settings["entity"].settings["uranium-ore"] = nil --Removes Crude oil from map_gen_settings generation 
        else
            solar_modifier=1
        end    

        if old_planet.surface_properties["solar-power"] then
            new_planet.surface_properties["solar-power"]=old_planet.surface_properties["solar-power"]*solar_modifier
        else
            new_planet.surface_properties["solar-power"]=100*solar_modifier
        end
        new_planet.distance=old_planet.distance+old_planet.magnitude*Planet_Locations_distance_mod[j]
        new_planet.map_seed_offset=Planet_Locations_seed_offset[j]
        new_planet.orientation = old_planet.orientation-old_planet.magnitude*Planet_Locations_orientation_mod[j]/old_planet.distance
            if old_planet.label_orientation then --check if label orientation is defined. Important for modded planets.
                
                new_planet.label_orientation = old_planet.label_orientation+Planet_Locations_label_orientation_mod[j]
            else
                new_planet.label_orientation = Planet_Locations_label_orientation_mod[j]
            end
            if old_planet.name=="fulgora" and (direction=="west" or direction=="east") then --I don't know why fulgora's west/east labels are opposite the rest. This fixes that discrepancy.
                new_planet.label_orientation = -new_planet.label_orientation
            end
            
            
        local from_planet
        local length_multiplier =1
        if direction=="north" then
            from_planet=planet .."-" .. Planet_Locations[6]
        elseif direction=="south" then
            from_planet=planet .. "-" .. Planet_Locations[5]
        else
            from_planet=planet
        end
        if direction ~="west" and direction ~="east" then
            length_multiplier = 0.25
        end
        local new_connection= {
            type="space-connection",
            name=new_planet.name.."-"..from_planet,
            subgroup = "planet-connections",
            to=new_planet.name,
            from=from_planet,
            order = "aa",
            length=500*old_planet.magnitude*length_multiplier
        }
        if planet ~= "nauvis" then
            table.insert(data.raw["technology"]["planet-discovery-"..planet].effects,{
                type = "unlock-space-location",
                space_location = new_planet.name,
                use_icon_overlay_constant = true
            })
        end
        if planet == "nauvis" then
            if mods["cargo-ships"] then --Add cargo ships' offshore oil to secondary surfaces.
                new_planet.map_gen_settings.autoplace_controls["offshore-oil"] = {}
                new_planet.map_gen_settings.autoplace_settings.entity.settings["offshore-oil"] = {}
            end            
            table.insert(data.raw["technology"]["space-platform-thruster"].effects,{
                type = "unlock-space-location",
                space_location = new_planet.name,
                use_icon_overlay_constant = true
            })
        end
        data:extend({new_planet,new_connection})
        
    end
    if old_planet.label_orientation then
        old_planet.label_orientation=old_planet.label_orientation+Planet_label_mod[i]
    else 
        old_planet.label_orientation=Planet_label_mod[i]
    end
    
end
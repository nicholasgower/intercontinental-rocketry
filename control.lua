-- script.on_surface_created(function()
    
--         local is_subsurface = false
--         local is_tropical = false
--         local is_polar = true
--         for location in Planet_Locations do
--             if string.find(name,location) ~=nil then
--                 if location=="tropical-east" or location =="tropical-west" then
--                     is_tropical=true
--                 end
--                 if location=="polar-north" or location =="polar-south" then
--                     is_polar=true
--                 end
--                 is_subsurface=true
--                 goto break_loop
--             end
               
--         ::break_loop::
--             if is_tropical then
--                 set_evolution_factor(0.5,)
--             end
            
--         end
    
--   end)
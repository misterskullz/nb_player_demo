local nb_player_demo = {}
nb_player_demo.players = {}
nb_player_demo.rotation = 0
nb_player_demo.rotation_step = 1
nb_player_demo.rotating = false

local register_entity = minetest.register_entity
local register_node = minetest.register_node
local chat_send_all = minetest.chat_send_all
local add_entity = minetest.add_entity
local register_tool = minetest.register_tool
local pos_to_string = minetest.pos_to_string
local register_globalstep = minetest.register_globalstep

register_node("nb_player_demo:attach1_nodebox", {
	description = "Attach Nodebox 1",
	tiles = { 
		"default_stone.png",
	},
	paramtype = "light",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = { 
			{-0.25, -0.25, -0.25, 0.25, 0.25, 0.25},
		},
	},
	groups = {not_in_creative_inventory = 1},
})

register_node("nb_player_demo:attach2_nodebox", {
	description = "Attach Nodebox 2",
	tiles = {
		"default_sand.png",
	},
	paramtype = "light",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.25, -0.25, 0.25, 0.25, 0.25},
		},
	},
	groups = {not_in_creative_inventory = 1},
})


local attach1 = {
		initial_properties = {
		physical = true,
		collide_with_objects = false,
		collisionbox = {-0.25, -0.25, -0.25, 0.25, 0.25, 0.25},
		visual = "wielditem",
		visual_size = {x = 1, y = 1},
		textures = {"nb_player_demo:attach1_nodebox"},
	},
  
	attached_entity = nil,
	removed = false,
}

local attach2 = {
		initial_properties = {
		physical = true,
		collide_with_objects = false,
		collisionbox = {-0.25, -0.25, -0.25, 0.25, 0.25, 0.25},
		visual = "wielditem",
		visual_size = {x = 1, y = 1},
		textures = {"nb_player_demo:attach2_nodebox"},
	},

	attached_entity = nil,
	removed = false,
}

register_entity("nb_player_demo:attach1", attach1)
register_entity("nb_player_demo:attach2", attach2)

nb_player_demo.attach = function(user)
  chat_send_all("nb_player_demo.attach start")
  
  if not user or not user:is_player() then
    chat_send_all("nb_player_demo.attach error: " .. user)
		return
	end
  
  local player_name = user:get_player_name()
  if player_name and nb_player_demo.players[player_name] then
    chat_send_all("nb_player_demo.players record exists, removing")
    
    local p = nb_player_demo.players[player_name]
    
    p.attach6:remove()
    p.attach6 = nil
    
    p.attach5:remove()
    p.attach5 = nil
    
    p.attach4:remove()
    p.attach4 = nil
    
    p.attach3:remove()
    p.attach3 = nil
    
    p.attach2:remove()
    p.attach2 = nil
      
    p.attach1:remove()
    p.attach1 = nil
    
    p.player = nil
    
    nb_player_demo.players[player_name] = nil
  else
    chat_send_all("nb_player_demo.attach attach1 does not exist, creating")

    local pos = user:getpos()
    
    chat_send_all("nb_player_demo.attach attaching to player " .. player_name .. " at " .. pos_to_string(pos))
    
    nb_player_demo.players[player_name] = {}
    local p = nb_player_demo.players[player_name]
    p.player = user
    
    local a1 = add_entity(pos, "nb_player_demo:attach1")
    a1:set_attach(p.player, "", {x = 6, y = 10, z = 0}, {x = 0, y = 0, z = 0})
    
    local a2 = add_entity(pos, "nb_player_demo:attach2")
    a2:set_attach(a1, "", {x = 10, y = 10, z = 0}, {x = 0, y = 0, z = 0})
    
    local a5 = add_entity(pos, "nb_player_demo:attach2")
    a5:set_attach(a1, "", {x = 15, y = 5, z = 0}, {x = 0, y = 0, z = 0})
    
    local a3 = add_entity(pos, "nb_player_demo:attach1")
    a3:set_attach(p.player, "", {x = -6, y = 10, z = 0}, {x = 0, y = 0, z = 0})
    
    local a4 = add_entity(pos, "nb_player_demo:attach2")
    a4:set_attach(a3, "", {x = -10, y = 10, z = 0}, {x = 0, y = 0, z = 0})
    
    local a6 = add_entity(pos, "nb_player_demo:attach2")
    a6:set_attach(a3, "", {x = -15, y = 5, z = 0}, {x = 0, y = 0, z = 0})
    
    p.attach1 = a1
    p.attach2 = a2
    p.attach3 = a3
    p.attach4 = a4
    p.attach5 = a5
    p.attach6 = a6
  end
  
  chat_send_all("nb_player_demo.attach end")
end

nb_player_demo.rotate = function(user)
  chat_send_all("nb_player_demo.rotate start")
  
  if not nb_player_demo.rotating then
    nb_player_demo.rotating = true
  else
    nb_player_demo.rotating = false
  end
  
  chat_send_all("nb_player_demo.rotate end")
end

nb_player_demo.step = function(dtime)
  -- hack: should temper rotation speed by dtime, but doesn't
  
  if nb_player_demo.rotating then
    --chat_send_all("nb_player_demo.step rotating")
    nb_player_demo.rotation = nb_player_demo.rotation + nb_player_demo.rotation_step
    local r = nb_player_demo.rotation
    
    for i,player in pairs(nb_player_demo.players) do
      -- hack: assume there are player and 6 attach
      local p = player.player
      
      --chat_send_all("nb_player_demo.step rotating for player " .. p:get_player_name())
      local a1 = player.attach1
      local a2 = player.attach2
      local a3 = player.attach3
      local a4 = player.attach4
      local a5 = player.attach5
      local a6 = player.attach6
      
      a1:set_attach(p, "", {x = 6, y = 10, z = 0}, {x = r , y = 0, z = 0})
      a2:set_attach(a1, "", {x = 10, y = 10, z = 0}, {x = 0, y = r , z = 0})
      a5:set_attach(a1, "", {x = 15, y = 5, z = 0}, {x = 0, y = 2 * r, z = 0})
      a3:set_attach(p, "", {x = -6, y = 10, z = 0}, {x = -1 * r , y = 0, z = 0})
      a4:set_attach(a3, "", {x = -10, y = 10, z = 0}, {x = 0, y = -1 * r , z = 0})
      a6:set_attach(a3, "", {x = -15, y = 5, z = 0}, {x = 0, y = -2 * r, z = 0})
    end
  end
end


register_tool("nb_player_demo:tester", {
	description = "Tester",
	inventory_image = "screwdriver.png",
	on_use = function(itemstack, user, pointed_thing)
		nb_player_demo.attach(user)
	end,
  on_place = function(itemstack, user, pointed_thing)
		nb_player_demo.rotate(user)
	end,
})

register_globalstep(nb_player_demo.step)
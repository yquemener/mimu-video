--Minetest
--Copyright (C) 2014 sapier
--
--This program is free software; you can redistribute it and/or modify
--it under the terms of the GNU Lesser General Public License as published by
--the Free Software Foundation; either version 2.1 of the License, or
--(at your option) any later version.
--
--This program is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--GNU Lesser General Public License for more details.
--
--You should have received a copy of the GNU Lesser General Public License along
--with this program; if not, write to the Free Software Foundation, Inc.,
--51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.


--------------------------------------------------------------------------------
-- LazyCube simplified main menu                                              --
--------------------------------------------------------------------------------
local function get_formspec(tabview, name, tabdata)
	common_update_cached_supp_proto()
	local fav_selected
	local retval =
		"formspec_version[2]"..
		"size[10,10]"..
		"field[1,1		;3,1 ;name;name;]"..
		"pwdfield[6,1		;3,1 ;password;password]"..
		"image[-4,3   ;4,4;"..mm_texture.defaulttexturedir:gsub("\\", "/").."/lcm1.png]"..
		"image[10,3   ;4,4;"..mm_texture.defaulttexturedir:gsub("\\", "/").."/lcm2.png]"..
		"button[2,3.5 ;6,1.5;btn_join_server;Connect to workshop]" ..
		"button[2,5.5   ;6,1.5;btn_join_test;Connect to test room]" ..
		"button[2,7.5 ;6,1.5;btn_play_solo;Tutorial]"
	return retval
end

--------------------------------------------------------------------------------
local function valid(s)
	if s:gsub("[A-Za-z0-9_%-%.]","")=="" then
    return true
	else
    return false
	end
end

--------------------------------------------------------------------------------
local function handle_buttons(self,fields)
  core.debug("handle_buttons")
	core.debug(dump(fields))

	if fields['btn_join_server'] ~= nil then
		if not valid(fields['password']) or not valid(fields['name']) then
			core.debug("invalid name or password")
		else
			local cmd = "start /min "..core.get_builtin_path().."../bin/Mumble/mumble.exe mumble://"..
								 fields['name']..":"..fields['password']..
								 "@minetest.iv-labs.org:/Lala"
			core.debug(cmd)
			os.execute(cmd)
		  gamedata.playername = fields['name']
			gamedata.password = fields['password']
		 	gamedata.address = "minetest.iv-labs.org"
		 	gamedata.port = 30000
		 	gamedata.selected_world = 0
		 	gamedata.singleplayer   = false
			core.start()
		end
	elseif fields['btn_join_test'] ~= nil then
		if not valid(fields['password']) or not valid(fields['name']) then
			core.debug("invalid name or password")
		else
			local cmd = "start /min "..core.get_builtin_path().."../bin/Mumble/mumble.exe mumble://"..
								 fields['name']..":"..fields['password']..
								 "@minetest.iv-labs.org:/TestRoom"
			core.debug(cmd)
			os.execute(cmd)
		  gamedata.playername = fields['name']
			gamedata.password = "bienvenue!"
		 	gamedata.address = "minetest.iv-labs.org"
		 	gamedata.port = 30001
		 	gamedata.selected_world = 0
		 	gamedata.singleplayer   = false
			core.start()
		end
	elseif fields['btn_play_solo'] ~= nil then
		gamedata.address = nil
		gamedata.port = nil
		gamedata.selected_world = 1
		gamedata.singleplayer   = true
		core.start()
	end


	if self.hidden then
		return false
	end

	if self.glb_btn_handler ~= nil and
		self.glb_btn_handler(self,fields) then
		return true
	end
	return false
end

--------------------------------------------------------------------------------
local function handle_events(self,event)
core.debug("handle_events")
	if self.hidden then
		return false
	end

	if self.glb_evt_handler ~= nil and
		self.glb_evt_handler(self,event) then
		return true
	end
	return false
end


--------------------------------------------------------------------------------
local function tab_header(self)

	local toadd = ""

	for i=1,#self.tablist,1 do

		if toadd ~= "" then
			toadd = toadd .. ","
		end

		toadd = toadd .. self.tablist[i].caption
	end
	return string.format("tabheader[%f,%f;%s;%s;%i;true;false]",
			self.header_x, self.header_y, self.name, toadd, self.last_tab_index);
end


--------------------------------------------------------------------------------
local function hide_lala(self)
	self.hidden=true
end

--------------------------------------------------------------------------------
local function show_lala(self)
	self.hidden=false
end

local lala_metatable = {
	handle_buttons            = handle_buttons,
	handle_events             = handle_events,
	get_formspec              = get_formspec,
	show                      = show_lala,
	hide                      = hide_lala,
	delete                    = function(self) ui.delete(self) end,
	set_parent                = function(self,parent) self.parent = parent end,
	set_global_button_handler =
			function(self,handler) self.glb_btn_handler = handler end,
	set_global_event_handler =
			function(self,handler) self.glb_evt_handler = handler end,
	set_fixed_size =
			function(self,state) self.fixed_size = state end
}

lala_metatable.__index = lala_metatable

--------------------------------------------------------------------------------
function lala_create(name, size, tabheaderpos)
	local self = {}

	self.name     = name
	self.type     = "toplevel"
	self.width    = size.x
	self.height   = size.y
	self.header_x = tabheaderpos.x
	self.header_y = tabheaderpos.y

	setmetatable(self, lala_metatable)

	self.fixed_size     = true
	self.hidden         = true
	self.current_tab    = nil
	self.last_tab_index = 1
	self.tablist        = {}

	self.autosave_tab   = false

	ui.add(self)
	return self
end

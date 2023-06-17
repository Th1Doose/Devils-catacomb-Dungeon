quest devils_catacomb begin
	state start begin

		function setting()
			return
			{
				["floor3_stone"] = 8038,
				["floor3_stone_pos"] =
				{
					{ 1366, 150 },
					{ 1366, 351 },
					{ 1234, 365 },
					{ 1234, 140 },
					{ 1150, 135 },
					{ 1130, 365 },
					{ 1135, 253 }
				},

				["devil_king_pos"] =
				{
					{ 673, 829 },
					{ 691, 638 },
					{ 848, 568 },
					{ 1026, 642 },
					{ 1008, 862 }
				},

				["floor5_stone_pos"] = { 848, 735 },
				["unlock_stone"] = 30312,

				["devil_great_king"] = 2597,
				["devil_great_king_pos"] = { 1303, 704 },
				["devil_emperor"] = 2598,
				["devil_emperor_pos"] = { 74, 1103 },

			}
		end

		when logout begin
			if pc.get_map_index() >= 2160000 and pc.get_map_index() < 2170000 then
				if pc.get_empire() == 3 then
					d.set_warp_location(425, 21469, 2448)
					d.exit_all()
				elseif pc.get_empire() == 2 then
					d.set_warp_location(425, 21469, 2448)
					d.exit_all()
				elseif pc.get_empire() == 1 then
					d.set_warp_location(425, 21469, 2448)
					d.exit_all()
				end
			end
		end

		-- Entry
		when 20367.chat."DC Entry" with pc.get_level() >= 50 begin
			say_title("DC Entry")
			say("Want to go inside dungeon?")
			local s = select("Yes","No")
			if s == 1 then
				if party.is_party() then
					d.new_jump_party(216, 3145, 12095)
					d.set_regen_file("data/dungeon/devilcatacomb/dc_1f_regen.txt")
					d.setf("niv", 1)
					
				elseif not party.is_party() then
					d.new_jump(216, 314500, 1209500)
					d.set_regen_file("data/dungeon/devilcatacomb/dc_1f_regen.txt")
					d.setf("niv", 1)
				end
			elseif s == 2 then
				return
			end
		end

		-- First Floor

		when login with d.getf("niv") == 1 begin
			if pc.get_map_index() >= 2160000 and pc.get_map_index() < 2170000 then
				say_title("DC Dung")
				say("Hi, you need to get")
				say("the key from the monsters.")
				say("Kill them until you drop it!")
				say("Once you drop, send it to the npc!")
				say("You have 35 minutes to finish this dungeon.")
				say("")
				say("Good Luck!")
				timer("thirty_five_mins", 60*35, d.get_map_index())
			end
		end

		when kill with d.getf("niv") == 1 begin
			if pc.get_map_index() >= 2160000 and pc.get_map_index() < 2170000 then
				local j = number(1, 100)
				if j == 1 then
					game.drop_item(30311, 1)
				end
			end
		end

		when 30101.take with item.vnum == 30311 begin
			if d.getf("niv") == 1 then
				chat("You used the key, in 5 seconds you will be teleported to next place.")
				pc.remove_item(30311, 1)
				npc.purge()
				d.setf("niv", 2)
				timer("dc_room_2", 5)
			elseif d.getf("niv") > 1 then
				say_title("DC Dung")
				say("Return to first floor")
			end
		end

		when dc_room_2.timer begin
			d.jump_all(3622, 12077)
			d.set_regen_file("data/dungeon/devilcatacomb/dc_2f_regen.txt")
			d.notice("Destroy the doors and find Schrumpfkopf and bring it to the turtle")
		end

		-- Second Floor

		when kill with d.getf("niv") == 2 begin
			if pc.get_map_index() >= 2160000 and pc.get_map_index() < 2170000 then
				local i = number(1, 100)
				if i == 1 then
					game.drop_item(30319, 1)
				end
			end
		end

		when 30103.take with item.vnum == 30319 begin
			if d.getf("niv") == 2 then
				chat("You used the key, in 5 seconds you will be teleported to next place.")
				pc.remove_item(30319, 1)
				npc.purge()
				timer("dc_room_3", 5)
			elseif d.getf("niv") > 2 or d.getf("niv") < 2 then
				say_title("DC Dung")
				say("Return to the second floor")
			end
		end

		--Verdadeira Metin
		when dc_room_3.timer begin
			local setting = devils_catacomb.setting()
			d.jump_all(4435, 12281)
			d.set_regen_file("data/dungeon/devilcatacomb/dc_3f_regen.txt")
			d.setf("niv", 3)
			d.notice ("Find and Destroy the true Metinstone to get to next Stage")
			local position = setting.floor3_stone_pos
			local n = number(1, 7)
			for i = 1, 7 do
				if (i ~= n) then
					d.set_unique("fake"..i, d.spawn_mob(setting.floor3_stone, position[i][1], position[i][2]))
				end
			end

			local vid = d.spawn_mob(setting.floor3_stone, position[n][1], position[n][2])
			d.set_unique("real", vid)
		end
		

		-- Third Floor

		when 8038.kill with pc.in_dungeon(216) begin
			local setting = devils_catacomb.setting()
			if d.is_unique_dead("real") then
				d.notice("You destroyed the true Stone. You will be teleported in 5 seconds.") --825
				d.setf("niv", 4)
				timer("dc_room_4", 5)
			else
				d.notice("You destroyed the wrong Stone. Find the true one and destroy it.") --826
			end
		end
		--Fim da Verdadeira Metin

		when dc_room_4.timer begin
			local setting = devils_catacomb.setting()
			local n = number(1, 5)
			d.jump_all(3918, 12930)
			d.set_regen_file("data/dungeon/devilcatacomb/dc_5f_regen.txt")
			d.notice("Kill Tartaros! He was in one of the Rooms under the mountain!! Bring the FratzenTotem on top of the mountain und drag and drop it on the obelisk to get to the next stage!")
			d.spawn_mob(2591, setting.devil_king_pos[n][1], setting.devil_king_pos[n][2])
			d.spawn_mob(30102, setting.floor5_stone_pos[1], setting.floor5_stone_pos[2])
		end


		-- Fourth Floor

		when 2591.kill begin
			local setting = devils_catacomb.setting()
			game.drop_item(setting.unlock_stone, 1)
			d.notice("You killed Tartaros, he dropped 1 key, bring it to the top NPC and drag it to it.")
		end

		when 30102.take begin
			local setting = devils_catacomb.setting()
			if item.vnum == setting.unlock_stone then
				item.remove()
				d.notice("You will be teleported in 5 seconds.") --829
				d.clear_regen()
				d.purge()
				timer("dc_room_5", 5)
			end
		end

		when dc_room_5.timer begin
			local setting = devils_catacomb.setting()
			d.jump_all(4434, 12703)
			d.notice ("Now you have to kill Charon! Do it and you will be teleported to last stage!")
			d.set_regen_file("data/dungeon/devilcatacomb/dc_6f_regen.txt")
			d.spawn_mob(setting.devil_great_king, setting.devil_great_king_pos[1], setting.devil_great_king_pos[2])
		end

		-- Fifth Floor

		when 2597.kill with pc.in_dungeon(216) begin
			d.clear_regen()
			d.kill_all()
			d.notice("You killed Charon! In 5 seconds you will be teleported to the last stage! Good Luck!") --830
			timer("dc_room_6", 5)
		end

		when dc_room_6.timer begin
			local setting = devilcatacomb_zone.setting()
			d.jump_all(3145, 13181)
			d.notice ("Now you have to Kill Azrael!!")
			d.regen_file("data/dungeon/devilcatacomb/dc_7f_regen.txt")
			d.spawn_mob(setting.devil_emperor, setting.devil_emperor_pos[1], setting.devil_emperor_pos[2])
		end

		-- Sixth Floor

		when thirty_five_mins.timer with d.select(get_server_timer_arg()) begin
			if pc.get_map_index() >= 2160000 and pc.get_map_index() < 2170000 then
				if pc.get_empire() == 3 then
					d.set_warp_location(425, 21469, 2448)
					d.exit_all()
				elseif pc.get_empire() == 2 then
					d.set_warp_location(425, 21469, 2448)
					d.exit_all()
				elseif pc.get_empire() == 1 then
					d.set_warp_location(425, 21469, 2448)
					d.exit_all()
				end
			end
		end

		when 2598.kill with pc.in_dungeon(216) begin
			d.notice("You Killd the God of demons!The darkness is over and the Evil are banned! Come back to Home Warrior! You teleport out in 60 Seconds.")
			d.clear_regen()
			d.kill_all()
			timer("dc_room_leave", 60)
			clear_server_timer("thirty_five_mins", d.get_map_index())
		end

		when dc_room_leave.timer begin
			clear_server_timer("thirty_five_mins", d.get_map_index())
			if pc.get_map_index() >= 2160000 and pc.get_map_index() < 2170000 then
				if pc.get_empire() == 3 then
					d.set_warp_location(425, 21469, 2448)
					d.exit_all()
				elseif pc.get_empire() == 2 then
					d.set_warp_location(425, 21469, 2448)
					d.exit_all()
				elseif pc.get_empire() == 1 then
					d.set_warp_location(425, 21469, 2448)
					d.exit_all()
				end
			end
		end

	end
end
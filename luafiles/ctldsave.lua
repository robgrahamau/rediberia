-- Simple Group Saving by Pikey May 2019 https://github.com/thebgpikester/SimpleGroupSaving/
-- Usage of this script should credit the following contributors:
 --Pikey, 
 --Speed & Grimes for their work on Serialising tables, included below,
 --FlightControl for MOOSE (Required)
 
 --INTENDED USAGE
 --DCS Server Admins looking to do long term multi session play that will need a server reboot in between and they wish to keep the Ground 
 --Unit positions true from one reload to the next.
 
 --USAGE
 --Ensure LFS and IO are not santitised in missionScripting.lua. This enables writing of files. If you don't know what this does, don't attempt to use this script.
 --Requires versions of MOOSE.lua supporting "SET:ForEachGroupAlive()". Should be good for 6 months or more from date of writing. 
 --MIST not required, but should work OK with it regardless.
 --Edit 'SaveScheduleUnits' below, (line 34) to the number of seconds between saves. Low impact. 10 seconds is a fast schedule.
 --Place Ground Groups wherever you want on the map as normal.
 --Run this script at Mission start
 --The script will create a small file with the list of Groups and Units.
 --At Mission Start it will check for a save file, if not there, create it fresh
 --If the table is there, it loads it and Spawns everything that was saved.
 --The table is updated throughout mission play
 --The next time the mission is loaded it goes through all the Groups again and loads them from the save file.
 
 --LIMITATIONS
 --Only Ground Groups and Units are specified, play with the SET Filter at your own peril. Could be adjusted for just one Coalition or a FilterByName().
 --See line 107 and 168 for the SET.
 defaultlogisticUnits = {
 "FARP1-1",
    "FARP1-4",
    "FARP2-1",
    "FARP3-1",
    "FARP3-2",
    "FARP-Kaemka",
    "FARP-Otrytka",
    "RFARP1-1",
    "RFARP2-1",    
    "RFARP3-1",
}


 --Configurable for user:
local SaveSchedulePersistence=60 --how many seconds between each check of all the statics.
 --AllGroups = SET_GROUP:New():FilterCategories("ground"):FilterPrefixes({"RSAM","RRSUP","REWR","BSAM","BEWR",}):FilterActive(true):FilterStart()
 ctldper = false
 ctldsave = {}
local savefilename = "ctldsave.lua"
 
local savefile = lfs.writedir() .."rib\\" .. savefilename
 -----------------------------------
 --Do not edit below here
 -----------------------------------
 local version = "1.1"
 
 function IntegratedbasicSerialize(s)
    if s == nil then
      return "\"\""
    else
      if ((type(s) == 'number') or (type(s) == 'boolean') or (type(s) == 'function') or (type(s) == 'table') or (type(s) == 'userdata') ) then
        return tostring(s)
      elseif type(s) == 'string' then
        return string.format('%q', s)
      end
    end
  end
  
-- imported slmod.serializeWithCycles (Speed)
  function IntegratedserializeWithCycles(name, value, saved)
    local basicSerialize = function (o)
      if type(o) == "number" then
        return tostring(o)
      elseif type(o) == "boolean" then
        return tostring(o)
      else -- assume it is a string
        return IntegratedbasicSerialize(o)
      end
    end

    local t_str = {}
    saved = saved or {}       -- initial value
    if ((type(value) == 'string') or (type(value) == 'number') or (type(value) == 'table') or (type(value) == 'boolean')) then
      table.insert(t_str, name .. " = ")
      if type(value) == "number" or type(value) == "string" or type(value) == "boolean" then
        table.insert(t_str, basicSerialize(value) ..  "\n")
      else

        if saved[value] then    -- value already saved?
          table.insert(t_str, saved[value] .. "\n")
        else
          saved[value] = name   -- save name for next time
          table.insert(t_str, "{}\n")
          for k,v in pairs(value) do      -- save its fields
            local fieldname = string.format("%s[%s]", name, basicSerialize(k))
            table.insert(t_str, IntegratedserializeWithCycles(fieldname, v, saved))
          end
        end
      end
      return table.concat(t_str)
    else
      return ""
    end
  end

function file_exists(name) --check if the file already exists for writing
    if lfs.attributes(name) then
    BASE:E({"Mission file found"})
    return true
    else
    BASE:E({"Mission file not found"})
    return false end 
end

function writemission(data, file)--Function for saving to file (commonly found)
  File = io.open(file, "w")
  File:write(data)
  File:close()
end

--SCRIPT START
env.info("Loaded RIB SAVE, version " .. version)
if resetall == 0 then
  if file_exists(savefile) then --Script has been run before, so we need to load the save
    dofile(savefile)
	if ctldsave[1] ~= nil then
		ctld.completeAASystems = ctldsave[1]
	else
		ctld.completeAASystems = {}
	end
    if ctldsave[2] ~= nil then
		ctld.droppedTroopsRED = ctldsave[2]
	else
		ctld.droppedTroopsRED = {}
	end
	if ctldsave[3] ~= nil then
		ctld.droppedTroopsBLUE = ctldsave[3]
	else
		ctld.droppedTroopsBLUE = {}
	end
    if ctldsave[4] ~= nil then
		ctld.droppedVehiclesRED = ctldsave[4]
	else
		ctld.droppedVehiclesRED = {}
	end
	if ctldsave[5] ~= nil then
		ctld.droppedVehiclesBLUE = ctldsave[5]
	else
		ctld.droppedVehiclesBLUE = {}
	end
    if ctldsave[6] ~= nil then
		ctld.jtacUnits = ctldsave[6]
		local _jtacGroupName = nil
		local _jtacUnit = nil
		for _jtacGroupName, _jtacDetails in pairs(ctld.jtacUnits) do
			print("_jtacGroupName is:" .. _jtacGroupName .. "Units we don't care about")
			local _code = table.remove(ctld.jtacGeneratedLaserCodes, 1)
            --put to the end
            table.insert(ctld.jtacGeneratedLaserCodes, _code)
            ctld.JTACAutoLase(_jtacGroupName, _code) --(_jtacGroupName, 
		end
		
		
	else
		ctld.jtacUnits = {}
	end
    if ctldsave[7] ~= nil then
		ctld.builtFOBS = ctldsave[7]
	else
		ctld.builtFOBS = {}
	end
	if ctldsave[8] ~= nil then
		ctld.logisticUnits = ctldsave[8]
	else
		BASE:E({"WARNING CTLD SAVE TABLE 8 WAS EMPTY!!!! GENERATING FROM DEFAULT VALUES"})
		--ctld.logisticUnits = defaultlogisticUnits
    end
	if ctldsave[9] ~= nil then
		ctld.extractableGroups = ctldsave[9]
	else
		ctld.extractableGroups = {}
	end

	--ctld.jtacGeneratedLaserCodes = ctldsave[10]
	--ctld.jtacLaserPointCodes = ctldsave[11]
	--ctld.nextUnitId = ctldsave[12]
	--ctld.nextGroupId = ctldsave[13]
    env.info("Main Mission: Existing database, loading from File.")
    BASE:E({ctldsave})
    ctldper = true
  else
    env.info("Main Mission: We couldn't find an existing Database to load from file")
  end
else
  if resetall == 1 then
    env.info("Main Mission: PersistedStore.resetall was 1")
    ctldper = false
  end
end


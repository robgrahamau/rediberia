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
 --See https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Set.html##(SET_GROUP)
 --Naval Groups not Saved. If Included, there may be issues with spawned objects and Client slots where Ships have slots for aircraft/helo. Possible if not a factor
 --Statics are not included. See 'Simple Static Saving' for a solution
 --Routes are not saved. Uncomment lines 148-153 if you wish to keep them, but they won't activate them on restart. It is impossible to query a group for it's current
 --route, only for the original route it recieved from the Mission Editor. Therefore a DCS limitation.
 -----------------------------------
 --Configurable for user:
local SaveSchedulePersistence=60 --how many seconds between each check of all the statics.
 --AllGroups = SET_GROUP:New():FilterCategories("ground"):FilterPrefixes({"RSAM","RRSUP","REWR","BSAM","BEWR",}):FilterActive(true):FilterStart()
 gpar = false
 mainmission = {
    ["RedSukSpawned"] = 0,
    ["RedGudSpawned"] = 0,
    ["RedSenSpawned"] = 0,
    ["RedKutSpawned"] = 0,
    ["RedArmySpawned"] = 0,
    ["RedArmy1Spawned"] = 0,
    ["BlueSukSpawned"] = 0,
    ["BlueGudSpawned"] = 0,
    ["BlueSenSpawned"] = 0,
    ["BlueKutSpawned"] = 0,
    ["BlueKobSpawned"] = 0,
    ["BlueArmySpawned"] = 0,
    ["BlueArmy1Spawned"] = 0,
    ["BlueArmy2Spawned"] = 0,
  }
local savefilename = "mainmissionsave.lua"
 
local savefile = lfs.writedir() .."rib\\" .. savefilename
 -----------------------------------
 --Do not edit below here
 -----------------------------------
 local version = "1.0"
 
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
if PersistedStore.resetall == 0 then
  if file_exists(savefile) then --Script has been run before, so we need to load the save
    dofile(savefile)
    env.info("Main Mission: Existing database, loading from File.")
    BASE:E({mainmission})
    gpar = true
  else
    env.info("Main Mission: We couldn't find an existing Database to load from file")
  end
else
  if PersistedStore.resetall == 1 then
    env.info("Main Mission: PersistedStore.resetall was 1")
    gpar = false
  end
end


function savenewpersistence(ourthread)
  BASE:E({"RUNNING PERSISTENCE FOR MAINMISSION"})
  BASE:E({"DUMPING OURTHREAD",ourthread})
  if ourthread.RedSukSpawned == 0 then
      mainmission.RedSukSpawned = 0 
  else
      mainmission.RedSukSpawned = ourthread.RedSukSpawned:GetName()
  end
  if ourthread.RedGudSpawned == 0 then
    mainmission.RedGudSpawned = 0
  else
    mainmission.RedGudSpawned = ourthread.RedGudSpawned:GetName()
  end
  if ourthread.RedSenSpawned == 0 then
    mainmission.RedSenSpawned = 0
  else
    mainmission.RedSenSpawned = ourthread.RedSenSpawned:GetName()
  end
  if ourthread.RedKutSpawned == 0 then
    mainmission.RedKutSpawned = 0
  else
    mainmission.RedKutSpawned = ourthread.RedKutSpawned:GetName()
  end
  if ourthread.RedArmySpawned == 0 then
    mainmission.RedArmySpawned = 0
  else
    mainmission.RedArmySpawned = ourthread.RedArmySpawned:GetName()
  end
  if ourthread.RedArmy1Spawned == 0 then
    mainmission.RedArmy1Spawned = 0 
  else
    mainmission.RedArmy1Spawned = ourthread.RedArmy1Spawned:GetName()
  end
  if ourthread.BlueSukSpawned == 0 then
    mainmission.BlueSukSpawned = 0
  else
    mainmission.BlueSukSpawned = ourthread.BlueSukSpawned:GetName()
  end
  if ourthread.BlueGudSpawned == 0 then
    mainmission.BlueGudSpawned = 0
  else
    mainmission.BlueGudSpawned = ourthread.BlueGudSpawned:GetName()
  end
  if ourthread.BlueSenSpawned == 0 then
    mainmission.BlueSenSpawned = 0
  else
    mainmission.BlueSenSpawned = ourthread.BlueSenSpawned:GetName()
  end
  if ourthread.BlueKutSpawned == 0 then
    mainmission.BlueKutSpawned = 0
  else
    mainmission.BlueKutSpawned = ourthread.BlueKutSpawned:GetName()
  end
  if ourthread.BlueKobSpawned == 0 then
    mainmission.BlueKobSpawned = 0 
  else 
    mainmission.BlueKobSpawned = ourthread.BlueKobSpawned:GetName()
  end
  if ourthread.BlueArmySpawned == 0 then
    mainmission.BlueArmySpawned = 0
  else
    mainmission.BlueArmySpawned = ourthread.BlueArmySpawned:GetName()
  end
  if ourthread.BlueArmy1Spawned == 0 then
    mainmission.BlueArmy1Spawned = 0
  else
    mainmission.BlueArmy1Spawned = ourthread.BlueArmy1Spawned:GetName()
  end
  if ourthread.BlueArmy2Spawned == 0 then
    mainmission.BlueArmy2Spawned = 0
  else
    mainmission.BlueArmy2Spawned = ourthread.BlueArmy2Spawned:GetName()
  end
  BASE:E({"DONE RUNNING PERSISTENCE FOR MAINMISSION"})
  BASE:E({"Our Thread table is",ourthread})
  BASE:E({"MAINMISSION TABLE IS",mainmission})
end

function savenewpersistencenow(ourthread)
  env.info("FORCE DATA Data SAVE!!!!!!!!!!.")
  savenewpersistence(ourthread)
  newMissionStr = IntegratedserializeWithCycles("mainmission",mainmission) --save the Table as a serialised type with key SaveUnits
  writemission(newMissionStr, savefile)--write the file from the above to SaveUnits.lua
  env.info("Data saved.")
end
--THE SAVING SCHEDULE
SCHEDULER:New( nil, function()
if init == true then
  savenewpersistence(mainthread)
  newMissionStr = IntegratedserializeWithCycles("mainmission",mainmission) --save the Table as a serialised type with key SaveUnits
  writemission(newMissionStr, savefile)--write the file from the above to SaveUnits.lua
  env.info("Data saved.")
else
  env.info("init was not true not saving")
end
end, {}, 1, SaveSchedulePersistence)
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
    ["RedSochiSpawned"] = 0,
    ["RedArmySpawned"] = 0,
    ["RedArmy1Spawned"] = 0,
    ["RedArmy2Spawned"] = 0,
    ["BlueSukSpawned"] = 0,
    ["BlueGudSpawned"] = 0,
    ["BlueSenSpawned"] = 0,
    ["BlueKutSpawned"] = 0,
    ["BlueKobSpawned"] = 0,
    ["BlueArmySpawned"] = 0,
    ["BlueArmy1Spawned"] = 0,
    ["BlueArmy2Spawned"] = 0,
    ["novosqnsize"] = 32,
    ["maysqnsize"] = 24,
    ["mozsqnsize"] = 24,
    ["krazsqnsize"] = 24,
    ["sochisqnsize"] = 12,
    ["redgroundsupply"] = 100,
    ["redairsupply"] = 12,
    ["bluegroundsupply"] = 100,
    ["blueairsupply"] = 12,
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


function savenewpersistence(RedSukSpawned,RedSochiSpawned,RedGudSpawned,RedSenSpawned,RedKutSpawned,RedArmySpawned,RedArmy1Spawned,RedArmy2Spawned,BlueSukSpawned,BlueGudSpawned,BlueSenSpawned,BlueKutSpawned,BlueKobSpawned,BlueArmySpawned,BlueArmy1Spawned,BlueArmy2Spawned)
  BASE:E({"RUNNING PERSISTENCE FOR MAINMISSION"})
  if RedSukSpawned == 0 then
      mainmission.RedSukSpawned = 0 
  else
    if RedSukSpawned:IsAlive() == true then
      mainmission.RedSukSpawned = RedSukSpawned:GetName()
    else
      mainmission.RedSukSpawned = 0
    end
  end
  if RedSochiSpawned == 0 then
      mainmission.RedSochiSpawned = 0 
  else
    if RedSochiSpawned:IsAlive() == true then
      mainmission.RedSochiSpawned = RedSochiSpawned:GetName()
    else
      mainmission.RedSochiSpawned = 0
    end
  end
  if RedGudSpawned == 0 then
    mainmission.RedGudSpawned = 0
  else
    if RedGudSpawned:IsAlive() == true then
      mainmission.RedGudSpawned = RedGudSpawned:GetName()
    else
      mainmission.RedGudSpawned = 0
    end
  end
  if RedSenSpawned == 0 then
    mainmission.RedSenSpawned = 0
  else
    if RedSenSpawned:IsAlive() == true then
      mainmission.RedSenSpawned = RedSenSpawned:GetName()
    else
      mainmission.RedGudSpawned = 0
    end
  end
  if RedKutSpawned == 0 then
    mainmission.RedKutSpawned = 0
  else
    if RedKutSpawned:IsAlive() == true then
      mainmission.RedKutSpawned = RedKutSpawned:GetName()
    else
      mainmission.RedKutSpawned = 0
    end
  end
  if RedArmySpawned == 0 then
    mainmission.RedArmySpawned = 0
  else
    if RedArmySpawned:IsAlive() == true then
      mainmission.RedArmySpawned = RedArmySpawned:GetName()
    else
      mainmission.RedArmySpawned = 0
    end
  end
  if RedArmy1Spawned == 0 then
    mainmission.RedArmy1Spawned = 0 
  else
    if RedArmy1Spawned:IsAlive() == true then
      mainmission.RedArmy1Spawned = RedArmy1Spawned:GetName()
    else
      mainmission.RedArmy1Spawned = 0
    end
  end
  if RedArmy2Spawned == 0 then
    mainmission.RedArmy2Spawned = 0 
  else
    if RedArmy2Spawned:IsAlive() == true then
      mainmission.RedArmy2Spawned = RedArmy2Spawned:GetName()
    else
      mainmission.RedArmy2Spawned = 0
    end
  end
  if BlueSukSpawned == 0 then
    mainmission.BlueSukSpawned = 0
  else
    if BlueSukSpawned:IsAlive() == true then
      mainmission.BlueSukSpawned = BlueSukSpawned:GetName()
    else
      mainmission.BlueSukSpawned = 0
    end
  end
  if BlueGudSpawned == 0 then
    mainmission.BlueGudSpawned = 0
  else
    if BlueGudSpawned:IsAlive() == true then
      mainmission.BlueGudSpawned = BlueGudSpawned:GetName()
    else
      mainmission.BlueGudSpawned = 0
    end
  end
  if BlueSenSpawned == 0 then
    mainmission.BlueSenSpawned = 0
  else
    if BlueSenSpawned:IsAlive() == true then
      mainmission.BlueSenSpawned = BlueSenSpawned:GetName()
    else
      mainmission.BlueSenSpawned = 0
    end
  end
  if BlueKutSpawned == 0 then
    mainmission.BlueKutSpawned = 0
  else
    if BlueKutSpawned:IsAlive() == true then
      mainmission.BlueKutSpawned = BlueKutSpawned:GetName()
    else
      mainmission.BlueKutSpawned = 0
    end
  end
  if BlueKobSpawned == 0 then
    mainmission.BlueKobSpawned = 0 
  else 
    if BlueKobSpawned:IsAlive() == true then
      mainmission.BlueKobSpawned = BlueKobSpawned:GetName()
    else
      mainmission.BlueKobSpawned = 0
    end
  end
  if BlueArmySpawned == 0 then
    mainmission.BlueArmySpawned = 0
  else
    if BlueArmySpawned:IsAlive() == true then
      mainmission.BlueArmySpawned = BlueArmySpawned:GetName()
    else
      mainmission.BlueArmySpawned = 0
    end
  end
  if BlueArmy1Spawned == 0 then
    mainmission.BlueArmy1Spawned = 0
  else
    if BlueArmy1Spawned:IsAlive() == true then
      mainmission.BlueArmy1Spawned = BlueArmy1Spawned:GetName()
    else
      mainmission.BlueArmy1Spawned = 0
    end
  end
  if BlueArmy2Spawned == 0 then
    mainmission.BlueArmy2Spawned = 0
  else
    if BlueArmy2Spawned:IsAlive() == true then
      mainmission.BlueArmy2Spawned = BlueArmy2Spawned:GetName()
    else
      mainmission.BlueArmy2Spawned = 0
    end
  end
  if novosqnsize ~= nil then
    mainmission.novosqnsize = novosqnsize
  else
    mainmission.novosqnsize = 32
  end
  if maysqnsize ~= nil then
    mainmission.maysqnsize = maysqnsize
  else
    mainmission.maysqnsize = 24  
  end
  if mozsqnsize ~= nil then
    mainmission.mozsqnsize = mozsqnsize
  else
    mainmission.mozsqnsize = 24
  end
  if krazsqnsize ~= nil then
    mainmission.krazsqnsize = krazsqnsize
  else
    mainmission.krazsqnsize = 24
  end
  if sochisqnsize ~= nil then
    mainmission.sochisqnsize = sochisqnsize
  else
    mainmission.sochisqnsize = 12
  end
  if redgroundsupply ~= nil then
    mainmission.redgroundsupply = redgroundsupply
  else
    BASE:E({"Warning rib save saw a nil value on redground supply! setting to 200"})
    redgroundsupply = 200
  end
  if redairsupply ~= nil then
    mainmission.redairsupply = redairsupply
  else
    BASE:E({"Warning rib save saw a nil value on redground supply! setting to 4"})
    mainmission.redairsupply = 4
  end
  if bluegroundsupply ~= nil then
    mainmission.bluegroundsupply = bluegroundsupply
  else
    BASE:E({"Warning rib save saw a nil value on blueground supply! setting to 200"})
    bluegroundsupply = 200
  end
  if blueairsupply ~= nil then
    mainmission.redairsupply = blueairsupply
  else
    BASE:E({"Warning rib save saw a nil value on redground supply! setting to 4"})
    mainmission.blueairsupply = 4
  end
  BASE:E({"DONE RUNNING PERSISTENCE FOR MAINMISSION"})
  BASE:E({"Our Thread table is",ourthread})
  BASE:E({"MAINMISSION TABLE IS",mainmission})
end

function savenewpersistencenow(RedSukSpawned,RedSochiSpawned,RedGudSpawned,RedSenSpawned,RedKutSpawned,RedArmySpawned,RedArmy1Spawned,RedArmy2Spawned,BlueSukSpawned,BlueGudSpawned,BlueSenSpawned,BlueKutSpawned,BlueKobSpawned,BlueArmySpawned,BlueArmy1Spawned,BlueArmy2Spawned)
  env.info("FORCE DATA Data SAVE!!!!!!!!!!.")
  savenewpersistence(RedSukSpawned,RedSochiSpawned,RedGudSpawned,RedSenSpawned,RedKutSpawned,RedArmySpawned,RedArmy1Spawned,RedArmy2Spawned,BlueSukSpawned,BlueGudSpawned,BlueSenSpawned,BlueKutSpawned,BlueKobSpawned,BlueArmySpawned,BlueArmy1Spawned,BlueArmy2Spawned)
  newMissionStr = IntegratedserializeWithCycles("mainmission",mainmission) --save the Table as a serialised type with key SaveUnits
  writemission(newMissionStr, savefile)--write the file from the above to SaveUnits.lua
  env.info("Data saved.")
end
--THE SAVING SCHEDULE
SCHEDULER:New( nil, function()
if init == true then
  savenewpersistence(mainthread.RedSukSpawned,mainthread.RedSochiSpawned,mainthread.RedGudSpawned,mainthread.RedSenSpawned,mainthread.RedKutSpawned,mainthread.RedArmySpawned,mainthread.RedArmy1Spawned,mainthread.RedArmy2Spawned,mainthread.BlueSukSpawned,mainthread.BlueGudSpawned,mainthread.BlueSenSpawned,mainthread.BlueKutSpawned,mainthread.BlueKobSpawned,mainthread.BlueArmySpawned,mainthread.BlueArmy1Spawned,mainthread.BlueArmy2Spawned)
  newMissionStr = IntegratedserializeWithCycles("mainmission",mainmission) --save the Table as a serialised type with key SaveUnits
  writemission(newMissionStr, savefile)--write the file from the above to SaveUnits.lua
  env.info("Data saved.")
else
  env.info("init was not true not saving")
end
end, {}, 1, SaveSchedulePersistence)
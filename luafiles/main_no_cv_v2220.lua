
env.info("----------------------------------------------------------")
env.info("--------------RED IBERIA VERSION ".. version .." -----------")
env.info("--------------last update:" .. lastupdate .. "-----------------------------------")
env.info("--------------By Robert Graham for TGW -------------------")
env.info("--------------USES MOOSE AND CTDL ------------------------")




SupportHandler = EVENTHANDLER:New()

-------- Main CONSTANT Variables ----------

BlueHq = GROUP:FindByName("BHQ") -- blue hq
BCC = COMMANDCENTER:New(BlueHq,"Coalition HQ")

RedHq = GROUP:FindByName("RHQ") -- red hq items
RCC = COMMANDCENTER:New(RedHq,"Russian HQ")
RAS = ZONE_POLYGON:New("RAS",GROUP:FindByName("RAS"))
RAS1 = ZONE_POLYGON:New("RAS1",GROUP:FindByName("RAS1")) -- red airspace
RAS2 = ZONE_POLYGON:New("RAS2",GROUP:FindByName("RAS2")) -- red airspace
BAS = ZONE_POLYGON:New("BAS",GROUP:FindByName("BAS"))
BAS1 = ZONE_POLYGON:New("BAS1",GROUP:FindByName("BAS1")) -- bull airspace
-- SAS = ZONE_POLYGON:New("SAS",GROUP:FindByName("SAS")) -- Stennis airspace
-- SAS1 = ZONE_POLYGON:New("SAS1",GROUP:FindByName("SAS1")) -- Stennis airspace
RCAP = ZONE_POLYGON:New("RED CAPZONE",GROUP:FindByName("RCAP"))
RCAP2 = ZONE_POLYGON:New("RED CAPZONE1",GROUP:FindByName("RCAP2"))
RCAP3 = ZONE_POLYGON:New("RED CAPZONE2",GROUP:FindByName("RCAP3"))
BCAP = ZONE_POLYGON:New("BLUE CAPZONE",GROUP:FindByName("BCAP"))
BCAP2 = ZONE_POLYGON:New("BLUE CAPZONE1",GROUP:FindByName("BCAP2"))
BCAP3 = ZONE_POLYGON:New("BLUE CAPZONE2",GROUP:FindByName("BCAP3"))

novocommand = GROUP:FindByName("Novocommand")
krymskcommand = GROUP:FindByName("Krymskcommand")
krazcommand = GROUP:FindByName("Krascommand")
mozcommand = GROUP:FindByName("mozcommand")
maycommand = GROUP:FindByName("Maycommand")

novo1 = 0
may1 = 0
moz1 = 0
kraz1 = 0

nfmc = ZONE:New("nozinfo")
nfmc = nfmc:GetCoordinate()
nfm = nfmc:MarkToAll("Novorossiysk Factory Awaiting Sat Pass",true)
kfmc = ZONE:New("krasinfo")
kfmc = kfmc:GetCoordinate()
kfm = kfmc:MarkToAll("Krasnador Factory Awaiting Sat Pass",true)
apsmc = ZONE:New("apsinfo")
apsmc = apsmc:GetCoordinate()
apsm = apsmc:MarkToAll("Apsheronsk Factory Awaiting Sat Pass",true)
cfmc = ZONE:New("cherkinfo")
cfmc = cfmc:GetCoordinate()
cfm = cfmc:MarkToAll("Cherkessk Factory Awaiting Sat Pass",true)
mfmc = ZONE:New("mayskiyinfo")
mfmc = mfmc:GetCoordinate()
mfm = mfmc:MarkToAll("Mayskiy Factory Awaiting Sat Pass",true)
gfmc = ZONE:New("gleninfo")
gfmc = gfmc:GetCoordinate()
gfm = gfmc:MarkToAll("Gelendzhik Factory Awaiting Sat Pass",true)
bluescore = 0
redscore = 0
do
_mc = mozcommand:GetCoordinate()
_nc = novocommand:GetCoordinate()
_mac = maycommand:GetCoordinate()
_kc = krazcommand:GetCoordinate()
_mm = _mc:MarkToAll("Mozdok Command Center, Active",true)
_nm = _nc:MarkToAll("Novorossisk Command Center, Active",true)
_mam = _mac:MarkToAll("Maykop Command Center, Active",true)
_km = _kc:MarkToAll("Kraznador Command Center, Active",true)
end

RInsurgTemplates = {"InsGroup_1","InsGroup_2","InsGroup_3"}
BInsurgTemplates = {"BInsurg1","BInsurg1"}
RArmyTemplates = {"RTEMP_ARMY1","RTEMP_ARMY2","RTEMP_ARMY3"}
BInsurgentZones = {ZONE:New("BZONE1"),ZONE:New("BZONE2"),ZONE:New("BZONE3"),ZONE:New("BZONE4"),ZONE:New("BZONE5"),ZONE:New("BZONE6")}
InsurgentZones = {ZONE:New("SPOT1"),ZONE:New("SPOT2"),ZONE:New("SPOT3"),ZONE:New("SPOT4"),ZONE:New("SPOT5"),ZONE:New("SPOT6"),ZONE:New("SPOT7")}
InsurgentCount = 0
RAttackSpawnZone = ZONE_POLYGON:New("RedAttackSpawnZone",GROUP:FindByName("RedAttack")) -- RED AREA THAT CAN BE SPAWNED IN WHEN ATTACKING.
BAttackSpawnZone = ZONE_POLYGON:New("BlueAttackSpawnZone",GROUP:FindByName("BlueAttack")) -- Blue Attack SPAWN zone.
RDefSpawnZone = ZONE_POLYGON:New("RedDefenceSpawnZone",GROUP:FindByName("RedDefence")) -- Red defence spawn area
BDefSpawnZone = ZONE_POLYGON:New("BlueDefenceSpawnZone",GROUP:FindByName("BlueDefence")) -- blue defence spawn area.
LandZone = ZONE_POLYGON:New("LandZone",GROUP:FindByName("landZone")) -- this is our land zone when we are routing shit we want to make certain the ground stuff is inside it.
RCAPTEMPLATES = { "SQN112-1","SQN112-2", "SQN112-3","SQN112-4","SQN112-5","SQN112-6"}
BCAPTEMPLATES = {"SQN147","SQN147-1","SQN147-2","SQN147-3","SQN192-1","SQN192","SQN192-2","SQN192-3"}
-- RDETGROUP = SET_GROUP:New():FilterPrefixes({ "REWR","Wizard","RSAM",}):FilterStart()
BDETGROUP = SET_GROUP:New():FilterPrefixes({"BEWR","Overlord","Magic","BSAM",}):FilterStart()
SetPlayer = SET_CLIENT:New():FilterStart()
SetPlayerRed = SET_CLIENT:New():FilterCoalitions("red"):FilterStart()
SetPlayerBlue = SET_CLIENT:New():FilterCoalitions("blue"):FilterStart()
Scoring = SCORING:New("Scoring")
redobject = ""
rcomms = ""
bcomms = ""
blueobject = ""
GUDOWNER = 1
SUKOWNER = 1
SOCHIOWNER = 1
SENOWNER = 2
KUTOWNER = 2
KOBOWNER = 2

attacker = 2 -- which coalition is attacking 1 = red 2 = blue 
round = 0 -- what round are we on for this attacker?
rsupplies = 100
bsupplies = 100
BSweepAmount = 30
RSweepAmount = 30
ASAMCount = 3 -- How many SAMS can the Attacker put down using spawns?
DSAMCount = 5 -- How many SAMS can the Defender put down using spawns?
DGMax = 10 -- Maximum # of Ground Groups for the Defenders
AGMax = 10 -- Maximum # of Ground Groups for the Attackers
SukhumiTakeover = GROUP:FindByName("SUK-BLUE") -- When initalising if we need BLUE to control Sukhimi we use this
SukhumiTakeover1 = GROUP:FindByName("SUK-RED") -- When initalising if we need BLUE to control Sukhimi we use this
GudautaTakeover = GROUP:FindByName("GUD-BLUE") -- When Initalising if we need Blue to control Guduata we use this.
GudautaTakeover1 = GROUP:FindByName("GUD-RED") -- When Initalising if we need Blue to control Guduata we use this.
SochiTakeOver = GROUP:FindByName("SOCHITAKEOVER")
SenakiTakeover = GROUP:FindByName("Senaki-Takeover") -- Red take over for Senaki
KutaisiTakeover = GROUP:FindByName("Kut-Takeover")
GUDZONE = ZONE:New("PICKUP-GUD")
GUDZONEL = ZONE:New("GUDZONEL") 
SUKZONE = ZONE:New("PICKUP-BAB")
SUKZONEL = ZONE:New("SUKZONEL")
KOBZONE = ZONE:New("KOBZONE")
KOBZONEL = ZONE:New("KOBZONEL")
KUTZONE = ZONE:New("KUTZONE")
KUTZONEL = ZONE:New("KUTZONEL")
SENZONE = ZONE:New("SENZONE")
SENZONEL = ZONE:New("SENZONEL")
SOCHIZONE = ZONE:New("PICKUP-SOCHI")
S6ZONE = ZONE:New("state6")
-- store our zone coords
dg = GUDZONE:GetCoordinate()
ds = SUKZONE:GetCoordinate()
dse = SENZONE:GetCoordinate()
dk = KUTZONE:GetCoordinate()
dko = KOBZONE:GetCoordinate()
dso = SOCHIZONE:GetCoordinate()
ds6 = S6ZONE:GetCoordinate()
PlayerMap = {}
PlayerRMap = {}
PlayerBMap = {}
glz = ZONE:New("GUDLOG")
glzc = glz:GetCoordinate()
glr = nil
glb = nil
slz = ZONE:New("SUKLOG")
slzc = slz:GetCoordinate()
slb = nil
slr = nil
local PlayerMenuMap = {}
BAICAP = GROUP:FindByName("BAI_CAP")
BAICAPSpawn = SPAWN:NewWithAlias("BAI_CAP","UZI88"):InitCleanUp(360):OnSpawnGroup(function(SpawnGroup) 
  if BAICAP ~= nil then
    BAICAP:Destroy()
  end
  BAICAP = SpawnGroup
  BSweepAmount = BSweepAmount - 2
  if BSweepAmount < 0 then 
    BSweepAmount = 0
  end
  BCC:MessageToCoalition('SU-27s are scrambling, they should be on station for tasking on the F10 Map in under 5 minutes and will remain until BINGO, Winchester or Dead')
end)
RAICAP = GROUP:FindByName("Silence1")
RAICAPSpawn = SPAWN:NewWithAlias("Silence1","SIL11"):OnSpawnGroup(function(spawngroup)
  if RAICAP:IsAlive() then
    RAICAP:Destroy()
  end
  RAICAP = spawngroup
  RSweepAmount = RSweepAmount - 2
  if RSweepAmount < 0 then 
    RSweepAmount = 0
  end
end,{}):InitCleanUp(300):InitRepeatOnEngineShutDown()


-- carrier status and update items -- 
-- stennis = GROUP:FindByName("Stennis") -- get the stennis group

BLUEAWAC = GROUP:FindByName("Overlord")
init = false
RTOE = {}
BTOE = {}

function _redobject()
  RCC:MessageToCoalition(redobject)
end

function _blueobject()
  BCC:MessageToCoalition(blueobject)
end

function _redcomms()
  RCC:MessageToCoalition(rcomms)
end

function _bluecomms()
  BCC:MessageToCoalition(bcomms)
end




function findstate(unit,currentstate,unitside,altattack)
  -- ok lets work out what state we are meant to be in.
  -- first off we hate the following states now
  -- state 0 - move to Sochi.
  -- state 1 - move to gudauta
  -- state 2 - move to sukhumi
  -- state 3 - move to senaki
  -- state 4 - move to kutasi
  -- state 5 - move to kobulette
  -- state 6 - special movement to the bottom of gori valley 
  -- 7- 8 reserverd
  -- state 9 - attacking
  -- state 10 - idle
  -- state 99 revert to last state

  
  if rdebug == true then
    BASE:E({"FindState Unit,currentstate,side,altattack",unit:GetName(),currentstate,unitside,altattack})
  end
  
  local cp = unit:GetCoordinate() -- get our current unit position
  local dp = dso
  
  if currentstate == 0 then
    dp = dso -- destination point is Sochizone
  elseif currentstate == 1 then
    dp = dg
  elseif currentstate == 2 then
    dp = ds
  elseif currentstate == 3 then
    dp = dse
  elseif currentstate == 4 then
    dp = dk
  elseif currentstate == 5 then
    dp = dko
  elseif currentstate == 6 then
    dp = ds6
  end
  if rdebug == true then
    BASE:E({"FindState top of states"})
  end
  
  
  if unitside == 1 and altattack == false then
  if rdebug == true then
        BASE:E({"findstate, side 1 alt attack = false",unitside,altattack})  
  end

  if SOCHIOWNER ~= 1 then
    if rdebug == true then
      BASE:E({"findstate side 1 sochi owner not 1 altattack false sochiowner:",SOCHIOWNER,basestate})  
    end
    return 0
  elseif GUDOWNER ~= 1 then
    -- we need to work out out current state and start moving back if state
        -- is 5 or 4 we go to 3 if state is 3 we go to 2 if state is 2 we move straight to 1.
    if currentstate == 10 then
      return 1
    elseif currentstate == 9 then
      return 99
    elseif currentstate ~= 1 then
      if cp:Get2DDistance(dp) < 500 then
        BASE:E({"Find State 2d Distance less then 500",cp:Get2DDistance(dp)})
        if currentstate == 5 or currentstate == 4 then
          return 3
        elseif currentstate == 3 then
          return 2
        elseif currentstate == 2 then
          return 1
        elseif currentstate == 0 then
          return 1
        end
      else
        return currentstate
      end
    elseif currentstate == 1 then
        return 1
    end
  elseif SUKOWNER ~= 1 then
    if rdebug == true then
      BASE:E({"findstate sukowner not 1 red side altattack false"})
    end 
      -- we need to work out out current state and start moving back if state
      -- is 5 or 4 we go to 3 if state is 3 we go to 2 if state is 2 we move straight to 1.
    if currentstate == 10 then
      return 2
    elseif currentstate == 9 then
      return 99
    elseif currentstate ~= 2 then
      if cp:Get2DDistance(dp) < 500 then
        BASE:E({"Find State 2d Distance less then 500",cp:Get2DDistance(dp)})
        if currentstate == 5 or currentstate == 4 then
          return 3
        elseif currentstate == 3 then
          return 2
        elseif currentstate == 1 then
          return 2
        elseif currentstate == 0 then
          return 1
        end
      else
        return currentstate
      end
    else
        return 2
    end
  elseif SENOWNER ~= 1 then
    if rdebug == true then
      BASE:E({"findstate senowner not 1 red side altattack false"})
    end
    if currentstate == 10 then
      return 3
    elseif currentstate == 9 then
      return 99
    elseif currentstate ~= 3 then
      if cp:Get2DDistance(dp) < 500 then
        BASE:E({"Find State 2d Distance less then 500",cp:Get2DDistance(dp)})
        if currentstate == 5 then
          return 3
        elseif currentstate == 4 then
          return 3
        elseif currentstate == 2 then
          return 3
        elseif currentstate == 1 then
          return 2
        elseif currentstate == 0 then
          return 1
        end
      else
        return currentstate
      end
    else
      return 3
    end
  elseif KUTOWNER ~= 1 then
    if rdebug == true then
      BASE:E({"findstate kutowner not 1 red side altattack false"})
    end 
    if currentstate == 10 then
      return 4
    elseif currentstate == 9 then
      return 99
    elseif currentstate ~= 4 then
      if cp:Get2DDistance(dp) < 500 then
        if currentstate == 5 then
          return 4
        elseif currentstate == 3 then
          return 4
        elseif currentstate == 2 then
          return 3
        elseif currentstate == 1 then
          return 2
        elseif currentstate == 0 then
          return 1
        end
      else
        return currentstate
      end
    else
      return 4     
    end
  elseif KOBOWNER ~= 1 then
    if rdebug == true then
      BASE:E({"kobstate gudowner not 1 red side altattack false"})
    end
    if currentstate == 10 then
      return 5
    elseif currentstate == 9 then
      return 99
    elseif currentstate ~= 5 then
      BASE:E({"Find State 2d Distance less then 500",cp:Get2DDistance(dp)})
      if cp:Get2DDistance(dp) < 500 then
        if currentstate == 4 then
          return 5
        elseif currentstate == 3 then
          return 5
        elseif currentstate == 2 then
          return 3
        elseif currentstate == 1 then
          return 2
        elseif currentstate == 0 then
          return 1
        end
      else
        return currentstate
      end
    else
      return 5         
    end
  else
    if rdebug == true then
      BASE:E({"find state none worked setting 10"})
    end
    return 10
  end  
elseif unitside == 1 and altattack == true then
  if rdebug == true then
    BASE:E({"findstate side 1 altattack == true",unitside,altattack})  
  end  
  if SOCHIOWNER ~= 1 then
    BASE:E({"findstate side 1 sochi owner not 1 altattack false sochiowner:",SOCHIOWNER})
    return 5 -- Take Kobuleti from them please.
  elseif currentstate == 6 then
    if rdebug == true then
      BASE:E({"findstate We are in state 6 this is a unique state"})  
    end
    if cp:Get2DDistance(dp) < 1000 then
      BASE:E({"Find State 6 2d Distance less then 1000",cp:Get2DDistance(dp)})
      return 4
    else
      BASE:E({"Find State 6 2d Distance",cp:Get2DDistance(dp)})
      return 6      
    end
  elseif KUTOWNER ~= 1 then
    if rdebug == true then
      BASE:E({"findstate KutOwner not 1 side 1 alt attack true"})
    end
    -- we need to work out out current state and start moving back if state
    if currentstate == 10 then
      return 4
    elseif currentstate == 9 then
      return 99
    elseif currentstate ~= 4 then
      if cp:Get2DDistance(dp) < 500 then
        BASE:E({"Find State 2d Distance less then 500",cp:Get2DDistance(dp)})
        if currentstate == 5 then
          return 4
        elseif currentstate == 3 then
          return 4
        elseif currentstate == 2 then
          return 4
        elseif currentstate == 1 then
          return 2
        elseif currentstate == 0 then
          return 1
        end
      else
        return currentstate
      end
    else
        return 4
    end  
  elseif SENOWNER ~= 1 then
    if rdebug == true then
      BASE:E({"findstate SENOwner not 1 side 1 alt attack true"})
    end
          -- we need to work out out current state and start moving back if state
        if currentstate == 10 then
          return 3
        elseif currentstate == 9 then
          return 99
        elseif currentstate ~= 3 then
      if cp:Get2DDistance(dp) < 500 then
        if currentstate == 5 then
          return 3
        elseif currentstate == 4 then
          return 3
        elseif currentstate == 2 then
          return 3
        elseif currentstate == 1 then
          return 2
        elseif currentstate == 0 then
          return 1
        end
      else
        return currentstate
      end
    else
        return 3
    end
  elseif KOBOWNER ~= 1 then
    if rdebug == true then
      BASE:E({"findstate KobOwner not 1 side 1 alt attack true"})
        end
    -- we need to work out out current state and start moving back if state
        if currentstate == 10 then
      return 5
        elseif currentstate == 9 then
      return 99
        elseif currentstate ~= 5 then
      if cp:Get2DDistance(dp) < 500 then
        if currentstate == 4 then
          return 5
        elseif currentstate == 3 then
          return 5
        elseif currentstate == 2 then
          return 3
        elseif currentstate == 1 then
          return 2
        elseif currentstate == 0 then
          return 1
        end
      else
        return currentstate
      end
    else
  
              return 5
    
        end
  elseif SUKOWNER ~= 1 then
        if rdebug == true then
          BASE:E({"findstate SUKOwner not 1 side 1 alt attack true"})
        end
        -- we need to work out out current state and start moving back if state
        if currentstate == 10 then
          return 2
        elseif currentstate == 9 then
          return 99
        elseif currentstate ~= 2 then
      if cp:Get2DDistance(dp) < 500 then
        if currentstate == 5 then
          return 3
        elseif currentstate == 4 then
          return 3
        elseif currentstate == 3 then
          return 2
        elseif currentstate == 1 then
          return 2
        elseif currentstate == 0 then
          return 1
        end      
      else
        return currentstate
      end
        else
  
              return 2
    
        end
  elseif GUDOWNER ~= 1  then
        if rdebug == true then
      BASE:E({"findstate GUDOwner not 1 side 1 alt attack true"})
        end
        -- we need to work out out current state and start moving back if state
        if currentstate == 10 then
      return 1
        elseif currentstate == 9 then
      return 99
        elseif currentstate ~= 1 then
      if cp:Get2DDistance(dp) < 500 then
        if currentstate == 5 then
          return 3
        elseif currentstate == 4 then
          return 3
        elseif currentstate == 3 then
          return 2
        elseif currentstate == 2 then
          return 1
        elseif currentstate == 0 then
          return 1
        end
      else
        return currentstate
      end
        else
  
              return 1
      end
    else
        if rdebug == true then
          BASE:E({"findstate None matched return 10 "})  
        end
        return 10
    end
elseif unitside == 2 and altattack == false then
    if rdebug == true then
        BASE:E({"findstate side 2 alt attack false",unitside,altattack})  
    end
    -- If we are Blue and we do not Hold Kobuleti then we want Kobuleti back.
    -- We will Immediately Path for Kobuleti, we don't give a shit about anything else.
    -- Kobuleti must be ours, Red Heathans may not be allowed to desecrate it's sacred litterboxes
    -- besides Kosh has his claws at our throats for ever letting Red get this far.
    if KOBOWNER ~= 2 then
        BASE:E({"findstate side 2 Kobowner 2 KOBOWNER:",KOBOWNER})
        return 5
    elseif KUTOWNER ~= 2 then
        if rdebug == true then
          BASE:E({"findstate KUTowner not 2 side 2"})
    end
    -- we need to work out out current state and start moving back if state
    if currentstate == 10 then
      return 4
    elseif currentstate == 9 then
      return 99
    elseif currentstate ~= 4 then
      if cp:Get2DDistance(dp) < 500 then
        if currentstate == 5 then
          return 4
        elseif currentstate == 3 then
          return 4
        elseif currentstate == 2 then
          return 4
        elseif currentstate == 1 then
          return 2
        elseif currentstate == 0 then
          return 1
        end
      else
        return currentstate
      end
    else
        return 4
    end
    elseif SENOWNER ~= 2 then
    if rdebug == true then
      BASE:E({"findstate Kobowner not 2 side 2"})
    end
    -- we need to work out out current state and start moving back if state
    if currentstate == 10 then
      return 3
    elseif currentstate == 9 then
      return 99
    elseif currentstate ~= 3 then
      if cp:Get2DDistance(dp) < 500 then
        if currentstate == 5 then
          return 3
        elseif currentstate == 4 then
          return 3
        elseif currentstate == 2 then
          return 3
        elseif currentstate == 1 then
          return 2
        elseif currentstate == 0 then
          return 1
        end
      else
        return currentstate
      end
    else
        return 3
    
     end
    elseif SUKOWNER ~= 2 then
    if rdebug == true then
      BASE:E({"findstate Sukowner not 2 side 2 alt attack false"})
    end
    -- we need to work out out current state and start moving back if state
    if currentstate == 10 then
      return 2
    elseif currentstate == 9 then
      return 99
    elseif currentstate ~= 2 then
      if cp:Get2DDistance(dp) < 500 then
        if currentstate == 5 then
          return 3
        elseif currentstate == 4 then
          return 3
        elseif currentstate == 3 then
          return 2
        elseif currentstate == 1 then
          return 2
        elseif currentstate == 0 then
          return 1
        end
      else
        return currentstate
      end
        else
          return 2
      end
    elseif GUDOWNER ~= 2 then
    -- we need to work out out current state and start moving back if state
    if rdebug == true then
      BASE:E({"findstate Gudowner not 2 side 2 alt attack false"})
    end
    if currentstate == 10 then
      return 1
    elseif currentstate == 9 then
      return 99
    elseif currentstate ~= 1 then
      if cp:Get2DDistance(dp) < 500 then
        if currentstate == 5 then
          return 3
        elseif currentstate == 4 then
          return 3
        elseif currentstate == 3 then
          return 2
        elseif currentstate == 2 then
          return 1
        elseif currentstate == 0 then
          return 1
        end
      else
        return currentstate
      end
    else
              return 1
    end
    elseif SOCHIOWNER ~= 2 then
    if rdebug == true then
      BASE:E({"findstate Sukowner not 2 side 2 alt attack false"})
    end
    -- we need to work out out current state and start moving back if state
    if currentstate == 10 then
      return 0
    elseif currentstate == 9 then
      return 99
    elseif currentstate ~= 0 then
      if cp:Get2DDistance(dp) < 500 then
        if currentstate == 5 then
          return 3
        elseif currentstate == 4 then
          return 3
        elseif currentstate == 3 then
          return 2
        elseif currentstate == 2 then
          return 1
        elseif currentstate == 1 then
          return 0
        end
      else
        return currentstate
      end
    else
        return 0   
    end
  end
elseif unitside == 2 and altattack == true then
  if rdebug == true then
          BASE:E({"findstate unitside 2 altattack =true",unitside,altattack})
    end
  if KOBOWNER ~= 2 then
        if rdebug == true then
      BASE:E({"findstate side 2 Kobowner 2 KOBOWNER:",KOBOWNER})
    end
        return 5
    elseif KUTOWNER ~= 2 then
        if rdebug == true then
          BASE:E({"findstate KUTowner not 2 side 2"})
    end
    -- we need to work out out current state and start moving back if state
    if currentstate == 10 then
      return 4
    elseif currentstate == 9 then
      return 99
    elseif currentstate ~= 4 then
      if cp:Get2DDistance(dp) < 500 then
        if currentstate == 5 then
          return 4
        elseif currentstate == 3 then
          return 4
        elseif currentstate == 2 then
          return 4
        elseif currentstate == 1 then
          return 2
        elseif currentstate == 0 then
          return 1
        end
      else
        return currentstate
      end
        else
          return 4 
    end
    elseif SENOWNER ~= 2 then
    if rdebug == true then
      BASE:E({"findstate Kobowner not 2 side 2"})
        end
    -- we need to work out out current state and start moving back if state
        if currentstate == 10 then
          return 3
        elseif currentstate == 9 then
          return 99
        elseif currentstate ~= 3 then
      if cp:Get2DDistance(dp) < 500 then
        if currentstate == 5 then
          return 3
        elseif currentstate == 4 then
          return 3
        elseif currentstate == 2 then
          return 3
        elseif currentstate == 1 then
          return 2
        elseif currentstate == 0 then
          return 1
        end
      else
        return currentstate
      end
        else
              return 3 
        end
    end
else
  BASE:E({"Warning we did not find any States that were valid"})
end  
  
  if rdebug == true then
  BASE:E({"End of States"})
  end
  return 10
end

-- routes ground units to a certain zone based on state.
 function routeground(_group,state,road)
  if forceground == true then
    road = false
  end
  if rdebug == true then
    BASE:E({"routeground:",_group:GetName(),state,road})
  end
  if state == 0 and road == true then
    _group:RouteGroundOnRoad(SOCHIZONE:GetRandomCoordinate(0,300),math.random(10,30),5,randomform())
    if rdebug == true then
      BASE:E({"routeground: route command sent",_group:GetName(),state,road})
    end
  end
  if state == 0 and road == false then
    _group:RouteGroundTo(SOCHIZONE:GetRandomCoordinate(0,300),math.random(10,20),randomform(),5)
    if rdebug == true then
      BASE:E({"routeground: route command sent",_group:GetName(),state,road})
    end
  end
  if state == 1 and road == true then
    _group:RouteGroundOnRoad(GUDZONE:GetRandomCoordinate(0,200),math.random(10,30),5,randomform())
    if rdebug == true then
      BASE:E({"routeground: route command sent",_group:GetName(),state,road})
    end
  end
  if state == 1 and road == false then
    _group:RouteGroundTo(GUDZONE:GetRandomCoordinate(0,200),math.random(10,20),randomform(),5)
    if rdebug == true then
      BASE:E({"routeground: route command sent",_group:GetName(),state,road})
    end
  end
  if state == 2 and road == true then
    _group:RouteGroundOnRoad(SUKZONE:GetRandomCoordinate(0,200),math.random(10,30),5,randomform())
    if rdebug == true then
      BASE:E({"routeground: route command sent",_group:GetName(),state,road})
    end
  end
  if state == 2 and road == false then
    _group:RouteGroundTo(SUKZONE:GetRandomCoordinate(0,200),math.random(10,20),randomform(),5)
    if rdebug == true then
      BASE:E({"routeground: route command sent",_group:GetName(),state,road})
    end
  end
  if state == 3 and road == true then
    _group:RouteGroundOnRoad(SENZONE:GetRandomCoordinate(0,200),math.random(10,30),5,randomform())
    if rdebug == true then
      BASE:E({"routeground: route command sent",_group:GetName(),state,road})
    end
  end
  if state == 3 and road == false then
    _group:RouteGroundTo(SENZONE:GetRandomCoordinate(0,200),math.random(10,20),randomform(),5)
    if rdebug == true then
      BASE:E({"routeground: route command sent",_group:GetName(),state,road})
    end
  end
  if state == 4 and road == true then
    _group:RouteGroundOnRoad(KUTZONE:GetRandomCoordinate(0,200),math.random(10,30),5,randomform())
    if rdebug == true then
      BASE:E({"routeground: route command sent",_group:GetName(),state,road})
    end
  end
  if state == 4 and road == false then
    _group:RouteGroundTo(KUTZONE:GetRandomCoordinate(0,200),math.random(10,20),randomform(),5)
    if rdebug == true then
      BASE:E({"routeground: route command sent",_group:GetName(),state,road})
    end
  end
  if state == 5 and road == true then
    _group:RouteGroundOnRoad(KOBZONE:GetRandomCoordinate(0,200),math.random(10,30),5,randomform())
    if rdebug == true then
      BASE:E({"routeground: route command sent",_group:GetName(),state,road})
    end
  end
  if state == 5 and road == false then
    _group:RouteGroundTo(KOBZONE:GetRandomCoordinate(0,200),math.random(10,20),randomform(),5)
    if rdebug == true then
      BASE:E({"routeground: route command sent",_group:GetName(),state,road})
    end
  end
  if state == 6 then
    _group:RouteGroundTo(S6ZONE:GetCoordinate(),math.random(10,20),randomform(),5)
    if rdebug == true then
      BASE:E({"routeground: route command sent",_group:GetName(),state,road})
    end
  end
  if rdebug == true then
    BASE:E({"routeground: End"})
  end
 end
 




-- RIB core class
RIB = {
ClassName = "RIB",
REDAWAC = nil,
RAWACS = nil,
REDTNKR = nil,
RTNKR = nil,
BLUAWAC = nil,
BLUAWAC2 = nil,
BAWACS2 = nil,
BAWACS = nil,
BLUTNKR = nil,
BLUTNKR2 = nil,
BTNKR = nil,
BTNKR2 = nil,
RedDetection = nil,
RedA2AD = nil,
BluDetection = nil,
BlueA2AD = nil,
Tscheduler = nil,
RedSochiDef = GROUP:FindByName("RTEMP Sochi Def"),
RedSochiDefSpawn = SPAWN:NewWithAlias("RTEMP Sochi Def","RAF Sochi Defense"):InitRandomizePosition(true,200,5),
RedSochiSpawned = 0,
RedSukDef = GROUP:FindByName("RTEMP Sukhumi Def"),
RedSukDefSpawn = SPAWN:NewWithAlias("RTEMP Sukhumi Def","RAF Sukhumi Defense"):InitRandomizePosition(true,200,0),
RedSukSpawned = 0,
RedGudDef = GROUP:FindByName("RTEMP Gudauta Def"),
RedGudDefSpawn = SPAWN:NewWithAlias("RTEMP Gudauta Def","RAF Gudauta Defense"):InitRandomizePosition(true,200,0),
RedGudSpawned = 0,
RedSenDef = GROUP:FindByName("RTEMP Sen Def"),
RedSenSpawn = SPAWN:NewWithAlias("RTEMP Sen Def","RAF Senaki Defense"),
RedSenSpawned = 0,
RedKutDef = GROUP:FindByName("RTEMP Kut Def"),
RedKutSpawn = SPAWN:NewWithAlias("RTEMP Kut Def","RAF Kutasi Defense"),
RedKutSpawned = 0,
RedArmy = GROUP:FindByName("Russian Army"),
RedArmySpawn = SPAWN:NewWithAlias("Russian Army","RAF 1st Division"):InitRandomizeTemplate(RArmyTemplates),
RedArmySpawned = 0,
RedArmyAlive = 1,
RedArmyX = 0,
RedArmyY = 0,
RedArmyState = 0,
RedArmyStateL = 10,
RedArmy1Spawn = SPAWN:NewWithAlias("Russian Army 2","RAF 2nd Division"):InitRandomizeTemplate(RArmyTemplates),
RedArmy1 = GROUP:FindByName("Russian Army 2"),
RedArmy1Spawned = 0,
RedArmy1Alive = 1,
RedArmy1X = 0,
RedArmy1Y = 0,
RedArmy1State = 0,
RedArmy1StateL = 10,
RedArmy2Spawn = SPAWN:NewWithAlias("Russian Army 3","RAF 3rd Division"):InitRandomizeTemplate(RArmyTemplates),
RedArmy2 = GROUP:FindByName("Russian Army 3"),
RedArmy2Spawned = 0,
RedArmyAlive2 = 0,
RedArmy2Y = 0,
RedArmy2Y = 0,
RedArmy2State = 4,
RedArmy2StateL = 10,
BlueSukDef = GROUP:FindByName("BAF Sukhumi"),
BlueSukDefSpawn = SPAWN:NewWithAlias("BAF Sukhumi","COL Sukhimi Defense"):InitRandomizePosition(true,200,0),
BlueSukSpawned = 0,
BluGudDef = GROUP:FindByName("BAF Gudauta"),
BluGudDefSpawn = SPAWN:NewWithAlias("BAF Gudauta","COL Guduata Defense"):InitRandomizePosition(true,200,0),
BlueGudSpawned = 0,
BlueSenDef = GROUP:FindByName("BAF SEN"),
BlueSenSpawn = SPAWN:NewWithAlias("BAF SEN","COL Senaki Defense"),
BlueSenSpawned = 0,
BlueKutDef = GROUP:FindByName("BAF Kut"),
BlueKutSpawn = SPAWN:NewWithAlias("BAF Kut","COL Kutaisi Defense"),
BlueKutSpawned = 0,
BlueKobDef = GROUP:FindByName("BAF Kob"),
BlueKobSpawn = SPAWN:NewWithAlias("BAF Kob","COL Kobuleti Defense"),
BlueKobSpawned = 0,
BluArmy = GROUP:FindByName("US Army"),
BluArmySpawn = SPAWN:NewWithAlias("US Army","COL 9th Division"),
BlueArmySpawned = 0,
BluArmyAlive = 1,
BluArmyX = 0,
BluArmyY = 0,
BluArmyState = 5,
BluArmyStateL = 10,
BluArmy1 = GROUP:FindByName("US Army 2"),
BluArmy1Spawn = SPAWN:NewWithAlias("US Army 2","COL 10th Division"),
BlueArmy1Spawned = 0,
BluArmy1X = 0,
BluArmy1Y = 0,
BluArmy1Alive = 1,
BluArmy1State = 5,
BluArmy1StateL = 10,
BluArmy2 = GROUP:FindByName("US Army 3"),
BluArmy2Spawn = SPAWN:NewWithAlias("US Army 3","COL 11th Division"),
BlueArmy2Spawned = 0,
BluArmy2X = 0,
BluArmy2Y = 0,
BluArmy2Alive = 1,
BluArmy2State = 5,
BluArmy2StateL = 10,
redrelaytime = 10,
bluerelaytime = 10,
novosqn = nil,
maysqn = nil,
krassqn = nil,
kobsqn = nil,
kutsqn = nil,
sensqn = nil,
vfa192 = nil,
mozsqn = nil,
insurgent1 = nil,
insurgent1m = nil,
rattack = nil,
battack = nil,
r99 = nil,
bapache = nil,
insurgent1t = nil,
rinsurgent1 = nil,
rinsurgent1m = nil,
rinsurgent1t = nil,
insurgent2 = nil,
insurgent2m = nil,
insurgent2t = nil,
rinsurgent2 = nil,
rinsurgent2m = nil,
rinsurgent2t = nil,
insurgent3 = nil,
insurgent3m = nil,
insurgent3t = nil,
rinsurgent3 = nil,
rinsurgent3m = nil,
rinsurgent3t = nil,
insurgent4 = nil,
insurgent4m = nil,
insurgent4t = nil,
rinsurgent4 = nil,
rinsurgent4m = nil,
rinsurgent4t = nil,
rsam = {},
bsam = {},
}


  function RIB:New(Name)
    local self = BASE:Inherit(self, BASE:New())
    self.init = false -- we start uninitialised
    self.name = Name -- set out name
    self:HandleEvent( EVENTS.BaseCaptured ) -- handle events
    -- insurgent spawn items

    self.insurgent1s = SPAWN:NewWithAlias("ISPAWN1","Insurgent Group"):InitRandomizeTemplate(RInsurgTemplates):InitRandomizeZones(InsurgentZones):InitRandomizePosition(true,800,100):OnSpawnGroup(function(SpawnGroup) 
      local coord = SpawnGroup:GetCoordinate()
      local lldms = coord:ToStringLLDMS()
      local mgrs = coord:ToStringMGRS()
      local text = "HUMINT Reports Possible Insurgent Forces at \n".. lldms .. "\n" .. mgrs .."\n"
      local text1 = "HUMINT Insurgent Forces at \n" .. lldms .. "\n" .. mgrs .. "\n"
      BCC:MessageToCoalition(text)
      if self.insurgent1m ~= nil then
        coord:RemoveMark(self.insurgent1m)
      end
      self.insurgent1m = coord:MarkToCoalitionBlue(text1,false)
      self.insurgent1t = text
      self.insurgent1 = SpawnGroup
    end)

    self.rinsurgent1s = SPAWN:NewWithAlias("RISPAWN1","Georgian Insurgent Group"):InitRandomizeTemplate(BInsurgTemplates):InitRandomizeZones(BInsurgentZones):InitRandomizePosition(true,800,100):OnSpawnGroup(function(SpawnGroup) 
      local coord = SpawnGroup:GetCoordinate()
      local lldms = coord:ToStringLLDMS()
      local mgrs = coord:ToStringMGRS()
      local text = "HUMINT Reports Possible Insurgent Forces at \n".. lldms .. "\n" .. mgrs .."\n"
      local text1 = "HUMINT Insurgent Forces at \n" .. lldms .. "\n" .. mgrs .. "\n"
      RCC:MessageToCoalition(text)
      if self.rinsurgent1m ~= nil then
        coord:RemoveMark(self.rinsurgent1m)
      end
      self.rinsurgent1m = coord:MarkToCoalitionRed(text1,false)
      self.rinsurgent1t = text
    end)

    self.insurgent2s = SPAWN:NewWithAlias("ISPAWN2","Insurgent Group"):InitRandomizeTemplate(RInsurgTemplates):InitRandomizeZones(InsurgentZones):InitRandomizePosition(true,800,100):OnSpawnGroup(function(SpawnGroup) 
      self.insurgent2 = SpawnGroup
      local coord = SpawnGroup:GetCoordinate()
      local text = "HUMINT Reports Possible Insurgent Forces at \n" .. coord:ToStringLLDMS() .. "\n" .. coord:ToStringMGRS() .."\n"
      local text1 = "HUMINT Insurgent Forces at \n" .. coord:ToStringLLDMS() .. "\n" .. coord:ToStringMGRS() .."\n"
      BCC:MessageToCoalition(text)
      if self.insurgent2m ~= nil then
        coord:RemoveMark(self.insurgent2m)
      end
      self.insurgent2m = coord:MarkToCoalitionBlue(text1,false)
      end)

    self.rinsurgent2s = SPAWN:NewWithAlias("RISPAWN1","Georgian Insurgent Group"):InitRandomizeTemplate(BInsurgTemplates):InitRandomizeZones(BInsurgentZones):InitRandomizePosition(true,800,100):OnSpawnGroup(function(SpawnGroup) 
      self.rinsurgent2 = SpawnGroup
      local coord = SpawnGroup:GetCoordinate()
      local lldms = coord:ToStringLLDMS()
      local mgrs = coord:ToStringMGRS()
      local text = "HUMINT Reports Possible Insurgent Forces at \n".. lldms .. "\n" .. mgrs .."\n"
      local text1 = "HUMINT Insurgent Forces at \n" .. lldms .. "\n" .. mgrs .. "\n"
      RCC:MessageToCoalition(text)
      if self.rinsurgent2m ~= nil then
        coord:RemoveMark(self.rinsurgent2m)
      end
      self.rinsurgent2m = coord:MarkToCoalitionRed(text1,false)
    end)

    self.insurgent3s = SPAWN:NewWithAlias("ISPAWN3","Insurgent Group"):InitRandomizeTemplate(RInsurgTemplates):InitRandomizeZones(InsurgentZones):InitRandomizePosition(true,800,100):OnSpawnGroup(function(SpawnGroup) 
      self.insurgent3 = SpawnGroup
      local coord = SpawnGroup:GetCoordinate()
      local text = "HUMINT Reports Possible Insurgent Forces at \n" .. coord:ToStringLLDMS() .. "\n" .. coord:ToStringMGRS().. "\n"
      local text1 = "HUMINT Insurgent Forces at \n" .. coord:ToStringLLDMS() .. "\n" .. coord:ToStringMGRS() .."\n"
      BCC:MessageToCoalition(text)
      if self.insurgent3m ~= nil then
        coord:RemoveMark(self.insurgent3m)
      end
      self.insurgent3m = coord:MarkToCoalitionBlue(text1,false)
      self.insurgent3t = text
    end)

    self.rinsurgent3s = SPAWN:NewWithAlias("RISPAWN1","Georgian Insurgent Group"):InitRandomizeTemplate(BInsurgTemplates):InitRandomizeZones(BInsurgentZones):InitRandomizePosition(true,800,100):OnSpawnGroup(function(SpawnGroup) 
      self.rinsurgent3 = SpawnGroup
      local coord = SpawnGroup:GetCoordinate()
      local lldms = coord:ToStringLLDMS()
      local mgrs = coord:ToStringMGRS()
      local text = "HUMINT Reports Possible Insurgent Forces at \n".. lldms .. "\n" .. mgrs .."\n"
      local text1 = "HUMINT Insurgent Forces at \n" .. lldms .. "\n" .. mgrs .. "\n"
      RCC:MessageToCoalition(text)
      if self.rinsurgen3m ~= nil then
        coord:RemoveMark(self.rinsurgent3m)
      end
      self.rinsurgent3m = coord:MarkToCoalitionRed(text1,false)
      self.rinsurgent3t = text
    end)

    self.insurgent4s = SPAWN:NewWithAlias("ISPAWN4","Insurgent Group"):InitRandomizeTemplate(RInsurgTemplates):InitRandomizeZones(InsurgentZones):InitRandomizePosition(true,800,100)
    :OnSpawnGroup(function(SpawnGroup) 
      self.insurgent4 = SpawnGroup
      local coord = SpawnGroup:GetCoordinate()
      local text = "HUMINT Reports Possible Insurgent Forces at \n" .. coord:ToStringLLDMS() .. "\n" .. coord:ToStringMGRS() .."\n"
      local text1 = "HUMINT Insurgent Forces at \n" .. coord:ToStringLLDMS() .. "\n" .. coord:ToStringMGRS() .."\n"
      BCC:MessageToCoalition(text)
      if self.insurgent4m ~= nil then
        coord:RemoveMark(self.insurgent3m)
      end
      self.insurgent4m = coord:MarkToCoalitionBlue(text1,false)
      self.insurgent4t = text
    end)

    self.rinsurgent4s = SPAWN:NewWithAlias("RISPAWN1","Georgian Insurgent Group"):InitRandomizeTemplate(BInsurgTemplates):InitRandomizeZones(BInsurgentZones):InitRandomizePosition(true,800,100):OnSpawnGroup(function(SpawnGroup) 
      self.rinsurgent4 = SpawnGroup
      local coord = SpawnGroup:GetCoordinate()
      local lldms = coord:ToStringLLDMS()
      local mgrs = coord:ToStringMGRS()
      local text = "HUMINT Reports Possible Insurgent Forces at \n".. lldms .. "\n" .. mgrs .."\n"
      local text1 = "HUMINT Insurgent Forces at \n" .. lldms .. "\n" .. mgrs .. "\n"
      RCC:MessageToCoalition(text)
      if self.rinsurgent4m ~= nil then
        coord:RemoveMark(self.rinsurgent4m)
      end
      self.rinsurgent4m = coord:MarkToCoalitionRed(text1,false)
      self.rinsurgent4t = text
    end)

    --self.BLUAWAC2 = GROUP:FindByName("Magic")
    --self.BAWACS2 = SPAWN:NewWithAlias("Magic","Magic"):InitCleanUp(120):InitRepeatOnLanding():OnSpawnGroup(function(SpawnGroup) 
--      if self.BLUAWAC2 ~= nil then
--        self.BLUAWAC2:Destroy()
--      end      
--      Scoring:AddScoreGroup(SpawnGroup,30)
--      BASE:E({self.name},"SPAWNING MAGIC")
--      BCC:MessageToCoalition("Magic 11 is active on 250")
--      self.BLUAWAC2 = SpawnGroup
--    end)

    -- set up the spawn for when we start everything.
    self.REDAWAC = GROUP:FindByName("Wizard") -- store redawacs

    self.RAWACS = SPAWN:NewWithAlias("Wizard","Wizard"):InitCleanUp(120):InitRepeatOnEngineShutDown():OnSpawnGroup(function(SpawnGroup)
      -- if redawac isn't nil just incase we destroy it. we don't want 2.
      if self.REDAWAC ~= nil then
        self.REDAWAC:Destroy()
      end
      self.REDAWAC = SpawnGroup -- store awac
      Scoring:AddScoreGroup(SpawnGroup,30)
      
      if rdebug == true then
       BASE:E({self.name,"Spawning Red AWAC & Setting Escort"})
      end
      
      RCC:MessageToCoalition("Wizard11 is active and will be on 251.0")
    end
    )
    self.REDTNKR2 = GROUP:FindByName("RSHELL")
    self.RTNKR2 = SPAWN:NewWithAlias("RSHELL","RSHELL"):InitCleanUp(120):InitRepeatOnEngineShutDown():OnSpawnGroup(function(SpawnGroup)
      if self.REDTNKR2 ~= nil then
        self.REDTNKR2:Destroy()
      end

      Scoring:AddScoreGroup(SpawnGroup,20)
      
      if rdebug == true then
        BASE:E({self.name,"SPAWNING RED SHELL TANKER"})
      end
      
      RCC:MessageToCoalition("SHELL11 is active and will be on 252.0 TACAN 6X")
      self.REDTNKR2 = SpawnGroup
    end)
    self.REDTNKR = GROUP:FindByName("Arco") -- Red Tanker store.
    
    self.RTNKR = SPAWN:NewWithAlias("Arco","Arco"):InitCleanUp(120):InitRepeatOnEngineShutDown():OnSpawnGroup(function(SpawnGroup)
      -- if redtanker isn't nil just incase we destroy it we don't want 2.
      if self.REDTNKR ~= nil then
        self.REDTNKR:Destroy()
      end

      Scoring:AddScoreGroup(SpawnGroup,20)
      
      if rdebug == true then
        BASE:E({self.name,"SPAWNING RED TANKER"})
      end
      
      RCC:MessageToCoalition("ARCO11 is active and will be on 252.0 TACAN 5X")
      self.REDTNKR = SpawnGroup -- store our tanker
      do
        if ra2adisp ~= nil then
          ra2adisp:SetDefaultTanker(SpawnGroup:GetName())
          
          if rdebug == true then
            BASE:E({self.name,"RED A2A DISPATCHER TANKER SET TO NEW TANKER NAME IS",SpawnGroup:GetName()})
          end
        end
      end
    end
    )
    self.BLUAWAC = GROUP:FindByName("Overlord") -- store redawacs
    -- set up the spawn for when we start everything.
    self.BAWACS = SPAWN:NewWithAlias("Overlord","Overlord"):InitCleanUp(120):InitRepeatOnEngineShutDown():OnSpawnGroup(function(SpawnGroup)
      -- if redawac isn't nil just incase we destroy it. we don't want 2.
      if self.BLUAWAC ~= nil then
        self.BLUAWAC:Destroy()
      end
      Scoring:AddScoreGroup(SpawnGroup,30)
        
        if rdebug == true then
          BASE:E({self.name,"Spawning BLU AWAC & Setting Escort"})
        end
        
      BCC:MessageToCoalition("Overlord11 is active and will be on 251.0")
      self.BLUAWAC = SpawnGroup -- store awac
    end
    )
    self.BLUTNKR = GROUP:FindByName("Arco11") -- Red Tanker store.
    self.BTNKR = SPAWN:NewWithAlias("Arco11","Arco11"):InitCleanUp(120):InitRepeatOnEngineShutDown():OnSpawnGroup(function(SpawnGroup)
      -- if redtanker isn't nil just incase we destroy it we don't want 2.
      if self.BLUTNKR ~= nil then
        self.BLUTNKR:Destroy()
      end
      self.BLUTNKR = SpawnGroup -- store our tanker
      Scoring:AddScoreGroup(SpawnGroup,20)
      
      if rdebug == true then
       BASE:E({self.name,"SPAWNING BLUE TANKER"})
      end
      
      BCC:MessageToCoalition("ARCO11 is active and will be on 252.0, TACAN 3X")
    end
    )
    self.BLUTNKR2 = GROUP:FindByName("Texaco") -- Red Tanker store.
    self.BTNKR2 = SPAWN:NewWithAlias("Texaco","Texaco"):InitCleanUp(120):InitRepeatOnEngineShutDown():OnSpawnGroup(function(SpawnGroup)
      -- if redtanker isn't nil just incase we destroy it we don't want 2.
      if self.BLUTNKR2 ~= nil then
        self.BLUTNKR2:Destroy()
      end
      self.BLUTNKR2 = SpawnGroup -- store our tanker
      Scoring:AddScoreGroup(SpawnGroup,20)
      
      if rdebug == true then
        BASE:E({self.name,"SPAWNING BLUE TANKER"})
      end
      
      BCC:MessageToCoalition("TEXACO is active and will be on 253.0, TACAN 15X")
    end
    )
    self.afac = GROUP:FindByName("AFAC")
    self.afacs = SPAWN:NewWithAlias("AFAC","AFAC"):InitCleanUp(120):InitRepeatOnEngineShutDown():OnSpawnGroup(function(SpawnGroup) 
      if self.afac ~= nil then
        self.afac:Destroy()
      end
      self.afac = SpawnGroup
      BCC:MessageToCoalition("AFAC Enfield 133AM Now active.")
    end)
  return self
  end 
  
   function RIB:SpawnSupports()
    
    if rdebug == true then
      BASE:E({self.name,"Running support script"})
    end
    
    if self.REDAWAC:IsAlive() ~= true or self.REDAWAC:AllOnGround() == true then
      self.RAWACS:Spawn()
    end
    if self.REDTNKR:IsAlive() ~= true or self.REDTNKR:AllOnGround() == true then
      self.RTNKR:Spawn()
    end
    if self.REDTNKR2:IsAlive() ~= true or self.REDTNKR2:AllOnGround() == true then
      self.RTNKR2:Spawn()
    end
    if self.BLUAWAC:IsAlive() ~= true or self.BLUAWAC:AllOnGround() == true then
      self.BAWACS:Spawn()
    end
    if self.BLUTNKR:IsAlive() ~= true or self.BLUTNKR:AllOnGround() == true then
      self.BTNKR:Spawn()
    end
    if self.BLUTNKR2:IsAlive() ~= true or self.BLUTNKR2:AllOnGround() == true then
      self.BTNKR2:Spawn()
    end
    --if self.BLUAWAC2:IsAlive() ~= true or self.BLUAWAC2:AllOnGround() == true then
--      self.BAWACS2:Spawn()
    --end
    if self.afac:IsAlive() ~= true or self.afac:AllOnGround() == true then
      self.afacs:Spawn()
    end
  end
  
  ---@param self
  --@param Core.Event#EVENTDATA EventData
  function RIB:OnEventDead(EventData)
    if rdebug == true then
      self:E({self.name,"Event Dead occured initating group was",EventData.IniGroupName})
    end
  end

 -- This is gonna handle all of our Captures! lot better then a zonecapture.. because we don't have to check it constantly lot less headroom!
  function RIB:OnEventBaseCaptured( EventData )
    local AirbaseName = EventData.PlaceName -- The name of the airbase that was captured.
    local ABItem = AIRBASE:FindByName(AirbaseName)
    local coalition = ABItem:GetCoalition()
    -- local coalition = EventData.getCoalition()
    self:E({self.name,"BASE Captured " .. AirbaseName,coalition})
    -- ARE WE INITALIZED? Because if we aren't then things are likely being set up and this shit don't matter!.
    if init == true then
      if AirbaseName == AIRBASE.Caucasus.Sochi_Adler then
        if coalition == 2 then 
          if SOCHIOWNER ~= 2 then
            BASE:E({self.name,"Blue has taken Sochi, but blue doesn't get anything put here"})
            disableredsochi()
            ra2adisp:SetSquadron("SochiSqn",AIRBASE.Caucasus.Sochi_Adler,RCAPTEMPLATES,0) -- kill sochisqn for now.            
          else
            BASE:E({self.name,"Base change but we alread own it.",AirbaseName,coalition})
          end
        else
          if SOCHIOWNER ~= 1 then
            BASE:E({self.name,"Red has taken Sochi, Time to do some spawning!"})
            allowredsochi()
            ra2adisp:SetSquadron("SochiSqn",AIRBASE.Caucasus.Sochi_Adler,RCAPTEMPLATES,math.random(0,6)) -- start sochi gci sqn back up.
            if self.RedSochiSpawned ~= 0 then
              self.RedSochiSpawned:Destroy()
            end
            self.RedSochiSpawned = self.RedSochiDefSpawn:Spawn()     
          else
            BASE:E({self.name,"Base change but we alread own it.",AirbaseName,coalition})
          end
        end
      end
      if AirbaseName == AIRBASE.Caucasus.Kobuleti then
        if coalition == 2 then 
          if KOBOWNER ~= 2 then
            KOBOWNER = 2
            BASE:E({self.name,"Spawning Blue Kobeleti Defenses"})
            if self.BlueKobSpawned ~= 0 then
              do
                self.BlueKobSpawned:Destroy()
              end
            end
            self.BlueKobSpawned = self.BlueKobSpawn:Spawn()
            allowbluekob()
            if AIBLUECAP ~= true then
              if self.kobsqn ~= nil then
                self.kobsqn:SpawnScheduleStart()
              else
                self.kobsqn = spawnA2ACap("kobSqn",kob,BCAPTEMPLATES,1,math.random(12,24),BCAP,BAS,120,15000,35000,300,450,300,0.5)
              end
            else
              ba2adisp:SetSquadron("KobSqn",AIRBASE.Caucasus.Kobuleti,BCAPTEMPLATES,4)
            end
          else
            BASE:E({self.name,"Base change but we alread own it.",AirbaseName,coalition})
          end
        else
          if KOBOWNER ~= 1 then
            KOBOWNER = 1
            BASE:E({"Red has taken Kobuleti! Spawning Defences oh that's right they don't get any!"})
            disallowbluekob()
              if AIBLUECAP ~= true then
                if self.kobsqn ~= nil then
                  self.kobsqn:SpawnScheduleStop()
                else
                  BASE:E({self.name,"Kob sqn was NIL this shouldn't happen!"})
                end
              else     
                ba2adisp:SetSquadron("KobSqn",AIRBASE.Caucasus.Kobuleti,BCAPTEMPLATES,0)
              end
          else
            BASE:E({self.name,"Base change but we alread own it.",AirbaseName,coalition})
          end
        end
      end
      if AirbaseName == AIRBASE.Caucasus.Senaki_Kolkhi then
        if coalition == 2 then 
          if SENOWNER ~= 2 then
            SENOWNER = 2
            BASE:E({self.name,"Spawning Blue Sen Defenses, opening blue slots"})
            if self.BlueSenSpawned ~= 0 then
              self.BlueSenSpawned:Destroy()
            end
            self.BlueSenSpawned = self.BlueSenSpawn:Spawn()
            allowbluesen()
            if AIBLUECAP ~= true then
              if self.sensqn ~= nil then
                self.sensqn:SpawnScheduleStart()
              else
                self.sensqn = spawnA2ACap("senSqn",sen,BCAPTEMPLATES,1,math.random(12,24),BCAP3,BAS,120,15000,35000,300,450,300,0.5)
              end
            end
          else
            BASE:E({self.name,"Base change but we alread own it.",AirbaseName,coalition})
          end
        else
          if SENOWNER ~= 1 then
            SENOWNER = 1
            BASE:E({self.name,"Spawning RAFD Sen Defenses, closing blue slots"})
            if self.RedSenSpawned ~= 0 then
              self.RedSenSpawned:Destroy()
            end
            self.RedSenSpawned = self.RedSenSpawn:Spawn() 
            disallowbluesen()
            if AIBLUECAP ~= true then
              if self.sensqn ~= nil then
                self.sensqn:SpawnScheduleStop()
              else
                BASE:E({self.name,"sensqn was nil this shouldn't happen"})
              end
            end
          else
            BASE:E({self.name,"Base change but we alread own it.",AirbaseName,coalition})
          end
        end
      end
      
      if AirbaseName == AIRBASE.Caucasus.Kutaisi then
        if coalition == 2 then 
          if KUTOWNER ~= 2 then
            KUTOWNER = 2
            BASE:E({self.name,"Spawning Blue KUT Defenses, opening blue slots"})
            if self.BlueKutSpawned ~= 0 then
              self.BlueKutSpawned:Destory()
            end
            self.BlueKutSpawned = self.BlueKutSpawn:Spawn()
            allowbluekut()
            if AIBLUECAP ~= true then
              if self.kutsqn ~= nil then
                self.kutsqn:SpawnScheduleStart()
              else
                self.kutsqn = spawnA2ACap("kutSqn",kut,BCAPTEMPLATES,1,math.random(12,24),BCAP2,BAS,120,15000,35000,300,450,300,0.5)
              end
            else
              ba2adisp:SetSquadron("KutSqn",AIRBASE.Caucasus.Kutaisi,BCAPTEMPLATES,4)
            end
          else
            BASE:E({self.name,"Base change but we alread own it.",AirbaseName,coalition})
          end
        else
          if KUTOWNER ~= 1 then
            KUTOWNER = 1
            BASE:E({self.name,"Spawning RAFD Kut Defenses, opening blue slots"})
            if self.RedKutSpawned ~= 0 then
              self.RedKutSpawned:Destroy()
            end
            self.RedKutSpawned = self.RedKutSpawn:Spawn()
            disallowbluekut()
            if AIBLUECAP ~= true then
              if self.kutsqn ~= nil then
                self.kutsqn:SpawnScheduleStop()
              else
                BASE:E({self.name,"Kutsqn was nil this shoulnd't happen"})
                end
              else
                ba2adisp:SetSquadron("KutSqn",AIRBASE.Caucasus.Kutaisi,BCAPTEMPLATES,0)
              end
          else
            BASE:E({self.name,"Base change but we alread own it.",AirbaseName,coalition})
          end
        end
      end
      
      if AirbaseName == AIRBASE.Caucasus.Sukhumi_Babushara then
        if coalition == 2 then 
          if SUKOWNER ~= 2 then
            SUKOWNER = 2
            BASE:E({self.name,"Blue Spawning Sukhumi Defenses."})
            if self.BlueSukSpawned ~= 0 then
              self.BlueSukSpawened:Destroy()
            end
            self.BlueSukSpawned = self.BlueSukDefSpawn:Spawn()
            allowbluesuk()
            disallowredsuk()
         else
          BASE:E({self.name,"Base change but we alread own it.",AirbaseName,coalition})
         end
        else
          if SUKOWNER ~= 1 then
            SUKOWNER = 1
            BASE:E({self.name,"Red Spawning Sukhumi Defenses."})
            if self.RedSukSpawned ~= 0 then
              self.RedSukSpawned:Destroy()
            end
            self.RedSukSpawned = self.RedSukDefSpawn:Spawn()
            disallowbluesuk()
            allowredsuk()
          else
            BASE:E({self.name,"Base change but red already owns it"})
          end
        end
      elseif AirbaseName == AIRBASE.Caucasus.Gudauta then
        if coalition == 2 then
          if GUDOWNER ~= 2 then
            GUDOWNER = 2
            BASE:E({self.name,"Blue Spawning Guduata Defences"})
            self.BlueGudSpawned = self.BluGudDefSpawn:Spawn()
            allowbluegud()
            disallowredgud()
          else
            BASE:E({self.name,"Base change but blue already owns it"})
          end
        else
          if GUDOWNER ~= 1 then
            GUDOWNER = 1
            BASE:E({self.name,"Red Spawning Guduata Defences"})
            self.RedGudSpawned = self.RedGudDefSpawn:Spawn()
            disallowbluegud()
            allowredgud()
          else
            BASE:E({self.name,"Base change but red already owns it"})
          end
        end
      else
        BASE:E({self.name,"Some one took an airbase that wasn't expected!",AirbaseName})
      end
      self:E({"Updating Persistence"})
      savePersistenceEngine()
      self:E({"Should be Updating main Persistence"})
      savenewpersistencenow(self.RedSukSpawned,self.RedSochiSpawned,self.RedGudSpawned,self.RedSenSpawned,self.RedKutSpawned,self.RedArmySpawned,self.RedArmy1Spawned,self.RedArmy2Spawned,self.BlueSukSpawned,self.BlueGudSpawned,self.BlueSenSpawned,self.BlueKutSpawned,self.BlueKobSpawned,self.BlueArmySpawned,self.BlueArmy1Spawned,self.BlueArmy2Spawned)
    else
      self:E({"RIB WARNING NOT INITALISED CAPTURE",AirbaseName,coalition})
    end  
 end
 
 
 --- Command to Destroy a ground unit
 -- 
 function RIB:DestroyGround(unit)
  BASE:E{"Call for the destruction of unit",unit}
  if unit == "blue1" then
    BASE:E{"destroy",unit}
    if self.BluArmy:IsAlive() == true then
      BASE:E{"Is Alive Destroying",unit}
      self.BluArmy:Destroy()
      self.BluArmyStateL = 10
      self.BlueArmySpawned = 0
    end
  elseif unit == "blue2" then
    BASE:E{"destroy",unit}
    if self.BluArmy1:IsAlive() == true then
      BASE:E{"Is Alive Destroying",unit}
      self.BluArmy1:Destroy()
      self.BluArmy1StateL = 10
      self.BlueArmy1Spawned = 0
    end
  elseif unit == "blue3" then
    BASE:E{"destroy",unit}
    if self.BluArmy2:IsAlive() == true then
      BASE:E{"Is Alive Destroying",unit}
      self.BluArmy2:Destroy()
      self.BluArmy2StateL = 10
      self.BlueArmy2Spawned = 0
    end
  elseif unit == "red1" then
    BASE:E{"destroy",unit}
    if self.RedArmy:IsAlive() == true then
      BASE:E{"Is Alive Destroying",unit}
      self.RedArmy:Destroy()
      self.RedArmyStateL = 10
      self.RedArmySpawned = 0
    end
  elseif unit == "red2" then
    BASE:E{"destroy",unit}
    if self.RedArmy1:IsAlive() == true then
      BASE:E{"Is Alive Destroying",unit}
      self.RedArmy1:Destroy()
      self.RedArmy1StateL = 10
      self.RedArmy1Spawned = 0
    end
   elseif unit == "red3" then
    BASE:E{"destroy",unit}
    if self.RedArmy2:IsAlive() == true then
      BASE:E{"Is Alive Destroying",unit}
      self.RedArmy2:Destroy()
      self.RedArmy2StateL = 4
      self.RedArmy2Spawned = 0
    end
  end
 end
 
 function RIB:RouteUnitTo(Runit,uzone,distance,relaytime)
  BASE:E({self.name,"RouteUnitTo",Runit.GroupName,uzone.ZoneName,relaytime})
  if Runit:IsAlive() == true then
    local pos = Runit:GetCoordinate()
    local nco = uzone:GetRandomCoordinate(0,200)
    local tco = vcoord(pos,nco,distance)
    BASE:E({"Pos is:",pos,"tco is:",tco})
    Runit:RouteGroundTo(tco,40,randomform(),relaytime)
    BASE:E({self.name,"UNIT ROUTED"})
  else
    BASE:E({self.name,"UNIT ROUTE UNABLE NOT ALIVE"})
  end
 end
 
 --- our function for red army tick
 -- 
 -- 
 function RIB:RedArmyTick(distance,attackdistance,altattack)
 if rdebug == true then
  BASE:E({self.name,"ENTERED RED ARMY TICK"})
 end
  rengaged = false
  ralive = false
  if rpos ~= nil then
    rposold = rpos
  end
  rpos = nil

  -- if we are nil spawn in a damned unit, this should NEVER happen.
  if self.RedArmy == nil then
    self.RedArmy = self.RedArmySpawn:Spawn()
    self.RedArmySpawned = self.RedArmy 
    BASE:E({self.name,"Red Army was NIL! this shouldn't be it is now",self.RedArmy:GetName()})
  end
  
  -- Are we alive? if we are then we want to store coords and move on.
  -- if we are not then we want to basically look at the supply and if there isn't
  -- enough we stop.
  BASE:E({self.name,"RedArmy is",self.RedArmy})
  BASE:E({self.name,"RedArmy Name is",self.RedArmy:GetName()})
  BASE:E({self.name,"RedArmy Alive Is",self.RedArmy:IsAlive()})
  
  if self.RedArmy:IsAlive() == true then
    if rdebug == true then
      BASE:E({self.name,"Red Army Alive Storing Coord"})
    end
    ralive = true
    rpos = self.RedArmy:GetCoordinate()
    self.RedArmyAlive = 1
    local tempvec2 = rpos:GetVec2()
    self.RedArmyX = tempvec2.x
    self.RedArmyY = tempvec2.y
  else
    if RedHq:IsAlive() == true then
      if redgroundsupply >= 20 then
       if rdebug == true then
          BASE:E({self.name,"Red Army Dead ReSpawning",redgroundsupply})
       end
        self.RedArmy:Destroy()
        BASE:E({self.name,"RedArmy About Respawned Red Army is now:",self.RedArmy:GetName()})
        self.RedArmy = self.RedArmySpawn:Spawn()
        BASE:E({self.name,"RedArmy Was Respawned Red Army is now:",self.RedArmy:GetName()})
        self.RedArmySpawned = self.RedArmy
        self.RedArmyAlive = 0
        self.RedArmyState = 5
        self.RedArmyStateL = 10
        ralive = true
        redgroundsupply = redgroundsupply - 20
      else
        self.RedArmySpawned = 0
        if rdebug == true then
          BASE:E({self.name,"No Supplies Avalible at the moment! can't spawn Red Army",redgroundsupply})
        end
      end
    else
      self.RedArmySpawned = 0
      if rdebug == true then
        BASE:E({self.name,"Red Headquarters was dead can't resupply and respawn an army if there's no HQ!"})
      end
    end
    
  end
  
    -- run a check for nil state we should NEVER get this but we are being certain just incase something breaks for some reason.
  if self.RedArmyState == nil then
    self.RedArmyState = 10
    self.RedArmyStateL = 10 
  end
  
  -- lets see if we can't make this better so first off lets quickly store the distances to each army.
  local closest = findclosest(self.RedArmy,self.BluArmy,self.BluArmy1,self.BluArmy2)
  
  if rdebug == true then
    BASE:E({self.name,"closest",closest})
  end
  if closest ~= nil then
    local tmpcoord = closest:GetCoordinate()
    if checkifclose(tmpcoord,rpos,attackdistance) == true then
      local nco = rpos:Translate((rpos:Get2DDistance(tmpcoord) - 200),rpos:HeadingTo(tmpcoord)) -- get a new coordinate 200 m short of the blue position.
      if LandZone:IsCoordinateInZone(nco) == true then
        BASE:E({self.name,"We had an army that was within "..  attackdistance .. " routing Red Army to attack"})
        self.RedArmy:RouteGroundTo(nco,20,randomform(),self.redrelaytime) -- route to attack.
        if self.RedArmyState ~= 9 then
          self.RedArmyStateL = self.RedArmyState -- Set state so when we unengage we can do what we have to do
          self.RedArmyState = 9
        end
        rengaged = true
      else
        BASE:E({self.name,"Tried to route Red to Blue Army but wasn't in the zone, so we can't!"})
        rengaged = false
      end
    end
  end
    

  if rdebug == true then  
    BASE:E({self.name,"RED0 states"})
  end
  
  if ralive == true then
    if rengaged == false then
      local newstate = findstate(self.RedArmy,self.RedArmyState,1,altattack)
      BASE:E({self.name,newstate})
      if rdebug == true then 
        BASE:E({self.name,"Red Army States:",newstate,self.RedArmyState,self.RedArmyStateL})
      end
      temprnd = math.random(1,2)
      if self.RedArmyStateL ~= newstate then
          if rdebug == true then 
                BASE:E({self.name,"Red Army Route"})
          end
          if newstate == 99 then
            self.RedArmyState = self.RedArmyStateL
            if temprnd == 1 then
              routeground(self.RedArmy,self.RedArmyState,true)
            else
              routeground(self.RedArmy,self.RedArmyState,false)
            end
            self.RedArmyStateL = 9
          else
            self.RedArmyStateL = self.RedArmyState
            self.RedArmyState = newstate
            if temprnd == 1 then
              routeground(self.RedArmy,self.RedArmyState,true)
            else
              routeground(self.RedArmy,self.RedArmyState,false)
            end
            
          end
      end
      if rdebug == true then 
        BASE:E({self.name,"Red Army States at end:",newstate,self.RedArmyState,self.RedArmyStateL})
      end
    end
  end
  if rposold ~= nil then
    if rdebug == true then
      BASE:E({self.name,"We have a rposold that isn't nil",rposold,rpos})
    end
    if rposold == rpos then
      BASE:E({self.name"Red Army Was reported at the same location as last tick FORCING a route."})
      routeground(self.RedArmy,self.RedArmyState,false)
    end
  end
  if rdebug == true then
    BASE:E({self.name,"END OF RED ARMY TICK"})
  end
 end
 
 
 function RIB:RedArmy1Tick(distance,attackdistance,altattack)
  if red1active == true then
  if rdebug == true then
    BASE:E({self.name,"ENTERED RED ARMY 1 TICK"})
  end
  rengaged1 = false
  ralive1 = false
  if rpos1 ~= nil then
   rpos1old = rpos1
  end
  rpos1 = nil
  -- if we are nil spawn in a damned unit, this should NEVER happen.
  if  self.RedArmy1 == nil then
    if red1active == true then
      self.RedArmy1 = self.RedArmy1Spawn:Spawn()
      self.RedArmy1Spawned = self.RedArmy1
    end
    BASE:E({self.name,"Red Army 1 was NIL! this shouldn't be"})
  end
  
  -- Are we alive? if we are then we want to store coords and move on.
  -- if we are not then we want to basically look at the supply and if there isn't
  -- enough we stop.
  if self.RedArmy1:IsAlive() == true then
    if rdebug == true then
      BASE:E({self.name,"Red Army 1 Alive Storing Coord"})
    end
    ralive1 = true
    rpos1 = self.RedArmy1:GetCoordinate()
    self.RedArmy1Alive = 1
    local tempvec2 = rpos1:GetVec2()
    self.RedArmy1X = tempvec2.x
    self.RedArmy1Y = tempvec2.y
  else
    if RedHq:IsAlive() == true then
      if redgroundsupply >= 20 then
       if rdebug == true then
          BASE:E({self.name,"Red Army 1 Dead ReSpawning"})
       end
        
        self.RedArmy1 = self.RedArmy1Spawn:Spawn()
        self.RedArmy1Spawned = self.RedArmy1
        self.RedArmy1Alive = 0
        self.RedArmy1State = 5
        self.RedArmy1StateL = 10
        redgroundsupply = redgroundsupply - 20
      else
        self.RedArmy1Spawned = 0
        if rdebug == true then
          BASE:E({self.name,"No Supplies Avalible at the moment! can't spawn Red Army",redgroundsupply})
        end
      end
    else
      self.RedArmy1Spawned = 0
      if rdebug == true then
        BASE:E({self.name,"Red Headquarters was dead can't resupply and respawn an army if there's no HQ!"})
      end
    end
  end
  
    -- run a check for nil state we should NEVER get this but we are being certain just incase something breaks for some reason.
  if self.RedArmy1State == nil then
    self.RedArmy1State = 10
    self.RedArmy1StateL = 10 
  end
  
  -- lets see if we can't make this better so first off lets quickly store the distances to each army.
  local closest = findclosest(self.RedArmy1,self.BluArmy,self.BluArmy1,self.BluArmy2)
  
  if rdebug == true then
    BASE:E({self.name,"closest",closest})
  end
  if closest ~= nil then
    local tmpcoord = closest:GetCoordinate()
    if checkifclose(tmpcoord,rpos1,attackdistance) == true then
      local nco = rpos1:Translate((rpos1:Get2DDistance(tmpcoord) - 200),rpos1:HeadingTo(tmpcoord)) -- get a new coordinate 200 m short of the blue position.
      if LandZone:IsCoordinateInZone(nco) == true then
        BASE:E({self.name,"We had an army that was within "..  attackdistance .. " routing Red Army 1 to attack"})
        self.RedArmy1:RouteGroundTo(nco,20,randomform(),self.redrelaytime) -- route to attack.
        if self.RedArmy1State ~= 9 then
          self.RedArmy1StateL = self.RedArmy1State -- Set state so when we unengage we can do what we have to do
          self.RedArmy1State = 9
        end
        rengaged1 = true
      else
        BASE:E({self.name,"Tried to route Red to Blue Army but wasn't in the zone, so we can't!"})
        rengaged1 = false
      end
    end
  end
  if rdebug == true then  
    BASE:E({self.name,"RED1 states"})
  end
  
  if ralive1 == true then
    if rengaged1 == false then
      local newstate = findstate(self.RedArmy1,self.RedArmy1State,1,altattack)
      if rdebug == true then 
        BASE:E({self.name,"Red Army1 States:",newstate,self.RedArmy1State,self.RedArmy1StateL})
      end
      temprnd = math.random(1,2)
      if self.RedArmy1StateL ~= newstate then
          if rdebug == true then 
                BASE:E({self.name,"RedArmy1 Route"})
          end
          if newstate == 99 then
            self.RedArmy1State = self.RedArmy1StateL
           if temprnd == 1 then
              routeground(self.RedArmy1,self.RedArmy1State,true)
            else
              routeground(self.RedArmy1,self.RedArmy1State,false)
            end
            self.RedArmy1StateL = 9
          else
            self.RedArmy1StateL = self.RedArmy1State
            self.RedArmy1State = newstate
            if temprnd == 1 then
              routeground(self.RedArmy1,self.RedArmy1State,true)
            else
              routeground(self.RedArmy1,self.RedArmy1State,false)
            end

          end
      end
      if rdebug == true then 
        BASE:E({self.name,"Red Army 1 States at end:",newstate,self.RedArmy1State,self.RedArmy1StateL})
      end
    end
  end
  if rpos1old ~= nil then
    if rdebug == true then
      BASE:E({self.name,"We have a rpos1old that isn't nil",rpos1old,rpos1})
    end
    if rpos1old == rpos1 then
      BASE:E({self.name"Red Army Was reported at the same location as last tick FORCING a route."})
      routeground(self.RedArmy1,self.RedArmy1State,false)
    end
  end
  if rdebug == true then
    BASE:E({self.name,"END RED ARMY 1 TICK"})
  end
  else
    BASE:E({"red1active was false"})
  end
 end


 function RIB:RedArmy2Tick(distance,attackdistance,altattack)
  if rdebug == true then
    BASE:E({self.name,"ENTERED RED ARMY 2 TICK"})
  end
  rengaged2 = false
  ralive2 = false
  if rpos2 ~= nil then
    rpos2old = rpos2
  end
  rpos2 = nil
  -- if we are nil spawn in a damned unit, this should NEVER happen.
  if  self.RedArmy2 == nil then
    self.RedArmy2 = self.RedArmy2Spawn:Spawn()
    self.RedArmy2Spawned = self.RedArmy2
    BASE:E({self.name,"Red Army 2 was NIL! this shouldn't be"})
  end
  
  -- Are we alive? if we are then we want to store coords and move on.
  -- if we are not then we want to basically look at the supply and if there isn't
  -- enough we stop.
  if self.RedArmy2:IsAlive() == true then
    if rdebug == true then
      BASE:E({self.name,"Red Army 2 Alive Storing Coord"})
    end
    ralive2 = true
    rpos2 = self.RedArmy2:GetCoordinate()
    self.RedArmy2Alive = 1
    local tempvec2 = rpos2:GetVec2()
    self.RedArmy2X = tempvec2.x
    self.RedArmy2Y = tempvec2.y
  else
    if RedHq:IsAlive() == true then
      if redgroundsupply >= 20 then
       if rdebug == true then
          BASE:E({self.name,"Red Army 2 Dead ReSpawning"})
       end
        self.RedArmy2 = self.RedArmy2Spawn:Spawn()
        self.RedArmy2Spawned = self.RedArmy2
        self.RedArmy2Alive = 0
        self.RedArmy2State = 4
        self.RedArmy2StateL = 10
        redgroundsupply = redgroundsupply - 20
      else
        self.RedArmy2Spawned = 0
        if rdebug == true then
          BASE:E({self.name,"No Supplies Avalible at the moment! can't spawn Red Army",redgroundsupply})
        end
      end
    else
      self.RedArmy2Spawned = 0
      if rdebug == true then
        BASE:E({self.name,"Red Headquarters was dead can't resupply and respawn an army if there's no HQ!"})
      end
    end
  end
  
    -- run a check for nil state we should NEVER get this but we are being certain just incase something breaks for some reason.
  if self.RedArmy2State == nil then
    self.RedArmy2State = 10
    self.RedArmy2StateL = 10 
  end
  
  -- lets see if we can't make this better so first off lets quickly store the distances to each army.
  local closest = findclosest(self.RedArmy2,self.BluArmy,self.BluArmy1,self.BluArmy2)
  
  if rdebug == true then
    BASE:E({self.name,"closest",closest})
  end
  if closest ~= nil then
    local tmpcoord = closest:GetCoordinate()
    if checkifclose(tmpcoord,rpos2,attackdistance) == true then
      local nco = rpos2:Translate((rpos2:Get2DDistance(tmpcoord) - 200),rpos2:HeadingTo(tmpcoord)) -- get a new coordinate 200 m short of the blue position.
      if LandZone:IsCoordinateInZone(nco) == true then
        BASE:E({self.name,"We had an army that was within "..  attackdistance .. " routing Red Army 2 to attack"})
        self.RedArmy2:RouteGroundTo(nco,20,randomform(),self.redrelaytime) -- route to attack.
        if self.RedArmy2State ~= 9 then
          self.RedArmy2StateL = self.RedArmy2State -- Set state so when we unengage we can do what we have to do
          self.RedArmy2State = 9
        end
        rengaged2 = true
      else
        BASE:E({self.name,"Tried to route Red to Blue Army but wasn't in the zone, so we can't!"})
        rengaged2 = false
      end
    end
  end
  if rdebug == true then  
    BASE:E({self.name,"RED2 states"})
  end
  
  if ralive2 == true then
    if rengaged2 == false then
      local newstate = findstate(self.RedArmy2,self.RedArmy2State,1,altattack)
      if rdebug == true then 
        BASE:E({self.name,"Red Army2 States:",newstate,self.RedArmy2State,self.RedArmy2StateL})
      end
      temprnd = math.random(1,2)
      if self.RedArmy2StateL ~= newstate then
          if rdebug == true then 
             BASE:E({self.name,"RedArmy2 Route"})
          end
          if newstate == 99 then
            self.RedArmy2State = self.RedArmy2StateL
            if temprnd == 1 then
              routeground(self.RedArmy2,self.RedArmy2State,true)
            else
              routeground(self.RedArmy2,self.RedArmy2State,false)
            end
            self.RedArmy2StateL = 9
          elseif newstate == 4 then
            routeground(self.RedArmy2,self.RedArmy2State,false)
          else
            self.RedArmy2StateL = self.RedArmy2State
            self.RedArmy2State = newstate
            if temprnd == 1 then
              routeground(self.RedArmy2,self.RedArmy2State,true)
            else
              routeground(self.RedArmy2,self.RedArmy2State,false)
            end
          end
      end
      if rdebug == true then 
        BASE:E({self.name,"Red Army 2 States at end:",newstate,self.RedArmy2State,self.RedArmy2StateL})
      end
    end
  end
  if rpos2old ~= nil then
    if rdebug == true then
      BASE:E({self.name,"We have a rpos2old that isn't nil",rpos2old,rpos2})
    end
    if rpos2old == rpos2 then
      BASE:E({self.name"Red Army 2 Was reported at the same location as last tick FORCING a route."})
      routeground(self.RedArmy2,self.RedArmy2State,false)
    end
  end
  if rdebug == true then
    BASE:E({self.name,"END RED ARMY 2 TICK"})
  end
 end
 
 --- this runs our red ground routing and states.
  function RIB:RGroundTick(distance,attackdistance)
    BASE:E({self.name,"begin Red Ground Tick"})
    -- Ok lets set all our engagement states to false, for the moment and our alive state to false, positions to nil
    self.RedArmyTick(self,distance,attackdistance,false)
    self.RedArmy1Tick(self,distance,attackdistance,false)
    self.RedArmy2Tick(self,distance,attackdistance,true)
  
    -- run a check for nil state we should NEVER get this but we are being certain just incase something breaks for some reason.
    if self.RedArmyState == nil then
      self.RedArmyState = 10
    end
    if self.RedArmy1State == nil then
      self.RedArmy1State = 10
    end
    if self.RedArmy2State == nil then
      self.RedArmy2State = 10
    end
    BASE:E({self.name,"end Red Ground Tick"})
 end
 
  --- our function for Red army tick
 -- 
 -- 
 function RIB:BlueArmyTick(distance,attackdistance,altattack)
 if rdebug == true then
  BASE:E({self.name,"ENTERED BLUEARMY TICK"})
 end
  bengaged = false
  balive = false
  if bpos ~= nil then
    bposold = bpos
  end
  bpos = nil
  -- if we are nil spawn in a damned unit, this should NEVER happen.
  if  self.BluArmy == nil then
    self.BluArmy = self.BluArmySpawn:Spawn()
    self.BluArmySpawned = self.BluArmy 
    BASE:E({self.name,"BluArmy was NIL! this shouldn't be"})
  end
  
  -- Are we alive? if we are then we want to store coords and move on.
  -- if we are not then we want to basically look at the supply and if there isn't
  -- enough we stop.
  if self.BluArmy:IsAlive() == true then
    if rdebug == true then
      BASE:E({self.name,"BluArmy Alive Storing Coord"})
    end
    balive = true
    bpos = self.BluArmy:GetCoordinate()
    self.BluArmyAlive = 1
    local tempvec2 = bpos:GetVec2()
    self.BluArmyX = tempvec2.x
    self.BluArmyY = tempvec2.y
  else
    if BlueHq:IsAlive() == true then
      if bluegroundsupply >= 20 then
       if rdebug == true then
          BASE:E({self.name,"BluArmy Dead ReSpawning"})
       end
        self.BluArmy = self.BluArmySpawn:Spawn()
        self.BluArmySpawned = self.BluArmy
        self.BluArmyAlive = 0
        self.BluArmyState = 5
        self.BluArmyStateL = 10
        bluegroundsupply = bluegroundsupply - 20
      else
        self.BluArmySpawned = 0
        if rdebug == true then
          BASE:E({self.name,"No Supplies Avalible at the moment! can't spawn BluArmy",bluegroundsupply})
        end
      end
    else
      self.BluArmySpawned = 0
      if rdebug == true then
        BASE:E({self.name,"BluArmy Blue Headquarters was dead can't resupply and respawn an army if there's no HQ!"})
      end
    end
    
  end
  
    -- run a check for nil state we should NEVER get this but we are being certain just incase something breaks for some reason.
  if self.BluArmyState == nil then
    self.BluArmyState = 10
    self.BluArmyStateL = 10 
  end
  
  -- lets see if we can't make this better so first off lets quickly store the distances to each army.
  local closest = findclosest(self.BluArmy,self.RedArmy,self.RedArmy1,self.RedArmy2)
  
  if rdebug == true then
    BASE:E({self.name,"closest",closest})
  end
  if closest ~= nil then
    local tmpcoord = closest:GetCoordinate()
    if checkifclose(tmpcoord,bpos,attackdistance) == true then
      local nco = bpos:Translate((bpos:Get2DDistance(tmpcoord) - 200),bpos:HeadingTo(tmpcoord)) -- get a new coordinate 200 m short of the Red position.
      if LandZone:IsCoordinateInZone(nco) == true then
        BASE:E({self.name,"We had an army that was within "..  attackdistance .. " routing BluArmy to attack"})
        self.BluArmy:RouteGroundTo(nco,20,randomform(),self.bluerelaytime) -- route to attack.
        if self.BluArmyState ~= 9 then
          self.BluArmyStateL = self.BluArmyState -- Set state so when we unengage we can do what we have to do
          self.BluArmyState = 9
        end
        bengaged = true
      else
        BASE:E({self.name,"Tried to route Blue to Red Army but wasn't in the zone, so we can't!"})
        bengaged = false
      end
    end
  end
    

  if rdebug == true then  
    BASE:E({self.name,"Blue 0 states"})
  end
  
  if balive == true then
    if bengaged == false then
      local newstate = findstate(self.BluArmy,self.BluArmyState,2,altattack)
      if rdebug == true then 
        BASE:E({self.name,"bluArmy States:",newstate,self.BluArmyState,self.BluArmyStateL})
      end
      temprnd = math.random(1,2)
      if self.BluArmyStateL ~= newstate then
        if rdebug == true then 
          BASE:E({self.name,"Routing BluArmy"})
        end   
          if newstate == 99 then
            self.BluArmyState = self.BluArmyStateL
            if temprnd == 1 then
              if rdebug == true then
                BASE:E({self.name,"Route Ground is 1"})
              end
              routeground(self.BluArmy,self.BluArmyState,true)
            else
              if rdebug == true then
                BASE:E({self.name,"Route Ground is 0"})
              end
              routeground(self.BluArmy,self.BluArmyState,false)
            end
            self.BluArmyStateL = 9
          else
            self.BluArmyStateL = self.BluArmyState
            self.BluArmyState = newstate
            if temprnd == 1 then
              if rdebug == true then
                BASE:E({self.name,"Route Ground is 1"})
              end
              routeground(self.BluArmy,self.BluArmyState,true)
            else
              if rdebug == true then
                BASE:E({self.name,"Route Ground is 0"})
              end
              routeground(self.BluArmy,self.BluArmyState,false)
            end

          end
      end
      if rdebug == true then 
        BASE:E({self.name,"BluArmy States at end:",newstate,self.BluArmyState,self.BluArmyStateL})
      end
    end
  end
  if bposold ~= nil then
    if rdebug == true then
      BASE:E({self.name,"We have a bposold that isn't nil",bposold,bpos})
    end
    if bposold == bpos then
      BASE:E({self.name"Blue Army Was reported at the same location as last tick FORCING a route."})
      routeground(self.BluArmy,self.BluArmyState,false)
    end
  end
  if rdebug == true then
    BASE:E({self.name,"END OF BLUEARMY TICK"})
  end
 end
 
  --- our function for BLUE ARMY 1 tick
 -- 
 -- 
 function RIB:BlueArmy1Tick(distance,attackdistance,altattack)
 if rdebug == true then
  BASE:E({self.name,"ENTERED BLUEARMY 1 TICK"})
 end
  bengaged1 = false
  balive1 = false
  if bpos1 ~= nil then
    bposold = bpos1
  end
  bpos1 = nil
  -- if we are nil spawn in a damned unit, this should NEVER happen.
  if  self.BluArmy1 == nil then
    self.BluArmy1 = self.BluArmy1Spawn:Spawn()
    self.BluArmy1Spawned = self.BluArmy1 
    BASE:E({self.name,"BluArmy1 was NIL! this shouldn't be"})
  end
  
  -- Are we alive? if we are then we want to store coords and move on.
  -- if we are not then we want to basically look at the supply and if there isn't
  -- enough we stop.
  if self.BluArmy1:IsAlive() == true then
    if rdebug == true then
      BASE:E({self.name,"BluArmy1 Alive Storing Coord"})
    end
    balive1 = true
    bpos1 = self.BluArmy1:GetCoordinate()
    self.BluArmy1Alive = 1
    local tempvec2 = bpos1:GetVec2()
    self.BluArmy1X = tempvec2.x
    self.BluArmy1Y = tempvec2.y
  else
    if BlueHq:IsAlive() == true then
      if bluegroundsupply >= 20 then
       if rdebug == true then
          BASE:E({self.name,"BluArmy1 Dead ReSpawning"})
       end
        self.BluArmy1 = self.BluArmy1Spawn:Spawn()
        self.BluArmy1Spawned = self.BluArmy1
        self.BluArmy1Alive = 0
        self.BluArmy1State = 5
        self.BluArmy1StateL = 10
        bluegroundsupply = bluegroundsupply - 20
      else
        self.BluArmy1Spawned = 0
        if rdebug == true then
          BASE:E({self.name,"No Supplies Avalible at the moment! can't spawn BluArmy1",bluegroundsupply})
        end
      end
    else
      self.BluArmy1Spawned = 0
      if rdebug == true then
        BASE:E({self.name,"Blue Headquarters was dead can't resupply and respawn an army if there's no HQ!"})
      end
    end
    
  end
  
    -- run a check for nil state we should NEVER get this but we are being certain just incase something breaks for some reason.
  if self.BluArmy1State == nil then
    self.BluArmy1State = 10
    self.BluArmy1StateL = 10 
  end
  
  -- lets see if we can't make this better so first off lets quickly store the distances to each army.
  local closest = findclosest(self.BluArmy1,self.RedArmy,self.RedArmy1,self.RedArmy2)
  
  if rdebug == true then
    BASE:E({self.name,"closest",closest})
  end
  if closest ~= nil then
    local tmpcoord = closest:GetCoordinate()
    if checkifclose(tmpcoord,bpos1,attackdistance) == true then
      local nco = bpos1:Translate((bpos1:Get2DDistance(tmpcoord) - 200),bpos1:HeadingTo(tmpcoord)) -- get a new coordinate 200 m short of the Red position.
      if LandZone:IsCoordinateInZone(nco) == true then
        BASE:E({self.name,"We had an army that was within "..  attackdistance .. " routing BluArmy 1 to attack"})
        self.BluArmy1:RouteGroundTo(nco,20,randomform(),self.bluerelaytime) -- route to attack.
        if self.BluArmy1State ~= 9 then
          self.BluArmy1StateL = self.BluArmy1State -- Set state so when we unengage we can do what we have to do
          self.BluArmy1State = 9
        end
        bengaged1 = true
      else
        BASE:E({self.name,"Tried to route Blue to Red Army but wasn't in the zone, so we can't!"})
        bengaged1 = false
      end
    end
  end

  if rdebug == true then  
    BASE:E({self.name,"Blue 1 states"})
  end
  
  if balive1 == true then
    if bengaged1 == false then
      local newstate = findstate(self.BluArmy1,self.BluArmy1State,2,false)
      if rdebug == true then 
        BASE:E({self.name,"BluArmy 1 States:",newstate,self.BluArmy1State,self.BluArmy1StateL})
      end
      temprnd = math.random(1,2)
      if self.BluArmy1StateL ~= newstate then
          if newstate == 99 then
            self.BluArmy1State = self.BluArmy1StateL
            if temprnd == 1 then
              routeground(self.BluArmy1,self.BluArmy1State,true)
            else
              routeground(self.BluArmy1,self.BluArmy1State,false)
            end
            self.BluArmy1StateL = 9
          else
            self.BluArmy1StateL = self.BluArmy1State
            self.BluArmy1State = newstate
            if temprnd == 1 then
              routeground(self.BluArmy1,self.BluArmy1State,true)
            else
              routeground(self.BluArmy1,self.BluArmy1State,false)
            end

          end
      end
      if rdebug == true then 
        BASE:E({self.name,"BluArmy 1 States at end:",newstate,self.BluArmy1State,self.BluArmy1StateL})
      end
    end
  end
  if bpos1old ~= nil then
    if rdebug == true then
      BASE:E({self.name,"We have a bpos1old that isn't nil",bpos1old,bpos1})
    end
    if bpos1old == bpos1 then
      BASE:E({self.name"Blue Army Was reported at the same location as last tick FORCING a route."})
      routeground(self.BluArmy1,self.BluArmy1State,false)
    end
  end
  if rdebug == true then
    BASE:E({self.name,"END OF BLUEARMY 1 TICK"})
  end
 end
 
  --- our function for BLUE ARMY 2 tick
 -- 
 -- 
 function RIB:BlueArmy2Tick(distance,attackdistance,altattack)
 if rdebug == true then
  BASE:E({self.name,"ENTERED BLUE ARMY 2 TICK"})
 end
  bengaged2 = false
  balive2 = false
  if bpos2 ~= nil then
    bpos2old = bpos2
  end
  bpos2 = nil
  -- if we are nil spawn in a damned unit, this should NEVER happen.
  if  self.BluArmy2 == nil then
    if blue2active == true then
      self.BluArmy2 = self.BluArmy2Spawn:Spawn()
      self.BluArmy2Spawned = self.BluArmy2
    else
      BASE:E({self.name,"BluArmy2 was NIL! this shouldn't be but blue2active is false"})
    end 
    BASE:E({self.name,"BluArmy2 was NIL! this shouldn't be"})
  end
  
  -- Are we alive? if we are then we want to store coords and move on.
  -- if we are not then we want to basically look at the supply and if there isn't
  -- enough we stop.
  if self.BluArmy2:IsAlive() == true then
    if rdebug == true then
      BASE:E({self.name,"BluArmy2 Alive Storing Coord"})
    end
    balive2 = true
    bpos2 = self.BluArmy2:GetCoordinate()
    self.BluArmy2Alive = 1
    local tempvec2 = bpos2:GetVec2()
    self.BluArmy2X = tempvec2.x
    self.BluArmy2Y = tempvec2.y
  else
    if BlueHq:IsAlive() == true then
      if bluegroundsupply >= 20 then
       if rdebug == true then
          BASE:E({self.name,"BluArmy2 Dead ReSpawning"})
       end
       if blue2active == true then
        self.BluArmy2 = self.BluArmy2Spawn:Spawn()
        self.BluArmy2Spawned = self.BluArmy2
        self.BluArmy2Alive = 0
        self.BluArmy2State = 5
        self.BluArmy2StateL = 10
        bluegroundsupply = bluegroundsupply - 20
       else
        BASE:E({self.name,"Blue2active is false, not spawning."})
       end
      else
        self.BluArmy2Spawned = 0
        if rdebug == true then
          BASE:E({self.name,"No Supplies Avalible at the moment! can't spawn BluArmy2",bluegroundsupply})
        end
      end
    else
      self.BluArmy2Spawned = 0
      if rdebug == true then
        BASE:E({self.name,"Blue Headquarters was dead can't resupply and respawn an army if there's no HQ!"})
      end
    end
    
  end
  
    -- run a check for nil state we should NEVER get this but we are being certain just incase something breaks for some reason.
  if self.BluArmy2State == nil then
    self.BluArmy2State = 10
    self.BluArmy2StateL = 10 
  end
  
  -- lets see if we can't make this better so first off lets quickly store the distances to each army.
  local closest = findclosest(self.BluArmy2,self.RedArmy,self.RedArmy1,self.RedArmy2)
  
  if rdebug == true then
    BASE:E({self.name,"closest",closest})
  end
  if closest ~= nil then
    local tmpcoord = closest:GetCoordinate()
    if checkifclose(tmpcoord,bpos2,attackdistance) == true then
      local nco = bpos2:Translate((bpos2:Get2DDistance(tmpcoord) - 200),bpos2:HeadingTo(tmpcoord)) -- get a new coordinate 200 m short of the Red position.
      if LandZone:IsCoordinateInZone(nco) == true then
        BASE:E({self.name,"We had an army that was within "..  attackdistance .. " routing BluArmy2 to attack"})
        self.BluArmy2:RouteGroundTo(nco,20,randomform(),self.bluerelaytime) -- route to attack.
        if self.BluArmy2State ~= 9 then
          self.BluArmy2StateL = self.BluArmy2State -- Set state so when we unengage we can do what we have to do
          self.BluArmy2State = 9
        end
        bengaged2 = true
      else
        BASE:E({self.name,"Tried to route Blue to Red Army but wasn't in the zone, so we can't!"})
        bengaged2 = false
      end
    end
  end
    

  if rdebug == true then  
    BASE:E({self.name,"Blue 2 states"})
  end
  
  if balive2 == true then
    if bengaged2 == false then
      local newstate = findstate(self.BluArmy2,self.BluArmy2State,2,true)
      if rdebug == true then 
        BASE:E({self.name,"BluArmy2 States:",newstate,self.BluArmy2State,self.BluArmy2StateL})
      end
      temprnd = math.random(1,2)
      if self.BluArmy2StateL ~= newstate then
          if newstate == 99 then
            self.BluArmy2State = self.BluArmy2StateL
            if temprnd == 1 then
              routeground(self.BluArmy2,self.BluArmy2State,true)
            else
              routeground(self.BluArmy2,self.BluArmy2State,false)
            end
            self.BluArmy2StateL = 9
          else
            self.BluArmy2StateL = self.BluArmy2State
            self.BluArmy2State = newstate
            if temprnd == 1 then
              routeground(self.BluArmy2,self.BluArmy2State,true)
            else
              routeground(self.BluArmy2,self.BluArmy2State,false)
            end
            
          end
      end
      if rdebug == true then 
        BASE:E({self.name,"BluArmy2 States at end:",newstate,self.BluArmy2State,self.BluArmy2StateL})
      end
    end
  end
  if bpos2old ~= nil then
   if rdebug == true then
    BASE:E({self.name,"We have a bpos2old that isn't nil",bpos2old,bpos2})
   end
    if bpos2old == bpos2 then
      BASE:E({self.name,"Blue Army 2 Was reported at the same location as last tick FORCING a route."})
      routeground(self.BluArmy2,self.BluArmy2State,false)
    end
  end
  if rdebug == true then
    BASE:E({self.name,"END OF BLUE ARMY 2 TICK"})
  end
 end
 
 
  --- this runs our red ground routing and states.
  function RIB:BGroundTick(distance,attackdistance)
    BASE:E({self.name,"begin Blue Ground Tick"})
    -- Ok lets set all our engagement states to false, for the moment and our alive state to false, positions to nil
    self.BlueArmyTick(self,distance,attackdistance,false)
    if blue2active == true then
      self.BlueArmy1Tick(self,distance,attackdistance,false)
    else
      self.BlueArmy1Tick(self,distance,attackdistance,true)
    end
    if blue2active == true then
      self.BlueArmy2Tick(self,distance,attackdistance,true)
    end
    -- run a check for nil state we should NEVER get this but we are being certain just incase something breaks for some reason.
    if self.BlueArmyState == nil then
      self.BlueArmyState = 10
    end
    if self.BlueArmy1State == nil then
      self.BlueArmy1State = 10
    end
    if self.BlueArmyState2 == nil then
      self.BlueArmyState2 = 10
    end
    BASE:E({self.name,"end Blue Ground Tick"})
 end
 
 
 function RIB:Gunships()
  BASE:E({self.name,"Gunship Tick"})
 local randomchance = math.random(1,100)
  if rdebug == true then
    BASE:E({self.name,"sead",randomchance})
  end
  if randomchance > 85 then
    if self.battack == nil then
      if rdebug == true then 
        BASE:E({self.name,"Blue Attack was nil spawning them in"})
      end
      self.battack = SPAWN:New("PIG11"):InitRepeatOnLanding():InitCleanUp(120):Spawn()
    else
      if self.battack:IsAlive()~= true or self.battack:AllOnGround() == true then
        self.battack:Destroy()
        self.battack = SPAWN:New("PIG11"):InitRepeatOnLanding():InitCleanUp(120):Spawn()
      end
    end
  end
  local rrand = math.random(1,100)
  if rrand > 50 then
    if self.russianhelos == nil then
      if rdebug == true then
        BASE:E({self.name,"Russian Helo's were nil spawning them in"})
      end
      self.russianhelos = SPAWN:New("RAH"):InitRepeatOnLanding():InitCleanUp(120):Spawn()
    else
      if self.russianhelos:IsAlive() ~= true or self.russianhelos:AllOnGround() == true then
        if rdebug == true then
          BASE:E({self.name,"Russian Helo's were not alive or all on ground spawning new set"})
        end
        self.russianhelos:Destroy()
        self.russianhelos = SPAWN:New("RAH"):InitRepeatOnLanding():InitCleanUp(120):Spawn()
      else
        if rdebug == true then
          BASE:E({self.name,"Russian Helo's are alive, continuing."})
        end
      end
    end
  end
  local brand = math.random(1,100)
  if brand > 70 then
    if self.bapache == nil then
      if rdebug == true then 
        BASE:E({self.name,"Apaches nil spawning"})
      end
      self.bapache = SPAWN:New("Apaches"):InitRepeatOnLanding():InitCleanUp(120):Spawn()
    else
      if self.bapache:IsAlive() ~= true or self.bapache:AllOnGround() == true then
        if rdebug == true then
          BASE:E({self.name,"Apaches are not alive or all on ground spawning in new set"})
        end
        self.bapache:Destroy()
        self.bapache = SPAWN:New("Apaches"):InitRepeatOnLanding():InitCleanUp(120):Spawn()
      else
        if rdebug == true then
        BASE:E({self.name,"Apaches are fine"})
        end      
      end
    end  
  end  
 end
 
 
 
  function RIB:spawnGround(unit,x,y,state)
  if unit == "blue1" then
    if self.BluArmy ~= nil then
      if self.BluArmy:IsAlive() == true then
        self.BluArmy:Destroy()
      end
    end
    self.BluArmyX = x
    self.BluArmyY = y
    self.BluArmyState = state
    self.BluArmyStateL = 5
    local tempvec2 = POINT_VEC2:New(x,y)
    self.BluArmy = self.BluArmySpawn:SpawnFromPointVec2(tempvec2)
    self.BlueArmySpawned = self.BluArmy
  elseif unit == "blue2" then
    if self.BluArmy1 ~= nil then
      if self.BluArmy1:IsAlive() == true then
        self.BluArmy1:Destroy()
      end
    end
    self.BluArmy1X = x
    self.BluArmy1Y = y
    self.BluArmy1State = state
    self.BluArmy1StateL = 5
    local tempvec2 = POINT_VEC2:New(x,y)
    self.BluArmy1 = self.BluArmy1Spawn:SpawnFromPointVec2(tempvec2)
    self.BlueArmy1Spawned = self.BluArmy1
  elseif unit == "blue3" then
    if self.BluArmy2 ~= nil then   
      if self.BluArmy2:IsAlive() == true then
        self.BluArmy2:Destroy()
      end
    end
    self.BluArmy2X = x
    self.BluArmy2Y = y
    self.BluArmy2State = state
    local tempvec2 = POINT_VEC2:New(x,y)
    if blue2active == true then
      self.BluArmy2 = self.BluArmy2Spawn:SpawnFromPointVec2(tempvec2)
      self.BlueArmy2Spawned = self.BluArmy2
    end
    self.BluArmy2StateL = 5
  elseif unit == "red1" then
    if self.RedArmy ~= nil then
      if self.RedArmy:IsAlive() == true then
        self.RedArmy:Destroy()
      end
    end
    self.RedArmyX = x
    self.RedArmyY = y
    self.RedArmyState = state
    local tempvec2 = POINT_VEC2:New(x,y)
    self.RedArmy = self.RedArmySpawn:SpawnFromPointVec2(tempvec2)
    self.RedArmySpawned = self.RedArmy
    self.RedArmyStateL = 5
  elseif unit == "red2" then
    if self.RedArmy1 ~= nil then
      if self.RedArmy1:IsAlive() == true then
        self.RedArmy1:Destroy()
      end
    end
     self.RedArmy1X = x
     self.RedArmy1Y = y
     self.RedArmy1State = state
     self.RedArmy1StateL = 5
     local tempvec2 = POINT_VEC2:New(x,y)
    self.RedArmy1 = self.RedArmy1Spawn:SpawnFromPointVec2(tempvec2)
    self.RedArmy1Spawned = self.RedArmy1
   elseif unit == "red3" then
    if self.RedArmy2 ~= nil then
      if self.RedArmy2:IsAlive() == true then
        self.RedArmy2:Destroy()
      end
    end
     self.RedArmy2X = x
     self.RedArmy2Y = y
     self.RedArmy2State = state
     self.RedArmy2StateL = 5
     local tempvec2 = POINT_VEC2:New(x,y)
    self.RedArmy2 = self.RedArmy2Spawn:SpawnFromPointVec2(tempvec2)
    self.RedArmy2Spawned = self.RedArmy2
  end
 end
 
 
 function RIB:BInsurgents()
  BASE:E({self.name, "Blue Insurgent Thread"})
  local BCS = SET_CLIENT:New():FilterCoalitions("blue"):FilterActive():FilterOnce()
  local BC = BCS:Count()
  local BCS = SET_CLIENT:New():FilterCoalitions("blue"):FilterCategories("helicopter"):FilterActive():FilterOnce()
  if rdebug == true then
    BASE:E({self.name, "Client count is",BC})
    BASE:E({self.name, "Blue Client Heli count is",BCS:Count()})
  end
  local v1 = 110
  local v2 = 110
  local v3 = 110
  local v4 = 110
 if (BC >= 1) and (BC <=2) then
    if rdebug == true then
      BASE:E({self.name,"We have blue clients!"})
    end
    v1 = 80 - (BCS:Count() * 10)
    v2 = 110 
    v3 = 110
    v4 = 110
  elseif ((BC > 2) and (BC <= 5)) then
    v1 = 80 - (BCS:Count() * 10) - ((BC *5))
    v2 = 99
    v3 = 110
    v4 = 110
  elseif ((BC > 5) and (BC <= 10)) then
    v1 = 60
    v2 = 90
    v3 = 95
    v4 = 110
  elseif ((BC > 10) and (BC <= 15)) then
    v1 = 50
    v2 = 60
    v3 = 80
    v4 = 95
  elseif BC > 15 then
    v1 = 50
    v2 = 60
    v3 = 70
    v4 = 80
  else
    v1 = 110 - (BCS:Count() * 10)
    v2 = 110 
    v3 = 110
    v4 = 110
  end
    chance = math.random(0,100)
    if rdebug == true then
      BASE:E({self.name,"Insurgents 1 C/V",chance,v1})
    end
    if self.insurgent1 == nil then
      -- we don't have any insurgents in slot 1!   
        if chance > v1 then
        if rdebug == true then
          BASE:E({self.name,"Spawning Insurgents 1 C/V",chance,v1})
        end
        self.insurgent1 = self.insurgent1s:Spawn()
        end  
    else
      if self.insurgent1:IsAlive() ~= true then
        if chance > v1 then
          -- we don't have any insurgents in slot 1!
          if rdebug == true then
            BASE:E({self.name,"Spawning Insurgents 1 C/V",chance,v1})
          end   
          self.insurgent1 = self.insurgent1s:Spawn()
        end        
      end
    end
    chance = math.random(0,100)
    if rdebug == true then
      BASE:E({self.name,"Insurgents 2 C/V",chance,v2})
    end
    if self.insurgent2 == nil then
      -- we don't have any insurgents in slot 2!   
        if chance > v2 then
        if rdebug == true then
          BASE:E({self.name,"Spawning Insurgents 2 C/V",chance,v2})
        end
        self.insurgent2 = self.insurgent2s:Spawn()
        end
    else
      if self.insurgent2:IsAlive() ~= true then
      if chance > v2 then
        -- we don't have any insurgents in slot 2!
        if rdebug == true then
          BASE:E({self.name,"Spawning Insurgents 2 C/V",chance,v2})
        end   
        self.insurgent2 = self.insurgent1s:Spawn()
      end
      end
    end
    if rdebug == true then
      BASE:E({self.name,"Insurgents 3 C/V",chance,v3})
    end
    chance = math.random(0,100)
    if self.insurgent3 == nil then
      -- we don't have any insurgents in slot 3!   
        if chance > v3 then
        if rdebug == true then
          BASE:E({self.name,"Spawning Insurgents 3 C/V",chance,v3})
        end
        self.insurgent3 = self.insurgent3s:Spawn()
        end
    else
      if self.insurgent3:IsAlive() ~= true then
        if chance > v3 then
        -- we don't have any insurgents in slot 1!
          if rdebug == true then
            BASE:E({self.name,"Spawning Insurgents 3 C/V",chance,v3})
          end   
          self.insurgent3 = self.insurgent3s:Spawn()
        end
      end
    end
        chance = math.random(0,100)
        if rdebug == true then
          BASE:E({self.name,"Insurgents 4 C/V",chance,v4})
        end
    if self.insurgent4 == nil then
      -- we don't have any insurgents in slot 4!   
        if chance > v4 then
          if rdebug == true then
            BASE:E({self.name,"Spawning Insurgents 4 C/V",chance,v4})
          end
          self.insurgent4 = self.insurgent4s:Spawn()
        end
    else
      if self.insurgent4:IsAlive() ~= true then
      if chance > v4 then
        -- we don't have any insurgents in slot 4!
          if rdebug == true then
            BASE:E({self.name,"Spawning Insurgents 4 C/V",chance,v4})
          end   
        self.insurgent4 = self.insurgent4s:Spawn()
      end
      end
    end
    BASE:E({self.name,"End Blue Insurgent Thread"})
 end
 
  
function RIB:RAttackers()
  BASE:E({self.name,"Red Attacker Thread"})
  local randomchance = math.random(1,100)
  if rdebug == true then
    BASE:E({self.name,"sead",randomchance})
  end
  if randomchance > 85 then
    if self.rattack ~= nil then
      if self.rattack:IsAlive() ~= true or self.rattack:AllOnGround() == true then
        self.rattack = SPAWN:NewWithAlias("Sqn119 BAI","Sqn119 BAI"):InitRandomizeRoute(1,4,2000,1500):Spawn()
      end
    else
      self.rattack = SPAWN:NewWithAlias("Sqn119 BAI","Sqn119 BAI"):InitRandomizeRoute(1,4,2000,1500):Spawn()
    end
    end
      if rdebug == true then
        BASE:E({self.name,"99",randomchance})
      end
    randomchance = math.random(1,100)
    if math.random(1,100) > 90 then
    if self.r99 ~= nil then
      if self.r99:IsAlive() ~= true or self.r99:AllOnGround() == true then
        self.r99 = SPAWN:NewWithAlias("SQN99","SQN99"):Spawn()
      end
    else
      self.r99 = SPAWN:NewWithAlias("SQN99","SQN99"):Spawn()
    end
  end
  BASE:E({self.name,"End Red Attackers Thread"})
end



function RIB:RInsurgents()
  BASE:E({self.name, "Red Insurgent Thread"})
  local RBC = SET_CLIENT:New():FilterCoalitions("red"):FilterActive():FilterOnce()
  RBC = RBC:Count()      
  local RBCS = SET_CLIENT:New():FilterCoalitions("red"):FilterCategories("helicopter"):FilterActive():FilterOnce()
  if rdebug == true then
    BASE:E({self.name, "Red Client count is",RBC})
    BASE:E({self.name, "Red Client Heli count is",RBCS:Count()})
  end
  local v1 = 110
  local v2 = 110
  local v3 = 110
  local v4 = 110
  if (RBC >= 1) and (RBC <=2) then
    if rdebug == true then
      BASE:E({self.name,"We have red clients!"})
    end
    v1 = 80 - (RBCS:Count() * 10)
    v2 = 110 
    v3 = 110
    v4 = 110
  elseif ((RBC > 2) and (RBC <= 5)) then
    v1 = 80 - (RBCS:Count() * 10) - ((RBC *5))
    v2 = 90
    v3 = 110
    v4 = 110
  elseif ((RBC > 5) and (RBC <= 10)) then
    v1 = 40
    v2 = 70
    v3 = 90
    v4 = 110
  elseif ((RBC > 10) and (RBC <= 15)) then
    v1 = 40
    v2 = 50
    v3 = 60
    v4 = 70
  elseif RBC > 15 then
    v1 = 30
    v2 = 40
    v3 = 50
    v4 = 60
  else
    v1 = 110 - (RBCS:Count() * 10)
    v2 = 110 
    v3 = 110
    v4 = 110
  end
    rchance = math.random(0,100)
    if rdebug == true then
      BASE:E({self.name,"Insurgents 1 C/V",rchance,v1})
    end
    if self.rinsurgent1 == nil then
      -- we don't have any insurgents in slot 1!   
        if rchance > v1 then
        if rdebug == true then
          BASE:E({self.name,"Spawning RInsurgents 1 C/V",rchance,v1})
        end
        self.rinsurgent1 = self.rinsurgent1s:Spawn()
        end  
    else
      if self.rinsurgent1:IsAlive() ~= true then
        if rchance > v1 then
          -- we don't have any insurgents in slot 1!
          if rdebug == true then
            BASE:E({self.name,"Spawning RInsurgents 1 C/V",rchance,v1})
          end   
          self.rinsurgent1 = self.rinsurgent1s:Spawn()
        end        
      end
    end
    rchance = math.random(0,100)
    if rdebug == true then
      BASE:E({self.name,"RInsurgents 2 C/V",rchance,v2})
    end
    if self.irnsurgent2 == nil then
      -- we don't have any insurgents in slot 2!   
        if rchance > v2 then
        if rdebug == true then
          BASE:E({self.name,"Spawning RInsurgents 2 C/V",rchance,v2})
        end
        self.irnsurgent2 = self.rinsurgent2s:Spawn()
        end
    else
      if self.rinsurgent2:IsAlive() ~= true then
      if rchance > v2 then
        -- we don't have any insurgents in slot 2!
        if rdebug == true then
          BASE:E({self.name,"Spawning RInsurgents 2 C/V",rchance,v2})
        end   
        self.rinsurgent2 = self.rinsurgent1s:Spawn()
      end
      end
    end
    if rdebug == true then
      BASE:E({self.name,"RInsurgents 3 C/V",rchance,v3})
    end
    rchance = math.random(0,100)
    if self.rinsurgent3 == nil then
      -- we don't have any insurgents in slot 3!   
        if rchance > v3 then
        if rdebug == true then
          BASE:E({self.name,"Spawning RInsurgents 3 C/V",rchance,v3})
        end
        self.rinsurgent3 = self.rinsurgent3s:Spawn()
        end
    else
      if self.rinsurgent3:IsAlive() ~= true then
      if rchance > v3 then
        -- we don't have any insurgents in slot 1!
        if rdebug == true then
          BASE:E({self.name,"Spawning RInsurgents 3 C/V",rchance,v3})
        end   
        self.rinsurgent3 = self.rinsurgent3s:Spawn()
      end
      end
    end
        rchance = math.random(0,100)
        if rdebug == true then
          BASE:E({self.name,"RInsurgents 4 C/V",rchance,v4})
        end
    if self.rinsurgent4 == nil then
      -- we don't have any insurgents in slot 4!   
        if rchance > v4 then
          if rdebug == true then
            BASE:E({self.name,"Spawning RInsurgents 4 C/V",rchance,v4})
          end
        self.rinsurgent4 = self.rinsurgent4s:Spawn()
        end
    else
      if self.rinsurgent4:IsAlive() ~= true then
      if rchance > v4 then
        -- we don't have any insurgents in slot 4!
        if rdebug == true then
          BASE:E({self.name,"Spawning Insurgents 4 C/V",rchance,v4})
        end   
        self.rinsurgent4 = self.rinsurgent4s:Spawn()
      end
      end
    end
    BASE:E({self.name,"End of Red Insurgent Thread"})
 end

-- START UP THREAD
-- START UP THREAD
-- START UP THREAD
-- START UP THREAD
-- START UP THREAD
-- START UP THREAD
-- START UP THREAD
-- START UP THREAD
-- START UP THREAD
 function RIB:StartUp()
  if ploaded == true then
    BASE:E({self.name,"Persisted claims it's loaded table is",PersistedStore})
  else
    BASE:E({self.name,"Persisted is not loaded."})
  end
  if gpar == true then
    BASE:E({self.name,"GPAR claims it's loaded table is",mainmission})
  else
    BASE:E({self.name,"GPAR Not loaded mainmission should be empty/nil",mainmission})
  end
  
  BASE:E({self.name,"STARTING UP"})
  roundreset = PersistedStore.roundreset
  if PersistedStore.resetall == nil then
    RESETALL = 0  
  else
    RESETALL = PersistedStore.resetall
  end
  CurrentRound = PersistedStore.round
  LastRound = PersistedStore.lastround
  if PersistedStore.bluescore ~= nil then
    bluescore = PersistedStore.bluescore 
  else
    PersistedStore.bluescore = 0
    bluescore = 0
  end
  if PersistedStore.redscore ~= nil then
    redscore = PersistedStore.redscore
  else
    PersistedStore.redscore = 0
    redscore = 0
  end 
  BASE:E({"ROUND COUNTER UPDATE",CurrentRound,LastRound,roundreset})
  local lastround = CurrentRound
  local round = CurrentRound + 1
  if round > roundreset then
      round = 1
      BASE:E({"Reset Round! Round set to 1"})
  end
  CurrentRound = round
  LastRound = lastround
  PersistedStore.round = round
  PersistedStore.lastround = lastround
  BASE:E({"ROUND COUNTER UPDATE PS",PersistedStore.round,PersistedStore.lastround})
  if mainmission.redgroundsupply ~= nil then
    redgroundsupply = mainmission.redgroundsupply
  else
    redgroundsupply = 200
    BASE:E({self.name,"redgroundsupply returned NIL setting to 200"})
  end
  if mainmission.redairsupply ~= nil then
    redairsupply = mainmission.redairsupply
  else
    redairsupply = 4
    BASE:E({self.name,"redairsupply returned nil setting to 4."})
  end
  if mainmission.bluegroundsupply ~= nil then
    bluegroundsupply = mainmission.bluegroundsupply
  else
    bluegroundsupply = 200
    BASE:E({self.name,"bluegroundsupply returned NIL setting to 200"})
  end
  if mainmission.blueairsupply ~= nil then
    blueairsupply = mainmission.blueairsupply
  else
    blueairsupply = 4
    BASE:E({self.name,"blueairsupply returned NIL setting to 4"})
  end
  if PersistedStore.noclients ~= nil then
    noclients = PersistedStore.noclients
  else
    noclients = 0
  end
  BASE:E({self.name, "Rounds loaded",CurrentRound,LastRound,roundreset})
  
  if PersistedStore.sochi == 1 or PersistedStore.sochi == 0 then
    SOCHIOWNER = 1
    BASE:E({self.name,"Red has taken Sochi Spawning Defenses"})
    if mainmission.RedSochiSpawned ~= 0 then
      BASE:E({self.name,"Main mission Red Sochi spawned was not nil trying to find group.",mainmission.RedSochiSpawned})
      if GROUP:FindByName(mainmission.RedSochiSpawned) ~= nil then
        self.RedSochiSpawned = GROUP:FindByName(mainmission.RedSochiSpawned)
      else
        BASE:E({self.name,"Main mission Sochi Red spawned was nil spawning in new unit"})
      end
    else
      self.RedSochiSpawned = self.RedSochiDefSpawn:Spawn()
    end
    allowredsochi()
  else
    SOCHIOWNER = 2
    self.RedSochiSpawned = 0
    local RK = GROUP:FindByName("Sochi-Takeover")
    RK:Activate()
    BASE:E({"Blue has taken Sochi! Spawning Defences oh that's right they don't get any!"})
    disableredsochi()
    ra2adisp:SetSquadron("SochiSqn",AIRBASE.Caucasus.Sochi_Adler,RCAPTEMPLATES,0) -- kill sochisqn for now.
  end
  BASE:E({self.name, "Sochi",SOCHIOWNER})
  
  if PersistedStore.kobuleti == 2 or PersistedStore.kobuleti == 0 then
    KOBOWNER = 2
    BASE:E({self.name,"Spawning Blue Kobeleti Defenses"})
    if mainmission.BlueKobSpawned ~= 0 then
      BASE:E({self.name,"Main mission blue kobspawned was not nil trying to find group.",mainmission.BlueKobSpawned})
      if GROUP:FindByName(mainmission.BlueKobSpawned) ~= nil then
        self.BlueKobSpawned = GROUP:FindByName(mainmission.BlueKobSpawned)
      else
        BASE:E({self.name,"Main mission blue kobspawned was nil spawning in new unit"})
      end
    else
      self.BlueKobSpawned = self.BlueKobSpawn:Spawn()
    end
    allowbluekob()
  else
    KOBOWNER = 1
    self.BlueKobSpawned = 0
    local RK = GROUP:FindByName("Kob-Takeover")
    RK:Activate()
    BASE:E({"Red has taken Kobuleti! Spawning Defences oh that's right they don't get any!"})
    disallowbluekob()
    if AIBLUECAP ~= true then
      if self.kobsqn ~= nil then
        self.kobsqn:SpawnScheduleStop()
      else
        BASE:E({self.name,"Kob sqn was NIL this shouldn't happen!"})
      end
    else     
      ba2adisp:SetSquadron("KobSqn",AIRBASE.Caucasus.Kobuleti,BCAPTEMPLATES,0)
    end
  end
  if PersistedStore.senaki == 2 or PersistedStore.senaki == 0 then
    SENOWNER = 2
    self.RedSenSpawned = 0
    BASE:E({self.name,"Spawning Blue Sen Defenses, opening blue slots"})
    if mainmission.BlueSenSpawned ~= 0 then
      BASE:E({self.name,"Main mission blue Sen spawned was not nil trying to find.",mainmission.BlueKobSpawned})
      if GROUP:FindByName(mainmission.BlueKobSpawned) ~= nil then
        self.BlueSenSpawned = GROUP:FindByName(mainmission.BlueKobSpawned)
      else
        BASE:E({self.name,"Main mission blue Sen spawned was nil spawning in new unit"})
      end
    else
      self.BlueSenSpawned = self.BlueSenSpawn:Spawn()
    end
    allowbluesen()
  else
    SENOWNER = 1
    self.BlueSenSpawned = 0
    BASE:E({self.name,"Spawning RAFD Sen Defenses, closing blue slots"})
    if mainmission.RedSenSpawned ~= 0 then
      BASE:E({self.name,"Main mission Red Sen spawned was not nil trying to find.",RedSenSpawned})
      if GROUP:FindByName(mainmission.RedSenSpawned) ~= nil then
        self.RedSenSpawned = GROUP:FindByName(mainmission.RedSenSpawned)
      else
        BASE:E({self.name,"Main mission Red Sen spawned was nil spawning in new unit"})
      end
    else
      self.RedSenSpawned = self.RedSenSpawn:Spawn()
    end
     disallowbluesen()
     if AIBLUECAP ~= true then
        if self.sensqn ~= nil then
          self.sensqn:SpawnScheduleStop()
        else
          BASE:E({self.name,"sensqn was nil this shouldn't happen"})
        end
      end
  end
  if PersistedStore.kutaisi == 2 or PersistedStore.kutaisi == 0 then
    KUTOWNER = 2
    self.RedKutSpawned = 0
    BASE:E({self.name,"Spawning Blue KUT Defenses, opening blue slots"})
    if mainmission.BlueKutSpawned ~= 0 then
      BASE:E({self.name,"Main mission blue kutspawned was not nil trying to find.",mainmission.BlueKutSpawned})
      if GROUP:FindByName(mainmission.BlueKutSpawned) ~= nil then
        self.BlueKutSpawned = GROUP:FindByName(mainmission.BlueKutSpawned)
      else
        BASE:E({self.name,"Main mission blue Kutspawned was nil so = 0"})
      end
    else
      self.BlueKutSpawned = self.BlueKutSpawn:Spawn()
    end
         MESSAGE:New("INIT KUT OWNED BY BLUE",30):ToAll()
            allowbluekut()
    else
     KUTOWNER = 1
     self.BlueKutSpawned = 0
     MESSAGE:New("INIT KUT OWNED BY RED",30):ToAll()
     BASE:E({self.name,"Spawning RAFD Kut Defenses, opening blue slots"})
     if mainmission.RedKutSpawned ~= 0 then
       BASE:E({self.name,"Main mission Red kutspawned was not nil trying to find.",mainmission.BlueKutSpawned})
       if GROUP:FindByName(mainmission.RedKutSpawned) ~= nil then
          self.RedKutSpawned = GROUP:FindByName(mainmission.RedKutSpawned)
       else
          BASE:E({self.name,"Main mission Red kutspawned was nil setting to 0"})
          self.RedKutSpawned = 0
       end
     else
      self.RedKutSpawned = self.RedKutSpawn:Spawn()
     end
     disallowbluekut()
     if AIBLUECAP ~= true then
      if self.kutsqn ~= nil then
        self.kutsqn:SpawnScheduleStop()
      else
        BASE:E({self.name,"Kutsqn was nil this shoulnd't happen"})
        end
      else
        ba2adisp:SetSquadron("KutSqn",AIRBASE.Caucasus.Kutaisi,BCAPTEMPLATES,0)
      end
  end
  if (PersistedStore.sukhumi == 1) or (PersistedStore.sukhumi == 0) then
    BASE:E({self.name,"Red Spawning Sukhumi Defenses."})
    self.BlueSukSpawned = 0
    if mainmission.RedSukSpawned ~= 0 then
      BASE:E({self.name,"Main mission Red Sukspawned was not nil trying to find.",mainmission.RedSukSpawned})
      if GROUP:FindByName(mainmission.RedSukSpawned) ~= nil then
        self.RedSukSpawned = GROUP:FindByName(mainmission.RedSukSpawned)
      else
        BASE:E({self.name,"RedSukSpawned Find BY name on group == nil setting to 0"})
      end
    else
      self.RedSukSpawned = self.RedSukDefSpawn:Spawn()
    end
    SUKOWNER = 1
    MESSAGE:New("INIT SUK OWNED BY RED",30):ToAll() 
          allowredsuk()
          disallowbluesuk()
          BASE:E({self.name,"Blue Slots Should be Closed at Suk"})          
  elseif PersistedStore.sukhumi == 2 then
    SUKOWNER = 2
    self.RedSukSpawned = 0 
    BASE:E({self.name,"Blue Spawning Sukhumi Defenses."})
         MESSAGE:New("INIT Suk OWNED BY Blue",30):ToAll()
    if mainmission.BlueSukSpawned ~= 0 then
      BASE:E({self.name,"Main mission Blue Sukspawned was not nil trying to find.",mainmission.BlueSukSpawned})
      if GROUP:FindByName(mainmission.BlueSukSpawned) ~= nil then
        self.BlueSukSpawned = GROUP:FindByName(mainmission.BlueSukSpawned)
      else
        BASE:E({self.name,"BlueSukSpawned returned nil setting to 0"})
      end
    else
        self.BlueSukSpawned = self.BlueSukDefSpawn:Spawn()
    end
         allowbluesuk()
         disallowredsuk()
          BASE:E({self.name,"Blue Slots Should be Open at Suk"})    
  else
    BASE:E({self.name, "PersistedStore.sukhumi reported as",PersistedStore.sukhumi})
  end
  if (PersistedStore.gudauta == 1) or (PersistedStore.gudauta == 0) then
     GUDOWNER = 1
     BASE:E({self.name,"Red Spawning Guduata Defences"})
     self.BlueGudSpawned = 0
    if mainmission.RedGudSpawned ~= 0 then
      BASE:E({self.name,"Main mission Red Gudspawned was not nil trying to find.",mainmission.RedGudSpawned})
      if GROUP:FindByName(mainmission.RedGudSpawned) ~= nil then
        self.RedGudSpawned = GROUP:FindByName(mainmission.RedGudSpawned)
      end
    else
      self.RedGudSpawned = self.RedGudDefSpawn:Spawn()
    end
     MESSAGE:New("INIT: GUD OWNED BY RED",30):ToAll()
     disallowbluegud()
     allowredgud()
  elseif PersistedStore.gudauta == 2 then
     GUDOWNER = 2
     self.RedGudSpawned = 0
     BASE:E({self.name,"Blue Spawning Guduata Defences"})
     if mainmission.BlueGudSpawned ~= 0 then
      BASE:E({self.name,"Main mission Blue Gudspawned was not nil trying to find.",mainmission.BlueGudSpawned})
      if GROUP:FindByName(mainmission.BlueGudSpawned) ~= nil then
        self.BlueGudSpawned = GROUP:FindByName(mainmission.BlueGudSpawned)
      end
     else
      self.BlueGudSpawned = self.BluGudDefSpawn:Spawn()
    end
     self.BluGudDef = self.BluGudDefSpawn:Spawn()
     MESSAGE:New("INIT GUD OWNED BY BLUE",30):ToAll()
     disallowredgud()
     allowbluegud()
  else
      BASE:E({self.name, "PersistedStore.Guduata reported as",PersistedStore.gudauta})
  end
  if PersistedStore.ralive == 1 then
     self.RedArmyStateL = 10
     BASE:E({self.name,"Red Army was alive in Persistance table, destroying old making new"})
     if PersistedStore.rx ~= 0 and PersistedStore.ry ~= 0 then
      self.RedArmyX = PersistedStore.rx
      self.RedArmyY = PersistedStore.ry
      self.RedArmyState = PersistedStore.RedArmyState
      local tempvec2 = POINT_VEC2:New(PersistedStore.rx,PersistedStore.ry)
      if mainmission.RedArmySpawned ~= 0 then
        BASE:E({self.name,"Mainmission.RedArmySpawned was not nil looking for group",mainmission.RedArmySpawned})
        self.RedArmy = GROUP:FindByName(mainmission.RedArmySpawned)
        self.RedArmySpawned = self.RedArmy
        if self.RedArmy == nil then
          BASE:E({self.name,"Mainmission.RedArmy group search came back nil!"})
        else
          local ccord = self.RedArmy:GetCoordinate()
          if ccord:IsSurfaceTypeWater() == true then
            BASE:E({self.name,"RedArmy was in the water! DESTROYING IT"})
            self.RedArmy:Destroy()
            self.RedArmySpawned = 0
          end
        end
      else
        BASE:E({self.name,"mainmission.RedArmySpawned was nil we need to spawn in a new one"})
        self.RedArmy = self.RedArmySpawn:SpawnFromPointVec2(tempvec2)
        BASE:E({self.name,"RedArmy Was spawned Red Army is now",self.RedArmy:GetName()})
        self.RedArmySpawned = self.RedArmy
      end
      BASE:E({self.name,"Red Army should be spawned"})
     else
      if mainmission.RedArmySpawned ~= 0 then
        BASE:E({self.name,"Coords were 0,0 but we had a stored unit so using it"})
        BASE:E({self.name,"Mainmission.RedArmySpawned was not nil looking for group",mainmission.RedArmySpawned})
        self.RedArmy = GROUP:FindByName(mainmission.RedArmySpawned)
        BASE:E({self.name,"RedArmy is now",self.RedArmy:GetName()})
        self.RedArmySpawned = self.RedArmy
        if self.RedArmy == nil then
          BASE:E({self.name,"Mainmissoin.RedArmy group search came back nil!"})
        else
          local ccord = self.RedArmy:GetCoordinate()
          if ccord:IsSurfaceTypeWater() == true then
            BASE:E({self.name,"RedArmy was in the water! DESTROYING IT"})
            self.RedArmy:Destroy()
            self.RedArmySpawned = 0
          end
        end
      else
        BASE:E({self.name,"Coords were 0,0 so using base spawn and not destroying after all!"})
        self.RedArmy = self.RedArmySpawn:Spawn()
        BASE:E({self.name,"RedArmy Was Respawned Red Army is now",self.RedArmy:GetName()})
        self.RedArmySpawned = self.RedArmy
      end
     end
  else
     BASE:E({self.name,"Red Army was dead so it should be at the start again"})
     self.RedArmy = self.RedArmySpawn:Spawn()
     BASE:E({self.name,"RedArmy Was Respawned Red Army is now",self.RedArmy:GetName()})
     self.RedArmySpawned = self.RedArmy
  end
  if red1active == true then
  if PersistedStore.ralive1 == 1 then
     BASE:E({self.name,"RedArmy1 was alive in Persistance table, destroying old making new"})
     if PersistedStore.rx1 ~= 0 and PersistedStore.ry1 ~= 0 then
      self.RedArmy1X = PersistedStore.rx1
      self.RedArmy1Y = PersistedStore.ry1
      self.RedArmy1State = PersistedStore.RedArmy1State
      local tempvec2 = POINT_VEC2:New(PersistedStore.rx1,PersistedStore.ry1)
      if mainmission.RedArmy1Spawned ~= 0 then
        BASE:E({self.name,"Mainmission.RedArmy1Spawned was not nil looking for group",mainmission.RedArmy1Spawned})
        
        self.RedArmy1 = GROUP:FindByName(mainmission.RedArmy1Spawned)
        self.RedArmy1Spawned = self.RedArmy1
        if self.RedArmy1 == nil then
          BASE:E({self.name,"Mainmissoin.RedArmy group search came back nil!"})
        else
          local ccord = self.RedArmy1:GetCoordinate()
          if ccord:IsSurfaceTypeWater() == true then
            BASE:E({self.name,"RedArmy1 was in the water! DESTROYING IT"})
            self.RedArmy1:Destroy()
            self.RedArmy1Spawned = 0
          end
        end
      else
        BASE:E({self.name,"mainmission.RedArmy1Spawned was nil we need to spawn in a new one"})
        self.RedArmy1 = self.RedArmy1Spawn:SpawnFromPointVec2(tempvec2)
        self.RedArmy1Spawned = self.RedArmy1
      end
      BASE:E({self.name,"RedArmy1 should be spawned"})
     else
      if mainmission.RedArmy1Spawned ~= 0 then
        BASE:E({self.name,"Coords were 0,0 but we had a stored unit so using it"})
        BASE:E({self.name,"Mainmission.RedArmy1Spawned was not nil looking for group",mainmission.RedArmy1Spawned})
        self.RedArmy1 = GROUP:FindByName(mainmission.RedArmy1Spawned)
        self.RedArmy1Spawned = self.RedArmy1
        if self.RedArmy1 == nil then
          BASE:E({self.name,"Mainmissoin.RedArmy1 group search came back nil!"})
        else
          local ccord = self.RedArmy1:GetCoordinate()
          if ccord:IsSurfaceTypeWater() == true then
            BASE:E({self.name,"RedArmy1 was in the water! DESTROYING IT"})
            self.RedArmy1:Destroy()
            self.RedArmy1Spawned = 0
          end
        end
      else
        BASE:E({self.name,"Coords were 0,0 so using base spawn and not destroying after all!"})
        self.RedArmy1 = self.RedArmy1Spawn:Spawn()
        self.RedArmy1Spawned = self.RedArmy1
      end
     end
  else
     BASE:E({self.name,"RedArmy1 was dead so it should be at the start again"})
     self.RedArmy1 = self.RedArmy1Spawn:Spawn()
     self.RedArmy1Spawned = self.RedArmy1
  end
  else
    BASE:E({self.name,"red1active was false"})
  end
  
  if PersistedStore.ralive2 == 1 then
     BASE:E({self.name,"RedArmy2 was alive in Persistance table, destroying old making new"})
     if PersistedStore.rx2 ~= 0 and PersistedStore.ry2 ~= 0 then
      self.RedArmy2X = PersistedStore.rx2
      self.RedArmy2Y = PersistedStore.ry2
      self.RedArmy2State = PersistedStore.RedArmy2State
      local tempvec2 = POINT_VEC2:New(PersistedStore.rx2,PersistedStore.ry2)
      if mainmission.RedArmy2Spawned ~= 0 then
        BASE:E({self.name,"Mainmission.RedArmy2Spawned was not nil looking for group",mainmission.RedArmy2Spawned})
        self.RedArmy2 = GROUP:FindByName(mainmission.RedArmy2Spawned)
        self.RedArmy2Spawned = self.RedArmy2
        if self.RedArmy2 == nil then
          BASE:E({self.name,"Mainmissoin.RedArmy group search came back nil!"})
        else
          local ccord = self.RedArmy2:GetCoordinate()
          if ccord:IsSurfaceTypeWater() == true then
            BASE:E({self.name,"RedArmy2 was in the water! DESTROYING IT"})
            self.RedArmy2:Destroy()
            self.RedArmy2Spawned = 0
          end
        end
      else
        BASE:E({self.name,"mainmission.RedArmy2Spawned was nil we need to spawn in a new one"})
        self.RedArmy2 = self.RedArmy2Spawn:SpawnFromPointVec2(tempvec2)
        self.RedArmy2Spawned = self.RedArmy2
      end
      BASE:E({self.name,"RedArmy2 should be spawned"})
     else
      if mainmission.RedArmy2Spawned ~= 0 then
        BASE:E({self.name,"Coords were 0,0 but we had a stored unit so using it"})
        BASE:E({self.name,"Mainmission.RedArmy2Spawned was not nil looking for group",mainmission.RedArmy2Spawned})
        self.RedArmy2 = GROUP:FindByName(mainmission.RedArmy2Spawned)
        self.RedArmy2Spawned = self.RedArmy2
        if self.RedArmy2 == nil then
          BASE:E({self.name,"Mainmissoin.RedArmy2 group search came back nil!"})
        else
          local ccord = self.RedArmy2:GetCoordinate()
          if ccord:IsSurfaceTypeWater() == true then
            BASE:E({self.name,"RedArmy2 was in the water! DESTROYING IT"})
            self.RedArmy2:Destroy()
            self.RedArmy2Spawned = 0
          end
        end
      else
        BASE:E({self.name,"Coords were 0,0 so using base spawn and not destroying after all!"})
        self.RedArmy2 = self.RedArmy2Spawn:Spawn()
        self.RedArmy2Spawned = self.RedArmy2
      end
     end
  else
     BASE:E({self.name,"RedArmy2 was dead so it should be at the start again"})
     self.RedArmy2 = self.RedArmy2Spawn:Spawn()
     self.RedArmy2Spawned = self.RedArmy2
  end
  
  
    if PersistedStore.balive == 1 then
     BASE:E({self.name,"Blue Army was alive in Persistance table, destroying old making new"})
     if PersistedStore.bx ~= 0 and PersistedStore.by ~= 0 then
      self.BluArmyX = PersistedStore.bx
      self.BluArmyY = PersistedStore.by
      self.BluArmyState = PersistedStore.BluArmyState
      local tempvec2 = POINT_VEC2:New(PersistedStore.bx,PersistedStore.by)
      if mainmission.BlueArmySpawned ~= 0 then
        BASE:E({self.name,"BLUE ARMY returned not nil on a group find",mainmission.BlueArmySpawned})
        self.BluArmy = GROUP:FindByName(mainmission.BlueArmySpawned)
        self.BlueArmySpawned = self.BluArmy
        if self.BluArmy == nil then
          BASE:E({self.name,"BLUE ARMY returned nil on a group find"})
          self.BluArmy = self.BluArmySpawn:SpawnFromPointVec2(tempvec2)
          self.BlueArmySpawned = self.BluArmy
        else
          local ccord = self.BluArmy:GetCoordinate()
          if ccord:IsSurfaceTypeWater() == true then
            BASE:E({self.name,"BLUE ARMY WAS REPORTED ON WATER! DESTROYING IT"})
            self.BluArmy:Destroy()
            self.BlueArmySpawned = 0
          end
        end
      else
        self.BluArmy = self.BluArmySpawn:SpawnFromPointVec2(tempvec2)
        self.BlueArmySpawned = self.BluArmy
      end
      BASE:E({self.name,"Blu Army should be spawned"})
     else
      if mainmission.BlueArmySpawned ~= 0 then
        BASE:E({self.name,"Coords were 0,0 but we have a stored unit so we are using it"})
        self.BluArmy = GROUP:FindByName(mainmission.BlueArmySpawned)
        self.BlueArmySpawned = self.BluArmy
        if self.BluArmy == nil then
          BASE:E({self.name,"BLUE ARMY returned nil on a group find"})
          self.BluArmy = self.BluArmySpawn:Spawn()
          self.BlueArmySpawned = self.BluArmy
        else
          local ccord = self.BluArmy:GetCoordinate()
          if ccord:IsSurfaceTypeWater() == true then
            BASE:E({self.name,"BLUE ARMY WAS REPORTED ON WATER! DESTROYING IT"})
            self.BluArmy:Destroy()
            self.BluArmy = self.BluArmySpawn:Spawn()
            self.BlueArmySpawned = self.BluArmy
          end
        end
      end
      BASE:E({self.name,"Coords were 0,0 so using base spawn and not destroying after all!"})
      self.BluArmy = self.BluArmySpawn:Spawn()
      self.BlueArmySpawned = self.BluArmy
      
     end
  else
     BASE:E({self.name,"Blu Army was dead so it should be at the start again"})
  end
  if PersistedStore.balive1 == 1 then
     BASE:E({self.name,"Blue Army1 was alive in Persistance table, destroying old making new"})
     if PersistedStore.bx1 ~= 0 and PersistedStore.by1 ~= 0 then
      self.BluArmy1X = PersistedStore.bx1
      self.BluArmy1Y = PersistedStore.by1
      self.BluArmy1State = PersistedStore.BluArmy1State 
      local tempvec2 = POINT_VEC2:New(PersistedStore.bx1,PersistedStore.by1)
      if mainmission.BlueArmy1Spawned ~= 0 then
        BASE:E({self.name,"BLUE ARMY returned not nil on a group find",mainmission.BlueArmy1Spawned})
        self.BluArmy1 = GROUP:FindByName(mainmission.BlueArmy1Spawned)
        self.BlueArmy1Spawned = self.BluArmy1   
        if self.BluArmy1 == nil then
          BASE:E({self.name,"Blue Army 1 was nil"})
          self.BluArmy1 = self.BluArmy1Spawn:SpawnFromPointVec2(tempvec2)
          self.BlueArmy1Spawned = self.BluArmy1
        else
          local ccord = self.BluArmy1:GetCoordinate()
          if ccord:IsSurfaceTypeWater() == true then
            BASE:E({self.name,"BLUE ARMY1 WAS REPORTED ON WATER! DESTROYING IT"})
            self.BluArmy1:Destroy()
            self.BlueArmy1Spawned = 0
          end
        end
      else
        BASE:E({self.name,"Blue Army 1 spawned was nil"})
        self.BluArmy1 = self.BluArmy1Spawn:SpawnFromPointVec2(tempvec2)
        self.BlueArmy1Spawned = self.BluArmy1
      end
      BASE:E({self.name,"Blu Army 1 should be spawned"})
     else
      if mainmission.BlueArmy1Spawned ~= 0 then
      BASE:E({self.name,"Coords were 0,0 but we have a unit so we are using it"})
        BASE:E({self.name,"BLUE ARMY returned not nil on a group find",mainmission.BlueArmy1Spawned})
        self.BluArmy1 = GROUP:FindByName(mainmission.BlueArmy1Spawned)
        self.BlueArmy1Spawned = self.BluArmy1   
        if self.BluArmy1 == nil then
          BASE:E({self.name,"Blue Army 1 was nil"})
          self.BluArmy1 = self.BluArmy1Spawn:Spawn()
          self.BlueArmy1Spawned = self.BluArmy1
        else
          local ccord = self.BluArmy1:GetCoordinate()
          if ccord:IsSurfaceTypeWater() == true then
            BASE:E({self.name,"BLUE ARMY1 WAS REPORTED ON WATER! DESTROYING IT"})
            self.BluArmy1:Destroy()
            self.BlueArmy1Spawned = 0
            self.BluArmy1 = self.BluArmy1Spawn:Spawn()
            self.BlueArmy1Spawned = self.BluArmy1
          end
        end
      else
      BASE:E({self.name,"Coords were 0,0 so using base spawn and not destroying after all!"})
      self.BluArmy1 = self.BluArmy1Spawn:Spawn()
      self.BlueArmy1Spawned = self.BluArmy1
      end
     end
  else
     BASE:E({self.name,"Blu Army 1 was dead so it should be at the start again"})
     self.BluArmy1 = self.BluArmy1Spawn:Spawn()
     self.BlueArmy1Spawned = self.BluArmy1
  end
    if PersistedStore.balive2 == 1 then
     BASE:E({self.name,"Blue Army2 was alive in Persistance table, destroying old making new"})
     if PersistedStore.bx2 ~= 0 and PersistedStore.by2 ~= 0 then
      self.BluArmy2X = PersistedStore.bx2
      self.BluArmy2Y = PersistedStore.by2
      self.BluArmy2State = PersistedStore.BluArmy2State
      local tempvec2 = POINT_VEC2:New(PersistedStore.bx2,PersistedStore.by2)
       if mainmission.BlueArmy2Spawned ~= 0 then
       BASE:E({self.name,"BLUE ARMY2 returned not nil on a group find",mainmission.BlueArmy2Spawned})
        self.BluArmy2 = GROUP:FindByName(mainmission.BlueArmy2Spawned)
        self.BlueArmy2Spawned = self.BluArmy2   
        if self.BluArmy2 == nil then
          BASE:E({self.name,"BluArmy2 returned nil spawning in old fashioned way"})
          if blue2active == true then
            self.BluArmy2 = self.BluArmy2Spawn:SpawnFromPointVec2(tempvec2)
            self.BlueArmy2Spawned = self.BluArmy2
          end
        else
          local ccord = self.BluArmy2:GetCoordinate()
          if ccord:IsSurfaceTypeWater() == true then
            BASE:E({self.name,"BLUE ARMY2 WAS REPORTED ON WATER! DESTROYING IT"})
            self.BluArmy2:Destroy()
            self.BlueArmy2Spawned = 0
            if blue2active == true then
              self.BluArmy2 = self.BluArmy2Spawn:Spawn()
              self.BlueArmy2Spawned = self.BluArmy2
            end
          end
        end
      else
        if blue2active == true then
          self.BluArmy2 = self.BluArmy2Spawn:SpawnFromPointVec2(tempvec2)
          self.BlueArmy2Spawned = self.BluArmy2
        end
      end
      BASE:E({self.name,"Blu Army 2 should be spawned unless blue2active = false it is",blue2active})
     else
      if mainmission.BlueArmy2Spawned ~= 0 then
        BASE:E({self.name,"Coords were 0,0 but we had a stored unit using it instead"})
        BASE:E({self.name,"BLUE ARMY2 returned not nil on a group find",mainmission.BlueArmy2Spawned})
        if blue2active == true then 
          self.BluArmy2 = GROUP:FindByName(mainmission.BlueArmy2Spawned)
          self.BlueArmy2Spawned = self.BluArmy2
        end   
        if self.BluArmy2 == nil then
          BASE:E({self.name,"BluArmy2 returned nil spawning in old fashioned way"})
          BASE:E({self.name,"Coords were 0,0 so using base spawn and not destroying after all!"})
          if blue2active == true then 
            self.BluArmy2 = self.BluArmy2Spawn:Spawn()
            self.BlueArmy2Spawned = self.BluArmy2
          end
        else
          local ccord = self.BluArmy2:GetCoordinate()
          if ccord:IsSurfaceTypeWater() == true then
            BASE:E({self.name,"BLUE ARMY2 WAS REPORTED ON WATER! DESTROYING IT"})
            self.BluArmy2:Destroy()
            self.BlueArmy2Spawned = 0
            if blue2active == true then
              self.BluArmy2 = self.BluArmy2Spawn:Spawn()
              self.BlueArmy2Spawned = self.BluArmy2
            end
          end
        end
      else
        BASE:E({self.name,"Coords were 0,0 so using base spawn and not destroying after all!"})
        if blue2active == true then
          self.BluArmy2 = self.BluArmy2Spawn:Spawn()
          self.BlueArmy2Spawned = self.BluArmy2
        end
      end
     end
  else
      if blue2active == true then
        BASE:E({self.name,"Blu Army 2 was dead so it should be at the start again"})
        self.BluArmy2 = self.BluArmy2Spawn:Spawn()
        self.BlueArmy2Spawned = self.BluArmy2
      end
  end

  BASE:E({self.name,"Command Center Persistences"})
  BASE:E({self.name,"Command Center Novo"})
  if PersistedStore.NovoCommand ~= nil then
    if PersistedStore.NovoCommand == 0 then
      if nowtime < (PersistedStore.NovoRound + commandrebuild)  then
        if novocommand:IsAlive() == true then
          SCHEDULER:New(nil,function()
           novocommand:Destroy() 
           BASE:E({self.name,"Novocommand was reported as 0 current time is less then rebuild don't match destroying",PersistedStore.NovoRound,PersistedStore.NovoCommand})
          local rbt = os.date('%A, %B %d %Y at %H:%M UTC', (PersistedStore.NovoRound))
          _nc:RemoveMark(_nm)
          _nm = _nc:MarkToAll("Novorossisk Command Center, Destroyed rebuild after ".. rbt,true)
          end,{},15)
        end
      else
        PersistedStore.NovoCommand = 1
        BASE:E({self.name,"Novocommand is alive now"})
      end
    end
  else
    BASE:E({"PersistedStore.NovoCommand was Nil"})
    PersistedStore.NovoCommand = 1
    PersistedStore.NovoRound = 0
  end
  BASE:E({self.name,"Command Center May"})
  if PersistedStore.MayCommand ~= nil then
    if PersistedStore.MayCommand == 0 then
      if nowtime < (PersistedStore.MayRound + commandrebuild)  then
        if maycommand:IsAlive() == true then
          SCHEDULER:New(nil,function() maycommand:Destroy()
          BASE:E({self.name,"Maycommand was reported as 0 current time less then rebuild destroying",PersistedStore.MayRound,PersistedStore.MayCommand})
          local rbt = os.date('%A, %B %d %Y at %H:%M UTC', (PersistedStore.MayRound))
          _mac:RemoveMark(_mam)
          _mam = _mac:MarkToAll("Maykop Command Center, Destroyed rebuild after ".. rbt,true)
          end,{},15)
        end
      else
        BASE:E({self.name,"Maycommand is alive now"})
        PersistedStore.MayCommand = 1
      end
    end
  else
    BASE:E({self.name,"PersistedStore.MayCommand was Nil"})
    PersistedStore.MayCommand = 1
    PersistedStore.MayRound = 0
  end
  BASE:E({self.name,"Command Center Kraz"})
  if PersistedStore.KrazCommand ~= nil then
    if PersistedStore.KrazCommand == 0 then
      if nowtime < (PersistedStore.KrazRound + commandrebuild)  then
        if krazcommand:IsAlive() == true then
          SCHEDULER:New(nil,function() krazcommand:Destroy()
          local rbt = os.date('%A, %B %d %Y at %H:%M UTC', (PersistedStore.KrazRound))
          _kc:RemoveMark(_km)
          _km = _km:MarkToAll("Krasnodar Command Center, Destroyed rebuild after ".. rbt,true)
          BASE:E({self.name,"Krazcommand was reported as 0 current time is less then rebuild destroying",PersistedStore.KrazRound,PersistedStore.KrazCommand})
          end,{},15)
        end
      else
        BASE:E({self.name,"Krazcommand is alive now"})
        PersistedStore.KrazCommand = 1
      end
    end
  else
    BASE:E({self.name,"PersistedStore.KrazCommand was Nil"})
    PersistedStore.KrazCommand = 1
    PersistedStore.KrazRound = 0
  end
  BASE:E({self.name,"Command Center Moz"})
  if PersistedStore.MozCommand ~= nil then
    if PersistedStore.MozCommand == 0 then
      if nowtime < (PersistedStore.MozRound + commandrebuild)  then
        if mozcommand:IsAlive() == true then
          SCHEDULER:New(nil,function() mozcommand:Destroy()
           local rbt = os.date('%A, %B %d %Y at %H:%M UTC', (nowtime + commandrebuild))
          _mc:RemoveMark(_mm)
          _mm = _mc:MarkToAll("Mozdok Command Center, Destroyed rebuild after ".. rbt,true)
          BASE:E({self.name,"mozcommand was reported as 0 current time is less then rebuild destroying",PersistedStore.MozRound,PersistedStore.MozCommand})
          end,{},15)
        end
      else
        BASE:E({self.name,"Mozcommand is alive now"})
        PersistedStore.MozCommand = 1
      end
    end
  else
    BASE:E({self.name,"PersistedStore.MozCommand was Nil"})
    PersistedStore.MozCommand = 1
    PersistedStore.MozRound = 0
  end
  BASE:E({self.name,"Command Center Persistences Finished"})
  self.TBscheduler = SCHEDULER:New(nil, function()
    BASE:E({self.name,"BGROUND TICK SHOULD BE RUNNING"})
    if noclients < 2 then
      self.BGroundTick(self,3000,2000)
    else
      BASE:E({self.name,"BGROUND TICK Was not run as noclients was higher then 2",noclients})
    end
  end,{},60,(30*60))
  self.TRscheduler = SCHEDULER:New(nil, function()
    BASE:E({self.name,"RGROUND TICK SHOULD BE RUNNING"})
    if noclients < 2 then
      self.RGroundTick(self,3000,2000)
    else
      BASE:E({self.name,"RGROUND TICK was not run as Noclients was higher then 2",noclients})
    end
  end,{},90,(30*60))
  self.IScheduler = SCHEDULER:New(nil, function()
   BASE:E({self.name,"BInsurgent TICK should be running"})
   if insurgents == true then
    if noclients < 2 then
      self.BInsurgents(self)
    else
      BASE:E({self.name,"BInsurgent Tick did not run because No Clients was greater then 2"})
    end
   end
  end,{},(60*4),(30*60))
  -- self.IRScheduler = SCHEDULER:New(nil, function()
   --BASE:E({self.name,"RInsurgent TICK should be running"})
   --self.RInsurgents(self)
  -- end,{},(60*3),(60*90))
  SCHEDULER:New(nil,function() 
    self.init = true
    init = true
    checkthings()
    BASE:E({self.name,"INITALIZATION COMPLETED"})
     end,{},30)
  
 end
 -- end of RIW

function vcoord(mypos,tco,distance)
  BASE:E({"VCOORD: Attempting to Verify Coordinates"})
  local headingto = mypos:HeadingTo(tco)
  local distanceto = mypos:Get2DDistance(tco)
  local nco = tco
  if distanceto > distance then
    local tco1 = mypos:Translate(distance,headingto)
    nco = tco1
    local maxiterations = 17
    local validcoord = false
    if LandZone:IsCoordinateInZone(nco) == false then
      BASE:E({"COORD HUNTING: Attempting to get a valid Coord because the current one is not valid"})
      for i = 1, maxiterations do
        if validcoord == false then
          headingto = headingto + 10
          if headingto >= 360 then
            headingto = headingto - 360
          end
          BASE:E({"COORD HUNTING: Headingto is:",headingto})
          local tco2 = mypos:Translate(distance,headingto)
          if LandZone:IsCoordinateInZone(tco) == true then
            validcoord = true
            i = maxiterations
            nco = tco2
            BASE:E({"COORD HUNTING: New Valid Coord Found"})
            return nco
          end
        else
          BASE:E({"COORD HUNTING: Valid Coord is true"})
          return nco
        end
      end
      if validcoord == false then
        BASE:E({"COORD HUNTING: We couldn't get a valid coord using the original."})
        nco = tco
        return nco
      end
    else
      validcoord = true
      BASE:E({"COORD HUNTING: First Coord was valid we are good"})
      return nco
    end
  else
    BASE:E({"COORD IS less then ".. distance .. "Meters we are good"})
    return nco  
  end
  return nco
end


mainthread = RIB:New("Main Thread") -- create our main thread.
-- we will add something like mainthread:Initalize() here as well once we are doine which should run everything and get it all started
-- for now we are calling them one by one.
-- mainthread:SpawnSupports()
SCAPTEMPLATES = {"SQN192-1","SQN192"}
-- mainthread:StartRedAirForce()
novo = nil
may = nil
kras = nil
kob = nil
kut = nil
sen = nil
vfa192 = nil

if AIBLUECAP == true then
bradar = SET_GROUP:New()
bradar:FilterPrefixes({"Overlord","BEWR","BSAM"}):FilterActive(true):FilterStart()
bdet = DETECTION_AREAS:New(bradar,30000)
ba2adisp = AI_A2A_DISPATCHER:New(bdet)

ba2adisp:SetBorderZone(BAS)
ba2adisp:SetDefaultGrouping(2)
ba2adisp:SetDefaultFuelThreshold(0.3)
ba2adisp:SetDefaultOverhead(1.0)
ba2adisp:SetSquadron("BatumiSqn",AIRBASE.Caucasus.Batumi,BCAPTEMPLATES,math.random(4,8))
ba2adisp:SetSquadron("KutSqn",AIRBASE.Caucasus.Kutaisi,BCAPTEMPLATES,math.random(6,24))
ba2adisp:SetSquadron("KobSqn",AIRBASE.Caucasus.Kobuleti,BCAPTEMPLATES,math.random(6,24))
ba2adisp:SetSquadron("VazSqn",AIRBASE.Caucasus.Vaziani,BCAPTEMPLATES,math.random(6,32))
ba2adisp:SetDefaultTakeoffInAir()
ba2adisp:SetDefaultTakeoffInAirAltitude(100)
ba2adisp:SetDefaultLandingAtRunway()
ba2adisp:SetEngageRadius(UTILS.NMToMeters(80))
ba2adisp:SetDisengageRadius(UTILS.NMToMeters(200))
ba2adisp:SetGciRadius(UTILS.NMToMeters(50))
ba2adisp:SetSquadronCapInterval("BatumiSqn",1,(60*5),(60*15),1.0)
ba2adisp:SetSquadronCap("BatumiSqn",BCAP3,UTILS.FeetToMeters(24000),UTILS.FeetToMeters(44000),UTILS.KnotsToKmph(400),UTILS.KnotsToKmph(500),UTILS.KnotsToKmph(450),UTILS.KnotsToKmph(850),"BARO")

ba2adisp:SetSquadronCapInterval("KutSqn",1,(60*5),(60*15),1.0)
ba2adisp:SetSquadronCap("KutSqn",BCAP2,UTILS.FeetToMeters(24000),UTILS.FeetToMeters(44000),UTILS.KnotsToKmph(400),UTILS.KnotsToKmph(500),UTILS.KnotsToKmph(450),UTILS.KnotsToKmph(850),"BARO")

ba2adisp:SetSquadronCapInterval("KobSqn",1,(60*5),(60*15),1.0)
ba2adisp:SetSquadronCap("KobSqn",BCAP,UTILS.FeetToMeters(24000),UTILS.FeetToMeters(44000),UTILS.KnotsToKmph(400),UTILS.KnotsToKmph(500),UTILS.KnotsToKmph(450),UTILS.KnotsToKmph(850),"BARO")

ba2adisp:SetSquadronCapInterval("VazSqn",2,(60*5),(60*15),1.0)
ba2adisp:SetSquadronCap("VazSqn",BCAP3,UTILS.FeetToMeters(24000),UTILS.FeetToMeters(44000),UTILS.KnotsToKmph(400),UTILS.KnotsToKmph(500),UTILS.KnotsToKmph(450),UTILS.KnotsToKmph(850),"BARO")


else
  mainthread.kobsqn = spawnA2ACap("kobSqn",kob,BCAPTEMPLATES,1,math.random(12,24),BCAP,BAS,120,15000,35000,300,450,(60*2),(60*15),0.5)
  mainthread.kutsqn = spawnA2ACap("kutSqn",kut,BCAPTEMPLATES,1,math.random(12,24),BCAP2,BAS,120,15000,35000,300,450,(60*2),(60*25),0.5)
  mainthread.sensqn = spawnA2ACap("senSqn",sen,BCAPTEMPLATES,1,math.random(12,24),BCAP3,BAS,120,15000,35000,300,450,(60*2),(60*25),0.5)
  mainthread.vfa192 = spawnA2ACap("tbilisi",vfa192,BCAPTEMPLATES,2,math.random(12,24),BCAP,BAS,60,20000,45000,350,450,(60*2),(60*30),0.5)
  
end

cap1coord = ZONE:New("cap1")
cap2coord = ZONE:New("cap2")
cap3coord = ZONE:New("cap3")
rradar = SET_GROUP:New()
rradar:FilterPrefixes({"RSAM","REWR","Wizard"}):FilterActive(true):FilterStart()
rdet = DETECTION_AREAS:New(rradar,30000)
ra2adisp = AI_A2A_DISPATCHER:New(rdet)
ra2adisp:SetBorderZone(RAS)
ra2adisp:SetDefaultFuelThreshold(0.4)
ra2adisp:SetDefaultGrouping(2)
ra2adisp:SetDefaultOverhead(1.0)
ra2adisp:SetSquadron("NovoSqn",AIRBASE.Caucasus.Novorossiysk,RCAPTEMPLATES,math.random(6,32))
ra2adisp:SetSquadron("MozSqn",AIRBASE.Caucasus.Mozdok,RCAPTEMPLATES,math.random(6,24))
ra2adisp:SetSquadron("MaySqn",AIRBASE.Caucasus.Maykop_Khanskaya,RCAPTEMPLATES,math.random(6,32))
ra2adisp:SetSquadron("KrasSqn",AIRBASE.Caucasus.Krasnodar_Center,RCAPTEMPLATES,math.random(6,32))
ra2adisp:SetSquadron("SochiSqn",AIRBASE.Caucasus.Sochi_Adler,RCAPTEMPLATES,math.random(4,12))
ra2adisp:SetDefaultTakeoffInAir()
ra2adisp:SetDefaultTakeoffInAirAltitude(100)
ra2adisp:SetDefaultLandingAtRunway()
ra2adisp:SetEngageRadius(UTILS.NMToMeters(80))
ra2adisp:SetDisengageRadius(UTILS.NMToMeters(200))
ra2adisp:SetGciRadius(UTILS.NMToMeters(50))
ra2adisp:SetSquadronCapInterval("NovoSqn",1,(60*5),(60*15),1.0)
ra2adisp:SetSquadronOverhead("NovoSqn",1.5)
ra2adisp:SetSquadronCap("NovoSqn",RCAP,UTILS.FeetToMeters(14000),UTILS.FeetToMeters(34000),UTILS.KnotsToKmph(350),UTILS.KnotsToKmph(500),UTILS.KnotsToKmph(450),UTILS.KnotsToKmph(650),"BARO")
ra2adisp:SetSquadronCapRacetrack("NovoSqn",UTILS.NMToMeters(10),UTILS.NMToMeters(25),0,359,(60*15),(60*(60*1)),{cap1coord:GetRandomCoordinate(),cap2coord:GetRandomCoordinate()})
ra2adisp:SetSquadronCapInterval("MozSqn",1,(60*5),(60*15),1.0)
ra2adisp:SetSquadronCap("MozSqn",RCAP3,UTILS.FeetToMeters(14000),UTILS.FeetToMeters(34000),UTILS.KnotsToKmph(350),UTILS.KnotsToKmph(500),UTILS.KnotsToKmph(450),UTILS.KnotsToKmph(650),"BARO")
ra2adisp:SetSquadronCapRacetrack("MozSqn",UTILS.NMToMeters(10),UTILS.NMToMeters(25),0,359,(60*15),(60*(60*1)),{cap2coord:GetRandomCoordinate(),cap3coord:GetRandomCoordinate()})
ra2adisp:SetSquadronCapInterval("KrasSqn",2,(60*1),(60*1),1.0)
ra2adisp:SetSquadronCap("KrasSqn",RCAP2,UTILS.FeetToMeters(14000),UTILS.FeetToMeters(34000),UTILS.KnotsToKmph(350),UTILS.KnotsToKmph(500),UTILS.KnotsToKmph(450),UTILS.KnotsToKmph(650),"BARO")
ra2adisp:SetSquadronCapRacetrack("KrasSqn",UTILS.NMToMeters(10),UTILS.NMToMeters(25),0,359,(60*15),(60*(60*1)),{cap1coord:GetRandomCoordinate(),cap2coord:GetRandomCoordinate()})
ra2adisp:SetSquadronCap("MaySqn",RCAP2,UTILS.FeetToMeters(14000),UTILS.FeetToMeters(34000),UTILS.KnotsToKmph(350),UTILS.KnotsToKmph(500),UTILS.KnotsToKmph(450),UTILS.KnotsToKmph(650),"BARO")
ra2adisp:SetSquadronCapInterval("MaySqn",1,(60*5),(60*15),1.0)
ra2adisp:SetSquadronGci("SochiSqn",UTILS.KnotsToKmph(450),UTILS.KnotsToKmph(650))

do
  -- if russian HQ is blown up we want to set randomised radar for chaos..
  function randomradar()
    local russams = SET_GROUP:New():FilterPrefixes({"RSAM"}):FilterActive(true):FilterOnce()
    SET_GROUP:ForEachGroup(function(SetGroup) 
      local randomizer = math.random(1,100)
      if randomizer > 50 then
        SetGroup:OptionAlarmStateGreen()
      else
        SetGroup:OptionAlarmStateRed()
      end
     end)  
  end
end


SCHEDULER:New(nil,function()
  mainthread:StartUp()
  --initsams()
end,{},5)

flipflop = false

function runfactories()


end
SCHEDULER:New(nil,function()
  BASE:E({"Support and Rattack Timer go."})
  mainthread:SpawnSupports()
  if krymskcommand:IsAlive() == true then
    mainthread:RAttackers()
  else
    BASE:E("Krymskcommand is dead!")
  end
  BASE:E({"Gunships and Battack Timer go."})
  mainthread:Gunships()
  if flipflop == false then
    flipflop = true

  else
    flipflop = false
  end
end, {}, 75,(30*60))

flipflop2 = false
redairspace = 0


function reinforcesqns()
    
    if AIBLUECAP == true then
      if rdebug == true then
        BASE:E({"blue cap is on beginning reinforcements blueairsupply is:",blueairsupply})
      end
      local bamount = ba2adisp:GetSquadronAmount("BatumiSqn")
      local bresup = 0
      local kamount = ba2adisp:GetSquadronAmount("KutSqn")
      local kresup = 0
      local koamount = ba2adisp:GetSquadronAmount("KobSqn")
      local koresup = 0
      local vamount = ba2adisp:GetSquadronAmount("VazSqn")  
      if rdebug == true then
        BASE:E({"Blue Sqn Amounts are, B,Ku,Ko,Va:",bamount,kamount,koamount,vamount})
      end
      local varesup = 0
      local missing = 0
      if bamount < 8 then
        bresup = (8 - bamount)
        missing = bresup
      end
      if kamount < 24 then
        if KUTOWNER == 2 then
          kresup = (24 - kamount)
        else
          kresupt = 0
        end
        missing = kresup + missing
      end
      if koamount < 24 then
        if KOBOWNER == 2 then
          koresup = (24 - koamount)
        else
          koresup = 0
        end
        missing = koresup + missing
      end
      if vamount < 32 then
        varesup = (32 - vamount)
        missing = varesup + missing
      end
      if rdebug == true then
        BASE:E({"Blue Sqn Missing amounts Amounts are, B,Ku,Ko,Va:",bresup,kresup,koresup,varesup})
      end
      if rdebug == true then
        BASE:E({"Sqn Reinforce we are missing",missing})
      end
      if missing < blueairsupply then
        if rdebug == true then
          BASE:E({"We have more supply then what we are missing so just fill us all up"})
        end
        ba2adisp:ReinforceSquadron("BatumiSqn",bresup)
        ba2adisp:ReinforceSquadron("KobSqn",koresup)
        ba2adisp:ReinforceSquadron("KutSqn",kresup)
        ba2adisp:ReinforceSquadron("VazSqn",varesup)
        blueairsupply = blueairsupply - missing
        if rdebug == true then
          BASE:E({"blue reinforcements blueairsupply at end is:",blueairsupply})
        end
      else
        -- we need to spread out who we are reinforcing we have 4 bases so we take our 
        -- avalible blue airsupply / 4 and then spread it out.
        local supply = blueairsupply / 4
        local leftover = 0
        supply = math.floor(supply) -- round down.
        if bresup <= supply then 
          leftover = supply - bresup
          ba2adisp:ReinforceSquadron("BatumiSqn",bresup)
        else
          ba2adisp:ReinforceSquadron("BatumiSqn",supply)
        end
        if koresup <= supply then 
          leftover = (supply - koresup) + leftover
          ba2adisp:ReinforceSquadron("KobSqn",koresup)
        else
          ba2adisp:ReinforceSquadron("KobSqn",supply)
        end
        if kresup <= supply then 
          leftover = (supply - kresup) + leftover
          ba2adisp:ReinforceSquadron("KutSqn",kresup)
        else
          ba2adisp:ReinforceSquadron("KutSqn",supply)
        end
        supply = supply + leftover
        leftover = 0
        if varesup <= supply then 
          leftover = (supply - varesup)
          ba2adisp:ReinforceSquadron("KutSqn",kresup)
        else
          ba2adisp:ReinforceSquadron("KutSqn",supply)
        end
        blueairsupply = leftover
        if rdebug == true then
          BASE:E({"blue reinforcements blueairsupply at end is:",blueairsupply})
        end
      end
    end

    BASE:E({"Getting Squadron amounts if any under strength give them 4 new units if factories have made new fighters"})
    if novocommand:IsAlive() == true then
      sqn = "NovoSqn"
      BASE:E({"Novorossiysk Sqn Amount is",ra2adisp:GetSquadronAmount(sqn)})
      local _amount = ra2adisp:GetSquadronAmount(sqn)
      if _amount <= 24 then
        if redairsupply > 8 then
          local addamount = math.random(1,4)
          redairsupply = redairsupply - addamount
          ra2adisp:ReinforceSquadron(sqn,(4))
          local _amount2 = ra2adisp:GetSquadronAmount(sqn)
          MESSAGE:New("Novorossiysk CAP Sqn was just reinforced with ".. addamount .. " New Aircraft",5):ToRed()
          BASE:E({"Novorossiysk Sqn Amount after add is",ra2adisp:GetSquadronAmount(sqn)})
        else
          BASE:E({"Novorossiysk Sqn Amount after add should not have incrased as no resources avalible",ra2adisp:GetSquadronAmount(sqn)})
        end
      end
    end
    if mozcommand:IsAlive() == true then
    sqn = "MozSqn"
      BASE:E({"MozSqn Amount is",ra2adisp:GetSquadronAmount(sqn)})
      local _amount = ra2adisp:GetSquadronAmount(sqn)
      if _amount < 18 then
        if redairsupply > 8 then
          local addamount = math.random(1,4)
          redairsupply = redairsupply - addamount
          ra2adisp:ReinforceSquadron(sqn,(_amount + addamount))
          local _amount2 = ra2adisp:GetSquadronAmount(sqn)
          MESSAGE:New("Mozdok CAP Sqn was just reinforced with ".. addamount .. " New Aircraft",5):ToRed()
          BASE:E({"Moz Sqn Amount after add is",ra2adisp:GetSquadronAmount(sqn)})
        else
          BASE:E({"Moz Sqn Amount after add is should be the same as before no resources",ra2adisp:GetSquadronAmount(sqn)})
        end
     end
    end
    if maycommand:IsAlive() == true then
      sqn = "MaySqn"
      BASE:E({"Novorossiysk Sqn Amount is",ra2adisp:GetSquadronAmount(sqn)})
      local _amount = ra2adisp:GetSquadronAmount(sqn)
      if _amount < 18 then
        if redairsupply > 8 then
          local addamount = math.random(1,4)
          redairsupply = redairsupply - addamount
          ra2adisp:ReinforceSquadron(sqn,(_amount + addamount))
          local _amount2 = ra2adisp:GetSquadronAmount(sqn)
          MESSAGE:New("Maydok CAP Sqn was just reinforced with ".. addamount .. " New Aircraft",5):ToRed()
          BASE:E({"May Sqn Amount after add is",ra2adisp:GetSquadronAmount(sqn)})
        else
          BASE:E({"May Sqn Amount after add should be the same as before no resources",ra2adisp:GetSquadronAmount(sqn)})
        end
      end
    end
    if krazcommand:IsAlive() == true then
      if RSweepAmount < 8 then
        RSweepAmount = RSweepAmount + 2
      end
      sqn = "KrasSqn"
      BASE:E({"Kras Sqn Amount is",ra2adisp:GetSquadronAmount(sqn)})
      local _amount = ra2adisp:GetSquadronAmount(sqn)
      if _amount < 18 then
         if redairsupply > 8 then
          local addamount = math.random(2,4)
          redairsupply = redairsupply - addamount
          ra2adisp:ReinforceSquadron(sqn,(_amount + addamount))
          local _amount2 = ra2adisp:GetSquadronAmount(sqn)
          MESSAGE:New("Krasnador CAP Sqn was just reinforced with ".. addamount .. " New Aircraft",5):ToRed()
          BASE:E({"Kras Sqn Amount after add is",ra2adisp:GetSquadronAmount(sqn)})
        else
          BASE:E({"Kras Sqn Amount after add is should be the same as before as no new production",ra2adisp:GetSquadronAmount(sqn)})
        end
      end
      if SOCHIOWNER == 1 then
        sqn = "SochiSqn"
        BASE:E({"Sochi Sqn Amount is",ra2adisp:GetSquadronAmount(sqn)})
        local _amount = ra2adisp:GetSquadronAmount(sqn)
        if _amount < 8 then
          if redairsupply > 4 then
            local addamount = math.random(1,4)
            redairsupply = redairsupply - addamount
            ra2adisp:ReinforceSquadron(sqn,(_amount + addamount))
            local _amount2 = ra2adisp:GetSquadronAmount(sqn)
            MESSAGE:New("Sochi Adler GCI Sqn was just reinforced with ".. addamount .. " New Aircraft",5):ToRed()
            BASE:E({"Sochi Sqn Amount after add is",ra2adisp:GetSquadronAmount(sqn)})
          else
            BASE:E({"Sochi Sqn Amount after add should be the same as before as no new production",ra2adisp:GetSquadronAmount(sqn)})
          end
        end
      end
    end
end
function checkthings()
    BASE:E("Checking Command Groups")
  if novocommand:IsAlive() ~= true then
    if novo1 == 0 then
      BASE:E("NOVO Command is dead stopping sqns")
      novo1 = 1
      MESSAGE:New("Novorossiysk command has ceased to transmit, squadron is no longer active",15):ToAll()
      ra2adisp:SetSquadron("NovoSqn",AIRBASE.Caucasus.Novorossiysk,RCAPTEMPLATES,0)
      do
        if PersistedStore.NovoCommand == 1 then
          PersistedStore.NovoCommand = 0
          PersistedStore.NovoRound = nowtime
          local rbt = os.date('%A, %B %d %Y at %H:%M UTC', (nowtime + commandrebuild))
          _nc:RemoveMark(_nm)
          _nm = _nc:MarkToAll("Novorossisk Command Center, Destroyed rebuild after ".. rbt,true)
        else
          BASE:E({"NovoCommand was dead already not updating info."})
        end
      end
    --mainthread.novosqn:SpawnScheduleStop()
    end
  else
    sqn = "NovoSqn"
    BASE:E({"Novorossiysk Sqn Amount is",ra2adisp:GetSquadronAmount(sqn)})
    novosqnsize = ra2adisp:GetSquadronAmount(sqn)
  end
  if maycommand:IsAlive() ~= true then
    if may1 == 0 then
      may1 = 1 
      MESSAGE:New("Maykop command has ceased to transmit, squadrons are no longer active",15):ToAll()
      ra2adisp:SetSquadron("MaySqn",AIRBASE.Caucasus.Maykop_Khanskaya,RCAPTEMPLATES,0)
      do
        if PersistedStore.MayCommand == 1 then
          PersistedStore.MayCommand = 0
          PersistedStore.MayRound = nowtime
          local rbt = os.date('%A, %B %d %Y at %H:%M UTC', (nowtime + commandrebuild))
          _mac:RemoveMark(_mam)
          _mam = _mac:MarkToAll("Maykop Command Center, Destroyed rebuild after ".. rbt,true)
        else
          BASE:E({"MayCommand was reporting dead already not updating info."})
        end
      end
    end
    -- mainthread.maysqn:SpawnScheduleStop()
    BASE:E("MAY Command is dead stopping sqns")
  else
    sqn = "MaySqn"
    BASE:E({"Maykop Sqn Amount is",ra2adisp:GetSquadronAmount(sqn)})
    maysqnsize = ra2adisp:GetSquadronAmount(sqn)
  end
  if mozcommand:IsAlive() ~= true then
    if moz1 == 0 then
      moz1 = 1 
      MESSAGE:New("Mozdok command has ceased to transmit, squadrons are no longer active",15):ToAll()
      ra2adisp:SetSquadron("MozSqn",AIRBASE.Caucasus.Mozdok,RCAPTEMPLATES,0)
      do
        if PersistedStore.MozCommand == 1 then
          BASE:E({"Moz Command was not dead in persistence updating"})
          PersistedStore.MozCommand = 0
          PersistedStore.MozRound = nowtime
          local rbt = os.date('%A, %B %d %Y at %H:%M UTC', (nowtime + commandrebuild))
          _mc:RemoveMark(_mm)
          _mm = _mc:MarkToAll("Mozdok Command Center, Destroyed rebuild after ".. rbt,true)
        else
          BASE:E({"MozCommand was reporting dead already not updating info."})
        end
      end
    end
    -- mainthread.maysqn:SpawnScheduleStop()
    BASE:E("Moz Command is dead stopping sqns")
  else
    sqn = "MozSqn"
    BASE:E({"Moz Sqn Amount is",ra2adisp:GetSquadronAmount(sqn)})
    mozsqnsize = ra2adisp:GetSquadronAmount(sqn)
  end
  
  if krazcommand:IsAlive() ~= true then
    if kraz1 == 0 then
      kraz1 = 1
      ra2adisp:SetSquadron("KrasSqn",AIRBASE.Caucasus.Krasnodar_Center,RCAPTEMPLATES,0)
      MESSAGE:New("Krasnodar Center command has ceased to transmit, squadrons are no longer active",15):ToAll()
      do
        if PersistedStore.KrazCommand == 1 then
          PersistedStore.KrazCommand = 0
          PersistedStore.KrazRound = nowtime
           local rbt = os.date('%A, %B %d %Y at %H:%M UTC', (nowtime + commandrebuild))
          _kc:RemoveMark(_km)
          _km = _km:MarkToAll("Krasnodar Command Center, Destroyed rebuild after ".. rbt,true)
        else
          BASE:E({"KrasCommand was reporting dead already not updating info."})
        end
      end
      --mainthread.krassqn:SpawnScheduleStop()
    end
    BASE:E("Kraz Command is dead stopping sqns")
   else
    sqn = "KrasSqn"
    BASE:E({"Kras Sqn Amount is",ra2adisp:GetSquadronAmount(sqn)})
    krazsqnsize = ra2adisp:GetSquadronAmount(sqn)
  end
  sqn = "SochiSqn"
  BASE:E({"Sochi Sqn Amount is",ra2adisp:GetSquadronAmount(sqn)})
  sochisqnsize = ra2adisp:GetSquadronAmount(sqn)
  
  if RedHq:IsAlive() ~= true then
    BASE:E("Red HQ Dead")
    if flipflop == false then
      if flipflop2 == false then
        flipflop2 = true
        randomradar()
      end
    else
      flipflop2 = false
    end
  end
  BASE:E("Done checking Command Groups")
  BASE:E("Checking our Red Air Space items")
  do
  local abase = AIRBASE:FindByName(AIRBASE.Caucasus.Sukhumi_Babushara)
  local abcol = abase:GetCoalition()
  if abcol == 1 then
    if redairspace ~= 0 then
      ra2adisp:SetBorderZone(RAS2)
      if AIBLUECAP == true then
      ba2adisp:SetBorderZone(BAS)
      end
      redairspace = 0
      BASE:E("Red controls Suk so setting Border to extend past it")
    else
      BASE:E("Red controls Suk Border is already correct")
    end
  elseif abcol == 2 then
    local abase2 = AIRBASE:FindByName(AIRBASE.Caucasus.Gudauta)
    local abcol2 = abase2:GetCoalition()
    if abcol2 == 1 then 
      if redairspace ~= 1 then
        ra2adisp:SetBorderZone(RAS1)
        if AIBLUECAP == true then
        ba2adisp:SetBorderZone(BAS1)
        end
        redairspace = 1
        BASE:E("Red controls Gud but not suk Border is extended to just beyond Gud")
      else
        BASE:E("Red controls Gud but not suk Border is already correct")
      end
    else
      if redairspace ~= 2 then
        ra2adisp:SetBorderZone(RAS)
        if AIBLUECAP == true then
          ba2adisp:SetBorderZone(BAS1)
        end
        redairspace = 2
        BASE:E("Red controls neither of them border set to 3")
      else
        BASE:E("Red controls neither airfield but is already correct")
      end
    end
  end
  end
end

SCHEDULER:New(nil,function() 
  BASE:E({"CHECKING THINGS"})
  checkthings()
end,{},60,(5*60))

function invasion()
  rangers = GROUP:FindByName("Rangers")
  chinooks = GROUP:FindByName("Chinooks")
  if rangers:IsActive() ~= true then
    rangers:Activate()
    BCC:MessageToCoalition("Ranger 1 active")
  else
      BCC:MessageToCoalition("Ranger 1 already active")
  end
  if chinooks:IsActive() ~= true then 
    chinooks:Activate()
    BCC:MessageToCoalition("Whipit 1 now activating, Whipit 1 will be on 251")
  else
      BCC:MessageToCoalition("Whipit 1 already active")
  end
end
function spawnbaicap()
  if BSweepAmount > 0 then
    BCC:MessageToCoalition("Ukranian SU27's are readying should be airborne in 5 minutes")
    BAICAPSpawn:Spawn()
  else
    BCC:MessageToCoalition("Unable, we don't have any fighters left!")
  end
end

function spawnraicap()
  if RSweepAmount > 0 then
    RCC:MessageToCoalition("SU27's are readying should be airborne in 5 minutes")
    RAICAPSpawn:Spawn()
  else
    RCC:MessageToCoalition("Unable, we don't have any fighters left!")
  end
end

function rservertime()
message = "Current Server time is: ".. nowHour .. ":" .. nowminute .."\n Mission Restart Time: restart time:".. restarttime .. "" 
MESSAGE:New(message,10):ToRed()
end
function bservertime()
message = "Current Server time is: ".. nowHour .. ":" .. nowminute .."\n Mission Restart Time: restart time:".. restarttime .. "" 
MESSAGE:New(message,10):ToBlue()
end

function cservertime(grp)
message = "Current Server time is: ".. nowHour .. ":" .. nowminute .."\n Mission Restart Time: restart time:".. restarttime .. "" 
MESSAGE:New(message,10):ToGroup(grp)
end

r_ribmenu = MENU_COALITION:New(coalition.side.RED,"Red Ibera Controls/Information")
rinvasionmenu = MENU_COALITION:New(coalition.side.RED,"Ai Control",r_ribmenu)
rbriefing = MENU_COALITION_COMMAND:New(coalition.side.RED,"Current Objectives",r_ribmenu,_redobject)
rcommsm = MENU_COALITION_COMMAND:New(coalition.side.RED,"Comms Freqs",r_ribmenu,_redcomms)
rcapm = MENU_COALITION_COMMAND:New(coalition.side.RED,"Request Fighter Sweep over A.O",rinvasionmenu,spawnraicap)
rservertime = MENU_COALITION_COMMAND:New(coalition.side.RED,"Current Time",r_ribmenu,rservertime)
b_ribmenu = MENU_COALITION:New(coalition.side.BLUE,"Red Ibera Controls/Information")
bbriefing = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Current Objectives",b_ribmenu,_blueobject)
bcommsm = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Comm Freqs",b_ribmenu,_bluecomms)
bservertime = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Current Time",b_ribmenu,bservertime)
invasionmenu = MENU_COALITION:New(coalition.side.BLUE, "Ai Control",b_ribmenu)
bcapm = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Request Ukraine C.A.P over A.O",invasionmenu,spawnbaicap)
invasionm = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Request Ranger Assault on Sukhimi",invasionmenu,invasion)

local function mudhenCooldownHelp()
  BCC:MessageToCoalition(string.format("Su-27s commands are now available again. Use the following marker commands:\n-cap route\n-cap patrol\n-cap refuel \nor you can add extra information for finer control \n-cap <command> ,h <0-360>,d <0-150>,a <1-50>,s <250-850> \nFor more control"), MESSAGE.Type.Information)
end


local function handleCAPRequest(text, coord)
  local currentTime = os.time()
  local cooldown = currentTime - F15_Timer
  if text:find("roe") then
    if text:find("free") then
      BAICAP:OptionROEWeaponFree()
      BCC:MessageTypeToCoalition(string.format("Uzi 8 Rules of Engagement set to Weapons Free.\nOther Requests will be available again in %d minutes", (F15_COOLDOWN - cooldown) / 60), MESSAGE.Type.Information)
    elseif text:find("rf") then
      BAICAP:OptionROEReturnFire()
      BCC:MessageTypeToCoalition(string.format("Uzi 8 Rules of Engagement set to Return Fire.\nOther Requests will be available again in %d minutes", (F15_COOLDOWN - cooldown) / 60), MESSAGE.Type.Information)
    else
      BAICAP:OptionROEHoldFire()
      BCC:MessageTypeToCoalition(string.format("Uzi 8 Rules of Engagement set to Hold Fire.\nOther Requests will be available again in %d minutes", (F15_COOLDOWN - cooldown) / 60), MESSAGE.Type.Information)
    end
    return
  end
  
  if (cooldown < F15_COOLDOWN) and (text:find("route") == true or text:find("patrol") == true or text:find("refuel") == true) then 
     BCC:MessageTypeToCoalition(string.format("Uzi 8 Requests are not available at this time.\nRequests will be available again in %d minutes", (F15_COOLDOWN - cooldown) / 60), MESSAGE.Type.Information)
     return
  end
  if BAICAP:IsAlive() ~= true and BSweepAmount == 0 then
      BCC:MessageTypeToCoalition(string.format("Ukrainian Command Command is still awaiting reinforcements and are unable to task any further CAP then what is allocated."), MESSAGE.Type.Information)
     return
  end
  local keywords=_split(text, ",")
  local heading = nil
  local distance = nil
  local endcoord = nil
  local endpoint = false
  local altitude = nil
  local altft = nil
  local spknt = nil
  local speed = nil
  local engage = nil
  local capname = ""
  local routetask = nil
  BASE:E({keywords=keywords})
  for _,keyphrase in pairs(keywords) do
    local str=_split(keyphrase, " ")
    local key=str[1]
    local val=str[2]
    BASE:E(string.format("%s, keyphrase = %s, key = %s, val = %s", "route", tostring(keyphrase), tostring(key), tostring(val)))
    if key:lower():find("h") then
      heading = tonumber(val)
      -- BASE:E({"Tanker Movement we have heading",heading})
    end
    if key:lower():find("d") then
      distance = tonumber(val)
      -- BASE:E({"Tanker Movement we have distance",distance})
    end
    if key:lower():find("a") then
      altitude = tonumber(val)
      -- BASE:E({"Tanker Movement we have altitude ",altitude})
    end
    if key:lower():find("s") then
      speed = tonumber(val)
      -- BASE:E({"Tanker Movement we have speed",speed})
    end
    if key:lower():find("e") then
      engage = tonumber(val)
    end
  end
  if engage == nil then
    engage = 25
  elseif engage < 1 then 
    engage = 1
  elseif engage > 180 then
    engage = 180
  end
  if altitude == nil then
     altft = 23000
     altitude = UTILS.FeetToMeters(23000)
  else
  if altitude > 50 then
     altitude = 50
  elseif altitude < 1 then
     altitude = 1
  end
     altft = altitude
     altitude = UTILS.FeetToMeters((altitude * 1000))
  end
  if speed == nil then
     spknt = 400
     speed = UTILS.KnotsToMps(400)
  else
     if speed > 850 then
        speed = 850
     elseif speed < 150 then
        speed = 150
     end
       spknt = speed
       speed = UTILS.KnotsToMps(speed)
     end  
     if heading ~= nil then 
      if heading < 0 then
           heading = 0
      elseif heading > 360 then
           heading = 360
      end
      if distance ~= nil then
        if distance > 150 then
          distance = 150
        end
        if distance < 0 then
           distance = 0
        end
          endcoord = coord:Translate(UTILS.NMToMeters(distance),heading)
       else
          endcoord = coord:Translate(UTILS.NMToMeters(25),heading)
          distance = 0
        end
      else
         heading = math.random(0,360)
         endcoord = coord:Translate(UTILS.NMToMeters(25),heading)
         distance = 0
      end
  local task = ""
   local ertask = BAICAP:EnRouteTaskEngageTargets(UTILS.NMToMeters(engage),{"Air","Missile"},1)
  if text:find("route") then
    if distance == 0 then
      routetask = BAICAP:TaskOrbit(coord,altitude,speed)
      task = "CAP, Move and Hold at assigned Location"
    else
      routetask = BAICAP:TaskOrbit(coord,altitude,speed,endcoord)
      task = "CAP, Move and Hold in a RaceTrack at assigned Location"
    end
    F15_Timer = currentTime
    if BAICAP:IsActive() ~= true or BAICAP:IsAlive() ~= true or BAICAP:AllOnGround() == true then
      BAICAPSpawn:Spawn()
      SCHEDULER:New(nil,function() 
        BAICAP:SetTask(routetask, 2)
        BAICAP:PushTask(ertask,4)
        BAICAP:OptionROTEvadeFire()
        BCC:MessageTypeToCoalition( string.format("%s 2xSU27's are being scrambled and then re-routed to the player requested destination and task: %s.\nNew Orders can be issued in: %d minutes cooldown starting now", BAICAP:GetName(), task, F15_COOLDOWN / 60), MESSAGE.Type.Information )      
        SCHEDULER:New(nil, mudhenCooldownHelp, {}, F15_COOLDOWN)
      end,{},20)
    else
      BAICAP:OptionROTEvadeFire()
      BAICAP:SetTask(routetask,2)
      BAICAP:PushTask(ertask,4)
      BCC:MessageTypeToCoalition( string.format("%s 2xSU27's are re-routed to the player requested destination and task: %s.\nNew Orders can be issued in: %d minutes cooldown starting now", BAICAP:GetName(), task, F15_COOLDOWN / 60), MESSAGE.Type.Information )      
      SCHEDULER:New(nil, mudhenCooldownHelp, {}, F15_COOLDOWN)
    end
  elseif text:find("patrol") then
    routetask = BAICAP:TaskOrbit(BAICAP:GetCoordinate(),altitude,speed,coord)
    task = "CAP, Patrol between current and assigned Location"
    F15_Timer = currentTime
    if BAICAP:IsActive() ~= true or BAICAP:IsAlive() ~= true or BAICAP:AllOnGround() == true then
      BAICAPSpawn:Spawn()
      SCHEDULER:New(nil,function() 
        BAICAP:SetTask(routetask, 2)
        BAICAP:PushTask(ertask,4)
        BAICAP:OptionROTEvadeFire()
        BCC:MessageTypeToCoalition( string.format("%s 2xSU27's are being scrambled and then re-routed to the player requested destination and task: %s.\nNew Orders can be issued in: %d minutes cooldown starting now", BAICAP:GetName(), task, F15_COOLDOWN / 60), MESSAGE.Type.Information )      
        SCHEDULER:New(nil, mudhenCooldownHelp, {}, F15_COOLDOWN)
      end,{},20)
    else
      BAICAP:OptionROTEvadeFire()
      BAICAP:SetTask(routetask,2)
      BAICAP:PushTask(ertask,4)
      BCC:MessageTypeToCoalition( string.format("%s 2xSU27's are re-routed to the player requested destination and task: %s.\nNew Orders can be issued in: %d minutes cooldown starting now", BAICAP:GetName(), task, F15_COOLDOWN / 60), MESSAGE.Type.Information )      
      SCHEDULER:New(nil, mudhenCooldownHelp, {}, F15_COOLDOWN)
    end    
  elseif text:find("refuel") then
    routetask = {}
      routetask[1] = BAICAP:TaskRefueling()
      routetask[2] = BAICAP:TaskOrbit(coord,altitude,speed)
    task = "CAP, Air to Air Refuel"
    F15_Timer = currentTime
    if BAICAP:IsActive() ~= true or BAICAP:IsAlive() ~= true or BAICAP:AllOnGround() == true then
      BAICAPSpawn:Spawn()
      SCHEDULER:New(nil,function() 
        BAICAP:SetTask(BAICAP:TaskCombo(routetask),2)
        BAICAP:PushTask(ertask,4)
        BAICAP:OptionROTEvadeFire()
        BCC:MessageTypeToCoalition( string.format("%s 2xSU27's are being scrambled and then re-routed to the player requested destination and task: %s.\nNew Orders can be issued in: %d minutes cooldown starting now", BAICAP:GetName(), task, F15_COOLDOWN / 60), MESSAGE.Type.Information )      
        SCHEDULER:New(nil, mudhenCooldownHelp, {}, F15_COOLDOWN)
      end,{},20)
    else
      BAICAP:OptionROTEvadeFire()
      BAICAP:SetTask(BAICAP:TaskCombo(routetask),2)
      BAICAP:PushTask(ertask,4)
      BCC:MessageTypeToCoalition( string.format("%s 2xSU27's are re-routed to the player requested destination and task: %s.\nNew Orders can be issued in: %d minutes cooldown starting now", BAICAP:GetName(), task, F15_COOLDOWN / 60), MESSAGE.Type.Information )      
      SCHEDULER:New(nil, mudhenCooldownHelp, {}, F15_COOLDOWN)
    end
   else
    BCC:MessageTypeToCoalition( string.format("%s No valid commands were entered, Please check your commands and try again", BAICAP:GetName()), MESSAGE.Type.Information )
  end
end


--- Red cap handle request
-- 
-- 
-- 
local function handleRedCAPRequest(text, coord)
  local currentTime = os.time()
  local cooldown = currentTime - SU27_Timer
  if text:find("roe") then
    if text:find("free") then
      RAICAP:OptionROEWeaponFree()
      RCC:MessageTypeToCoalition(string.format("Silence 1 Rules of Engagement set to Weapons Free.\nOther Requests will be available again in %d minutes", (SU27_COOLDOWN - cooldown) / 60), MESSAGE.Type.Information)
    elseif text:find("rf") then
      RAICAP:OptionROEReturnFire()
      RCC:MessageTypeToCoalition(string.format("Silence 1 Rules of Engagement set to Return Fire.\nOther Requests will be available again in %d minutes", (SU27_COOLDOWN - cooldown) / 60), MESSAGE.Type.Information)
    else
      RAICAP:OptionROEHoldFire()
      RCC:MessageTypeToCoalition(string.format("Silence 1 Rules of Engagement set to Hold Fire.\nOther Requests will be available again in %d minutes", (SU27_COOLDOWN - cooldown) / 60), MESSAGE.Type.Information)
    end
    return
  end
  
  if (cooldown < SU27_COOLDOWN) and (text:find("route") == true or text:find("patrol") == true or text:find("refuel") == true) then 
     RCC:MessageTypeToCoalition(string.format("Silence 1 Requests are not available at this time.\nRequests will be available again in %d minutes", (SU27_COOLDOWN - cooldown) / 60), MESSAGE.Type.Information)
     return
  end
  if RAICAP:IsAlive() ~= true and RSweepAmount == 0 then
      RCC:MessageTypeToCoalition(string.format("Command is still awaiting reinforcements and are unable to task any further CAP then what is allocated."), MESSAGE.Type.Information)
     return
  end
  local keywords=_split(text, ",")
  local heading = nil
  local distance = nil
  local endcoord = nil
  local endpoint = false
  local altitude = nil
  local altft = nil
  local spknt = nil
  local speed = nil
  local engage = nil
  local capname = ""
  local routetask = nil
  BASE:E({keywords=keywords})
  for _,keyphrase in pairs(keywords) do
    local str=_split(keyphrase, " ")
    local key=str[1]
    local val=str[2]
    BASE:E(string.format("%s, keyphrase = %s, key = %s, val = %s", "route", tostring(keyphrase), tostring(key), tostring(val)))
    if key:lower():find("h") then
      heading = tonumber(val)
      -- BASE:E({"Tanker Movement we have heading",heading})
    end
    if key:lower():find("d") then
      distance = tonumber(val)
      -- BASE:E({"Tanker Movement we have distance",distance})
    end
    if key:lower():find("a") then
      altitude = tonumber(val)
      -- BASE:E({"Tanker Movement we have altitude ",altitude})
    end
    if key:lower():find("s") then
      speed = tonumber(val)
      -- BASE:E({"Tanker Movement we have speed",speed})
    end
    if key:lower():find("e") then
      engage = tonumber(val)
    end
  end
  if engage == nil then
    engage = 25
  elseif engage < 1 then 
    engage = 1
  elseif engage > 180 then
    engage = 180
  end
  if altitude == nil then
     altft = 23000
     altitude = UTILS.FeetToMeters(23000)
  else
  if altitude > 50 then
     altitude = 50
  elseif altitude < 1 then
     altitude = 1
  end
     altft = altitude
     altitude = UTILS.FeetToMeters((altitude * 1000))
  end
  if speed == nil then
     spknt = 400
     speed = UTILS.KnotsToMps(400)
  else
     if speed > 850 then
        speed = 850
     elseif speed < 150 then
        speed = 150
     end
       spknt = speed
       speed = UTILS.KnotsToMps(speed)
     end  
     if heading ~= nil then 
      if heading < 0 then
           heading = 0
      elseif heading > 360 then
           heading = 360
      end
      if distance ~= nil then
        if distance > 150 then
          distance = 150
        end
        if distance < 0 then
           distance = 0
        end
          endcoord = coord:Translate(UTILS.NMToMeters(distance),heading)
       else
          endcoord = coord:Translate(UTILS.NMToMeters(25),heading)
          distance = 0
        end
      else
         heading = math.random(0,360)
         endcoord = coord:Translate(UTILS.NMToMeters(25),heading)
         distance = 0
      end
  local task = ""
   local ertask = RAICAP:EnRouteTaskEngageTargets(UTILS.NMToMeters(engage),{"Air","Missile"},1)
  if text:find("route") then
    if distance == 0 then
      routetask = RAICAP:TaskOrbit(coord,altitude,speed)
      task = "CAP, Move and Hold at assigned Location"
    else
      routetask = RAICAP:TaskOrbit(coord,altitude,speed,endcoord)
      task = "CAP, Move and Hold in a RaceTrack at assigned Location"
    end
    F15_Timer = currentTime
    if RAICAP:IsActive() ~= true or RAICAP:IsAlive() ~= true or RAICAP:AllOnGround() == true then
      RAICAPSpawn:Spawn()
      SCHEDULER:New(nil,function() 
        RAICAP:SetTask(routetask, 2)
        RAICAP:PushTask(ertask,4)
        RAICAP:OptionROTEvadeFire()
        RCC:MessageTypeToCoalition( string.format("%s 2xSU27's are being scrambled and then re-routed to the player requested destination and task: %s.\nNew Orders can be issued in: %d minutes cooldown starting now", RAICAP:GetName(), task, SU27_COOLDOWN / 60), MESSAGE.Type.Information )      
        SCHEDULER:New(nil, mudhenCooldownHelp, {}, SU27_COOLDOWN)
      end,{},20)
    else
      RAICAP:OptionROTEvadeFire()
      RAICAP:SetTask(routetask,2)
      RAICAP:PushTask(ertask,4)
      RCC:MessageTypeToCoalition( string.format("%s 2xSU27's are re-routed to the player requested destination and task: %s.\nNew Orders can be issued in: %d minutes cooldown starting now", RAICAP:GetName(), task, SU27_COOLDOWN / 60), MESSAGE.Type.Information )      
      SCHEDULER:New(nil, mudhenCooldownHelp, {}, SU27_COOLDOWN)
    end
  elseif text:find("patrol") then
    routetask = RAICAP:TaskOrbit(RAICAP:GetCoordinate(),altitude,speed,coord)
    task = "CAP, Patrol between current and assigned Location"
    SU27_Timer = currentTime
    if RAICAP:IsActive() ~= true or RAICAP:IsAlive() ~= true or RAICAP:AllOnGround() == true then
      RAICAPSpawn:Spawn()
      SCHEDULER:New(nil,function() 
        RAICAP:SetTask(routetask, 2)
        RAICAP:PushTask(ertask,4)
        RAICAP:OptionROTEvadeFire()
        RCC:MessageTypeToCoalition( string.format("%s 2xSU27's are being scrambled and then re-routed to the player requested destination and task: %s.\nNew Orders can be issued in: %d minutes cooldown starting now", RAICAP:GetName(), task, SU27_COOLDOWN / 60), MESSAGE.Type.Information )      
        SCHEDULER:New(nil, mudhenCooldownHelp, {}, SU27_COOLDOWN)
      end,{},20)
    else
      RAICAP:OptionROTEvadeFire()
      RAICAP:SetTask(routetask,2)
      RAICAP:PushTask(ertask,4)
      RCC:MessageTypeToCoalition( string.format("%s 2xSU27's are re-routed to the player requested destination and task: %s.\nNew Orders can be issued in: %d minutes cooldown starting now", RAICAP:GetName(), task, SU27_COOLDOWN / 60), MESSAGE.Type.Information )      
      SCHEDULER:New(nil, mudhenCooldownHelp, {}, SU27_COOLDOWN)
    end    
  elseif text:find("refuel") then
    routetask = {}
      routetask[1] = RAICAP:TaskRefueling()
      routetask[2] = RAICAP:TaskOrbit(coord,altitude,speed)
    task = "CAP, Air to Air Refuel"
    SU27_Timer = currentTime
    if RAICAP:IsActive() ~= true or RAICAP:IsAlive() ~= true or RAICAP:AllOnGround() == true then
      RAICAPSpawn:Spawn()
      SCHEDULER:New(nil,function() 
        RAICAP:SetTask(RAICAP:TaskCombo(routetask),2)
        RAICAP:PushTask(ertask,4)
        RAICAP:OptionROTEvadeFire()
        RCC:MessageTypeToCoalition( string.format("%s 2xSU27's are being scrambled and then re-routed to the player requested destination and task: %s.\nNew Orders can be issued in: %d minutes cooldown starting now", RAICAP:GetName(), task, SU27_COOLDOWN / 60), MESSAGE.Type.Information )      
        SCHEDULER:New(nil, mudhenCooldownHelp, {}, SU27_COOLDOWN)
      end,{},20)
    else
      RAICAP:OptionROTEvadeFire()
      RAICAP:SetTask(RAICAP:TaskCombo(routetask),2)
      RAICAP:PushTask(ertask,4)
      RCC:MessageTypeToCoalition( string.format("%s 2xSU27's are re-routed to the player requested destination and task: %s.\nNew Orders can be issued in: %d minutes cooldown starting now", RAICAP:GetName(), task, SU27_COOLDOWN / 60), MESSAGE.Type.Information )      
      SCHEDULER:New(nil, mudhenCooldownHelp, {}, SU27_COOLDOWN)
    end
   else
    RCC:MessageTypeToCoalition( string.format("%s No valid commands were entered, Please check your commands and try again", RAICAP:GetName()), MESSAGE.Type.Information )
  end
end



local function handleWeatherRequest(text, coord, red)
    local currentPressure = coord:GetPressure(0)
    local currentTemperature = coord:GetTemperature()
    local currentWindDirection, currentWindStrengh = coord:GetWind()
    local currentWindDirection1, currentWindStrength1 = coord:GetWind(UTILS.FeetToMeters(1000))
    local currentWindDirection2, currentWindStrength2 = coord:GetWind(UTILS.FeetToMeters(2000))
    local currentWindDirection5, currentWindStrength5 = coord:GetWind(UTILS.FeetToMeters(5000))
    local currentWindDirection10, currentWindStrength10 = coord:GetWind(UTILS.FeetToMeters(10000))
    local weatherString = string.format("Requested weather: Wind from %d@%.1fkts, QNH %.2f, Temperature %d", currentWindDirection, UTILS.MpsToKnots(currentWindStrengh), currentPressure * 0.0295299830714, currentTemperature)
    local weatherString1 = string.format("Wind 1,000ft: Wind from%d@%.1fkts",currentWindDirection1, UTILS.MpsToKnots(currentWindStrength1))
    local weatherString2 = string.format("Wind 2,000ft: Wind from%d@%.1fkts",currentWindDirection2, UTILS.MpsToKnots(currentWindStrength2))
    local weatherString5 = string.format("Wind 5,000ft: Wind from%d@%.1fkts",currentWindDirection5, UTILS.MpsToKnots(currentWindStrength5))
    local weatherString10 = string.format("Wind 10,000ft: Wind from%d@%.1fkts",currentWindDirection10, UTILS.MpsToKnots(currentWindStrength10))
    if red == false then
    BCC:MessageTypeToCoalition(weatherString, MESSAGE.Type.Information)
    BCC:MessageTypeToCoalition(weatherString1, MESSAGE.Type.Information)
    BCC:MessageTypeToCoalition(weatherString2, MESSAGE.Type.Information)
    BCC:MessageTypeToCoalition(weatherString5, MESSAGE.Type.Information)
    BCC:MessageTypeToCoalition(weatherString10, MESSAGE.Type.Information)
    else
    RCC:MessageTypeToCoalition(weatherString, MESSAGE.Type.Information)
    RCC:MessageTypeToCoalition(weatherString1, MESSAGE.Type.Information)
    RCC:MessageTypeToCoalition(weatherString2, MESSAGE.Type.Information)
    RCC:MessageTypeToCoalition(weatherString5, MESSAGE.Type.Information)
    RCC:MessageTypeToCoalition(weatherString10, MESSAGE.Type.Information)
    end
end

local function afacCooldownHelp(afacname)
  BCC:MessageToCoalition(string.format("AFAC routing is now available again. Use the following marker commands:\n-afac route %s \nor \n-afac route %s ,h <0-360>,d <0-25>,a <1-20,000>,s <90-150> \nFor more control",afacname,afacname,afacname), MESSAGE.Type.Information)
end
local function tankerCooldownHelp(tankername)
  BCC:MessageToCoalition(string.format("Tanker routing is now available again for %s. Use the following marker commands:\n-tanker route %s \n-tanker route %s ,h <0-360>,d <5-100>,a <10-30,000>,s <250-400> \nFor more control",tankername,tankername,tankername), MESSAGE.Type.Information)
end
local function rtankerCooldownHelp(tankername)
  RCC:MessageToCoalition(string.format("Tanker routing is now available again for %s. Use the following marker commands:\n-tanker route %s \n-tanker route %s ,h <0-360>,d <5-100>,a <10-30,000>,s <250-400> \nFor more control",tankername,tankername,tankername), MESSAGE.Type.Information)
end
local function handleRedTankerRequest(text,coord)
  local currentTime = os.time()
  if text:find("route") then
        local keywords=_split(text, ",")
        local heading = nil
        local distance = nil
        local endcoord = nil
        local endpoint = false
        local altitude = nil
        local altft = nil
        local spknt = nil
        local speed = nil
        local tankername = ""
        BASE:E({keywords=keywords})
        for _,keyphrase in pairs(keywords) do
          local str=_split(keyphrase, " ")
          local key=str[1]
          local val=str[2]
          -- BASE:E(string.format("%s, keyphrase = %s, key = %s, val = %s", "route", tostring(keyphrase), tostring(key), tostring(val)))
          if key:lower():find("h") then
            heading = tonumber(val)
            -- BASE:E({"Tanker Movement we have heading",heading})
          end
          if key:lower():find("d") then
            distance = tonumber(val)
            -- BASE:E({"Tanker Movement we have distance",distance})
          end
          if key:lower():find("a") then
            altitude = tonumber(val)
            -- BASE:E({"Tanker Movement we have altitude ",altitude})
          end
          if key:lower():find("s") then
            speed = tonumber(val)
            -- BASE:E({"Tanker Movement we have speed",speed})
          end
        end
        local tanker = nil
        -- find our tanker
        if text:find("arco") or text:find("arc") then
            local tankername = "ARCO"
            local cooldown = currentTime - ARC2_Timer
              if cooldown < TANKER_COOLDOWN then 
                RCC:MessageTypeToCoalition(string.format("ARCO Tanker Requests are not available at this time.\nRequests will be available again in %d minutes", (TANKER_COOLDOWN - cooldown) / 60), MESSAGE.Type.Information)
              return
            end
            tanker = mainthread.REDTNKR
            if tanker:IsAlive() ~= true then
              RCC:MessageTypeToCoalition("ARCO is currently not avalible for tasking, it's M.I.A",MESSAGE.Type.Information)
              return
            end
            ARC2_Timer = currentTime
        elseif text:find("shell") or text:find("shl") then
          local tankername = "SHELL"
          local cooldown = currentTime - RSHEL2_Timer
          if cooldown < TANKER_COOLDOWN then
             RCC:MessageTypeToCoalition(string.format("SHELL Tanker Requests are not available at this time.\nRequests will be available again in %d minutes", (TANKER_COOLDOWN - cooldown) / 60), MESSAGE.Type.Information)
             return
          end
          tanker = mainthread.REDTNKR2
            if tanker:IsAlive() ~= true then
              RCC:MessageTypeToCoalition("SHELL is currently not avalible for tasking, it's M.I.A",MESSAGE.Type.Information)
              return
            end
            RSHEL2_Timer = currentTime
        end
        if altitude == nil then
           altft = 19000
           altitude = UTILS.FeetToMeters(19000)
        else
           if altitude > 30000 then
             altitude = 30000
           elseif altitude < 10000 then
             altitude = 10000
           end
           altft = altitude
           altitude = UTILS.FeetToMeters(altitude)
         end
         if speed == nil then
            spknt = 370
            speed = UTILS.KnotsToMps(370)
         else
            if speed > 450 then
              speed = 450
            elseif speed < 250 then
              speed = 250
            end
            spknt = speed
            speed = UTILS.KnotsToMps(speed)
         end  
        if heading ~= nil then 
          if heading < 0 then
            heading = 0
          elseif heading > 360 then
            heading = 360
          end
          if distance ~= nil then
            if distance > 100 then
              distance = 100
            end
            if distance < 5 then
              distance = 5
            end
            endcoord = coord:Translate(UTILS.NMToMeters(distance),heading)
          else
            endcoord = coord:Translate(UTILS.NMToMeters(25),heading)
            distance = 25
          end
        else
          heading = math.random(0,360)
          endcoord = coord:Translate(UTILS.NMToMeters(25),heading)
          distance = 25
        end
        tanker:ClearTasks()
        local routeTask = tanker:TaskOrbit( coord, altitude,  speed, endcoord )
        tanker:SetTask(routeTask, 2)
        local tankerTask = tanker:EnRouteTaskTanker()
        tanker:PushTask(tankerTask, 4)
        RCC:MessageTypeToCoalition( string.format("%s Tanker is re-routed to the player requested destination.\nIt will orbit on a heading of %d for %d nm, Alt: %d Gnd Speed %d.\n%d minutes cooldown starting now", tanker:GetName(),heading,distance,altft,spknt, TANKER_COOLDOWN / 60), MESSAGE.Type.Information )      
        SCHEDULER:New(nil, rtankerCooldownHelp, {tankername}, TANKER_COOLDOWN)
    end
end

local function handleRemoveRequest(text,coord)
  local currentTime = os.time()
  if text:find("red1") then
    mainthread:DestroyGround("red1") 
  elseif text:find("red2") then
    mainthread:DestroyGround("red2")
  elseif text:find("red3") then
    mainthread:DestroyGround("red3")
  elseif text:find("blue1") then
    mainthread:DestroyGround("blue1")
  elseif text:find("blue2") then
    mainthread:DestroyGround("blue2")
  elseif text:find("blue3") then
    mainthread:DestroyGround("blue3")
  end
end  
local function handleStateRequest(text,coord)
  BASE:E({"State Request",text,coord})
  local currentTime = os.time()
  local keywords=_split(text, ",")
  local statem = nil
  BASE:E({"Spawn Request",text,coord})
  local currentTime = os.time()
  local keywords=_split(text, ",")
  local statem = nil
  BASE:E({keywords=keywords})
  for _,keyphrase in pairs(keywords) do
    local str=_split(keyphrase, " ")
    local key=str[1]
    local val=str[2]
    -- BASE:E(string.format("%s, keyphrase = %s, key = %s, val = %s", "route", tostring(keyphrase), tostring(key), tostring(val)))
    if key:lower():find("s") then
      statem = tonumber(val)
    end
  end
  if text:find("red1") then
    if mainthread.RedArmy ~= nil then
       if statem > -1 and statem < 11 then
          mainthread.RedArmyState = statem
       else
            mainthread.RedArmyState = 10
        end
    end
    mainthread:RedArmyTick(2000,3000,false)
  elseif text:find("red2") then
    if mainthread.RedArmy1 ~= nil then
       if statem > -1 and statem < 11 then
          mainthread.RedArmy1State = statem
       else
            mainthread.RedArmy1State = 10
        end
    end
    mainthread:RedArmy1Tick(2000,3000,false)
  elseif text:find("red3") then
    if mainthread.RedArmy2 ~= nil then
       if statem > -1 and statem < 11 then
          mainthread.RedArmy2State = statem
       else
            mainthread.RedArmy2State = 10
        end
    end
    mainthread:RedArmy2Tick(2000,3000,true)
  elseif text:find("blue1") then
    if mainthread.BluArmy ~= nil then
       if statem > -1 and statem < 11 then
          mainthread.BluArmyState = statem
       else
            mainthread.BluArmyState = 10
        end
    end
    mainthread:BlueArmyTick(2000,3000,false)
  elseif text:find("blue2") then
    if mainthread.BluArmy1 ~= nil then
       if statem > -1 and statem < 11 then
          mainthread.BluArmy1State = statem
       else
           mainthread.BluArmy1State = 10
        end
    end
    mainthread:BlueArmy2Tick(2000,3000,false)
  elseif text:find("blue3") then
    if mainthread.BluArmy2 ~= nil then
       if statem > -1 and statem < 11 then
          mainthread.BluArmy2State = statem
       else
            mainthread.BluArmy2State = 10
        end
    end
    if blue2active == true then
      mainthread:BlueArmy2Tick(2000,3000,true)
    else
      MESSAGE:New("Blue 2 Is not active at the current time",15):ToAll()
    end
  end
end
local function handleSpawnRequest(text,coord)
  BASE:E({"Spawn Request",text,coord})
  local currentTime = os.time()
  local keywords=_split(text, ",")
  local statem = nil
  BASE:E({keywords=keywords})
  for _,keyphrase in pairs(keywords) do
    local str=_split(keyphrase, " ")
    local key=str[1]
    local val=str[2]
    -- BASE:E(string.format("%s, keyphrase = %s, key = %s, val = %s", "route", tostring(keyphrase), tostring(key), tostring(val)))
    if key:lower():find("s") then
      statem = tonumber(val)
    end
  end
  if text:find("red1") then
    if mainthread.RedArmy ~= nil then
      mainthread.RedArmy:Destroy()
    end
      mainthread.RedArmyX = coord.x
      mainthread.RedArmyY = coord.y
    
   if statem > -1 and statem < 11 then
    mainthread.RedArmyState = statem
   else
    mainthread.RedArmyState = 10
   end
   mainthread.RedArmy = mainthread.RedArmySpawn:SpawnFromCoordinate(coord)
   mainthread.RedArmySpawned = mainthread.RedArmy
  elseif text:find("red2") then
   if mainthread.RedArmy1 ~= nil then
    mainthread.RedArmy1:Destroy()
   end
   mainthread.RedArmy1X = coord.x
   mainthread.RedArmy1Y = coord.y
   if statem > -1 and statem < 11 then
    mainthread.RedArmy1State = statem
   else
    mainthread.RedArmy1State = 10
   end
   mainthread.RedArmy1 = mainthread.RedArmy1Spawn:SpawnFromCoordinate(coord)
   mainthread.RedArmy1Spawned = mainthread.RedArmy1
  elseif text:find("red3") then
   if mainthread.RedArmy2 ~= nil then
    mainthread.RedArmy2:Destroy()
   end
   mainthread.RedArmy2X = coord.x
   mainthread.RedArmy2Y = coord.y
   if statem > -1 and statem < 11 then
    mainthread.RedArmy2State = statem
   else
    mainthread.RedArmy2State = 10
   end
   mainthread.RedArmy2 = mainthread.RedArmy2Spawn:SpawnFromCoordinate(coord)
   mainthread.RedArmy2Spawned = mainthread.RedArmy2
  elseif text:find("blue1") then
    if mainthread.BluArmy ~= nil then
      mainthread.BluArmy:Destroy()
    end
   mainthread.BluArmyX = coord.x
   mainthread.BluArmyY = coord.y
   if statem > -1 and statem < 11 then
    mainthread.BluArmyState = statem
   else
    mainthread.BluArmyState = 10
   end
   mainthread.BluArmy = mainthread.BluArmySpawn:SpawnFromCoordinate(coord)
   mainthread.BlueArmySpawned = mainthread.BluArmy
  elseif text:find("blue2") then
   if mainthread.BluArmy1 ~= nil then
    mainthread.BluArmy1:Destroy()
   end
   mainthread.BluArmy1X = coord.x
   mainthread.BluArmy1Y = coord.y
   if statem > -1 and statem < 11 then
    mainthread.BluArmy1State = statem
   else
    mainthread.BluArmy1State = 10
   end
   mainthread.BluArmy1 = mainthread.BluArmy1Spawn:SpawnFromCoordinate(coord)
   mainthread.BlueArmy1Spawned = mainthread.BluArmy1
  elseif text:find("blue3") then
   if mainthread.BluArmy2 ~= nil then
    mainthread.BluArmy2:Destroy()
   end
   mainthread.BluArmy2X = coord.x
   mainthread.BluArmy2Y = coord.y
   if statem > -1 and statem < 11 then
    mainthread.BluArmy2State = statem
   else
    mainthread.BluArmy2State = 10
   end
    if blue2active == true then
      mainthread.BluArmy2 = mainthread.BluArmy2Spawn:SpawnFromCoordinate(coord)
      mainthread.BlueArmy2 = mainthread.BluArmy2
    end
  end
end  

local function handleBlueTankerRequest(text,coord)
  local currentTime = os.time()
  if text:find("route") then
        local keywords=_split(text, ",")
        local heading = nil
        local distance = nil
        local endcoord = nil
        local endpoint = false
        local altitude = nil
        local altft = nil
        local spknt = nil
        local speed = nil
        local tankername = ""
        BASE:E({keywords=keywords})
        for _,keyphrase in pairs(keywords) do
          local str=_split(keyphrase, " ")
          local key=str[1]
          local val=str[2]
          -- BASE:E(string.format("%s, keyphrase = %s, key = %s, val = %s", "route", tostring(keyphrase), tostring(key), tostring(val)))
          if key:lower():find("h") then
            heading = tonumber(val)
            -- BASE:E({"Tanker Movement we have heading",heading})
          end
          if key:lower():find("d") then
            distance = tonumber(val)
            -- BASE:E({"Tanker Movement we have distance",distance})
          end
          if key:lower():find("a") then
            altitude = tonumber(val)
            -- BASE:E({"Tanker Movement we have altitude ",altitude})
          end
          if key:lower():find("s") then
            speed = tonumber(val)
            -- BASE:E({"Tanker Movement we have speed",speed})
          end
        end
        local tanker = nil
        -- find our tanker
        if text:find("arco") or text:find("arc") then
            local tankername = "ARCO"
            local cooldown = currentTime - ARC_Timer
              if cooldown < TANKER_COOLDOWN then 
                BCC:MessageTypeToCoalition(string.format("ARCO Tanker Requests are not available at this time.\nRequests will be available again in %d minutes", (TANKER_COOLDOWN - cooldown) / 60), MESSAGE.Type.Information)
              return
            end
            tanker = mainthread.BLUTNKR
            if tanker:IsAlive() ~= true then
              BCC:MessageTypeToCoalition("ARCO is currently not avalible for tasking, it's M.I.A",MESSAGE.Type.Information)
              return
            end
            ARC_Timer = currentTime
         elseif text:find("texaco") or text:find("tex") then
            local tankername = "TEXACO"
            tanker = mainthread.BLUTNKR2
            local cooldown = currentTime - TEX_Timer
              if cooldown < TANKER_COOLDOWN then 
                BCC:MessageTypeToCoalition(string.format("TEXACO Tanker Requests are not available at this time.\nRequests will be available again in %d minutes", (TANKER_COOLDOWN - cooldown) / 60), MESSAGE.Type.Information)
              return
            end
            if tanker:IsAlive() ~= true then
              BCC:MessageTypeToCoalition("TEXACO is currently not avalible for tasking it's M.I.A",MESSAGE.Type.Information)
              return
            end
            TEX_Timer = currentTime
          else
          BCC:MessageTypeToCoalition("No known Tanker was included in the Tanker Route Command, please select ARCO21 or TEXACO21",MESSAGE.Type.Information)
          return
        end
        if altitude == nil then
           altft = 19000
           altitude = UTILS.FeetToMeters(19000)
        else
           if altitude > 30000 then
             altitude = 30000
           elseif altitude < 10000 then
             altitude = 10000
           end
           altft = altitude
           altitude = UTILS.FeetToMeters(altitude)
         end
         if speed == nil then
            spknt = 370
            speed = UTILS.KnotsToMps(370)
         else
            if speed > 450 then
              speed = 450
            elseif speed < 250 then
              speed = 250
            end
            spknt = speed
            speed = UTILS.KnotsToMps(speed)
         end  
        if heading ~= nil then 
          if heading < 0 then
            heading = 0
          elseif heading > 360 then
            heading = 360
          end
          if distance ~= nil then
            if distance > 100 then
              distance = 100
            end
            if distance < 5 then
              distance = 5
            end
            endcoord = coord:Translate(UTILS.NMToMeters(distance),heading)
          else
            endcoord = coord:Translate(UTILS.NMToMeters(25),heading)
            distance = 25
          end
        else
          heading = math.random(0,360)
          endcoord = coord:Translate(UTILS.NMToMeters(25),heading)
          distance = 25
        end
        tanker:ClearTasks()
        local routeTask = tanker:TaskOrbit( coord, altitude,  speed, endcoord )
        tanker:SetTask(routeTask, 2)
        local tankerTask = tanker:EnRouteTaskTanker()
        tanker:PushTask(tankerTask, 4)
        BCC:MessageTypeToCoalition( string.format("%s Tanker is re-routed to the player requested destination.\nIt will orbit on a heading of %d for %d nm, Alt: %d Gnd Speed %d.\n%d minutes cooldown starting now", tanker:GetName(),heading,distance,altft,spknt, TANKER_COOLDOWN / 60), MESSAGE.Type.Information )      
        SCHEDULER:New(nil, tankerCooldownHelp, {tankername}, TANKER_COOLDOWN)
    end
end
local function handleAfacRequest(text, coord)
  local currentTime = os.time()
 
  if text:find("route") then
    local keywords=_split(text, ",")
    local heading = nil
    local distance = nil
    local endcoord = nil
    local endpoint = false
    local altitude = nil
    local altft = nil
    local spknt = nil
    local speed = nil
    local afacname = ""
    BASE:E({keywords=keywords})
    for _,keyphrase in pairs(keywords) do
      local str=_split(keyphrase, " ")
      local key=str[1]
      local val=str[2]
      BASE:E(string.format("%s, keyphrase = %s, key = %s, val = %s", "route", tostring(keyphrase), tostring(key), tostring(val)))
        if key:lower():find("h") then
          heading = tonumber(val)
          -- BASE:E({"AFAC Movement we have heading",heading})
        end
        if key:lower():find("d") then
          distance = tonumber(val)
          -- BASE:E({"AFAC Movement we have distance",distance})
        end
        if key:lower():find("a") then
          altitude = tonumber(val)
          -- BASE:E({"AFAC Movement we have altitude ",altitude})
        end
        if key:lower():find("s") then
          speed = tonumber(val)
          -- BASE:E({"AFAC Movement we have speed",speed})
        end
    end
    local _afac = nil
    -- find our afac
    if text:find("afac1") or text:find("AFAC1") then
      local afacname = "fac1"
      _afac = mainthread.afac
      local cooldown = currentTime - FAC1_Timer
      if cooldown < JTAC_COOLDOWN then 
        BCC:MessageTypeToCoalition(string.format("AFAC1 Requests are not available at this time.\nRequests will be available again in %d minutes", (JTAC_COOLDOWN - cooldown) / 60), MESSAGE.Type.Information)
        return
      end
      if _afac:IsAlive() ~= true then
        BCC:MessageTypeToCoalition("AFAC1 is currently not avalible for tasking it's M.I.A",MESSAGE.Type.Information)
        return
      end
      FAC1_Timer = currentTime
    else
      BCC:MessageTypeToCoalition("No known AFAC was included in the Route Command, please select afac1",MESSAGE.Type.Information)
      return
    end
    if altitude == nil then
      altft = 9000
      altitude = UTILS.FeetToMeters(19000)
    else
      if altitude > 20000 then
        altitude = 20000
      elseif altitude < 1000 then
        altitude = 1000
      end
      altft = altitude
      altitude = UTILS.FeetToMeters(altitude)
    end
    if speed == nil then
      spknt = 120
      speed = UTILS.KnotsToMps(120)
    else
      if speed > 150 then
        speed = 150
      elseif speed < 90 then
        speed = 90
      end
    spknt = speed
    speed = UTILS.KnotsToMps(speed)
    end  
    if heading ~= nil then 
      if heading < 0 then
        heading = 0
      elseif heading > 360 then
        heading = 360
      end
      if distance ~= nil then
        if distance > 25 then
          distance = 25
        end
        if distance < 0 then
          distance = 0
        end
      endcoord = coord:Translate(UTILS.NMToMeters(distance),heading)
      else
        endcoord = coord:Translate(UTILS.NMToMeters(25),heading)
        distance = 0
      end
    else
      heading = math.random(0,360)
      endcoord = coord:Translate(UTILS.NMToMeters(25),heading)
      distance = 0
    end
    _afac:ClearTasks()
    local routeTask = _afac:TaskOrbit(coord,altitude,speed)
    if distance ~= 0 then
       routeTask = _afac:TaskOrbit(coord,altitude,speed,endcoord)
    end
    _afac:SetTask(routeTask, 2)

    local afacTask = _afac:EnRouteTaskFAC(UTILS.NMToMeters(10),1)
    _afac:PushTask(afacTask, 4)
    BCC:MessageTypeToCoalition( string.format("%s AFAC is re-routed to the player requested destination.\nIt will orbit on a heading of %d for %d nm, Alt: %d Gnd Speed %d.\n%d minutes cooldown starting now", _afac:GetName(),heading,distance,altft,spknt, JTAC_COOLDOWN / 60), MESSAGE.Type.Information )      
    SCHEDULER:New(nil, afacCooldownHelp, {afacname}, JTAC_COOLDOWN)
 end
end


local function handleRespawnRequest(text,coord)
  BASE:E({"ReSpawn Request",text,coord})
 BASE:E({"Spawn Request",text,coord})
  local currentTime = os.time()
  local keywords=_split(text, ",")
  local unit = nil
  BASE:E({keywords=keywords})
  unit = keywords[2]
  local mgroup = nil
  mgroup = GROUP:FindByName(unit)
  if mgroup == nil then
    BASE:E({"Respawn error, No group found"})
    BCC:MessageToAll("RIB ADMIN Error:No Group Found")
  else
    if mgroup:IsAlive() == true then
      mgroup:Destroy()
    end
    BASE:E({"Respawning unit/coord:",unit,coord})
    mspawner = SPAWN:New(unit):SpawnFromCoordinate(coord)
    BCC:MessageToAll("RIB ADMIN COMMAND COMPLETED")
  end
end



local function handleDestroyRequest(text,coord)
  BASE:E({"Destroy Request",text,coord})
  local currentTime = os.time()
  local keywords=_split(text, ",")
  local unit = nil
  BASE:E({keywords=keywords})
  unit = keywords[2]
  local mgroup = nil
  mgroup = GROUP:FindByName(unit)
  if mgroup == nil then
    BASE:E({"Respawn error, No group found",unit})
    BCC:MessageToAll("RIB ADMIN Error:No Group Found")
  else
    if mgroup:IsAlive() == true then
       BASE:E({"Destroying Unit:",unit,coord})
      mgroup:Destroy()
      BCC:MessageToAll("RIB ADMIN COMMAND COMPLETED")
    end
  end
end
function moveground(text,coord,EC)
  local keywords=_split(text, ",")
  BASE:E({"moveground",keywords})
  local unit = nil
  unit = keywords[2]
  local speed = keywords[3]
  if speed ~= nil then
    if speed ~= "" then 
      speed = tonumber(speed)
    else
      speed = 20
    end
  else
    speed = 20
  end
  local form = keywords[4]
  if form ~= nil then
    if form == "" then
    form = randomform()
    end
  else
    form = randomform()
  end
  local mgroup = nil
  mgroup = GROUP:FindByName(unit)
  if mgroup == nil then
    BASE:E({"Command Ground Unit Error: No Group",unit})
    if EC == 1 then
      MESSAGE:New("Could not find a group with the name ".. unit .. " please check again",15):ToRed()
    else
      MESSAGE:New("Could not find a group with the name ".. unit .. " please check again",15):ToBlue()
    end
  else
    if mgroup:GetCoalition() ~= ec then
      if EC == 1 then
        MESSAGE:New("Sorry Group ".. unit .. " is not a Red unit please check again",15):ToRed()
      else
        MESSAGE:New("Sorry Group ".. unit .. " is not a blue unit please check again",15):ToBlue()
      end
    else
      mgroup:RouteGroundTo(coord,speed,form,5)
      if EC == 1 then
        MESSAGE:New("Group ".. unit .. " Is moving to commanded position",15):ToRed()
      else
        MESSAGE:New("Group ".. unit .. " Is moving to commanded position",15):ToBlue()
      end
    end
  end
end
------------------------
function markRemoved(Event,EC)
    if Event.text~=nil and Event.text:lower():find("-") then 
        local text = Event.text:lower()
        local text2 = Event.text
        local vec3={y=Event.pos.y, x=Event.pos.x, z=Event.pos.z}
        local coord = COORDINATE:NewFromVec3(vec3)
        coord.y = coord:GetLandHeight()
        if Event.text:lower():find("-weather") then
            if EC == 2 then
              handleWeatherRequest(text, coord,false)
            else
              handleWeatherRequest(text, coord,true)
            end
        elseif Event.text:lower():find("-afac") then
            if EC == 2 then
              handleAfacRequest(text, coord)
            else
              RCC:MessageToAll("Red For does not have AFAC, please stop trying to give the command, you can't direct blue's.")
            end
        elseif Event.text:lower():find("-cap") then
            if EC == 2 then
              handleCAPRequest(text, coord)
            else
              handleRedCAPRequest(text, coord)
            end
        elseif Event.text:lower():find("-tanker") then
           if EC == 2 then
            handleBlueTankerRequest(text,coord)        
           else
            handleRedTankerRequest(text,coord)
           end
        elseif Event.text:lower():find("-remove") then
          BASE:E({"remove request",text,coord})
          if ribadmin == true then
            handleRemoveRequest(text,coord)
          else
           MESSAGE:New("Admin command denied, Not authorised",15):ToAll() 
          end
        elseif Event.text:lower():find("-state") then
          if ribadmin == true then
            handleStateRequest(text,coord)
          else
            MESSAGE:New("Admin command denied, Not authorised",15):ToAll()
          end
        elseif Event.text:lower():find("-add") then
          if ribadmin == true then
            handleSpawnRequest(text,coord)
          else
            MESSAGE:New("Admin command denied, Not authorised",15):ToAll()
          end
        elseif Event.text:lower():find("-respawn") then
          if ribadmin == true then
            handleRespawnRequest(text2,coord)
          else
            MESSAGE:New("Admin command denied, Not authorised",15):ToAll()
          end
        elseif Event.text:lower():find("-admindestroy") then
          if ribadmin == true then
            handleDestroyRequest(text2,coord)
          else
            MESSAGE:New("Admin command denied, Not authorised",15):ToAll()
          end
        elseif Event.text:lower():find("-adminresetround") then
          if ribadmin == true then
            if RESETALL == 0 then
              RESETALL = 1
              PersistedStore.resetall = 1
              MESSAGE:New("Admin command reset of all persistence data on Next restart.",15):ToAll()
              savePersistenceEngine()
            else
              RESETALL = 0
              PersistedStore.resetall = 0
              MESSAGE:New("Admin command reset of all persistence data cancelled.",15):ToAll()
              savePersistenceEngine()
            end
          else
            MESSAGE:New("Admin command denied, Not authorised",15):ToAll()
          end
        elseif Event.text:lower():find("-smokered") then
          coord:SmokeRed()
        elseif Event.text:lower():find("-smokeblue") then
          coord:SmokeBlue()
        elseif Event.text:lower():find("-smokegreen") then
          coord:SmokeGreen()
        elseif Event.text:lower():find("-smokeorange") then
          coord:SmokeOrange()
        elseif Event.text:lower():find("-smoke") then
          coord:SmokeWhite()
        elseif Event.text:lower():find("-flare") then
          coord:FlareRed(math.random(0,360))
          SCHEDULER:New(nil,function() 
            coord:FlareRed(math.random(0,20))
          end,{},30)
        elseif Event.text:lower():find("-light") then
          coord:IlluminationBomb(100000)
        elseif Event.text:lower():find("-adminexplode") then
          if ribadmin == true then
            MESSAGE:New("Admin command used something is gonna blow up in 10 seconds",15):ToAll()
            coord:Explosion(500,10)
          else
            MESSAGE:New("Admin command denied, Not authorised",15):ToAll()
          end
        elseif Event.text:lower():find("-ribadmin" .. PersistedStore.Password) then
          if ribadmin == false then
            MESSAGE:New("Admin Commands have been Activated",15):ToAll()
            ribadmin = true
          else
            ribadmin = false
            MESSAGE:New("Admin Commands have been DeActivated",15):ToAll()
          end
        elseif Event.text:lower():find("-groute") then
            moveground(text2,coord,EC)
        end
    end
end

function SupportHandler:onEvent(Event)
    if Event.id == world.event.S_EVENT_MARK_ADDED then
        env.info(string.format("RIB: Support got event ADDED id %s idx %s coalition %s group %s text %s", Event.id, Event.idx, Event.coalition, Event.groupID, Event.text))
    elseif Event.id == world.event.S_EVENT_MARK_CHANGE then
        -- nothing atm
    elseif Event.id == world.event.S_EVENT_MARK_REMOVED then
         env.info(string.format("RIB: Support got event ADDED id %s idx %s coalition %s group %s text %s", Event.id, Event.idx, Event.coalition, Event.groupID, Event.text))
        markRemoved(Event,Event.coalition)
    end
end


world.addEventHandler(SupportHandler)


local function permanentPlayerCheck()
    BASE:E("PPCHECK")
    do
    nowTable = os.date('*t')
    nowYear = nowTable.year
    nowMonth = nowTable.month
    nowDay = nowTable.day
    nowHour = nowTable.hour
    nowminute = nowTable.min
    end
    
    rcomms = "ARCO - KC135 Drogue 5x U252 | Wizard - E3 AWACS U251. | FOB Otkrytka - 127.5"
    bcomms = "Overlord - E3 AWACS U251.  |ARCO11 - KC135 Drogue 3x U252 \n Texaco - KC135 15X U253 | Shell - S3 9Y/X U254 \n Stennis: 55X STN, 1ICLS, A118.3, M305 (Check Kneeboard) | Tarawa: 75X | LONDON: 122.5 | AFAC 133AM"
    if GUDOWNER ~= 1 then
        redobject = "Retake Gudauta,"
        blueobject = "Defend Gudauta,"
    else
        redobject = "Defend Gudauta,"
        blueobject = "Capture Gudauta,"
    end
    if SOCHIOWNER ~= 1 then
      redobject = redobject .. " Retake Sochi-Adler Immediately,"
      blueobject = blueobject .. " Hold Sochi-Adler for as long as possible,"
    else
      redobject = redobject .. " Defend Sochi-Adler,"
      blueobject = blueobject .. " Capture and Hold Sochi-Adler,"
    end
    if SUKOWNER ~= 1 then
        redobject = redobject .. " Retake Sukhumi,"
        blueobject = blueobject .. " Hold Sukhumi,"
    else
        redobject = redobject .. " Defend Sukhumi,"
        blueobject = blueobject .. " Capture Sukhuimi,"  
    end
    if KUTOWNER ~= 2 then
        redobject = redobject .. " Hold Kutasi,"
        blueobject = blueobject .. " Retake Kutasi"
    else
        redobject = redobject .. " Capture Kutasi"
        blueobject = blueobject .. " Defend Kutasi"
    end
    if SENOWNER ~= 2 then
        redobject = redobject .. " Hold Senaki,"
        blueobject = blueobject .. " Retake Senaki"
    else
        redobject = redobject .. " Capture Senaki"
        blueobject = blueobject .. " Defend Senaki"
    end
    if KOBOWNER ~= 2 then
        redobject = redobject .. " Hold Kobuletti."
        blueobject = blueobject .. " Retake Kobuletti."
    else
        redobject = redobject .. " Capture Kobuletti."
        blueobject = blueobject .. " Defend Kobuletti."
    end   
    
   SetPlayerRed:ForEachClient(function(PlayerClient) 
      
      local PlayerID = PlayerClient.ObjectName
      -- MESSAGE:New("Welcome to Red Iberia Version: "..version.." \n Last updated:".. lastupdate .." \n No Red on Red is Allowed \n Your current objective is to ".. redobject .."\n" ..rcomms .. "\n Remember Stores and Aircraft are limited and take time to resupply",60):ToClient(PlayerClient)
      -- PlayerClient:AddBriefing("Welcome to Red Iberia By Rob Graham Version: "..version.." \n Last updated:".. lastupdate .." \n POWERED BY MOOSE \n Current Server time is: ".. nowHour .. ":" .. nowminute .."\n Mission Restart Time: restart time:".. restarttime .. "\n No Red on Red is Allowed \n Your current objective is to ".. redobject .."\n" ..rcomms .. "\n Remember Stores and Aircraft are limited and take time to resupply")
      if PlayerClient:GetGroup() ~= nil then
      end
      if PlayerClient:IsAlive() then
        if PlayerRMap[PlayerID] ~= true then
          PlayerRMap[PlayerID] = true
          MESSAGE:New("Welcome to Red Iberia By Rob Graham Version: "..version.." \n Last updated:".. lastupdate .." \n POWERED BY MOOSE \n Current Server time is: ".. nowHour .. ":" .. nowminute .."\n Mission Restart Time: restart time:".. restarttime .. "\n No Red on Red is Allowed \n Your current objective is to ".. redobject .."\n" ..rcomms .. "\n Supplied by core members of Http://TaskGroupWarrior.Info",60):ToClient(PlayerClient)
        end
      else
        if PlayerRMap[PlayerID] ~= false then
          PlayerRMap[PlayerID] = false
        end
      end
    end)
    SetPlayerBlue:ForEachClient(function(PlayerClient) 
      local PlayerID = PlayerClient.ObjectName
        --PlayerClient:AddBriefing("Welcome to Red Iberia Rob Graham Version: "..version.." \n Last updated:".. lastupdate .." \n POWERED BY MOOSE \n Current Server time is: ".. nowHour .. ":" .. nowminute .."\n Mission Restart time:".. restarttime .. "\n No Blue on Blue is Allowed \n Your current objective is to ".. blueobject .."\n" ..bcomms .. "\n Remember Stores and Aircraft are limited and take time to resupply")
        if PlayerClient:GetGroup() ~= nil then
          local group = PlayerClient:GetGroup()
        end
         if PlayerClient:IsAlive() then
           if PlayerBMap[PlayerID] ~= true then
                PlayerBMap[PlayerID] = true
                MESSAGE:New("Welcome to Red Iberia Rob Graham Version: "..version.." \n Last updated:".. lastupdate .." \n POWERED BY MOOSE \n Current Server time is: ".. nowHour .. ":" .. nowminute .."\n Mission Restart time:".. restarttime .. "\n No Blue on Blue is Allowed \n Your current objective is to ".. blueobject .."\n" ..bcomms .. "\n Supplied by core members of Http://TaskGroupWarrior.Info",60):ToClient(PlayerClient)
           end    
         else
          if PlayerBMap[PlayerID] ~= false then
                PlayerBMap[PlayerID] = false
          end
       end
    end)
   currentclient = 0
   local cc = SET_CLIENT:New():FilterCoalitions("red"):FilterActive():FilterOnce()
   if cc:Count() ~= 0 then
    nooclients = false
    currentclient = currentclient + cc:Count()
   end
    cc = SET_CLIENT:New():FilterCoalitions("blue"):FilterActive():FilterOnce()
   if cc:Count() ~= 0 then
    nooclients = false
    currentclient = currentclient + cc:Count()
   end
   if nooclients == false and lastclientcount ~= currentclient then
      BASE:E({"No Clients is no longer false",lastclientcount,currentclient})
      lastclientcount = currentclient
      if noclients >= 2 then
        BASE:E({"No clients was >= 2 but we h ave a client now running a tick",noclients})
        mainthread:BGroundTick(3000,2000)
        mainthread:RGroundTick(3000,2000)
        if insurgents == true then
          mainthread:BInsurgents()
        end
      else
        BASE:E({"No clients was less then 2, so tick was running normal anyway",noclients})
      end
      nooclients = false
      noclients = 0
   elseif lastclientcount ~= currentclient then
      BASE:E({"We have new clients",lastclientcount,currentclient})
      nooclients = false
   end
   BASE:E({"CLIENT UPDATE nooclients:",nooclients,"noclients",noclients,"currentclient",currentclient})
end

local function roundcounter()
  if nooclients == true then
    noclients = noclients + 1
  end
  BCC:MessageToAll("MISSION WILL RESTART IN 10 MINUTES")
  SCHEDULER:New(nil,function() 
    BCC:MessageToAll("Mission WILL RESTART IN 5 MINUTES")
  end,{}, (60*5))
  SCHEDULER:New(nil,function() 
    BCC:MessageToAll("Mission WILL RESTART IN 2 MINUTES")
  end,{}, (60*8))
  SCHEDULER:New(nil,function() 
    BCC:MessageToAll("Mission WILL RESTART IN 1 MINUTE")
  end,{}, (60*9))
  SCHEDULER:New(nil,function() 
    BCC:MessageToAll("Mission WILL RESTART IN 30 Seconds")
  end,{}, (60*9.5))
end
do 
local function starttimer()
  local currentTime = os.time()
  local cooldown = currentTime - round_Timer
  round_Timer = cooldown
  BASE:E({"starting timer for round current time,cooldown,round timer",currenttime,cooldown,Round_COOLDOWN})
  SCHEDULER:New(nil, roundcounter, {}, Round_COOLDOWN)
end

SCHEDULER:New(nil, starttimer,{},30)
SCHEDULER:New(nil, permanentPlayerCheck, {}, 3, 10)
SCHEDULER:New(nil,function() 
    BCC:MessageToAll("Mission WILL RESTART IN 5 hours")
  end,{}, (60*60)*1)
SCHEDULER:New(nil,function() 
    BCC:MessageToAll("Mission WILL RESTART IN 4 hours")
 end,{}, (60*60)*2)
SCHEDULER:New(nil,function() 
    BCC:MessageToAll("Mission WILL RESTART IN 3 hours")
  end,{}, (60*60)*3)
SCHEDULER:New(nil,function() 
    BCC:MessageToAll("Mission WILL RESTART IN 2 hours")
  end,{}, (60*60)*4)
SCHEDULER:New(nil,function() 
    BCC:MessageToAll("Mission WILL RESTART IN 1 hour")
  end,{}, (60*60)*5)
SCHEDULER:New(nil,function() 
    BCC:MessageToAll("Mission WILL RESTART IN 30 Minutes")
  end,{}, (60*60)*5.5) 
end
BASE:E("SETTING UP TASKING MISSIONS")
-- reda2gmission = MISSION:New(RCC,"RED HAMMER","PRIMARY","Destroy the Western Forces so we can retake what is ours",coalition.side.RED)
-- bluea2gmission = MISSION:New(BCC,"IRON HAND","PRIMARY","Destroy Russian Forces",coalition.side.BLUE)
-- rreeceset = SET_GROUP:New():FilterPrefixes({"Russian Army","RAFD"}):FilterCoalitions("red"):FilterActive():FilterStart()
-- rattackset = SET_GROUP:New():FilterPrefixes({"RUS"}):FilterCoalitions("red"):FilterActive():FilterStart()
-- rdetectionareas = DETECTION_AREAS:New(rreeceset,3000)
-- rTaskDispatcher = TASK_A2G_DISPATCHER:New(reda2gmission,rattackset,rdetectionareas)
-- brecceset = SET_GROUP:New():FilterPrefixes({"AFAC","BAF","US Army","Apaches","Overlord"}):FilterCoalitions("blue"):FilterActive():FilterStart()
-- bdetectionareas = DETECTION_AREAS:New(brecceset,3000)
-- battackset = SET_GROUP:New():FilterPrefixes({"USAF","FAF","GAF","RAAF","USMC","USN","GAA","RAA","UA","UAF","USAA"}):FilterActive():FilterStart()
-- bTaskDispatcher = TASK_A2G_DISPATCHER:New(bluea2gmission,battackset,bdetectionareas)

  
env.info("END MISSION SET UP")

function addredscore(score)
  redscore = redscore + score
end
function addbluescore(score)
  bluescore = bluescore + score
end


function scoreupdate()
  if SOCHIOWNER == 1 then
    addredscore(3)
  else
    addbluescore(100)
  end
  if GUDOWNER == 1 then
    addredscore(25)
  else
    addbluescore(50)
  end
  if SUKOWNER == 1 then
    addredscore(50)
  else
    addbluescore(25)
  end
  if SENOWNER == 1 then
    addredscore(25)
  else
    addbluescore(1)
  end
  if KUTOWNER == 1 then
    addredscore(25)
  else
    addbluescore(1)
  end
  if KOBOWNER == 1 then
    addredscore(50)
  else
    addbluescore(1)
  end
  MESSAGE:New("Red Side Score is:".. redscore .. "|Blue Side Score is:"..bluescore .." Points",15):ToAll()
end

do
lasthour = nil

SCHEDULER:New(nil,function()  

  BASE:E({"Current Local time is:",nowYear,nowMonth,nowDay,nowHour,nowminute})
  if lasthour == nil then
    lasthour = nowHour
    MESSAGE:New("SERVER TIME IS NOW:" .. nowHour .. ":" .. nowminute .. " DATE IS: " .. nowDay .. "-" .. nowMonth .."-" .. nowYear .. "",30):ToAll()
    if init == true then
      scoreupdate()
    end
  elseif nowHour ~= lasthour then
    lasthour = nowHour
    MESSAGE:New("SERVER TIME IS NOW:" .. nowHour .. ":" .. nowminute .. "",10):ToAll()
    if init == true then
      scoreupdate()
    end
  end
  if nowHour == 19 then
    if nowminute == 00 then
      MESSAGE:New("A FORCED RESTART WILL OCCUR AT 8PM IN 60 MINUTES ",30):ToAll()
      if nowDay == 1 then
        BASE:E({"It's 1st day of the month, Persistence Reset Scheduled for next restart"})
        resetall = 1
        PersistedStore.resetall = 1
        MESSAGE:New("Server Persistence Reset Will occur at next restart",30):ToAll()
      end
    end
    if nowminute == 10 then
      MESSAGE:New("A FORCED RESTART WILL OCCUR AT 8PM IN 50 MINUTES ",30):ToAll()
    end
    if nowminute == 20 then
      MESSAGE:New("A FORCED RESTART WILL OCCUR AT 8PM IN 40 MINUTES ",30):ToAll()
    end
    if nowminute == 30 then
      MESSAGE:New("A FORCED RESTART WILL OCCUR AT 8PM IN 30 MINUTES ",30):ToAll()
    end
    if nowminute == 40 then
      MESSAGE:New("A FORCED RESTART WILL OCCUR AT 8PM IN 20 MINUTES",30):ToAll()
    end
    if nowminute == 50 then
      MESSAGE:New("A FORCED RESTART WILL OCCUR AT 8PM IN 10 MINUTES",30):ToAll()
    end
    if nowminute == 55 then
      MESSAGE:New("A FORCED RESTART WILL OCCUR AT 8PM IN 5 MINUTES",30):ToAll()
    end
    if nowminute == 58 then
      MESSAGE:New("A FORCED RESTART WILL OCCUR AT 8PM IN 2 MINUTES",30):ToAll()
    end
    if nowminute == 59 then
      MESSAGE:New("A FORCED RESTART WILL OCCUR AT 8PM IN 1 MINUTE",30):ToAll()
    end
  end
 end,{},1,60)

function fAlive(grp)
if grp:IsAlive() then return true else return false end
end
function factory()
  
  AllStatics = SET_STATIC:New():FilterPrefixes({"DEPOT"}):FilterOnce()
    gfact = 0
    nfact = 0
    mfact = 0 
    kfact = 0
    cfact = 0
    afact = 0
    AllStatics:ForEach(function (grp)
    if  grp:GetName() == "DEPOT Factory1" then
      local prod = math.random(1,5)
      prod = prod / 10
      BASE:E({"PRODUCTION FOR FACTORY1 is:",prod})
      if fAlive(grp) == true then
        if redairsupply <= 100 then
          redairsupply = redairsupply + prod
        end
        gfact = gfact + prod
      end
    elseif grp:GetName() == "DEPOT Factory2" then
      local prod = math.random(1,5)
      prod = prod / 10
      if fAlive(grp) == true then
        if redairsupply <= 100 then
          redairsupply = redairsupply + prod
        end
      gfact = gfact + prod
      end
    elseif grp:GetName() == "DEPOT Factory3" then
      local prod = math.random(1,5)
      prod = prod / 10
      if fAlive(grp) == true then
        if redairsupply <= 100 then
          redairsupply = redairsupply + prod
        end
      gfact = gfact + prod
      end
    elseif grp:GetName() == "DEPOT Factory4" then
      local prod = matlocal prod = math.random(1,5)
      prod = prod / 10
      if fAlive(grp) == true then
        if redairsupply <= 100 then
          redairsupply = redairsupply + prod
        end
      gfact = gfact + prod
      end
    elseif grp:GetName() == "DEPOT Factory5" then
    local prod = math.random(5,50)
    prod = prod / 10
      if fAlive(grp) == true then
        if redgroundsupply <= 100 then
          redgroundsupply = redgroundsupply + prod
        end
      nfact = nfact + prod
      end
    elseif grp:GetName() == "DEPOT Factory6" then
    local prod = math.random(5,50)
      prod = prod / 10
      if fAlive(grp) == true then
        if redgroundsupply <= 100 then
          redgroundsupply = redgroundsupply + prod
        end
      mfact = mfact + prod
      end
    elseif grp:GetName() == "DEPOT Factory6" then
    local prod = math.random(5,50)
      prod = prod / 10
      if fAlive(grp) == true then
        if redgroundsupply <= 100 then
          redgroundsupply = redgroundsupply + prod
        end
      mfact = mfact + prod
      end
    elseif grp:GetName() == "DEPOT Factory7" then
    local prod = math.random(5,50)
      prod = prod / 10
      if fAlive(grp) == true then
        if redgroundsupply <= 100 then
          redgroundsupply = redgroundsupply + prod
        end
      mfact = mfact + prod
      end
    elseif grp:GetName() == "DEPOT Factory8" then
    local prod = math.random(5,50)
      prod = prod / 10
      if fAlive(grp) == true then
        if redgroundsupply <= 100 then
          redgroundsupply = redgroundsupply + prod
        end
      afact = afact + prod
      end    
    elseif grp:GetName() == "DEPOT Factory9" then
    local prod = math.random(5,50)
      prod = prod / 10
      if fAlive(grp) == true then
        if redgroundsupply <= 100 then
          redgroundsupply = redgroundsupply + prod
        end
      afact = afact + prod
      end    
    elseif grp:GetName() == "DEPOT Factory10" then
    local prod = math.random(5,50)
      prod = prod / 10
      if fAlive(grp) == true then
        if redgroundsupply <= 100 then
          redgroundsupply = redgroundsupply + prod
        end
      afact = afact + prod
      end  
    elseif grp:GetName() == "DEPOT Factory11" then
      local prod = math.random(1,5)
      prod = prod / 10
      if fAlive(grp) == true then
        if redairsupply <= 100 then
          redairsupply = redairsupply + prod
        end
      cfact = cfact + prod
      end
    elseif grp:GetName() == "DEPOT Factory12" then
      local prod = math.random(1,5)
      prod = prod / 10
      if fAlive(grp) == true then
        if redairsupply <= 100 then
          redairsupply = redairsupply + prod
        end
      cfact = cfact + prod
      end 
    elseif grp:GetName() == "DEPOT Factory13" then
      local prod = math.random(1,5)
      prod = prod / 10
      if fAlive(grp) == true then
        if redairsupply <= 100 then
          redairsupply = redairsupply + prod
        end
      cfact = cfact + prod
      end       
    
    elseif grp:GetName() == "DEPOT Factory14" then
      local prod = math.random(1,5)
      prod = prod / 10
      if fAlive(grp) == true then
        if redairsupply <= 100 then
          redairsupply = redairsupply + prod
        end
      cfact = cfact + prod
      end
    elseif grp:GetName() == "DEPOT Factory15" then
      local prod = math.random(1,5)
      prod = prod / 10
      if fAlive(grp) == true then
        if redairsupply <= 100 then
          redairsupply = redairsupply + prod
        end
      gfact = gfact + prod
      end
    elseif grp:GetName() == "DEPOT Factory16" then
    local prod = math.random(5,50)
      prod = prod / 10
      if fAlive(grp) == true then
        if redgroundsupply <= 100 then
          redgroundsupply = redgroundsupply + prod
        end
      kfact = kfact + prod
      end  
    elseif grp:GetName() == "DEPOT Factory17" then
    local prod = math.random(5,50)
      prod = prod / 10
      if fAlive(grp) == true then
        if redgroundsupply <= 100 then
          redgroundsupply = redgroundsupply + prod
        end
      kfact = kfact + prod
      end  
      elseif grp:GetName() == "DEPOT Factory18" then
    local prod = math.random(5,50)
      prod = prod / 10
      if fAlive(grp) == true then
        if redgroundsupply <= 100 then
          redgroundsupply = redgroundsupply + prod
        end
      kfact = kfact + prod
      end  
    elseif grp:GetName() == "DEPOT Factory19" then
    local prod = math.random(5,50)
      prod = prod / 10
      if fAlive(grp) == true then
        if redgroundsupply <= 100 then
          redgroundsupply = redgroundsupply + prod
        end
      kfact = kfact + prod
      end  
    elseif grp:GetName() == "DEPOT Factory20" then
    local prod = math.random(5,50)
      prod = prod / 10
      if fAlive(grp) == true then
        if redgroundsupply <= 100 then
          redgroundsupply = redgroundsupply + prod
        end
      kfact = kfact + prod
      end  
    elseif grp:GetName() == "DEPOT Factory21" then
      if fAlive(grp) == true then
          redgroundsupply = redgroundsupply + 5
      end  
    elseif grp:GetName() == "DEPOT Factory22" then
      if fAlive(grp) == true then
        redairsupply = redairsupply + 0.5
      end  
    end
     end)
    if blueairsupply <= 80 then
      blueairsupply = blueairsupply + 12
    end
    
    if bluegroundsupply <= 100 then
      bluegroundsupply = bluegroundsupply + 45
    end
    
    local nfac = (factorytime/60)
    nfmc:RemoveMark(nfm)
    nfm = nfmc:MarkToAll("Novorossiysk Factory Output Capacity:" .. nfact .. " Aircraft every ".. nfac .. " Minutes",true)
    mfmc:RemoveMark(mfm)
    mfm = mfmc:MarkToAll("Mayskiy Factory Output Capacity:".. mfact .. " Vehicles every ".. nfac .. " Minutes",true)
    apsmc:RemoveMark(apsm)
    apsm = apsmc:MarkToAll("Apsheronsk Factory Output Capacity:".. afact.. " Vehicles every ".. nfac .. " Minutes",true)
    cfmc:RemoveMark(cfm)
    cfm = cfmc:MarkToAll("Cherkessk Factory Output Capacity:" .. cfact .. " Aircraft every ".. nfac .. " Minutes",true)
    kfmc:RemoveMark(kfm)
    kfm = kfmc:MarkToAll("Krasnador Factory Output Capacity:".. kfact .. " Vehicles every ".. nfac .. " Minutes",true)
    gfmc:RemoveMark(gfm)
    gfm = gfmc:MarkToAll("Gelendzhik Factory Output Capacity:" .. gfact .. " Aircraft every ".. nfac .. " Minutes",true)
end



 
 -- these are just incase, and reinforce last set 30 minutes behind because we want it there
 if PersistedStore.FactoryLast == nil then
  PersistedStore.FactoryLast = 0
  BASE:E("PersistedStore.FactoryLast was nil!")
 end
 if PersistedStore.ReinforceLast == nil then
  PersistedStore.ReinforceLast = (os.time() - (30 * 60))
  BASE:E("PersistedStore.ReinforceLast was nil!")
 elseif PersistedStore.ReinforceLast == 0 then
  PersistedStore.ReinforceLast = (os.time() - (30 * 60))
 end

function checkcommandrebuild()
   if nowtime > (PersistedStore.KrazRound)  then
      if krazcommand:IsAlive() ~= true then
         krazcommand = SPAWN:New("Krascommand")
         _kc:RemoveMark(_km)
         _km = _kc:MarkToAll("Krasnodar Command Center, Active",true)
         PersistedStore.KrazCommand = 1
     end
   end
   if nowtime > (PersistedStore.NovoRound) then
      if novocommand:IsAlive() ~= true then
        novocommand = SPAWN:New("Novocommand") 
        _nc:RemoveMark(_nm)
        _nm = _kc:MarkToAll("Novorossysk Command Center, Active",true)
        PersistedStore.NovoCommand = 1
      end
   end
 end
 
 -- heartbeat 1 second timer
 SCHEDULER:New(nil,function()
  -- get our times and update them
  do
    nowtime = os.time()
    nowTable = os.date('*t')
    nowYear = nowTable.year
    nowMonth = nowTable.month
    nowDay = nowTable.day
    nowHour = nowTable.hour
    nowminute = nowTable.min
    nowDaylightsavings = nowTable.isdst
    nowDayofYear = nowTable.yday
    nowDayofWeek = nowTable.wday
    nowsecond = nowTable.sec
  end 

    -- ok take the now time if it's greater then our factory last + the factorytime then run
    if init == true then
      if pstatic == true then
          if nowtime > (PersistedStore.FactoryLast + factorytime) then
            BASE:E("Running Factory as FactoryLast + factorytime was < nowtime")
            factory()
            
            PersistedStore.FactoryLast = nowtime
            local nextrun = PersistedStore.FactoryLast + factorytime 
            BASE:E({"Next Factory Run should be at ",os.date('%A, %B %d %Y at %I:%M:%S %p',nextrun)})        
        end
      if nowtime > (PersistedStore.ReinforceLast + reinforcehours) then
        BASE:E({"Running Reinforce Sqns as ready to run"})
        reinforcesqns()
        PersistedStore.ReinforceLast = nowtime
        local nextrun = PersistedStore.ReinforceLast + reinforcehours 
        BASE:E({"Next Factory Run should be at ",os.date('%A, %B %d %Y at %I:%M:%S %p',nextrun)})      
      end
    end
    end
   end,{},0,1)

end

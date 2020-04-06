BASE:E({"TRAINING MISSION START"})
PlayerBMap = {}
clients = SET_CLIENT:New():FilterActive(true):FilterStart() -- look at clients
lastupdate = "1020 29 March 2020"
arco = GROUP:FindByName("ARC")
tex = GROUP:FindByName("TEX")
overlord = GROUP:FindByName("Overlord")
attacker = GROUP:FindByName("Attacker")
Ehandler = EVENTHANDLER:New()
Ehandler:HandleEvent(EVENTS.Dead)
bgroundd15 = nil
bground15 = nil
bground10 = nil
bgroundd10 = nil
bairspawn = nil
bairdestroy = nil
attackerspawn = false
sa10spawn = false
sa15spawn = false
carrierspawn = false
SupportHandler = EVENTHANDLER:New()
cruisergroup = GROUP:FindByName("Crusier")
sg1 = GROUP:FindByName("ShipGroup1")
---@param self
--@param Core.Event#EVENTDATA EventData
function Ehandler:OnEventDead(EventData)
  BASE:E({EventData.IniGroupName})
  if EventData.IniGroupName == cruisergroup:GetName() then
    MESSAGE:New("Cruiser Group was destroyed, New Cruiser in 15 minutes",30,"Training Command"):ToAll()
    SCHEDULER:New(nil,function() 
        cruisergroup = SPAWN:New("Crusier"):Spawn()
        MESSAGE:New("New Cruiser is Active",30,"Training Command"):ToAll()
      end,{},(60*15))  
  end 
  if EventData.IniGroupName == sg1:GetName() then
    MESSAGE:New("Tanker Group was destroyed, New tanker in 15 minutes",30,"Training Command"):ToAll()
    SCHEDULER:New(nil,function() 
        sg1 = SPAWN:New("ShipGroup1"):Spawn()
        MESSAGE:New("New Tanker Group is Active",30,"Training Command"):ToAll()
      end,{},(60*15))  
  end
  if EventData.IniGroupName == arco:GetName() then
    MESSAGE:New("ARCO was destroyed, New tanker in 1 minute",30,"Training Command"):ToAll()
    SCHEDULER:New(nil,function() 
        arco = SPAWN:New("ARC"):Spawn()
        MESSAGE:New("New ARCO is Active",30,"Training Command"):ToAll()
      end,{},(60*1))  
  end  
  if EventData.IniGroupName == tex:GetName() then
    MESSAGE:New("TEXACO was destroyed, New tanker in 1 minute",30,"Training Command"):ToAll()
    SCHEDULER:New(nil,function() 
        tex = SPAWN:New("TEX"):Spawn()
        MESSAGE:New("New TEXACO is Active",30,"Training Command"):ToAll()
      end,{},(60*1))  
  end  
end
-- handle our ejection

function respawntanker()
  arco:Destroy()
  arco = SPAWN:New("ARC"):Spawn()
  tex:Destroy()
  tex = SPAWN:New("TEX"):Spawn()
  MESSAGE:New("Tankers should be respawned",15):ToAll()
end

function respawnoverlord()
  overlord:Destroy()
  overlord = SPAWN:New("Overlord"):Spawn()
  MESSAGE:New("Overlord should be respawned",15):ToAll() 
end
group1 = GROUP:FindByName("group1")
group2 = GROUP:FindByName("group2")
group3 = GROUP:FindByName("group3")
sa15 = GROUP:FindByName("SA15")
sa10 = GROUP:FindByName("SA10")
function respawnground()
  group1:Destroy()
  group1 = SPAWN:New("group1"):Spawn()
  group2:Destroy()
  group2 = SPAWN:New("group2"):Spawn()
  group3:Destroy()
  group3 = SPAWN:New("group3"):Spawn()
  MESSAGE:New("Ground Units should be respawned",15):ToAll()
end

function spawn10()
  sa10:Destroy()
  sa10spawn = true
  sa10 = SPAWN:New("SA10"):Spawn()
  MESSAGE:New("SA10 Spawned at Sukhumi",15):ToAll()
  bground10:Remove()
  bgroundd10 = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Destroy SA10",b_menu,despawn10)
end
function despawn10()
  sa10:Destroy()
  sa10spawn = false
  MESSAGE:New("SA 10 should be dead",15):ToAll()
  bgroundd10:Remove()
  bground10 = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Spawn SA10",b_menu,spawn10)
end

function spawn15()
  sa15:Destroy()
  sa15 = SPAWN:New("SA15"):Spawn()
  sa15spawn = true
  MESSAGE:New("SA 10 should be spawned at Sukhumi",15):ToAll()
  bground15:Remove()
  bgroundd15 = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Destroy SA15",b_menu,despawn15)
  
end
function despawn15()
  sa15:Destroy()
  sa15sapwn = false
  bgroundd15:Remove()
  MESSAGE:New("SA 15 should be dead",15):ToAll()
  bground15 = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Spawn SA15",b_menu,spawn15)
end

function spawnair()
  attacker:Destroy()
  attacker = SPAWN:New("Attacker"):Spawn()
  MESSAGE:New("SU27 x 2 Spawned Near Sukhumi",15):ToAll()
  bairspawn:Remove()
  attackerspawn = true
  bairdestroy = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Destroy Air threat",b_menu,despawnair)
end
function despawnair()
  attacker:Destroy()
  bairdestroy:Remove()
  attackerspawn = false
  MESSAGE:New("SU27 x 2 Should be despawned",15):ToAll()
  bairspawn = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Spawn Air threat",b_menu,spawnair)
end
b_menu = MENU_COALITION:New(coalition.side.BLUE,"Spawning Controls")
barco = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Respawn Tankers",b_menu,respawntanker)
bover = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Respawn Overlord",b_menu,respawnoverlord)
bground = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Respawn Ground Targets",b_menu,respawnground)
bground10 = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Spawn SA10",b_menu,spawn10)
bground15 = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Spawn SA15",b_menu,spawn15)
bairspawn = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Spawn Air threat",b_menu,spawnair)


AirbossStennis = AIRBOSS:New("Stennis","Mother")
-- Delete auto recovery window.
function AirbossStennis:OnAfterStart(From,Event,To)
  self:DeleteAllRecoveryWindows()
end
AirbossStennis:Load()
AirbossStennis:SetMarshalRadio(305)
AirbossStennis:SetLSORadio(118.30)
AirbossStennis:SetTACAN(55,"X","STN")
AirbossStennis:SetSoundfilesFolder("Airboss Soundfiles/")
AirbossStennis:SetAirbossNiceGuy(true)
AirbossStennis:SetDespawnOnEngineShutdown(true)
AirbossStennis:SetRefuelAI(20)
AirbossStennis:SetMenuRecovery(30,25,false,30)
AirbossStennis:SetHoldingOffsetAngle(0)
AirbossStennis:SetMenuSingleCarrier(true)
AirbossStennis:Start()

 SCHEDULER:New(nil,function()
  if attackerspawn == true then
    if attacker:IsAlive() ~= true then
      attacker:Destroy()
      bairdestroy:Remove()
      attackerspawn = false
      MESSAGE:New("SU27 x 2 have Been Destroyed Respawn avalible.",15):ToAll()
      bairspawn = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Spawn Air threat",b_menu,spawnair)
    end
  end
  if sa10spawn == true then
    if sa10:IsAlive() ~= true then
      sa10:Destroy()
      sa10spawn = false
      MESSAGE:New("SA 10 is reporting dead, Respawn Avalible",15):ToAll()
      bgroundd10:Remove()
      bground10 = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Spawn SA10",b_menu,spawn10)
    end
  end
  if sa15spawn == true then
    if sa15:IsAlive() ~= true then
      sa15:Destroy()
      sa15sapwn = false
      bgroundd15:Remove()
      MESSAGE:New("SA 15 should be dead, Respawn Avalible",15):ToAll()
      bground15 = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Spawn SA15",b_menu,spawn15)
    end
  end
 end,{},5,5)


 
 function playercheck()
   clients:ForEachClient(function(PlayerClient) 
      local PlayerID = PlayerClient.ObjectName
        --PlayerClient:AddBriefing("Welcome to Red Iberia Rob Graham Version: "..version.." \n Last updated:".. lastupdate .." \n POWERED BY MOOSE \n Current Server time is: ".. nowHour .. ":" .. nowminute .."\n Mission Restart time:".. restarttime .. "\n No Blue on Blue is Allowed \n Your current objective is to ".. blueobject .."\n" ..bcomms .. "\n Remember Stores and Aircraft are limited and take time to resupply")
        if PlayerClient:GetGroup() ~= nil then
          local group = PlayerClient:GetGroup()
        end
         if PlayerClient:IsAlive() then
           if PlayerBMap[PlayerID] ~= true then
                PlayerBMap[PlayerID] = true
                MESSAGE:New("Welcome to TGW Training Server By Rob Graham \n Last updated:".. lastupdate .." \n POWERED BY MOOSE & MIST\n You need to be on Discord and SRS if possible please. \nIf Rob,SierraMikeBravo or another TGW admin says something pay attention. Otherwise Consential Blue on Blue is allowed.",60):ToClient(PlayerClient)
           end    
         else
          if PlayerBMap[PlayerID] ~= false then
                PlayerBMap[PlayerID] = false
          end
       end
    end)
 
 end

 SCHEDULER:New(nil,playercheck,{},1,10)
 
 
 
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
    MESSAGE:New(weatherString, 30, MESSAGE.Type.Information):ToAll()
    MESSAGE:New(weatherString1, 30, MESSAGE.Type.Information):ToAll()
    MESSAGE:New(weatherString2, 30, MESSAGE.Type.Information):ToAll()
    MESSAGE:New(weatherString5, 30, MESSAGE.Type.Information):ToAll()
    MESSAGE:New(weatherString10, 30, MESSAGE.Type.Information):ToAll()
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
    elseif Event.text:lower():find("-redsmoke") then
     coord:SmokeRed()
    elseif Event.text:lower():find("-bluesmoke") then
      coord:SmokeBlue()
    elseif Event.text:lower():find("-greensmoke") then
      coord:SmokeGreen()
    elseif Event.text:lower():find("-orangesmoke") then
      coord:SmokeOrange()
    elseif Event.text:lower():find("-whitesmoke") then
      coord:SmokeWhite()  
    elseif Event.text:lower():find("-flare") then
      coord:FlareRed(math.random(0,360))
      SCHEDULER:New(nil,function() 
      coord:FlareRed(math.random(0,20))
      end,{},30)
    elseif Event.text:lower():find("-ribexplode") then
      MESSAGE:New("Admin command used something is gonna blow up in 10 seconds",15):ToAll()
      coord:Explosion(500,10)
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
 
 
 do
    nowTable = os.date('*t')
    nowYear = nowTable.year
    nowMonth = nowTable.month
    nowDay = nowTable.day
    nowHour = nowTable.hour
    nowminute = nowTable.min
end
BASE:E({"TRAINING MISSION END"})
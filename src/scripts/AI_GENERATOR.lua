env.info("FIGHTER SWEEP SCRIPT VERSION 0.5")
function CONTROLLABLE:OptionRestrictBurner(d1)
  self:E({self.ControllableName})
  local DCSControllable = self:GetDCSObject()
  if DCSControllable then
    local Controller = self:_GetController()
    if d1 == true then
      if self:IsAir() then
        Controller:setOption(16,true)
      end
    else
      if self:IsAir() then
        Controller:setOption(16,false)
      end
    end
  end
end

BASE:E("AI GEN LOADED")
AI_RTASKING = {
    ClassName = "AI_RTASKING",
}
--- Sets up an AWACS FSM which can be told to go to a zone and orbit it. Using Extra options you can also set up a racetrack etc.
-- @param #Group AIGroup the controllable group that you want this to effect.
-- @param #Zone The zone object for the Orbit point.
-- @param #coord a coordinate to use instead of a zone 
-- @param #Bool if you want to use a coordinate instead of the zone.
-- @param #int OrbitAlt altitude to orbit in meters.
-- @param #int Orbitspeed speed at which to orbit in kmph.
-- returns self.
function AI_RTASKING:New(AIGroup, name, Tasking, TaskingZone, Package,homebase)
    local self = BASE:Inherit(self, AI_AIR:New(AIGroup))
    self.name = name
    self:AddTransition("*","Route","*")
        
    self.MinAltitude = UTILS.FeetToMeters(12000)
    self.MaxAltitude = UTILS.FeetToMeters(42000)
    self.MinSpeed = UTILS.KnotsToKmph(400)
    self.MaxSpeed = UTILS.KnotsToKmph(500)
    self:SetRTBSpeed(self.MinSpeed,self.MaxSpeed)
    self:SetSpeed(self.MinSpeed,self.MaxSpeed)
    self:SetAltitude(self.MinAltitude,self.MaxAltitude)
    
    self:SetDamageThreshold(0.4)
    self:SetFuelThreshold(0.15)
    self:SetHomeAirbase(AIRBASE:FindByName(homebase))
    if Tasking == "CAP" then
      self.engagedistance = 40
      self:SetDisengageRadius(UTILS.NMToMeters(40))
    else
      self.engagedistance = 80
      self:SetDisengageRadius(UTILS.NMToMeters(250))
    end
    self.Engaging = false
    self.Accomplished = false
    self.taskingzone = TaskingZone
    self.Tasking = Tasking
    self.package = Package
    return self
end

function AI_RTASKING:onafterStart(Controllable,From,Event,To)
  BASE:E({self.name,"Inside RTASKING:OnAfterStart",self.Tasking})
   self:__Status( 10 ) -- Check status status every 30 seconds.
  
  self:HandleEvent( EVENTS.PilotDead, self.OnPilotDead )
  self:HandleEvent( EVENTS.Crash, self.OnCrash )
  self:HandleEvent( EVENTS.Ejection, self.OnEjection )
  
  Controllable:OptionROEHoldFire()
  Controllable:OptionROTVertical()
  self:Route()
  
end
function AI_RTASKING:onafterHome(AIGROUP,From,Event,To)
 BASE:E({self.name,"Inside RTASKING:OnafterHome"})
 if AIGroup and AIGroup:IsAlive() then
  BASE:E({self.name,"Is Home, Destroying to clean it up"})
  AIGroup:Destroy()
 end
end

function AI_RTASKING:onafterRoute(AIGroup,From,Event,To)
  if self.Controllable:IsAlive() then
    BASE:E({self.name,"On After Route",self.Tasking})
    if (self.Tasking == "Sweep") then
      self:SetFSTask(self.taskingzone)
    elseif (self.Tasking == "CAP") then
      self:SetCapTask(self.taskingzone)
    end
  end
end

--- Creates a Fighter Sweep Tasking
-- @function [parent=#AI_RTASKING
-- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
function AI_RTASKING:SetFSTask(TaskingZone)
  BASE:E({self.name,"FS TASKING"})
  distance = 1000 
  local taskingCoord = TaskingZone:GetRandomCoordinate() -- this gets us our random coordinate point
  local startCoord startCoord = self.Controllable:GetCoordinate() -- Our starting Zone.
  local whilecounter = 0
  distance = startCoord:Get2DDistance(taskingCoord) -- Distance to the coord so we can work wit it.
  BASE:E({self.name,"Distance",distance})
  while ((UTILS.MetersToNM(distance) > 250)) do   
    BASE:E({self.name,"Distance was > 250",UTILS.MetersToNM(distance),whilecounter})
    taskingCoord = TaskingZone:GetRandomCoordinate() -- this gets us our random coordinate point
    distance = startCoord:Get2DDistance(taskingCoord) -- Distance to the coord so we can work wit it.
    BASE:E({self.name,"Distance now is",UTILS.MetersToNM(distance),whilecounter})
    whilecounter = whilecounter + 1
    if whilecounter > 20 then
      BASE:E({self.name,"WHILE COUNTER IS OVER 60 Breakout of the loop"})
      break
    end
  end
  local headingto = startCoord:HeadingTo(taskingCoord) -- heading from our current point ot the target coord.
  local lr = math.random(0,1) -- are we going left or right.
  local wpsplit = (distance / 2) / math.random(1,4) -- were we want to move wp 3 and 5 by
  if UTILS.MetersToNM(wpsplit) > 80 then
    BASE:E({self.name,"WP Split 1 was over 80nm clamping"})
    wpsplit = UTILS.NMToMeters(80)
  end
  local d1 = distance - wpsplit -- gives us the actual distance
  local d2 = d1 / 3-- gives us the actual distance
  if d2 < 5000 then
    d2 = 5000
  end
  local altitude = math.random(self.MinAltitude,self.MaxAltitude)
  if UTILS.MetersToFeet(altitude) < 10000 then
    altitude = UTILS.FeetToMeters(19000)
  end
  BASE:E({self.name,"Altitude for mission will be",altitude})
  local h1 = 0 -- heading offset 1
  local h2 = 0 -- heading offset 2
  local wp = {}
  local tasks = {}
  local Waypoints = {}
  BASE:E({self.name,"start making wp's"})
  -- make our first wp
  local coordalt = startCoord:GetLandHeight()
  if (startCoord.y == coordalt) or (startCoord.y < (coordalt + 50)) then
    startCoord.y = startCoord.y + UTILS.FeetToMeters(500) -- add 500 ft to our start coord.
  end
  if lr == 0 then
   h1 = headingto - math.random(10,25) -- if we are left neg the first 
   h2 = headingto + math.random(10,25) -- plus the second
  else
   h1 = headingto + math.random(10,25) -- if we are right plus the first
   h2 = headingto - math.random(10,25) -- neg the second.
  end
 -- now make certain we don't have values over 360 or under 0.
  if h1 < 0 then
    h1 = h1 + 360
  elseif h1 > 360 then
      h1 = h1 - 360
  end
  if h2 < 0 then
    h2 = h2 + 360
  elseif h2 > 360 then
    h2 = h2 - 360
  end
  
  local t1 = startCoord:Translate(500,math.random(0,359))
  t1.y = t1.y + UTILS.FeetToMeters(1500)
  local c1 = startCoord:Translate(d1,h1) -- create wp 3 co
  c1.y = altitude
  local c2 = startCoord:Translate(d1,h2) -- create wp 5 co.
  c2.y = altitude
  
  local c1_1 = startCoord:Translate(d2,h1)
  c1_1.y = altitude
  local c2_1 = startCoord:Translate(d2,h2)
  c2_1.y = altitude
  taskingCoord.y = altitude
  BASE:E({"WP1"})
  wp[1] = startCoord:WaypointAirTakeOffRunway("Baro",UTILS.KnotsToKmph(250))
  wp[2] = t1:WaypointAirTurningPoint("BARO",UTILS.KnotsToKmph(350),nil,"Take off")
  wp[3] = c1_1:WaypointAirTurningPoint("BARO",UTILS.KnotsToKmph(450),nil,"Fence In")
  self.Controllable:OptionRestrictBurner(true)
  tasks = self.Controllable:EnRouteTaskEngageTargets(UTILS.NMToMeters(self.engagedistance),{"Air","Missile"},1)
  self.Controllable:SetTaskWaypoint(wp[2],tasks)
  tasks = self.Controllable:TaskFunction("AI_RTASKING:FenceIn",self.Controllable)
  self.Controllable:SetTaskWaypoint(wp[3],tasks)
  BASE:E({"WP3"})
  wp[4] = c1:WaypointAirTurningPoint("BARO",math.random(self.MinSpeed,self.MaxSpeed),nil,"Sweep 1")
  BASE:E({"WP4"})
  wp[5] = taskingCoord:WaypointAirTurningPoint("BARO",math.random(self.MinSpeed,self.MaxSpeed),nil,"Sweep 2")
  BASE:E({"WP5"})
  wp[6] = c2:WaypointAirTurningPoint("BARO",math.random(self.MinSpeed,self.MaxSpeed),nil,"Sweep 3")
  BASE:E({"WP5"})
  wp[7] = c2_1:WaypointAirTurningPoint("BARO",UTILS.KnotsToKmph(450),nil,"Fence Out")
  tasks = self.Controllable:TaskFunction("AI_RTASKING:FenceOut",self.Controllable)
  self.Controllable:SetTaskWaypoint(wp[7],tasks)
  wp[8] = startCoord:WaypointAir("BARO",_type,_action,UTILS.KnotsToKmph(350),true,self.HomeAirbase,nil,"home")
  BASE:E({"WP6"})
  wp[9] = startCoord:WaypointAirLanding(UTILS.KnotsToMps(250),self.HomeAirbase,nil,"Landing")
  BASE:E({"Task WP"})
  for i,p in ipairs(wp) do
    table.insert(Waypoints,i,wp[i])
  end
  BASE:E({"Route"})
  self.Controllable:Route(Waypoints, 0.5)
  BASE:E({"Done"})
end

function AI_RTASKING:FenceIn(AIGroup,ROE)
  BASE:E({self.name,"Fence IN"})
  if ROE == "free" then
    AIGroup:OptionROEWeaponFree(true)
  elseif ROE == "return" then
    AIGroup:OptionROEReturnFire()
  end
  AIGroup:OptionROTEvadeFire(true)
  AIGroup:OptionRTBBingoFuel(true)
  AIGroup:OptionRestrictBurner(false)
end

function AI_RTASKING:FenceOut(AIGroup)
  BASE:E({self.name,"Fence OUT"})
  AIGroup:OptionROEReturnFire(true)
  AIGroup:OptionROTEvadeFire(true)
  AIGroup:OptionRTBBingoFuel(true)
  AIGroup:OptionRestrictBurner(true)
end

function AI_RTASKING:onafterHome(AIGroup, From,Event,To)
  BASE:E({self.name,"Inside onafterHome"})
  self:E("Group".. self.Controllable:GetName() .." ... Home")
  if AIGroup and AIGroup:IsAlive() then
     AIGroup:Destroy(true)
  end
end
--- Creates a CAP Tasking
-- @function [parent=#AI_RTASKING
-- @param Wrapper.Controllable#CONTROLLABLE Controllable The Controllable Object managed by the FSM.
function AI_RTASKING:SetCapTask(TaskingZone)
  BASE:E({self.name,"CAP TASKING"})
  local taskingCoord = TaskingZone:GetRandomCoordinate() -- this gets us our random coordinate point
  local startCoord = self.Controllable:GetCoordinate() -- Our starting Zone.
  local distance = startCoord:Get2DDistance(taskingCoord) -- Distance to the coord so we can work wit it.
  local headingto = startCoord:HeadingTo(taskingCoord) -- heading from our current point ot the target coord.
  local capleg = math.random(UTILS.NMToMeters(10,25))
  local capheading = math.random(0,359)
  local lr = math.random(0,1) -- are we going left or right.
  local wpsplit = (distance / 2) / math.random(1,4) -- were we want to move wp 3 and 5 by
  local d1 = distance - wpsplit -- gives us the actual distance
  local altitude = math.random(self.MinAltitude,self.MaxAltitude)
  local h1 = 0 -- heading offset 1
  local h2 = 0 -- heading offset 2
  local wp = {}
  local tasks = {}
  local Waypoints = {}
  local duration = (30*60)
  BASE:E({self.name,"start making wp's"})
  -- make our first wp
  local coordalt = startCoord:GetLandHeight()
  if (startCoord.y == coordalt) or (startCoord.y < (coordalt + 50)) then
    startCoord.y = startCoord.y + UTILS.FeetToMeters(500) -- add 500 ft to our start coord.
  end
  if lr == 0 then
   h1 = headingto - math.random(0,5) -- if we are left neg the first 
   h2 = headingto + math.random(0,5) -- plus the second
  else
   h1 = headingto + math.random(10,20) -- if we are right plus the first
   h2 = headingto - math.random(10,20) -- neg the second.
  end
  
 -- now make certain we don't have values over 360 or under 0.
  if h1 < 0 then
    h1 = h1 + 360
  elseif h1 > 360 then
      h1 = h1 - 360
  end
  if h2 < 0 then
    h2 = h2 + 360
  elseif h2 > 360 then
    h2 = h2 - 360
  end
  local t1 = startCoord:Translate(500,math.random(0,359))
  t1.y = t1.y + UTILS.FeetToMeters(500)
  local c1 = startCoord:Translate(wpsplit,h1) -- create wp 3 co
  c1.y = altitude
  local c2 = startCoord:Translate(wpsplit,h2) -- create wp 5 co.
  c2.y = altitude
  taskingCoord.y = altitude
  local oc = taskingCoord:Translate(capleg,capheading)
  BASE:E({"WP1"})
  wp[1] = startCoord:WaypointAirTakeOffRunway("Baro",UTILS.KnotsToKmph(250))
  wp[2] = t1:WaypointAirTurningPoint("BARO",UTILS.KnotsToKmph(350),nil,"Take off")
  BASE:E({"WP2"})
  wp[3] = c1:WaypointAirTurningPoint("BARO",math.random(self.MinSpeed,self.MaxSpeed),nil,"Fence In")
  tasks = self.Controllable:EnRouteTaskEngageTargets(UTILS.NMToMeters(self.engagedistance),{"Air","Missile"},1) 
  self.Controllable:SetTaskWaypoint(wp[2],tasks)
  tasks = self.Controllable:TaskFunction("AI_RTASKING:FenceIn",self.Controllable)
  self.Controllable:SetTaskWaypoint(wp[3],tasks)
  BASE:E({"WP3"})
  
  local taskorbit = self.Controllable:TaskOrbit(taskingCoord,altitude,UTILS.KmphToMps(math.random(self.MinSpeed,self.MaxSpeed)),oc)
  local taskcond = self.Controllable:TaskCondition(nil,nil,nil,nil,duration,nil)
  local taskcont = self.Controllable:TaskControlled(taskorbit, taskcond)
  wp[4] = taskingCoord:WaypointAirTurningPoint("BARO",math.random(self.MinSpeed,self.MaxSpeed),{taskcont},"Cap Hold")
  BASE:E({"WP4"})
  wp[5] = c2:WaypointAirTurningPoint("BARO",math.random(self.MinSpeed,self.MaxSpeed),nil,"Fence Out")
  tasks = self.Controllable:TaskFunction("AI_RTASKING:FenceOut",self.Controllable)
  self.Controllable:SetTaskWaypoint(wp[4],tasks)
  BASE:E({"WP5"})
  wp[6] = startCoord:WaypointAir("BARO",_type,_action,UTILS.KnotsToKmph(350),true,self.HomeAirbase,nil,"home")
  BASE:E({"WP6"})
  wp[7] = startCoord:WaypointAirLanding(UTILS.KnotsToMps(250),self.HomeAirbase,nil,"Landing")
  BASE:E({"Build Route"})
  for i,p in ipairs(wp) do
    table.insert(Waypoints,i,wp[i])
  end
  BASE:E({"Send Route "})
  self.Controllable:Route(Waypoints, 0.5)
  BASE:E({"Done"})
end



RTEMPS = {"SQN113-1","SQN113-2","SQN113-3","SQN113-4","SQN112-1","SQN112-2","SQN112-3","SQN112-4","SQN112-5","SQN112-6"}
BSWEEP = ZONE_POLYGON:New("BlueSweep",GROUP:FindByName("BSWEEPSPACE"))
NovoSqnSweep = nil
novnum = 1
krasspawn = false
novospawn = false
KrasSqnSweep= nil
krasnum = 1
local novsweepspawn = SPAWN:NewWithAlias("NovoSqnSweep","Tempest"..novnum.."1"):InitRandomizeTemplate(RTEMPS):OnSpawnGroup(function(Spawngroup)
    BASE:E("Spawning New NovoSweep SQN")
    if NovoSqnSweep == nil then
      NovoSqnSweep = Spawngroup
    else
      if NovoSqnSweep:IsAlive() == true then
        NovoSqnSweep:Destroy()
        NovoSqnSweep = Spawngroup
      else
        NovoSqnSweep = Spawngroup
      end
    end
    novnum = novnum + 1
    novospawn = false
    local rtasking = AI_RTASKING:New(Spawngroup,Spawngroup:GetName(),"Sweep",BSWEEP, "NovoSweep",AIRBASE.Caucasus.Novorossiysk)
    rtasking:__Start(2)
    RCC:MessageToCoalition("Fighter Sweep Tempest"..novnum.."1 taxing and taking off Novorossyisk")
    end)

local krassweepspawn = SPAWN:NewWithAlias("KrasSqnSweep","Angel".. krasnum .. "1"):InitRandomizeTemplate(RTEMPS):OnSpawnGroup(function(Spawngroup)
    BASE:E("Spawning New KrasSweep SQN")
    if KrasSqnSweep == nil then
      KrasSqnSweep = Spawngroup
    else
      if KrasSqnSweep:IsAlive() == true then
        KrasSqnSweep:Destroy()
        KrasSqnSweep = Spawngroup
      else
        KrasSqnSweep = Spawngroup
      end
    end
    krasnum = krasnum + 1
    krasspawn = false
    local rtasking = AI_RTASKING:New(Spawngroup,Spawngroup:GetName(),"Sweep",BSWEEP, "KrasSweep",AIRBASE.Caucasus.Krasnodar_Pashkovsky)
    rtasking:__Start(2)
    RCC:MessageToCoalition("Fighter Sweep Angel"..krasnum.."1 taxing and taking off Krasnador")
    end)
function checksweep()
if krasspawn == false then        
  if KrasSqnSweep == nil then
    local ttime = math.random((60*15),(60*30))
      local mtime = ttime/60
    krasspawn = true
    BASE:E({"KRASSQNSWEEP IS NIL! scheduling a spawn in minutes::",mtime})
    if RSweepAmount > 3 then
        RSweepAmount = RSweepAmount - 4
        if RSweepAmount < 0 then 
        RSweepAmount = 0
        end
        local tkrascommand = GROUP:FindByName("Krascommand")
        if tkrascommand:IsAlive() then
          SCHEDULER:New(nil,function() 
            krassweepspawn:Spawn()
          end,{},ttime)
        end
    end
  else
    if (KrasSqnSweep:AllOnGround() == true and KrasSqnSweep:GetVelocityKNOTS() < 5) or KrasSqnSweep:IsAlive() == false then
      local ttime = math.random((60*30),(60*60))
      local mtime = ttime/60
      BASE:E({"KRASSQNSWEEP IS NOT ALIVE OR NOT MOVING! scheduling a spawn in minutes::",mtime})
      krasspawn = true
      if RSweepAmount > 3 then
        RSweepAmount = RSweepAmount - 4
        if RSweepAmount < 0 then 
        RSweepAmount = 0
        end
       local tkrascommand = GROUP:FindByName("Krascommand")
        if tkrascommand:IsAlive() then
          SCHEDULER:New(nil,function() 
            krassweepspawn:Spawn()
          end,{},ttime)
        end
      end
    end
  end
else
BASE:E({"Sweep Timer, Kras Already Scheduled"})
end 
if novospawn == false then        
  if NovoSqnSweep == nil then
    local ttime = math.random((60*15),(60*30))
    local mtime = ttime/60
    novospawn = true
    BASE:E({"NOVOSQNSWEEP IS NIL! scheduling a spawn in minutes::",mtime})
    if RSweepAmount > 3 then
      RSweepAmount = RSweepAmount - 4
      if RSweepAmount < 0 then 
        RSweepAmount = 0
      end
      local tnovocommand = GROUP:FindByName("Novocommand")
        if tnovocommand:IsAlive() then
          SCHEDULER:New(nil,function() 
      novsweepspawn:Spawn()
          end,{},ttime)
        end
      
    end
  else
    if (NovoSqnSweep:AllOnGround() == true and NovoSqnSweep:GetVelocityKNOTS() < 5) or NovoSqnSweep:IsAlive() == false then
      local ttime = math.random((60*30),(60*60))
      local mtime = ttime/60
      BASE:E({"NOVOSQNSWEEP IS NOT ALIVE OR NOT MOVING! scheduling a spawn in minutes::",mtime})
      novospawn = true
      if RSweepAmount > 3 then
        RSweepAmount = RSweepAmount - 4
        if RSweepAmount < 0 then 
          RSweepAmount = 0
        end
       local tnovocommand = GROUP:FindByName("Novocommand")
        if tnovocommand:IsAlive() then
          SCHEDULER:New(nil,function() 
      novsweepspawn:Spawn()
          end,{},ttime)
        end
      end
    end
  end
else
BASE:E({"Sweep Timer, Nov Already Scheduled"})
end
end

sweeptimer, SchedulerID = SCHEDULER:New(nil,function()
BASE:E({"Running Sweep Timer"})
checksweep()
end,{},5,(60*45))
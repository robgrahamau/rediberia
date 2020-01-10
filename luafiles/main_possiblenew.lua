version = "2.2.4"
lastupdate = "10-JAN-2020 2040AUEDST"

env.info("----------------------------------------------------------")
env.info("--------------RED IBERIA VERSION ".. version .."----------------------")
env.info("--------------last update:" .. lastupdate .. "-----------------------------------")
env.info("--------------By Robert Graham for TGW -------------------")
env.info("--------------USES MOOSE AND CTDL ------------------------")
do
nowTable = os.date('*t')
nowYear = nowTable.year
nowMonth = nowTable.month
nowDay = nowTable.day
nowHour = nowTable.hour
nowminute = nowTable.min
nowDaylightsavings = nowTable.isdst
nowDayofYear = nowTable.yday
nowDayofWeek = nowTable.wday
starttime = "" .. nowHour .. ":" .. nowminute .. ""
restarthour = nowHour + 6
if restarthour > 23 then 
  restarthour = restarthour - 24
end

restarttime = "" .. restarthour ..":".. nowminute ..""
end
env.info("---------- start time:".. starttime .. "------------------")
env.info("---------- restart time:".. restarttime .. "------------------")
trigger.action.setUserFlag("SSB",100)

 function AI_A2A_DISPATCHER:ReinforceSquadron(SquadronName,Amount)
    DefenderSquadron = self:GetSquadron( SquadronName )
    if DefenderSquadron.ResourceCount then
      DefenderSquadron.ResourceCount = DefenderSquadron.ResourceCount + Amount
    end
    self:F( { Squadron = DefenderSquadron, SquadronResourceCount = DefenderSquadron.ResourceCount } )
  end


 function AI_A2A_DISPATCHER:GetSquadronAmount(SquadronName)
    DefenderSquadron = self:GetSquadron( SquadronName )
        self:F( { Squadron = DefenderSquadron, SquadronResourceCount = DefenderSquadron.ResourceCount } )
    return DefenderSquadron.ResourceCount 
  end
--- Returns a random ground formation
function randomform()
  local rndnum = math.random(1,7)
  BASE:E({"Random Form number is",rndnum})
  if rndnum == 1 then
    return "Off road"
  elseif rndnum == 2 then
    return "Line abreast"
  elseif rndnum == 3 then
    return "Cone"
  elseif rndnum == 4 then
    return "Vee"
  elseif rndnum == 5 then
    return "Diamond"
  elseif rndnum == 6 then
    return "Echelon Left"
  elseif rndnum == 7 then
    return "Echelon Right"
  else
    return "Vee"   
  end
end
SupportHandler = EVENTHANDLER:New()

function _split(str, sep)
  BASE:E({str=str, sep=sep})  
  local result = {}
  local regex = ("([^%s]+)"):format(sep)
  for each in str:gmatch(regex) do
    table.insert(result, each)
  end
  return result
end


-------- Main CONSTANT Variables ----------
roundreset = 8 -- This sets how many rounds before we reset to round one. each round is 6 hours so 4 = 24, 8 = 48. etc.
ribadmin = false
JTAC_COOLDOWN = (10)*60
F15_COOLDOWN = (2)*60
SU27_COOLDOWN = (2)*60
TANKER_COOLDOWN = (15)*60
Round_COOLDOWN = ((60*60)*5)+(60*50)
CurrentRound = 0
LastRound = 0
round_Timer = 0
F15_Timer = 0
SU27_Timer = 0
FAC1_Timer = 0
TEX_Timer = 0
ARC_Timer = 0
ARC2_Timer = 0
RSHEL2_Timer = 0
lastclientcount = 0
noclients = 0
nooclients = true
RESETALL = 0
BlueHq = GROUP:FindByName("BHQ") -- blue hq
BCC = COMMANDCENTER:New(BlueHq,"Coalition HQ")
lsosavepath = "D:\\lsodata\\"
RedHq = GROUP:FindByName("RHQ") -- red hq items
RCC = COMMANDCENTER:New(RedHq,"Russian HQ")
RAS = ZONE_POLYGON:New("RAS",GROUP:FindByName("RAS"))
RAS1 = ZONE_POLYGON:New("RAS1",GROUP:FindByName("RAS1")) -- red airspace
RAS2 = ZONE_POLYGON:New("RAS2",GROUP:FindByName("RAS2")) -- red airspace
BAS = ZONE_POLYGON:New("BAS",GROUP:FindByName("BAS"))
BAS1 = ZONE_POLYGON:New("BAS1",GROUP:FindByName("BAS1")) -- bull airspace
SAS = ZONE_POLYGON:New("SAS",GROUP:FindByName("SAS")) -- Stennis airspace
SAS1 = ZONE_POLYGON:New("SAS1",GROUP:FindByName("SAS1")) -- Stennis airspace
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
BInsurgentZones = {ZONE:New("BZONE1"),ZONE:New("BZONE2"),ZONE:New("BZONE3"),ZONE:New("BZONE4"),ZONE:New("BZONE5"),ZONE:New("BZONE6")}
InsurgentZones = {ZONE:New("SPOT1"),ZONE:New("SPOT2"),ZONE:New("SPOT3"),ZONE:New("SPOT4"),ZONE:New("SPOT5"),ZONE:New("SPOT6"),ZONE:New("SPOT7")}
InsurgentCount = 0
RAttackSpawnZone = ZONE_POLYGON:New("RedAttackSpawnZone",GROUP:FindByName("RedAttack")) -- RED AREA THAT CAN BE SPAWNED IN WHEN ATTACKING.
BAttackSpawnZone = ZONE_POLYGON:New("BlueAttackSpawnZone",GROUP:FindByName("BlueAttack")) -- Blue Attack SPAWN zone.
RDefSpawnZone = ZONE_POLYGON:New("RedDefenceSpawnZone",GROUP:FindByName("RedDefence")) -- Red defence spawn area
BDefSpawnZone = ZONE_POLYGON:New("BlueDefenceSpawnZone",GROUP:FindByName("BlueDefence")) -- blue defence spawn area.
LandZone = ZONE_POLYGON:New("LandZone",GROUP:FindByName("landZone")) -- this is our land zone when we are routing shit we want to make certain the ground stuff is inside it.
RCAPTEMPLATES = { "SQN112-1","SQN112-2", "SQN112-3","SQN112-4","SQN112-5","SQN112-6"}
BCAPTEMPLATES = {"SQN147-1","SQN147-2","SQN147-2"}
-- RDETGROUP = SET_GROUP:New():FilterPrefixes({ "REWR","Wizard","RSAM",}):FilterStart()
BDETGROUP = SET_GROUP:New():FilterPrefixes({"BEWR","Overlord","Magic","BSAM",}):FilterStart()
SetPlayer = SET_CLIENT:New():FilterStart()
SetPlayerRed = SET_CLIENT:New():FilterCoalitions("red"):FilterStart()
SetPlayerBlue = SET_CLIENT:New():FilterCoalitions("red"):FilterStart()
Scoring = SCORING:New("Scoring")
redobject = ""
rcomms = ""
bcomms = ""
blueobject = ""
GUDOWNER = 1
SUKOWNER = 1
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
-- store our zone coords
dg = GUDZONE:GetCoordinate()
ds = SUKZONE:GetCoordinate()
dse = SENZONE:GetCoordinate()
dk = KUTZONE:GetCoordinate()
dko = KOBZONE:GetCoordinate()
PlayerMap = {}
PlayerRMap = {}
PlayerBMap = {}
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
stennis = GROUP:FindByName("Stennis") -- get the stennis group

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

------------ SLOT BLOCKING FUNCTIONS ----------------
-----------------------------------------------------
--

--- Allows Blue Slots at kobuletie
  -- @param nil
  function allowbluekob()
    trigger.action.setUserFlag("RAAF F-18 Hot - KOB",0)
    trigger.action.setUserFlag("RAAF F-18 Hot - KOB #001",0)
    trigger.action.setUserFlag("RAAF F-18 Hot - KOB #002",0)
    trigger.action.setUserFlag("RAAF F-18 Hot - KOB #003",0)
    trigger.action.setUserFlag("RAAF F-18 C&D - KOB",0)
    trigger.action.setUserFlag("RAAF F-18 C&D - KOB #001",0)
    trigger.action.setUserFlag("RAAF F-18 C&D - KOB #002",0)
    trigger.action.setUserFlag("RAAF F-18 C&D - KOB #003",0)
    trigger.action.setUserFlag("USN F-14 VF103 HOT - KOB #002",0)
    trigger.action.setUserFlag("USN F-14 VF103 HOT - KOB #001",0)
    trigger.action.setUserFlag("USN F-14 VF103 HOT - KOB #003",0)
    trigger.action.setUserFlag("USN F-14 VF103 HOT - KOB",0)
    trigger.action.setUserFlag("USN F-14 VF103 C&D - KOB",0)
    trigger.action.setUserFlag("USN F-14 VF103 C&D - KOB #001",0)
    trigger.action.setUserFlag("USN F-14 VF103 C&D - KOB",0)
    trigger.action.setUserFlag("SWD - AJS37 - HOT",0)
    trigger.action.setUserFlag("SWD - AJS37 - HOT #001",0)
    trigger.action.setUserFlag("SWD - AJS37 - C&D #001",0)
    trigger.action.setUserFlag("SWD - AJS37 - C&D",0)
    trigger.action.setUserFlag("USMC F-18 HOT - KOB #001",0)
    trigger.action.setUserFlag("USMC F-18 HOT - KOB",0)
    trigger.action.setUserFlag("USMC F-18 C&D - KOB #001",0)
    trigger.action.setUserFlag("USMC F-18 C&D - KOB",0)
    trigger.action.setUserFlag("USAF - F16 - Kob - Hot",0)
    trigger.action.setUserFlag("USAF - F16 - Kob - Hot #001",0)
    trigger.action.setUserFlag("USAF - F16 - Kob - Hot #002",0)
    trigger.action.setUserFlag("USAF - F16 - Kob - Hot #003",0)
    trigger.action.setUserFlag("USAF - F16 - Kob - Hot #004",0)
    trigger.action.setUserFlag("USAF - F16 - Kob - Hot #005",0)
    trigger.action.setUserFlag("USAF - F16 - Kob - Hot #006",0)
    trigger.action.setUserFlag("USAF - F16 - Kob - Hot #007",0)
    trigger.action.setUserFlag("USAF - F16 - Kob - C&D",0)
    trigger.action.setUserFlag("USAF - F16 - Kob - C&D #001",0)
    trigger.action.setUserFlag("USAF - F16 - Kob - C&D #002",0)
    trigger.action.setUserFlag("USAF - F16 - Kob - C&D #003",0)
    BASE:E({"Blue Slots allowed at Kobuletie"})
  end
  --- disables blue forces at kobulette.
  -- @param nil.
  function disallowbluekob()
    trigger.action.setUserFlag("RAAF F-18 Hot - KOB",100)
    trigger.action.setUserFlag("RAAF F-18 Hot - KOB #001",100)
    trigger.action.setUserFlag("RAAF F-18 Hot - KOB #002",100)
    trigger.action.setUserFlag("RAAF F-18 Hot - KOB #003",100)
    trigger.action.setUserFlag("RAAF F-18 C&D - KOB",100)
    trigger.action.setUserFlag("RAAF F-18 C&D - KOB #001",100)
    trigger.action.setUserFlag("RAAF F-18 C&D - KOB #002",100)
    trigger.action.setUserFlag("RAAF F-18 C&D - KOB #003",100)
    trigger.action.setUserFlag("USN F-14 VF103 HOT - KOB #002",100)
    trigger.action.setUserFlag("USN F-14 VF103 HOT - KOB #001",100)
    trigger.action.setUserFlag("USN F-14 VF103 HOT - KOB #003",100)
    trigger.action.setUserFlag("USN F-14 VF103 HOT - KOB",100)
    trigger.action.setUserFlag("USN F-14 VF103 C&D - KOB",100)
    trigger.action.setUserFlag("USN F-14 VF103 C&D - KOB #001",100)
    trigger.action.setUserFlag("USN F-14 VF103 C&D - KOB",100)
    trigger.action.setUserFlag("SWD - AJS37 - HOT",100)
    trigger.action.setUserFlag("SWD - AJS37 - HOT #001",100)
    trigger.action.setUserFlag("SWD - AJS37 - C&D #001",100)
    trigger.action.setUserFlag("SWD - AJS37 - C&D",100)
    trigger.action.setUserFlag("USMC F-18 HOT - KOB #001",100)
    trigger.action.setUserFlag("USMC F-18 HOT - KOB",100)
    trigger.action.setUserFlag("USMC F-18 C&D - KOB #001",100)
    trigger.action.setUserFlag("USMC F-18 C&D - KOB",100)
    trigger.action.setUserFlag("USAF - F16 - Kob - Hot",100)
    trigger.action.setUserFlag("USAF - F16 - Kob - Hot #001",100)
    trigger.action.setUserFlag("USAF - F16 - Kob - Hot #002",100)
    trigger.action.setUserFlag("USAF - F16 - Kob - Hot #003",100)
    trigger.action.setUserFlag("USAF - F16 - Kob - Hot #004",100)
    trigger.action.setUserFlag("USAF - F16 - Kob - Hot #005",100)
    trigger.action.setUserFlag("USAF - F16 - Kob - Hot #006",100)
    trigger.action.setUserFlag("USAF - F16 - Kob - Hot #007",100)
    trigger.action.setUserFlag("USAF - F16 - Kob - C&D",100)
    trigger.action.setUserFlag("USAF - F16 - Kob - C&D #001",100)
    trigger.action.setUserFlag("USAF - F16 - Kob - C&D #002",100)
    trigger.action.setUserFlag("USAF - F16 - Kob - C&D #003",100)
    BASE:E({"Blue Slots Blocked at Kobulete"})
  end

--- Allow Blue slots to be open
-- @param nil.
function allowbluesen()
  trigger.action.setUserFlag("USAF - A10C C&D",0)
  trigger.action.setUserFlag("USAF - A10C C&D #001",0)
  trigger.action.setUserFlag("USAF - A10C C&D #002",0)
  trigger.action.setUserFlag("USAF - A10C C&D #003",0)
  trigger.action.setUserFlag("USAF - A10C C&D #004",0)
  trigger.action.setUserFlag("USAF - A10C HOT",0)
  trigger.action.setUserFlag("USAF - A10C HOT #002",0)
  trigger.action.setUserFlag("USAF - A10C HOT #001",0)
  trigger.action.setUserFlag("USAF - A10C HOT #003",0)
  trigger.action.setUserFlag("USAF A10A C&D",0)
  trigger.action.setUserFlag("USAF A10A C&D #001",0)
  trigger.action.setUserFlag("GAF SU-25 HOT - SENAKI #001",0)
  trigger.action.setUserFlag("GAF SU-25 HOT - SENAKI #002",0)
  trigger.action.setUserFlag("GAF SU-25 HOT - SENAKI",0)
  trigger.action.setUserFlag("GAF SU-25 HOT - SENAKI #003",0)
  trigger.action.setUserFlag("GAF SU-25T HOT - SENAKI",0)
  trigger.action.setUserFlag("GAF SU-25T HOT - SENAKI #001",0)
  trigger.action.setUserFlag("GAF SU-25T HOT - SENAKI #002",0)
  trigger.action.setUserFlag("GAF SU-25T HOT - SENAKI #003",0)
  trigger.action.setUserFlag("UAF SU-27 HOT - SENAKI",0)
  trigger.action.setUserFlag("UAF SU-27 HOT - SENAKI #001",0)
  trigger.action.setUserFlag("UAF SU-27 HOT - SENAKI #002",0)
  trigger.action.setUserFlag("UAF SU-27 HOT - SENAKI #003",0)
  trigger.action.setUserFlag("USMC AV-8B C&D - SENAKI #003",0)
  trigger.action.setUserFlag("USMC AV-8B C&D - SENAKI",0)
  trigger.action.setUserFlag("USMC AV-8B C&D - SENAKI #001",0)
  trigger.action.setUserFlag("USMC AV-8B C&D - SENAKI #002",0)
  trigger.action.setUserFlag("USMC AV-8B HOT - SENAKI",0)
  trigger.action.setUserFlag("USMC AV-8B HOT - SENAKI #001",0)
  trigger.action.setUserFlag("USMC AV-8B HOT - SENAKI #002",0)
  trigger.action.setUserFlag("USMC AV-8B HOT - SENAKI #003",0)
  trigger.action.setUserFlag("GAF MIG-15 HOT - Senaki",0)
  trigger.action.setUserFlag("GAF MIG-15 HOT - Senaki #001",0)
  trigger.action.setUserFlag("GAF MIG-15 HOT - Senaki #002",0)
  trigger.action.setUserFlag("GAF MIG-15 HOT - Senaki #003",0)
  trigger.action.setUserFlag("GAF MIG-21 HOT - Senaki",0)
  trigger.action.setUserFlag("GAF MIG-21 HOT - Senaki #001",0)
  trigger.action.setUserFlag("GAF MIG-21 HOT - Senaki #002",0)
  trigger.action.setUserFlag("GAF MIG-19 HOT - SENAKI",0)
  trigger.action.setUserFlag("GAF MIG-19 HOT - SENAKI #001",0)
  trigger.action.setUserFlag("GAF MIG-19 HOT - SENAKI #002",0)
  trigger.action.setUserFlag("GAF MIG-19 HOT - SENAKI #003",0)
  trigger.action.setUserFlag("USAF - F16 - Senaki - Hot",0)
  trigger.action.setUserFlag("USAF - F16 - Senaki - Hot #001",0)
  trigger.action.setUserFlag("USAF - F16 - Senaki - Hot #002",0)
  trigger.action.setUserFlag("USAF - F16 - Senaki - Hot #003",0)
  trigger.action.setUserFlag("USAF - F16 - Senaki - C&D",0)
  trigger.action.setUserFlag("USAF - F16 - Senaki - C&D #001",0)
  trigger.action.setUserFlag("USAF - F16 - Senaki - C&D #002",0)
  trigger.action.setUserFlag("USAF - F16 - Senaki - C&D #003",0)
BASE:E({"Blue Slots opened at Senaki"})
end

--- block blue slots at senaki.
function disallowbluesen()
            trigger.action.setUserFlag("USAF - A10C C&D",100)
            trigger.action.setUserFlag("USAF - A10C C&D #001",100)
            trigger.action.setUserFlag("USAF - A10C C&D #002",100)
            trigger.action.setUserFlag("USAF - A10C C&D #003",100)
            trigger.action.setUserFlag("USAF - A10C C&D #004",100)
            trigger.action.setUserFlag("USAF - A10C HOT",100)
            trigger.action.setUserFlag("USAF - A10C HOT #002",100)
            trigger.action.setUserFlag("USAF - A10C HOT #001",100)
            trigger.action.setUserFlag("USAF - A10C HOT #003",100)
            trigger.action.setUserFlag("USAF A10A C&D",100)
            trigger.action.setUserFlag("USAF A10A C&D #001",100)
            trigger.action.setUserFlag("GAF SU-25 HOT - SENAKI #001",100)
            trigger.action.setUserFlag("GAF SU-25 HOT - SENAKI #002",100)
            trigger.action.setUserFlag("GAF SU-25 HOT - SENAKI",100)
            trigger.action.setUserFlag("GAF SU-25 HOT - SENAKI #003",100)
            trigger.action.setUserFlag("GAF SU-25T HOT - SENAKI",100)
            trigger.action.setUserFlag("GAF SU-25T HOT - SENAKI #001",100)
            trigger.action.setUserFlag("GAF SU-25T HOT - SENAKI #002",100)
            trigger.action.setUserFlag("GAF SU-25T HOT - SENAKI #003",100)
            trigger.action.setUserFlag("UAF SU-27 HOT - SENAKI",100)
            trigger.action.setUserFlag("UAF SU-27 HOT - SENAKI #001",100)
            trigger.action.setUserFlag("UAF SU-27 HOT - SENAKI #002",100)
            trigger.action.setUserFlag("UAF SU-27 HOT - SENAKI #003",100)
            trigger.action.setUserFlag("USMC AV-8B C&D - SENAKI #003",100)
            trigger.action.setUserFlag("USMC AV-8B C&D - SENAKI",100)
            trigger.action.setUserFlag("USMC AV-8B C&D - SENAKI #001",100)
            trigger.action.setUserFlag("USMC AV-8B C&D - SENAKI #002",100)
            trigger.action.setUserFlag("USMC AV-8B HOT - SENAKI",100)
            trigger.action.setUserFlag("USMC AV-8B HOT - SENAKI #001",100)
            trigger.action.setUserFlag("USMC AV-8B HOT - SENAKI #002",100)
            trigger.action.setUserFlag("USMC AV-8B HOT - SENAKI #003",100)
            trigger.action.setUserFlag("GAF MIG-15 HOT - Senaki",100)
            trigger.action.setUserFlag("GAF MIG-15 HOT - Senaki #001",100)
            trigger.action.setUserFlag("GAF MIG-15 HOT - Senaki #002",100)
            trigger.action.setUserFlag("GAF MIG-15 HOT - Senaki #003",100)
            trigger.action.setUserFlag("GAF MIG-21 HOT - Senaki",100)
            trigger.action.setUserFlag("GAF MIG-21 HOT - Senaki #001",100)
            trigger.action.setUserFlag("GAF MIG-21 HOT - Senaki #002",100)
            trigger.action.setUserFlag("GAF MIG-19 HOT - SENAKI",100)
            trigger.action.setUserFlag("GAF MIG-19 HOT - SENAKI #001",100)
            trigger.action.setUserFlag("GAF MIG-19 HOT - SENAKI #002",100)
            trigger.action.setUserFlag("GAF MIG-19 HOT - SENAKI #003",100)
            trigger.action.setUserFlag("USAF - F16 - Senaki - Hot",100)
            trigger.action.setUserFlag("USAF - F16 - Senaki - Hot #001",100)
            trigger.action.setUserFlag("USAF - F16 - Senaki - Hot #002",100)
            trigger.action.setUserFlag("USAF - F16 - Senaki - Hot #003",100)
            trigger.action.setUserFlag("USAF - F16 - Senaki - C&D",100)
            trigger.action.setUserFlag("USAF - F16 - Senaki - C&D #001",100)
            trigger.action.setUserFlag("USAF - F16 - Senaki - C&D #002",100)
            trigger.action.setUserFlag("USAF - F16 - Senaki - C&D #003",100)
            BASE:E({"blue slots closed at Senaki"})
end

--- allow blue kutusi slots
function allowbluekut()
  trigger.action.setUserFlag("USAF F-5E C&D - KUTAISI",0)
  trigger.action.setUserFlag("USAF F-15C HOT #002",0)
  trigger.action.setUserFlag("USAF F-15C C&D - Kutaisi #003",0)
  trigger.action.setUserFlag("USAF F-15C HOT #001",0)
  trigger.action.setUserFlag("USAF F-15C C&D - Kutaisi #002",0)
  trigger.action.setUserFlag("USAF F-15C HOT",0)
  trigger.action.setUserFlag("USAF F-15C C&D - Kutaisi",0)
  trigger.action.setUserFlag("USAF F-15C HOT #004",0)
  trigger.action.setUserFlag("USAF F-15C C&D - Kutaisi #001",0)
  trigger.action.setUserFlag("USAF F-5E C&D - KUTAISI #001",0)
  trigger.action.setUserFlag("USAF F-5E C&D - KUTAISI #003",0)
  trigger.action.setUserFlag("USAF F-5E C&D - KUTAISI #002",0)
  trigger.action.setUserFlag("USAF F-5E HOT - KUTAISI",0)
  trigger.action.setUserFlag("USAF F-5E HOT - KUTAISI #001",0)
  trigger.action.setUserFlag("USAF F-5E HOT - KUTAISI #002",0)
  trigger.action.setUserFlag("USAF F-5E HOT - KUTAISI #003",0)
  trigger.action.setUserFlag("FAF M2000 HOT - KUTAISI",0)
  trigger.action.setUserFlag("FAF M2000 HOT - KUTAISI #003",0)
  trigger.action.setUserFlag("FAF M2000 HOT - KUTAISI #001",0)
  trigger.action.setUserFlag("FAF M2000 C&D - KUTAISI #004",0)
  trigger.action.setUserFlag("FAF M2000 HOT - KUTAISI #002",0)
  trigger.action.setUserFlag("FAF M2000 C&D - KUTAISI #001",0)
  trigger.action.setUserFlag("FAF M2000 C&D - KUTAISI #002",0)
  trigger.action.setUserFlag("FAF M2000 C&D - KUTAISI #003",0)
  trigger.action.setUserFlag("UAF MIG-29S HOT - KUTAISI #001",0)
  trigger.action.setUserFlag("UAF MIG-29S HOT - KUTAISI",0)
  trigger.action.setUserFlag("UAF MIG-29S HOT - KUTAISI #003",0)
  trigger.action.setUserFlag("UAF MIG-29S HOT - KUTAISI #002",0)
  trigger.action.setUserFlag("UAF MIG-29A HOT - KUTAISI #001",0)
  trigger.action.setUserFlag("UAF MIG-29A HOT - KUTAISI",0)
  trigger.action.setUserFlag("UAF MIG-29A HOT - KUTAISI #003",0)
  trigger.action.setUserFlag("UAF MIG-29A HOT - KUTAISI #002",0)
            BASE:E({"Blue slots open at Kutaisi"})
end

--- block blue slots at kutaisi
function disallowbluekut()
  trigger.action.setUserFlag("USAF F-5E C&D - KUTAISI",100)
  trigger.action.setUserFlag("USAF F-15C HOT #002",100)
  trigger.action.setUserFlag("USAF F-15C C&D - Kutaisi #003",100)
  trigger.action.setUserFlag("USAF F-15C HOT #001",100)
  trigger.action.setUserFlag("USAF F-15C C&D - Kutaisi #002",100)
  trigger.action.setUserFlag("USAF F-15C HOT",100)
  trigger.action.setUserFlag("USAF F-15C C&D - Kutaisi",100)
  trigger.action.setUserFlag("USAF F-15C HOT #004",100)
  trigger.action.setUserFlag("USAF F-15C C&D - Kutaisi #001",100)
  trigger.action.setUserFlag("USAF F-5E C&D - KUTAISI #001",100)
  trigger.action.setUserFlag("USAF F-5E C&D - KUTAISI #003",100)
  trigger.action.setUserFlag("USAF F-5E C&D - KUTAISI #002",100)
  trigger.action.setUserFlag("USAF F-5E HOT - KUTAISI",100)
  trigger.action.setUserFlag("USAF F-5E HOT - KUTAISI #001",100)
  trigger.action.setUserFlag("USAF F-5E HOT - KUTAISI #002",100)
  trigger.action.setUserFlag("USAF F-5E HOT - KUTAISI #003",100)
  trigger.action.setUserFlag("FAF M2000 HOT - KUTAISI",100)
  trigger.action.setUserFlag("FAF M2000 HOT - KUTAISI #003",100)
  trigger.action.setUserFlag("FAF M2000 HOT - KUTAISI #001",100)
  trigger.action.setUserFlag("FAF M2000 C&D - KUTAISI #004",100)
  trigger.action.setUserFlag("FAF M2000 HOT - KUTAISI #002",100)
  trigger.action.setUserFlag("FAF M2000 C&D - KUTAISI #001",100)
  trigger.action.setUserFlag("FAF M2000 C&D - KUTAISI #002",100)
  trigger.action.setUserFlag("FAF M2000 C&D - KUTAISI #003",100)
  trigger.action.setUserFlag("UAF MIG-29S HOT - KUTAISI #001",100)
  trigger.action.setUserFlag("UAF MIG-29S HOT - KUTAISI",100)
  trigger.action.setUserFlag("UAF MIG-29S HOT - KUTAISI #003",100)
  trigger.action.setUserFlag("UAF MIG-29S HOT - KUTAISI #002",100)
  trigger.action.setUserFlag("UAF MIG-29A HOT - KUTAISI #001",100)
  trigger.action.setUserFlag("UAF MIG-29A HOT - KUTAISI",100)
  trigger.action.setUserFlag("UAF MIG-29A HOT - KUTAISI #003",100)
  trigger.action.setUserFlag("UAF MIG-29A HOT - KUTAISI #002",100)
  BASE:E({"Blue slots closed at kutasi"})
end

--- open blue slots at Sukhumi
function allowbluesuk()
  trigger.action.setUserFlag("UA - MI8 - Sukhumi - Cold",0)
  trigger.action.setUserFlag("UA - MI8 - Sukhumi - Cold #001",0)
  trigger.action.setUserFlag("UA - KA50 - Sukhumi - Cold",0)
  trigger.action.setUserFlag("UA - KA50 - Sukhumi - Cold #001",0)
  trigger.action.setUserFlag("UA - KA50 - Sukhumi - Cold #002",0)
  trigger.action.setUserFlag("UA - KA50 - Sukhumi - Cold #003",0)
  trigger.action.setUserFlag("USAA - UH1 - Sukhumi - Cold",0)
  trigger.action.setUserFlag("USAA - UH1 - Sukhumi - Cold #001",0)
  trigger.action.setUserFlag("USAA - UH1 - Sukhumi - Cold #002",0)
  trigger.action.setUserFlag("USAA - UH1 - Sukhumi - Cold #003",0)
  trigger.action.setUserFlag("USAF - A10C - SUK C&D",0)
  trigger.action.setUserFlag("USAF - A10C - SUK C&D #001",0)
  trigger.action.setUserFlag("USAF - A10C - SUK C&D #002",0)
  trigger.action.setUserFlag("USAF - A10C - SUK C&D #003",0)
  trigger.action.setUserFlag("RAAF - SUK C&D",0)
  trigger.action.setUserFlag("RAAF - SUK C&D #001",0)
  trigger.action.setUserFlag("RAAF - SUK C&D #002",0)
  trigger.action.setUserFlag("USAF - F16 SUK C&D",0)
  trigger.action.setUserFlag("USAF - F16 SUK C&D #001",0)
  trigger.action.setUserFlag("USAF - F16 SUK C&D #002",0)
  trigger.action.setUserFlag("RAA SA342MINI",0)
  trigger.action.setUserFlag("RAA SA342MINI #001",0)
  trigger.action.setUserFlag("RAA KA50",0)
  trigger.action.setUserFlag("RAA KA50 #001",0)
  trigger.action.setUserFlag("RAA Huey Suk",0)
  trigger.action.setUserFlag("RAA Huey Suk #001",0)
  BASE:E({"Blue Slots Should be Open at Suk"})
end

--- close red slots at sukhumi
function disallowredsuk()
  trigger.action.setUserFlag("RUS F18C - SUK C&D",100)
  trigger.action.setUserFlag("RUS F18C - SUK C&D #100",100)
  BASE:E({"Red Slots Should be Closed at Suk"})
end

--- close blue slots at sukhumi
function disallowbluesuk()
  trigger.action.setUserFlag("UA - MI8 - Sukhumi - Cold",100)
  trigger.action.setUserFlag("UA - MI8 - Sukhumi - Cold #001",100)
  trigger.action.setUserFlag("UA - KA50 - Sukhumi - Cold",100)
  trigger.action.setUserFlag("UA - KA50 - Sukhumi - Cold #001",100)
  trigger.action.setUserFlag("UA - KA50 - Sukhumi - Cold #002",100)
  trigger.action.setUserFlag("UA - KA50 - Sukhumi - Cold #003",100)
  trigger.action.setUserFlag("USAA - UH1 - Sukhumi - Cold",100)
  trigger.action.setUserFlag("USAA - UH1 - Sukhumi - Cold #001",100)
  trigger.action.setUserFlag("USAA - UH1 - Sukhumi - Cold #002",100)
  trigger.action.setUserFlag("USAA - UH1 - Sukhumi - Cold #003",100)
  trigger.action.setUserFlag("USAF - A10C - SUK C&D",100)
  trigger.action.setUserFlag("USAF - A10C - SUK C&D #001",100)
  trigger.action.setUserFlag("USAF - A10C - SUK C&D #002",100)
  trigger.action.setUserFlag("USAF - A10C - SUK C&D #003",100)
  trigger.action.setUserFlag("RAAF - SUK C&D",100)
  trigger.action.setUserFlag("RAAF - SUK C&D #001",100)
  trigger.action.setUserFlag("RAAF - SUK C&D #002",100)
  trigger.action.setUserFlag("USAF - F16 SUK C&D",100)
  trigger.action.setUserFlag("USAF - F16 SUK C&D #001",100)
  trigger.action.setUserFlag("USAF - F16 SUK C&D #002",100)
  trigger.action.setUserFlag("RAA SA342MINI",100)
  trigger.action.setUserFlag("RAA SA342MINI #001",100)
  trigger.action.setUserFlag("RAA KA50",100)
  trigger.action.setUserFlag("RAA KA50 #001",100)
  trigger.action.setUserFlag("RAA Huey Suk",100)
  trigger.action.setUserFlag("RAA Huey Suk #001",100)
  BASE:E({"Blue Slots Should be Closed at Suk"})
end

--- open red slots at sukhumi.
function allowredsuk()
  trigger.action.setUserFlag("RUS F18C - SUK C&D",0)
  trigger.action.setUserFlag("RUS F18C - SUK C&D #100",0)
  BASE:E({"Red Slots Should be open at Suk"})
end

--- open blue slots at gudauta
function allowbluegud()
  trigger.action.setUserFlag("UA - KA50 - Gudauta - Cold",0)
  trigger.action.setUserFlag("UA - KA50 - Gudauta - Cold #001",0)
  trigger.action.setUserFlag("UA - KA50 - Gudauta - Cold #002",0)
  trigger.action.setUserFlag("UA - KA50 - Gudauta - Cold #003",0)
  trigger.action.setUserFlag("USAA - UH1 - Gudauta - Cold",0)
  trigger.action.setUserFlag("USAA - UH1 - Gudauta - Cold #001",0)
  trigger.action.setUserFlag("UA - MI8 - Gudauta - Cold",0)
  trigger.action.setUserFlag("UA - MI8 - Gudauta - Cold #001",0)
  BASE:E({"Blue Slots should be open at Gudauta"})
end

--- close red slots at gudauta
function disallowredgud()
  trigger.action.setUserFlag("RUS - A-10C - GUD C&D",100)
  trigger.action.setUserFlag("RUS - A-10C - GUD C&D #001",100)
  trigger.action.setUserFlag("RUS - A-10C - GUD C&D #002",100)
  trigger.action.setUserFlag("RUS - A-10C - GUD C&D #003",100)
  trigger.action.setUserFlag("RUS - KA50 GUD",100)
  trigger.action.setUserFlag("RUS - KA50 GUD #001",100)
  trigger.action.setUserFlag("RUS - MI8 GUD",100)
  trigger.action.setUserFlag("RUS - MI8 GUD #001",100)
  trigger.action.setUserFlag("RUS - JF17 - GUD C&D",100)
  trigger.action.setUserFlag("RUS - JF17 - GUD C&D #001",100)
  BASE:E({"Red Slots should be closed at Gudauta"})
end

--- close blue slots at gudauta
function disallowbluegud()
  trigger.action.setUserFlag("UA - KA50 - Gudauta - Cold",100)
  trigger.action.setUserFlag("UA - KA50 - Gudauta - Cold #001",100)
  trigger.action.setUserFlag("UA - KA50 - Gudauta - Cold #002",100)
  trigger.action.setUserFlag("UA - KA50 - Gudauta - Cold #003",100)
  trigger.action.setUserFlag("USAA - UH1 - Gudauta - Cold",100)
  trigger.action.setUserFlag("USAA - UH1 - Gudauta - Cold #001",100)
  trigger.action.setUserFlag("UA - MI8 - Gudauta - Cold",100)
  trigger.action.setUserFlag("UA - MI8 - Gudauta - Cold #001",100)
  BASE:E({"Blue Slots Should be closed at Gud"})
end

--- open red slots at guduata
function allowredgud()
  trigger.action.setUserFlag("RUS - A-10C - GUD C&D",0)
  trigger.action.setUserFlag("RUS - A-10C - GUD C&D #001",0)
  trigger.action.setUserFlag("RUS - A-10C - GUD C&D #002",0)
  trigger.action.setUserFlag("RUS - A-10C - GUD C&D #003",0)
  trigger.action.setUserFlag("RUS - KA50 GUD",0)
  trigger.action.setUserFlag("RUS - KA50 GUD #001",0)
  trigger.action.setUserFlag("RUS - MI8 GUD",0)
  trigger.action.setUserFlag("RUS - MI8 GUD #001",0)
  trigger.action.setUserFlag("RUS - JF17 - GUD C&D",0)
  trigger.action.setUserFlag("RUS - JF17 - GUD C&D #001",0)
  BASE:E({"Red slots should be open at Gud."})
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
RedArmySpawn = SPAWN:NewWithAlias("Russian Army","RAF 1st Division"):InitRandomizeUnits(true,100,10),
RedArmySpawned = 0,
RedArmyAlive = 1,
RedArmyX = 0,
RedArmyY = 0,
RedArmyState = 0,
RedArmyStateL = 5,
RedArmySpawn1 = SPAWN:NewWithAlias("Russian Army 2","RAF 2nd Division"):InitRandomizeUnits(true,100,10),
RedArmy1 = GROUP:FindByName("Russian Army 2"),
RedArmy1Spawned = 0,
RedArmyAlive1 = 1,
RedArmyX1 = 0,
RedArmyY1 = 0,
RedArmyState1 = 0,
RedArmyStateL1 = 5,
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
BluArmySpawn = SPAWN:NewWithAlias("US Army","COL 9th Division"):InitRandomizeUnits(true,100,10),
BlueArmySpawned = 0,
BluArmyAlive = 1,
BluArmyX = 0,
BluArmyY = 0,
BluArmyState = 0,
BluArmyStateL = 5,
BluArmy1 = GROUP:FindByName("US Army 2"),
BluArmy1Spawn = SPAWN:NewWithAlias("US Army 2","COL 10th Division"),
BlueArmy1Spawned = 0,
BluArmyX1 = 0,
BluArmyY1 = 0,
BluArmy1Alive = 1,
BluArmyState1 = 0,
BluArmyStateL1 = 5,
BluArmy2 = GROUP:FindByName("US Army 3"),
BluArmy2Spawn = SPAWN:NewWithAlias("US Army 3","COL 11th Division"),
BlueArmy2Spawned = 0,
BluArmyX2 = 0,
BluArmyY2 = 0,
BluArmy2Alive = 1,
BluArmyState2 = 0,
BluArmyStateL2 = 5,
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
rsam = {},
bsam = {},
}
do
  function RIB:New(Name)
    local self = BASE:Inherit(self, BASE:New())
    self.init = false -- we fast unitalised
    self.name = Name -- set out name
    self:HandleEvent( EVENTS.BaseCaptured ) -- handle events
    --self:HandleEvent(EVENTS.Dead)
    self.insurgent1 = nil
    self.insurgent1m = nil
    self.rsead = nil
    self.rattack = nil
    self.bsead= nil
    self.battack = nil
    self.r99 = nil
    self.bapache = nil
    self.insurgent1t = nil
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
    self.rinsurgent1 = nil
    self.rinsurgent1m = nil
    self.rinsurgent1t = nil
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
    self.insurgent2 = nil
    self.insurgent2m = nil
    self.insurgent2t = nil
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
    self.rinsurgent2 = nil
    self.rinsurgent2m = nil
    self.rinsurgent2t = nil
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
    self.insurgent3 = nil
    self.insurgent3m = nil
    self.insurgent3t = nil
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
    self.rinsurgent3 = nil
    self.rinsurgent3m = nil
    self.rinsurgent3t = nil
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
    self.insurgent4 = nil
    self.insurgent4m = nil
    self.insurgent4t = nil
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
    self.rinsurgent4 = nil
    self.rinsurgent4m = nil
    self.rinsurgent4t = nil
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
    self.BLUAWAC2 = GROUP:FindByName("Magic")
    self.BAWACS2 = SPAWN:NewWithAlias("Magic","Magic"):InitCleanUp(120):InitRepeatOnLanding():OnSpawnGroup(function(SpawnGroup) 
      if self.BLUAWAC2 ~= nil then
        self.BLUAWAC2:Destroy()
      end      
      Scoring:AddScoreGroup(SpawnGroup,30)
      BASE:E({self.name},"SPAWNING MAGIC")
      BCC:MessageToCoalition("Magic 11 is active on 250")
      self.BLUAWAC2 = SpawnGroup
    end)
    self.REDAWAC = GROUP:FindByName("Wizard") -- store redawacs
    -- set up the spawn for when we start everything.
    self.RAWACS = SPAWN:NewWithAlias("Wizard","Wizard"):InitCleanUp(120):InitRepeatOnEngineShutDown():OnSpawnGroup(function(SpawnGroup)
      -- if redawac isn't nil just incase we destroy it. we don't want 2.
      if self.REDAWAC ~= nil then
        self.REDAWAC:Destroy()
      end
      self.REDAWAC = SpawnGroup -- store awac
      Scoring:AddScoreGroup(SpawnGroup,30)
      BASE:E({self.name,"Spawning Red AWAC & Setting Escort"})
      RCC:MessageToCoalition("Wizard11 is active and will be on 251.0")
    end
    )
    self.REDTNKR2 = GROUP:FindByName("RSHELL")
    self.RTNKR2 = SPAWN:NewWithAlias("RSHELL","RSHELL"):InitCleanUp(120):InitRepeatOnEngineShutDown():OnSpawnGroup(function(SpawnGroup)
      if self.REDTNKR2 ~= nil then
        self.REDTNKR2:Destroy()
      end

      Scoring:AddScoreGroup(SpawnGroup,20)
      BASE:E({self.name,"SPAWNING RED SHELL TANKER"})
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
      BASE:E({self.name,"SPAWNING RED TANKER"})
      RCC:MessageToCoalition("ARCO11 is active and will be on 252.0 TACAN 5X")
      self.REDTNKR = SpawnGroup -- store our tanker
      do
        if ra2adisp ~= nil then
          ra2adisp:SetDefaultTanker(SpawnGroup:GetName())
          BASE:E({self.name,"RED A2A DISPATCHER TANKER SET TO NEW TANKER NAME IS",SpawnGroup:GetName()})
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
      BASE:E({self.name,"Spawning BLU AWAC & Setting Escort"})
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
      BASE:E({self.name,"SPAWNING BLUE TANKER"})
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
      BASE:E({self.name,"SPAWNING BLUE TANKER"})
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
    BASE:E({self.name,"Running support script"})
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
    if self.BLUAWAC2:IsAlive() ~= true or self.BLUAWAC2:AllOnGround() == true then
      self.BAWACS2:Spawn()
    end
    if self.afac:IsAlive() ~= true or self.afac:AllOnGround() == true then
      self.afacs:Spawn()
    end
  end
  
  ---@param self
  --@param Core.Event#EVENTDATA EventData
  function RIB:OnEventDead(EventData)
    self:E({self.name,"Event Dead occured initating group was",EventData.IniGroupName})
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
            kobblueallow()
            if self.kobsqn ~= nil then
              self.kobsqn:SpawnScheduleStart()
            else
              self.kobsqn = spawnA2ACap("kobSqn",kob,BCAPTEMPLATES,1,math.random(12,24),BCAP,BAS,120,15000,35000,300,450,300,0.5)
            end
          else
            BASE:E({self.name,"Base change but we alread own it.",AirbaseName,coalition})
          end
        else
          if KOBOWNER ~= 1 then
            KOBOWNER = 1
            BASE:E({"Red has taken Kobuleti! Spawning Defences oh that's right they don't get any!"})
            kobbluedisallow()
            self.BlueKobSpawned = 0 
            if self.kobsqn ~= nil then
              self.kobsqn:SpawnScheduleStop()
            else
              BASE:E({self.name,"Kob sqn was NIL this shouldn't happen!"})
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
            self.RedSenSpawned = 0
            allowbluesen()
            if self.sensqn ~= nil then
              self.sensqn:SpawnScheduleStart()
            else
              self.sensqn = spawnA2ACap("senSqn",sen,BCAPTEMPLATES,1,math.random(12,24),BCAP3,BAS,120,15000,35000,300,450,300,0.5)
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
            self.BlueSenSpawned = 0 
            disallowbluesen()
            if self.sensqn ~= nil then
              self.sensqn:SpawnScheduleStop()
            else
              BASE:E({self.name,"sensqn was nil this shouldn't happen"})
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
            self.RedKutSpawned = 0
            allowbluekut()
            if self.kutsqn ~= nil then
              self.kutsqn:SpawnScheduleStart()
            else
              self.kutsqn = spawnA2ACap("kutSqn",kut,BCAPTEMPLATES,1,math.random(12,24),BCAP2,BAS,120,15000,35000,300,450,300,0.5)
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
            self.BlueKutSpawned = 0
            if self.kutsqn ~= nil then
              self.kutsqn:SpawnScheduleStop()
            else
              BASE:E({self.name,"Kutsqn was nil this shoulnd't happen"})
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
            self.RedSukSpawned = 0
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
            self.BlueSukSpawned = 0
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
            self.RedGudSpawned = 0
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
            self.BlueGudSpawned = 0
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
      savenewpersistencenow(self)
    else
      self:E({"RIB WARNING NOT INITALISED CAPTURE",AirbaseName,coalition})
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
 
 --- this runs our red ground routing and states.
 function RIB:RGroundTick(distance,attackdistance)
  BASE:E({self.name,"begin Red Army 1,2",self.RedArmyState,self.RedArmyState1})
  -- Ok lets set all our engagement states to false, for the moment and our alive state to false, positions to nil
  local rengaged = false
  local rengaged1 = false
  ralive = false
  ralive1 = false
  rpos = nil
  rpos1 = nil
  -- check if our red army is alive if it is we set all the values to say so and store its position
  -- otherwise we say it's dead! and order a respawn
  if self.RedArmy:IsAlive() == true then
    BASE:E({self.name,"Red Army Alive Storing Coord"})
    ralive = true
    rpos = self.RedArmy:GetCoordinate()
    self.RedArmyAlive = 1
    local tempvec2 = rpos:GetVec2()
    self.RedArmyX = tempvec2.x
    self.RedArmyY = tempvec2.y
  else
    -- Need to expand this to do checks so we can grind this beast to a halt if need be.
    if RedHq:IsAlive() == true then
      BASE:E({self.name,"Red Army Dead ReSpawning"})
      self.RedArmy = self.RedArmySpawn:Spawn()
      self.RedArmySpawned = self.RedArmy
      self.RedArmyAlive = 0
      self.RedArmyState = 0
      self.RedArmyStateL = 5
    else
      self.RedArmySpawned = 0
      BASE:E({self.name,"Red Headquarters was dead can't resupply and respawn an army if there's no HQ!"})
    end
  end
  -- do the above but for the second army.. really we could move this into it's own little 
  -- state machine again but we can't be bothered.
  if self.RedArmy1:IsAlive() == true then
    BASE:E({self.name,"Red Army 2 Alive Storing Coord"})
    ralive1 = true
    rpos1 = self.RedArmy1:GetCoordinate()
    self.RedArmyAlive1 = 1
    local tempvec2 = rpos1:GetVec2()
    self.RedArmyX1 = tempvec2.x
    self.RedArmyY1 = tempvec2.y
  else
    if RedHq:IsAlive() == true then
      BASE:E({self.name,"Red Army 2 Dead ReSpawning"})
      self.RedArmy1 = self.RedArmySpawn1:Spawn()
      self.RedArmy1Spawned = self.RedArmy1
      self.RedArmyAlive1 = 0
      self.RedArmyState1 = 0
      self.RedArmyStateL1 = 5
    else
      self.RedArmy1Spawned = 0
      BASE:E({self.name,"Red Headquarters was dead can't resupply and respawn an army if there's no HQ!"})
    end    
  end
  
  -- run a check for nil state we should NEVER get this but we are being certain just incase something breaks for some reason.
  if self.RedArmyState == nil then
    self.RedArmyState = 0
  end
  if self.RedArmyState1 == nil then
    self.RedArmyState1 = 0
  end
  -- check if our armies are close to each other
  if bpos ~= nil and rpos ~= nil then
    -- get our current position and check it vs the main lue army (again later we need to work out a way to expand this!)
    local d2 = rpos:Get2DDistance(bpos)
    -- if they are within attack distance we route them to attack, we may actually want to also at some point check and see
    -- if there has been a detection of the group.. just incase. less 200 meters. 
    if d2 < attackdistance then
      local nco = rpos:Translate((d2 - 200),rpos:HeadingTo(bpos))
      -- double check that everything is in the land zones.
      if LandZone:IsCoordinateInZone(nco) == true then
        self.RedArmy:RouteGroundTo(nco,20,randomform(),self.redrelaytime)
        BASE:E({self.name,"Blue Army was within ".. attackdistance .. " route Red to Blue Army."})
        -- we are engaged so we set that
        self.RedArmyStateL = 5 -- set the state so when we unengage we can actually you know move.
        rengaged = true
      else
        BASE:E({self.name,"Tried to route Red to Blue Army but wasn't in zone this shouldn't happen!"})
        rengaged = false
      end
    else
      -- we aren't engaging.
      rengaged = false
    end
  else
    BASE:E({self.name,"tried to route bpos and rpos but one was nil",bpos,rpos})
  end
  -- red 2
  if bpos ~= nil and rpos1 ~= nil then
    local d2 = rpos1:Get2DDistance(bpos)
    if d2 < attackdistance then
      local nco = rpos1:Translate((d2 - 200),rpos1:HeadingTo(bpos))
      if LandZone:IsCoordinateInZone(nco) == true then
        self.RedArmy1:RouteGroundTo(nco,20,randomform(),self.redrelaytime)
        BASE:E({self.name,"Blue Army was within ".. attackdistance .." route Red2 to Blue Army."})
        rengaged1 = true
        self.RedArmyStateL1 = 5
      else
        BASE:E({self.name,"Tried to route Red2 to Blue Army but wasn't in zone this shouldn't happen!"})
        rengaged1 = false
      end
    else
      rengaged1 = false
    end
  else
    BASE:E({self.name,"tried to route bpos and rpos1 but one was nil",bpos,rpos1})
  end
  
  BASE:E({self.name,"RED1 states"})
  if ralive == true then
    if rengaged == false then
      if (SUKOWNER == 1) and (GUDOWNER == 1) then
         BASE:E({self.name,"Red Suk,Gud,Blue",SUKOWNER,GUDOWNER,balive})
        if self.RedArmyState == 0 then
          if rpos:Get2DDistance(dg) < 500 then
            BASE:E({self.name,"within 1/2 a click of Gud Switching RedArmy1 to State 1",self.RedArmyState})
            self.RedArmyState = 1
          end      
        end
      elseif ((SUKOWNER == 2) and (GUDOWNER == 1)) then
        BASE:E({self.name,"Red doesn't hold suk",SUKOWNER,GUDOWNER})
        if self.RedArmyState == 0 and rpos:Get2DDistance(dg) < 500 then
            BASE:E({self.name,"Switching RedArmy1 to State 1",self.RedArmyState})
            self.RedArmyStateL = self.RedArmyState
            self.RedArmyState = 1
        end        
      elseif ((SUKOWNER == 1) and (GUDOWNER == 2)) then
        BASE:E({self.name,"Red doesn't hold GUD",SUKOWNER,GUDOWNER})
        if self.RedArmyState ~= 0 then
          self.RedArmyState = 0
          BASE:E({self.name,"Switching Red Army 1 to State 0",self.RedArmyState})
        end
      else
        BASE:E({self.name,"Red doesn't own anything",SUKOWNER,GUDOWNER})
        if self.RedArmyState ~= 0 then
          self.RedArmyState = 0
          BASE:E({self.name,"Switching RedArmy1 to State 0",self.RedArmyState})
        end
      end
      BASE:E({self.name,"Red 1 movement",self.RedArmyState,self.RedArmyStateL})
      
      if self.RedArmyState == 0 then
        if self.RedArmyState ~= self.RedArmyStateL then
          self.RedArmy:RouteGroundOnRoad(GUDZONE:GetRandomCoordinate(0,200),20,30,randomform())
          self.RedArmyStateL = self.RedArmyState -- update our last state to match this state.
        end
      elseif self.RedArmyState == 1 then
        if self.RedArmyState ~= self.RedArmyStateL then
          self.RedArmy:RouteGroundOnRoad(SUKZONE:GetRandomCoordinate(0,200),20,30,randomform())
          self.RedArmyStateL = self.RedArmyState -- update our last state to match this state.
        end
      else
          BASE:E({self.name, "Red Army 1 wasn't in a state to either move to Suk or Gud and the army"})
      end      
    end
  end
  
  BASE:E({self.name,"Red 2 States",self.RedArmyState1}) 
  if ralive1 == true then
    if rengaged1 == false then
      if (SUKOWNER == 1) and (GUDOWNER == 1) then
        if self.RedArmyState1 == 0 then
          self.RedArmyState1 = 1
          BASE:E({self.name,"Red Army 2 was in state 0, switching it to move to Suk then onwards!"}) 
        elseif self.RedArmyState1 == 1 then
          if (GUDOWNER == 1) then
            self.RedArmyState1 = 2
          end
          if rpos1:Get2DDistance(ds) < 500 then
            self.RedArmyState1 = 2
          end
        elseif self.RedArmyState1 == 2 then 
          if (SENOWNER == 1) and rpos1:Get2DDistance(dse) < 500 then
              self.RedArmyState1 = 3
          end
        elseif self.RedArmyState1 == 3 then
          if (SENOWNER == 2) then
            self.RedArmyState1 = 2
          else
            if (KUTOWNER == 1) and rpos1:Get2DDistance(dk) < 500 then
              self.RedArmyState1 = 4
            end
          end
        elseif self.RedArmyState1 == 4 then
          if (SENOWNER == 2) then
            self.RedArmyState1 = 2
          elseif (KUTOWNER == 2) then
            self.RedArmyState1 = 3
          else
            -- we do nothing.
          end
        end
      elseif (SUKOWNER == 2) and (GUDOWNER == 1) then
        if self.RedArmyState1 > 2 then
          self.RedArmyState1 = 2
        elseif (self.RedArmyState1 == 2) and (rpos1:Get2DDistance(dse) < 500) then
            self.RedArmyState1 = 1
        elseif self.RedArmyState1 == 0 then
          self.RedArmyState1 = 1
        end
      elseif (SUKOWNER == 1) and (GUDOWNER == 2) then
        if self.RedArmyState1 > 2 then
          self.RedArmyState1 = 2
        elseif self.RedArmyState1 == 2 and (rpos1:Get2DDistance(dse) < 500) then
            self.RedArmyState1 = 1
        elseif self.RedArmyState1 == 1 and (rpos1:Get2DDistance(ds) < 500) then
            self.RedArmyState1 = 0
        end
      else
        if self.RedArmyState1 > 2 then
          self.RedArmyState1 = 2
        elseif self.RedArmyState1 == 2 and rpos1:Get2DDistance(dse) < 500 then
            self.RedArmyState1 = 1
        elseif self.RedArmyState1 == 1 and rpos1:Get2DDistance(ds) < 500 then
            self.RedArmyState1 = 0
        end
      end
      
      BASE:E({self.name,"RED 2 Movement",self.RedArmyState1,self.RedArmyStateL1})
      if self.RedArmyState1 == 0 then
        if self.RedArmyStateL1 ~= self.RedArmyState1 then
          self.RedArmy1:RouteGroundTo(GUDZONE:GetRandomCoordinate(0,200),20,randomform(),30)
          self.RedArmyStateL1 = self.RedArmyState1
        end
      elseif self.RedArmyState1 == 1 then
        if self.RedArmyStateL1 ~= self.RedArmyState1 then
          self.RedArmy1:RouteGroundTo(SUKZONE:GetRandomCoordinate(0,200),20,randomform(),30)
          self.RedArmyStateL1 = self.RedArmyState1
        end
      elseif self.RedArmyState1 == 2 then
        if self.RedArmyStateL1 ~= self.RedArmyState1 then
          self.RedArmy1:RouteGroundTo(SENZONE:GetRandomCoordinate(0,200),20,randomform(),30)
          self.RedArmyStateL1 = self.RedArmyState1
        end
      elseif self.RedArmyState1 == 3 then
        if self.RedArmyStateL1 ~= self.RedArmyState1 then
          self.RedArmy1:RouteGroundTo(KUTZONE:GetRandomCoordinate(0,200),20,randomform(),30)
          self.RedArmyStateL1 = self.RedArmyState1
        end
      elseif self.RedArmyState1 == 4 then
        if self.RedArmyStateL1 ~= self.RedArmyState1 then
          self.RedArmy1:RouteGroundTo(KOBZONE:GetRandomCoordinate(0,200),20,randomform(),30)
          self.RedArmyStateL1 = self.RedArmyState1
        end
      else
        BASE:E({self.name,"REd Army 1 was not in a correct state! this shouldn't happen",self.RedArmyState1})
      end
    end
  end
  
  BASE:E({self.name,"end Red Army 1,2",self.RedArmyState,self.RedArmyState1})
 end
 
 function RIB:DestroyGround(unit)
  BASE:E{"Call for the destruction of unit",unit}
  if unit == "blue1" then
    BASE:E{"destroy",unit}
    if self.BluArmy:IsAlive() == true then
      BASE:E{"Is Alive Destroying",unit}
      self.BluArmy:Destroy()
      self.BluArmyStateL = 5
      self.BlueArmySpawned = 0
    end
  elseif unit == "blue2" then
    BASE:E{"destroy",unit}
    if self.BluArmy1:IsAlive() == true then
      BASE:E{"Is Alive Destroying",unit}
      self.BluArmy1:Destroy()
      self.BluArmyStateL1 = 5
      self.BlueArmy1Spawned = 0
    end
  elseif unit == "blue3" then
    BASE:E{"destroy",unit}
    if self.BluArmy2:IsAlive() == true then
      BASE:E{"Is Alive Destroying",unit}
      self.BluArmy2:Destroy()
      self.BluArmyStateL2 = 5
      self.BlueArmy2Spawned = 0
    end
  elseif unit == "red1" then
    BASE:E{"destroy",unit}
    if self.RedArmy:IsAlive() == true then
      BASE:E{"Is Alive Destroying",unit}
      self.RedArmy:Destroy()
      self.RedArmyStateL = 5
      self.RedArmySpawned = 0
    end
  elseif unit == "red2" then
    BASE:E{"destroy",unit}
    if self.RedArmy1:IsAlive() == true then
      BASE:E{"Is Alive Destroying",unit}
      self.RedArmy1:Destroy()
      self.RedArmyStateL1 = 5
      self.RedArmy1Spawned = 0
    end
  end
 end
 
  function RIB:spawnGround(unit,x,y,state)
  if unit == "blue1" then
    if self.BluArmy:IsAlive() == true then
      self.BluArmy:Destroy()
    end
    self.BluArmyX = x
    self.BluArmyY = y
    self.BluArmyState = state
    self.BluArmyStateL = 5
    local tempvec2 = POINT_VEC2:New(x,y)
    self.BluArmy = self.BluArmySpawn:SpawnFromPointVec2(tempvec2)
    self.BlueArmySpawned = self.BluArmy
  elseif unit == "blue2" then
    if self.BluArmy1:IsAlive() == true then
      self.BluArmy1:Destroy()
    end
    self.BluArmyX1 = x
    self.BluArmyY1 = y
    self.BluArmyState1 = state
    self.BluArmyStateL1 = 5
    local tempvec2 = POINT_VEC2:New(x,y)
    self.BluArmy1 = self.BluArmy1Spawn:SpawnFromPointVec2(tempvec2)
    self.BlueArmy1Spawned = self.BluArmy1
  elseif unit == "blue3" then
    if self.BluArmy2:IsAlive() == true then
      self.BluArmy2:Destroy()
    end
    self.BluArmyX2 = x
    self.BluArmyY2 = y
    self.BluArmyState2 = state
    local tempvec2 = POINT_VEC2:New(x,y)
    self.BluArmy2 = self.BluArmy2Spawn:SpawnFromPointVec2(tempvec2)
    self.BlueArmy2Spawned = self.BluArmy2
    self.BluArmyStateL2 = 5
  elseif unit == "red1" then
    if self.RedArmy:IsAlive() == true then
      self.RedArmy:Destroy()
    end
    self.RedArmyX = x
    self.RedArmyY = y
    self.RedArmyState = state
    local tempvec2 = POINT_VEC2:New(x,y)
    self.RedArmy = self.RedArmySpawn:SpawnFromPointVec2(tempvec2)
    self.RedArmySpawned = self.RedArmy
    self.RedArmyStateL = 5
  elseif unit == "red2" then
    if self.RedArmy1:IsAlive() == true then
      self.RedArmy1:Destroy()
    end
     self.RedArmyX1 = x
     self.RedArmyY2 = y
     self.RedArmyState1 = state
     self.RedArmyStateL1 = 5
     local tempvec2 = POINT_VEC2:New(x,y)
    self.RedArmy1 = self.RedArmySpawn1:SpawnFromPointVec2(tempvec2)
    self.RedArmy1Spawned = self.RedArmy1
  end
 end
 
 function RIB:BGroundTick(distance,attackdistance)
  BASE:E({self.name,"BLUE GROUND TICK"})
  -- if Sukhumi is owned by red
 
  local bengaged = false
  -- rpos = nil
  bpos = nil
  balive = false
  balive1 = false
  balive2 = false
  -- Check if blue army is alive or dead
  if self.BluArmy:IsAlive() == true then
    balive = true
    BASE:E({self.name,"Blue Army Alive storing Coord"})
    bpos = self.BluArmy:GetCoordinate()
    self.BluArmyAlive = 1
    local tempvec2 = bpos:GetVec2()
    self.BluArmyX = tempvec2.x
    self.BluArmyY = tempvec2.y
  else
    BASE:E({self.name,"Blue Army Dead ReSpawning"})
    self.BluArmy = self.BluArmySpawn:Spawn()
    self.BlueArmySpawned = self.BluArmy
    self.BluArmyAlive = 0
    self.BluArmyX = 0
    self.BluArmyY = 0
    self.BluArmyState = 1
  end
  if self.BluArmy1:IsAlive() == true then
    balive1 = true
    BASE:E({self.name,"Blue 1 Army alive storing data"})
    bpos1 = self.BluArmy1:GetCoordinate()
    self.BluArmy1Alive = 1
    local tempvec2 = bpos1:GetVec2()
    self.BluArmyX1 = tempvec2.x
    self.BluArmyY1 = tempvec2.y
  else
    BASE:E({self.name,"Blue Army 1 Dead ReSpawning"})
    self.BluArmy1 = self.BluArmy1Spawn:Spawn()
    self.BluArmy1Alive = 0
    self.BluArmyX1 = 0
    self.BluArmyY1 = 0
    self.BluArmyState1 = 4
    self.BlueArmy1Spawned = self.BluArmy1
  end
  if self.BluArmy2:IsAlive() == true then
    balive2 = true
    BASE:E({self.name,"Blue 2 Army alive storing data"})
    bpos2 = self.BluArmy2:GetCoordinate()
    self.BluArmy2Alive = 1
    local tempvec2 = bpos2:GetVec2()
    self.BluArmyX2 = tempvec2.x
    self.BluArmyY2 = tempvec2.y
  else
    BASE:E({self.name,"Blue Army 2 Dead ReSpawning"})
    self.BluArmy2 = self.BluArmy2Spawn:Spawn()
    self.BluArmy2Alive = 0
    self.BluArmyX2 = 0
    self.BluArmyY2 = 0
    self.BluArmyState2 = 5
    self.BlueArmy2Spawned = self.BluArmy2
  end
  if self.BluArmyState == nil then
    self.BluArmyState = 1
  end
  if self.BluArmyState1 == nil then
    self.BluArmyState1 = 4
  end
  if self.BluArmyState2 == nil then
    self.BluArmyState2 = 5
  end
  if self.BluArmyStateL == nil then
    self.BluArmyStateL = 99
  end
  if self.BluArmyStateL1 == nil then
    self.BluArmyStateL1 = 99
  end
  if self.BluArmyStateL2 == nil then
    self.BluArmyStateL2 = 99
  end
  -- check if our armies are close to each other
  if bpos ~= nil and rpos ~= nil then
    local d2 = rpos:Get2DDistance(bpos)
    if d2 < attackdistance then
      nco = bpos:Translate((d2 - 200),bpos:HeadingTo(rpos))
      if LandZone:IsCoordinateInZone(nco) == true then
        self.BluArmy:RouteGroundTo(nco,20,randomform(),self.bluerelaytime)
        BASE:E({self.name,"Blue was within ".. attackdistance .." NCO is",nco,self.bluerelaytime})
        bengaged = true
      else
        bengaged = false
      end
    else
       BASE:E({self.name,"Blue Army was Greater 2km can't route Red to Blue Army."})     
       bengaged = false
    end
  else
    BASE:E({self.name,"Blue or red pos was nil can't route if we don't exist.",bpos,rpos})
    bengaged = false
  end
  -- ok lets do the red army
  if balive == true then
    if bengaged == false then
    BASE:E({self.name, "Blue Army states",self.BluArmyState,self.BluArmyStateL})
      local sh = bpos:HeadingTo(ds)
      local dh = bpos:HeadingTo(dg)
      if ((SUKOWNER == 2) and (GUDOWNER == 2)) then
        BASE:E({"Blue owns all"})
        BASE:T({self.name,"Blue Suk,Gud,Blue",SUKOWNER,GUDOWNER,balive})
          -- if we are set to go to Suk, move to Gud.
          if self.BluArmyState == 1 and bpos:Get2DDistance(ds) < 1000 then 
              self.BluArmyState = 0
          end
      elseif ((SUKOWNER == 2) and (GUDOWNER == 1)) then
        BASE:E({"Blue owns Suk not Gud"})
        if (self.BluArmyState == 1) and (bpos:Get2DDistance(ds) < 1000 or (dh < 90 and dh > 200) )then 
              self.BluArmyState = 0
              
        end
      elseif ((SUKOWNER == 1) and (GUDOWNER == 2)) then
        BASE:E({self.name,"BLUE doesn't hold SUK",SUKOWNER,GUDOWNER})
        if self.BluArmyState == 0 and (bpos:Get2DDistance(dg) < 33336 or (sh > 90 and sh < 270 )) then 
              self.BluArmyState = 1
        end
      else
        BASE:E({self.name,"Blue doesn't own anything",SUKOWNER,GUDOWNER})
        if self.BluArmyState == 0 then
           if bpos:Get2DDistance(dg) < 500 then 
              self.BluArmyState = 1
           end
        end
      end
    end
    BASE:E({self.name, "Blue Army movement",self.BluArmyState,self.BluArmyStateL})
    if self.BluArmyState == 0 then
      if self.BluArmyStateL ~= self.BluArmyState then
         self.BluArmy:RouteGroundOnRoad(GUDZONE:GetRandomCoordinate(0,200),20,30,randomform())
         self.BluArmyStateL = self.BluArmyState
      end
    elseif self.BluArmyState == 1 then
      if self.BluArmyStateL ~= self.BluArmyState then
        self.BluArmy:RouteGroundOnRoad(SUKZONE:GetRandomCoordinate(0,200),20,30,randomform())
        self.BluArmyStateL = self.BluArmyState
      end
    end
  end
  BASE:E({self.name, "Blue Army movement END",self.BluArmyState,self.BluArmyStateL})
  if balive1 == true then
    local bpos1 = self.BluArmy1:GetCoordinate()
    BASE:E({self.name,"Checking Blue Army 1 Conditions"})
    local closest = 0
    local bkd = bpos1:Get2DDistance(dk)
    local bsd = bpos1:Get2DDistance(dse)
    local bko = bpos1:Get2DDistance(dko)
    if ((SUKOWNER == 1) and (GUDOWNER == 1)) then
      -- if we aren't moving then we start routing to Kobuletti
      if self.BluArmyState1 == 5 then
        self.BluArmyState1 = 4
      end
      if KOBOWNER ~= 2 then
        if self.BluArmyState1 ~= 4 then
          self.BluArmyState1 = 4
        end 
      elseif KUTOWNER ~= 2 then
        if self.BluArmyState1 == 4 and bkd < 1000 then
          self.BluArmyState1 = 3
        elseif self.BluArmyState1 ~= 3 then
          self.BluArmyState1 = 3
        end
      elseif SENOWNER ~= 2 then
        if self.BluArmyState1 == 4 and bkd < 1000 then
          self.BluArmyState1 = 3
        elseif self.BluArmyState1 ~= 2 then
          self.BluArmyState1 = 2
        end
      else
        if self.BluArmyState1 == 4 and bpos1:Get2DDistance(dko) < 1000 then
          self.BluArmyState1 = 2        
        elseif self.BluArmyState1 == 3 and bpos1:Get2DDistance(dk) < 10000 then
          self.BluArmyState1 = 2
        elseif self.BluArmyState1 ~= 2 then
          self.BluArmyState1 = 2
        end        
      end
    end
  end
  BASE:E({self.name, "Blue Army 1 movement",self.BluArmyState1,self.BluArmyStateL1})
    if self.BluArmyState1 < 2 then
      self.BluArmyState1 = 4
    end
    if self.BluArmyState1 == 4 then
      if self.BluArmyStateL1 ~= self.BluArmyState1 then
        self.BluArmy1:RouteGroundOnRoad(KOBZONE:GetRandomCoordinate(),20,30,randomform())
        self.BluArmyStateL1 = self.BluArmyState1
      end
    elseif self.BluArmyState1 == 3 then
      if self.BluArmyStateL1 ~= self.BluArmyState1 then
        self.BluArmy1:RouteGroundOnRoad(KUTZONE:GetRandomCoordinate(),20,30,randomform())
        self.BluArmyStateL1 = self.BluArmyState1
      end 
    elseif self.BluArmyState1 == 2 then
      if self.BluArmyStateL1 ~= self.BluArmyState1 then
        self.BluArmy1:RouteGroundOnRoad(SENZONE:GetRandomCoordinate(),20,30,randomform())
        self.BluArmyStateL1 = self.BluArmyState1
      end
    else
      BASE:E({self.name,"BLUE ARMY 1 is in a state it shouldn't be in! setting to State 4"})
      self.BluArmyState1 = 4
      self.BluArmy1:RouteGroundOnRoad(KOBZONE:GetRandomCoordinate(),20,30,randomform())
      self.BluArmyStateL1 = self.BluArmyState1
    end
  BASE:E({self.name, "Blue Army 1 movement END",self.BluArmyState1,self.BluArmyStateL1})
  if balive2 == true then
    local bpos2 = self.BluArmy2:GetCoordinate()
    local closest = 0
    local bkd = bpos2:Get2DDistance(dk)
    local bsd = bpos2:Get2DDistance(dse)
    local bko = bpos2:Get2DDistance(dko)
    if bko > bkd and bko > bsd then
     if bsd > bkd then
      closest = 3
     else
      closest = 2
     end
    else
      closest = 4
    end 
    BASE:E({self.name,"Blue Army 2 Conditions and Movement",closest,bkd,bsd,bko})
    BASE:E({self.name, "Blue Army 2 States",self.BluArmyState2,self.BluArmyStateL2})
    if KOBOWNER ~= 2 then
      if self.BluArmyState2 == 5 then
        self.BluArmyState2 = closest -- start us moving north.
      elseif self.BluArmyState2 == 3 and bpos2:Get2DDistance(dk) < 5000 then
        self.BluArmyState2 = 4
      elseif Self.BluArmyState2 == 2 and bpos2:Get2DDistance(dse) < 5000 then
        self.BluArmyState2 = 4
      end
    elseif KUTOWNER ~= 2 then
      if self.BluArmyState2 == 5 then
        self.BluArmyState2 = 3 -- Kut Shoudl always be the closer and even if it's not..
      elseif self.BluArmyState2 ~= 3 then
        self.BluArmyState2 = 3 -- redirect to Kut automatically it should be closest.
      end
    elseif SENOWNER ~= 2 then
      if self.BluArmyState2 == 3 and bkd > 1000 then
        self.BluArmyState2 = 2
      else
        self.BluArmyState2 = 2
      end
    else
      self.BluArmyState2 = 5
    end
    BASE:E({self.name, "Blue Army 2 movement",self.BluArmyState2,self.BlueArmyStateL2})
    if self.BluArmyState2 == 4 then
      if self.BluArmyStateL2 ~= self.BluArmyState2 then
        self.BluArmy2:RouteGroundOnRoad(KOBZONE:GetRandomCoordinate(),20,30,randomform())
        self.BluArmyStateL2 = self.BluArmyState2
      end
    elseif self.BluArmyState2 == 3 then
      if self.BluArmyStateL2 ~= self.BluArmyState2 then
        self.BluArmy2:RouteGroundOnRoad(KUTZONE:GetRandomCoordinate(),20,30,randomform())
        self.BluArmyStateL2 = self.BluArmyState2
      end 
    elseif self.BluArmyState2 == 2 then
      if self.BluArmyStateL2 ~= self.BlueArmyState2 then
        self.BluArmy2:RouteGroundOnRoad(SENZONE:GetRandomCoordinate(),20,30,randomform())
        self.BluArmyStateL2 = self.BluArmyState2
      end
    elseif self.BluArmyState2 == 5 then
      if self.BluArmyStateL2 ~= self.BlueArmyState2 then
        self.BluArmyStateL2 = self.BluArmyState2
      end
    else
      BASE:E({self.name,"We were in a state we shouldn't be able to get into on BlueArmy2"})
    end
  BASE:E({self.name, "Blue Army 2 States End",self.BluArmyState2,self.BluArmyStateL2})    
  end
  BASE:E({self.name,"end Blue Army 0,1,2",self.BluArmyState,self.BluArmyState1,self.BluArmyState2})
 end
 
 function RIB:Gunships()
 local randomchance = math.random(1,100)
  BASE:E({self.name,"sead",randomchance})
  if randomchance > 85 then
    if self.bsead == nil then
      BASE:E({self.name,"Blue Sead was nil spawning them in"})
      self.bsead = SPAWN:New("Viper11"):InitRepeatOnLanding():InitCleanUp(120):Spawn()
    else
      if self.bsead:IsAlive() ~= true or self.bsead:AllOnGround() == true then
        self.bsead:Destroy()
        self.bsead = SPAWN:New("Viper11"):InitRepeatOnLanding():InitCleanUp(120):Spawn()
      end
    end
    if self.battack == nil then
      BASE:E({self.name,"Blue Attack was nil spawning them in"})
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
      BASE:E({self.name,"Russian Helo's were nil spawning them in"})
      self.russianhelos = SPAWN:New("RAH"):InitRepeatOnLanding():InitCleanUp(120):Spawn()
    else
      if self.russianhelos:IsAlive() ~= true or self.russianhelos:AllOnGround() == true then
        BASE:E({self.name,"Russian Helo's were not alive or all on ground spawning new set"})
        self.russianhelos:Destroy()
        self.russianhelos = SPAWN:New("RAH"):InitRepeatOnLanding():InitCleanUp(120):Spawn()
      else
          BASE:E({self.name,"Russian Helo's are alive, continuing."})
      end
    end
  end
  local brand = math.random(1,100)
  if brand > 70 then
    if self.bapache == nil then 
      BASE:E({self.name,"Apaches nil spawning"})
      self.bapache = SPAWN:New("Apaches"):InitRepeatOnLanding():InitCleanUp(120):Spawn()
    else
      if self.bapache:IsAlive() ~= true or self.bapache:AllOnGround() == true then
        BASE:E({self.name,"Apaches are not alive or all on ground spawning in new set"})
        self.bapache:Destroy()
        self.bapache = SPAWN:New("Apaches"):InitRepeatOnLanding():InitCleanUp(120):Spawn()
      else
        BASE:E({self.name,"Apaches are fine"})      
      end
    end  
  end  
 end
 
 function RIB:BInsurgents()
  BASE:E({self.name, "Insurgent Thread"})
  local BCS = SET_CLIENT:New():FilterCoalitions("blue"):FilterActive():FilterOnce()
  local BC = BCS:Count()
  local BCS = SET_CLIENT:New():FilterCoalitions("blue"):FilterCategories("helicopter"):FilterActive():FilterOnce()
  BASE:E({self.name, "Client count is",BC})
  BASE:E({self.name, "Blue Client Heli count is",BCS:Count()})
  local v1 = 110
  local v2 = 110
  local v3 = 110
  local v4 = 110
 if (BC >= 1) and (BC <=2) then
    BASE:E({self.name,"We have red clients!"})
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
    BASE:E({self.name,"Insurgents 1 C/V",chance,v1})
    if self.insurgent1 == nil then
      -- we don't have any insurgents in slot 1!   
        if chance > v1 then
        BASE:E({self.name,"Spawning Insurgents 1 C/V",chance,v1})
        self.insurgent1 = self.insurgent1s:Spawn()
        end  
    else
      if self.insurgent1:IsAlive() ~= true then
        if chance > v1 then
          -- we don't have any insurgents in slot 1!
          BASE:E({self.name,"Spawning Insurgents 1 C/V",chance,v1})   
          self.insurgent1 = self.insurgent1s:Spawn()
        end        
      end
    end
    chance = math.random(0,100)
    BASE:E({self.name,"Insurgents 2 C/V",chance,v2})
    if self.insurgent2 == nil then
      -- we don't have any insurgents in slot 2!   
        if chance > v2 then
        BASE:E({self.name,"Spawning Insurgents 2 C/V",chance,v2})
        self.insurgent2 = self.insurgent2s:Spawn()
        end
    else
      if self.insurgent2:IsAlive() ~= true then
      if chance > v2 then
        -- we don't have any insurgents in slot 2!
        BASE:E({self.name,"Spawning Insurgents 2 C/V",chance,v2})   
        self.insurgent2 = self.insurgent1s:Spawn()
      end
      end
    end
    BASE:E({self.name,"Insurgents 3 C/V",chance,v3})
    chance = math.random(0,100)
    if self.insurgent3 == nil then
      -- we don't have any insurgents in slot 3!   
        if chance > v3 then
        BASE:E({self.name,"Spawning Insurgents 3 C/V",chance,v3})
        self.insurgent3 = self.insurgent3s:Spawn()
        end
    else
      if self.insurgent3:IsAlive() ~= true then
      if chance > v3 then
        -- we don't have any insurgents in slot 1!
        BASE:E({self.name,"Spawning Insurgents 3 C/V",chance,v3})   
        self.insurgent3 = self.insurgent3s:Spawn()
      end
      end
    end
        chance = math.random(0,100)
        BASE:E({self.name,"Insurgents 4 C/V",chance,v4})
    if self.insurgent4 == nil then
      -- we don't have any insurgents in slot 4!   
        if chance > v4 then
        BASE:E({self.name,"Spawning Insurgents 4 C/V",chance,v4})
        self.insurgent4 = self.insurgent4s:Spawn()
        end
    else
      if self.insurgent4:IsAlive() ~= true then
      if chance > v4 then
        -- we don't have any insurgents in slot 4!
        BASE:E({self.name,"Spawning Insurgents 4 C/V",chance,v4})   
        self.insurgent4 = self.insurgent4s:Spawn()
      end
      end
    end
 end
 
  
function RIB:RAttackers()
local randomchance = math.random(1,100)
BASE:E({self.name,"sead",randomchance})
  if randomchance > 85 then
    if self.rsead ~= nil then
      if self.rsead:IsAlive() ~= true or self.rsead:AllOnGround() == true then
        self.rsead = SPAWN:NewWithAlias("Sqn119-SEAD","Sqn199-SEAD"):InitRandomizeRoute(1,4,2000,1500):Spawn()  
      end
    else
      self.rsead = SPAWN:NewWithAlias("Sqn119-SEAD","Sqn199-SEAD"):InitRandomizeRoute(1,4,2000,1500):Spawn()
    end
    if self.rattack ~= nil then
      if self.rattack:IsAlive() ~= true or self.rattack:AllOnGround() == true then
        self.rattack = SPAWN:NewWithAlias("Sqn119 BAI","Sqn119 BAI"):InitRandomizeRoute(1,4,2000,1500):Spawn()
      end
    else
      self.rattack = SPAWN:NewWithAlias("Sqn119 BAI","Sqn119 BAI"):InitRandomizeRoute(1,4,2000,1500):Spawn()
    end
    end
    BASE:E({self.name,"99",randomchance})
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
end



function RIB:RInsurgents()
  BASE:E({self.name, "Red Insurgent Thread"})
  local RBC = SET_CLIENT:New():FilterCoalitions("red"):FilterActive():FilterOnce()
  RBC = RBC:Count()      
  local RBCS = SET_CLIENT:New():FilterCoalitions("red"):FilterCategories("helicopter"):FilterActive():FilterOnce()
  BASE:E({self.name, "Red Client count is",RBC})
  BASE:E({self.name, "Red Client Heli count is",RBCS:Count()})
  local v1 = 110
  local v2 = 110
  local v3 = 110
  local v4 = 110
  if (RBC >= 1) and (RBC <=2) then
    BASE:E({self.name,"We have red clients!"})
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
    BASE:E({self.name,"Insurgents 1 C/V",rchance,v1})
    if self.rinsurgent1 == nil then
      -- we don't have any insurgents in slot 1!   
        if rchance > v1 then
        BASE:E({self.name,"Spawning RInsurgents 1 C/V",rchance,v1})
        self.rinsurgent1 = self.rinsurgent1s:Spawn()
        end  
    else
      if self.rinsurgent1:IsAlive() ~= true then
        if rchance > v1 then
          -- we don't have any insurgents in slot 1!
          BASE:E({self.name,"Spawning RInsurgents 1 C/V",rchance,v1})   
          self.rinsurgent1 = self.rinsurgent1s:Spawn()
        end        
      end
    end
    rchance = math.random(0,100)
    BASE:E({self.name,"RInsurgents 2 C/V",rchance,v2})
    if self.irnsurgent2 == nil then
      -- we don't have any insurgents in slot 2!   
        if rchance > v2 then
        BASE:E({self.name,"Spawning RInsurgents 2 C/V",rchance,v2})
        self.irnsurgent2 = self.rinsurgent2s:Spawn()
        end
    else
      if self.rinsurgent2:IsAlive() ~= true then
      if rchance > v2 then
        -- we don't have any insurgents in slot 2!
        BASE:E({self.name,"Spawning RInsurgents 2 C/V",rchance,v2})   
        self.rinsurgent2 = self.rinsurgent1s:Spawn()
      end
      end
    end
    BASE:E({self.name,"RInsurgents 3 C/V",rchance,v3})
    rchance = math.random(0,100)
    if self.rinsurgent3 == nil then
      -- we don't have any insurgents in slot 3!   
        if rchance > v3 then
        BASE:E({self.name,"Spawning RInsurgents 3 C/V",rchance,v3})
        self.rinsurgent3 = self.rinsurgent3s:Spawn()
        end
    else
      if self.rinsurgent3:IsAlive() ~= true then
      if rchance > v3 then
        -- we don't have any insurgents in slot 1!
        BASE:E({self.name,"Spawning RInsurgents 3 C/V",rchance,v3})   
        self.rinsurgent3 = self.rinsurgent3s:Spawn()
      end
      end
    end
        rchance = math.random(0,100)
        BASE:E({self.name,"RInsurgents 4 C/V",rchance,v4})
    if self.rinsurgent4 == nil then
      -- we don't have any insurgents in slot 4!   
        if rchance > v4 then
        BASE:E({self.name,"Spawning RInsurgents 4 C/V",rchance,v4})
        self.rinsurgent4 = self.rinsurgent4s:Spawn()
        end
    else
      if self.rinsurgent4:IsAlive() ~= true then
      if rchance > v4 then
        -- we don't have any insurgents in slot 4!
        BASE:E({self.name,"Spawning Insurgents 4 C/V",rchance,v4})   
        self.rinsurgent4 = self.rinsurgent4s:Spawn()
      end
      end
    end
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
  
  if PersistedStore.noclients ~= nil then
    noclients = PersistedStore.noclients
  else
    noclients = 0
  end
  BASE:E{self.name, "Rounds loaded",CurrentRound,LastRound,roundreset}
  if PersistedStore.kobuleti == 2 or PersistedStore.kobuleti == 0 then
    KOBOWNER = 2
    BASE:E({self.name,"Spawning Blue Kobeleti Defenses"})
    if mainmission.BlueKobSpawned ~= 0 then
      BASE:E({self.name,"Main mission blue kobspawned was not nil trying to find group.",mainmission.BlueKobSpawned})
      self.BlueKobSpawned = GROUP:FindByName(mainmission.BlueKobSpawned)
    else
      BASE:E({self.name,"Main mission blue kobspawned was nil spawning in new unit"})
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
    if self.kobsqn ~= nil then
      self.kobsqn:SpawnScheduleStop()
    else
      BASE:E({self.name,"Kob sqn was NIL this shouldn't happen!"})
    end
  end
  if PersistedStore.senaki == 2 or PersistedStore.senaki == 0 then
    SENOWNER = 2
    BASE:E({self.name,"Spawning Blue Sen Defenses, opening blue slots"})
    if mainmission.BlueSenSpawned ~= 0 then
      BASE:E({self.name,"Main mission blue Sen spawned was not nil trying to find.",mainmission.BlueKobSpawned})
      self.BlueSenSpawned = GROUP:FindByName(mainmission.BlueKobSpawned)
    else
      BASE:E({self.name,"Main mission blue Sen spawned was nil spawning in new unit"})
      self.BlueSenSpawned = self.BlueSenSpawn:Spawn()
    end
    allowbluesen()
  else
    SENOWNER = 1
    BASE:E({self.name,"Spawning RAFD Sen Defenses, closing blue slots"})
    if mainmission.RedSenSpawned ~= 0 then
      BASE:E({self.name,"Main mission Red Sen spawned was not nil trying to find.",RedSenSpawned})
      self.RedSenSpawned = GROUP:FindByName(mainmission.RedSenSpawned)
    else
      BASE:E({self.name,"Main mission Red Sen spawned was nil spawning in new unit"})
      self.RedSenSpawned = self.RedSenSpawn:Spawn()
    end
     disallowbluesen()
    if self.sensqn ~= nil then
      self.sensqn:SpawnScheduleStop()
    else
      BASE:E({self.name,"sensqn was nil this shouldn't happen"})
    end
  end
  if PersistedStore.kutaisi == 2 or PersistedStore.kutaisi == 0 then
    KUTOWNER = 2
    BASE:E({self.name,"Spawning Blue KUT Defenses, opening blue slots"})
    if mainmission.BlueKutSpawned ~= 0 then
      BASE:E({self.name,"Main mission blue kutspawned was not nil trying to find.",mainmission.BlueKutSpawned})
      self.BlueKutSpawned = GROUP:FindByName(mainmission.BlueKutSpawned)
    else
      BASE:E({self.name,"Main mission blue Kutspawned was nil spawning in new unit"})
      self.BlueKutSpawned = self.BlueKutSpawn:Spawn()
    end
         MESSAGE:New("INIT KUT OWNED BY BLUE",30):ToAll()
            allowbluekut()
    else
            KUTOWNER = 1
            MESSAGE:New("INIT KUT OWNED BY RED",30):ToAll()
            BASE:E({self.name,"Spawning RAFD Kut Defenses, opening blue slots"})
            if mainmission.RedKutSpawned ~= 0 then
              BASE:E({self.name,"Main mission Red kutspawned was not nil trying to find.",mainmission.BlueKutSpawned})
              self.RedKutSpawned = GROUP:FindByName(mainmission.RedKutSpawned)
            else
              BASE:E({self.name,"Main mission Red kutspawned was nil spawning in new unit"})
              self.RedKutSpawned = self.RedKutSpawn:Spawn()
            end
            disallowbluekut()
            if self.kutsqn ~= nil then
              self.kutsqn:SpawnScheduleStop()
            else
              BASE:E({self.name,"Kutsqn was nil this shoulnd't happen"})
            end
      end
  if (PersistedStore.sukhumi == 1) or (PersistedStore.sukhumi == 0) then
    BASE:E({self.name,"Red Spawning Sukhumi Defenses."})
    if mainmission.RedSukSpawned ~= 0 then
      BASE:E({self.name,"Main mission Red Sukspawned was not nil trying to find.",mainmission.RedSukSpawned})
      self.RedSukSpawned = GROUP:FindByName(mainmission.RedSukSpawned)
    else
      BASE:E({self.name,"Main mission blue kobspawned was nil spawning in new unit"})
      self.RedSukSpawned = self.RedSukDefSpawn:Spawn()
    end
    SUKOWNER = 1
    MESSAGE:New("INIT SUK OWNED BY RED",30):ToAll() 
          allowredsuk()
          disallowbluesuk()
          BASE:E({self.name,"Blue Slots Should be Closed at Suk"})          
  elseif PersistedStore.sukhumi == 2 then
    SUKOWNER = 2
    BASE:E({self.name,"Blue Spawning Sukhumi Defenses."})
         MESSAGE:New("INIT Suk OWNED BY Blue",30):ToAll()
    if mainmission.BlueSukSpawned ~= 0 then
      BASE:E({self.name,"Main mission Blue Sukspawned was not nil trying to find.",mainmission.BlueSukSpawned})
      self.BlueSukSpawned = GROUP:FindByName(mainmission.BlueSukSpawned)
    else
      BASE:E({self.name,"Main mission blue kobspawned was nil spawning in new unit"})
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
    if mainmission.RedGudSpawned ~= 0 then
      BASE:E({self.name,"Main mission Red Gudspawned was not nil trying to find.",mainmission.RedGudSpawned})
      self.RedGudSpawned = GROUP:FindByName(mainmission.RedGudSpawned)
    else
      BASE:E({self.name,"Main mission red Gudspawned was nil spawning in new unit"})
      self.RedGudSpawned = self.RedGudDefSpawn:Spawn()
    end
     MESSAGE:New("INIT: GUD OWNED BY RED",30):ToAll()
     disallowbluegud()
     allowredgud()
  elseif PersistedStore.gudauta == 2 then
     GUDOWNER = 2
     BASE:E({self.name,"Blue Spawning Guduata Defences"})
     if mainmission.BlueGudSpawned ~= 0 then
      BASE:E({self.name,"Main mission Blue Gudspawned was not nil trying to find.",mainmission.BlueGudSpawned})
      self.BlueGudSpawned = GROUP:FindByName(mainmission.BlueGudSpawned)
    else
      BASE:E({self.name,"Main mission Blue Gudspawned was nil spawning in new unit"})
      self.BlueGudSpawned = self.RedBlueDefSpawn:Spawn()
    end
     self.BluGudDef = self.BluGudDefSpawn:Spawn()
     MESSAGE:New("INIT GUD OWNED BY BLUE",30):ToAll()
     disallowredgud()
     allowbluegud()
  else
      BASE:E({self.name, "PersistedStore.Guduata reported as",PersistedStore.gudauta})
  end
  if PersistedStore.ralive == 1 then
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
        BASE:E({self.name,"mainmission.RedArmySpawned was nil we need to spawn in a new one"})
        self.RedArmy = self.RedArmySpawn:SpawnFromPointVec2(tempvec2)
        self.RedArmySpawned = self.RedArmy
      end
      BASE:E({self.name,"Red Army should be spawned"})
     else
      if mainmission.RedArmySpawned ~= 0 then
        BASE:E({self.name,"Coords were 0,0 but we had a stored unit so using it"})
        BASE:E({self.name,"Mainmission.RedArmySpawned was not nil looking for group",mainmission.RedArmySpawned})
        self.RedArmy = GROUP:FindByName(mainmission.RedArmySpawned)
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
        self.RedArmySpawned = self.RedArmy
      end
     end
  else
     BASE:E({self.name,"Red Army was dead so it should be at the start again"})
     self.RedArmy = self.RedArmySpawn:Spawn()
     self.RedArmySpawned = self.RedArmy
  end
  if PersistedStore.ralive1 == 1 then
     BASE:E({self.name,"Red Army 1 was alive in Persistance table, destroying old making new"})
     if PersistedStore.rx1 ~= 0 and PersistedStore.ry1 ~= 0 then
      self.RedArmyX1 = PersistedStore.rx1
      self.RedArmyY1 = PersistedStore.ry1
      self.RedArmyState1 = PersistedStore.RedArmyState1
      local tempvec2 = POINT_VEC2:New(PersistedStore.rx1,PersistedStore.ry1)
      if mainmission.RedArmy1Spawned ~= 0 then
        BASE:E({self.name,"RED ARMY 1 was not nil looking for group",mainmission.RedArmy1Spawned})
        self.RedArmy1 = GROUP:FindByName(mainmission.RedArmy1Spawned)
        self.RedArmy1Spawned = self.RedArmy1
        if self.RedArmy1 == nil then
          BASE:E({self.name,"REDARMY1 Reported NIL! No group found in search!"})
          self.RedArmy1 = self.RedArmySpawn1:SpawnFromPointVec2(tempvec2)
          self.RedArmy1Spawned = self.RedArmy1
        else
          local ccord = self.RedArmy1:GetCoordinate()
          if ccord:IsSurfaceTypeWater() == true then
            BASE:E({self.name,"RedArmy1 was in the water! DESTROYING IT"})
            self.RedArmy1:Destroy()
            self.RedArmy1Spawned = 0
          end
        end
      else
        BASE:E({self.name,"Mainmission.RedArmy1Spawned was nil we need to spawn a new one"})
        self.RedArmy1 = self.RedArmySpawn1:SpawnFromPointVec2(tempvec2)
        self.RedArmy1Spawned = self.RedArmy1 
      end
      BASE:E({self.name,"Red Army 1 should be spawned"})
     else
     
      BASE:E({self.name,"Coords were 0,0 so using base spawn and not destroying after all!"})
      if mainmission.RedArmy1Spawned ~= 0 then
        BASE:E({self.name,"RED ARMY 1 was not nil looking for group",mainmission.RedArmy1Spawned})
        self.RedArmy1 = GROUP:FindByName(mainmission.RedArmy1Spawned)
        self.RedArmy1Spawned = self.RedArmy1
        if self.RedArmy1 == nil then
          BASE:E({self.name,"REDARMY1 Reported NIL! No group found in search!"})
          self.RedArmy1 = self.RedArmySpawn1:Spawn()
        self.RedArmy1Spawned = self.RedArmy1
        else
          local ccord = self.RedArmy:GetCoordinate()
          if ccord:IsSurfaceTypeWater() == true then
            BASE:E({self.name,"RedArmy1 was in the water! DESTROYING IT"})
            self.RedArmy1:Destroy()
            self.RedArmy1Spawned = 0
            self.RedArmy1 = self.RedArmySpawn1:Spawn()
            self.RedArmy1Spawned = self.RedArmy1
          end
        end
         
      end
     end
  else
     BASE:E({self.name,"Red Army 1 was dead so it should be at the start again"})
     self.RedArmy1 = self.RedArmySpawn1:Spawn()
     self.RedArmy1Spawned = self.RedArmy1
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
      self.BluArmyX1 = PersistedStore.bx1
      self.BluArmyY1 = PersistedStore.by1
      self.BluArmyState1 = PersistedStore.BluArmyState1 
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
      self.BluArmyX2 = PersistedStore.bx2
      self.BluArmyY2 = PersistedStore.by2
      self.BluArmyState2 = PersistedStore.BluArmyState2
      local tempvec2 = POINT_VEC2:New(PersistedStore.bx2,PersistedStore.by2)
       if mainmission.BlueArmy2Spawned ~= 0 then
       BASE:E({self.name,"BLUE ARMY2 returned not nil on a group find",mainmission.BlueArmy2Spawned})
        self.BluArmy2 = GROUP:FindByName(mainmission.BlueArmy2Spawned)
        self.BlueArmy2Spawned = self.BluArmy2   
        if self.BluArmy2 == nil then
          BASE:E({self.name,"BluArmy2 returned nil spawning in old fashioned way"})
          self.BluArmy2 = self.BluArmy2Spawn:SpawnFromPointVec2(tempvec2)
          self.BlueArmy2Spawned = self.BluArmy2
        else
          local ccord = self.BluArmy2:GetCoordinate()
          if ccord:IsSurfaceTypeWater() == true then
            BASE:E({self.name,"BLUE ARMY2 WAS REPORTED ON WATER! DESTROYING IT"})
            self.BluArmy2:Destroy()
            self.BlueArmy2Spawned = 0
            self.BluArmy2 = self.BluArmy2Spawn:Spawn()
            self.BlueArmy2Spawned = self.BluArmy2
          end
        end
      else
        self.BluArmy2 = self.BluArmy2Spawn:SpawnFromPointVec2(tempvec2)
        self.BlueArmy2Spawned = self.BluArmy2
      end
      BASE:E({self.name,"Blu Army 2 should be spawned"})
     else
      if mainmission.BlueArmy2Spawned ~= 0 then
        BASE:E({self.name,"Coords were 0,0 but we had a stored unit using it instead"})
        BASE:E({self.name,"BLUE ARMY2 returned not nil on a group find",mainmission.BlueArmy2Spawned})
        self.BluArmy2 = GROUP:FindByName(mainmission.BlueArmy2Spawned)
        self.BlueArmy2Spawned = self.BluArmy2   
        if self.BluArmy2 == nil then
          BASE:E({self.name,"BluArmy2 returned nil spawning in old fashioned way"})
          BASE:E({self.name,"Coords were 0,0 so using base spawn and not destroying after all!"})
          self.BluArmy2 = self.BluArmy2Spawn:Spawn()
          self.BlueArmy2Spawned = self.BluArmy2
        else
          local ccord = self.BluArmy2:GetCoordinate()
          if ccord:IsSurfaceTypeWater() == true then
            BASE:E({self.name,"BLUE ARMY2 WAS REPORTED ON WATER! DESTROYING IT"})
            self.BluArmy2:Destroy()
            self.BlueArmy2Spawned = 0
            self.BluArmy2 = self.BluArmy2Spawn:Spawn()
            self.BlueArmy2Spawned = self.BluArmy2
          end
        end
      else
        BASE:E({self.name,"Coords were 0,0 so using base spawn and not destroying after all!"})
        self.BluArmy2 = self.BluArmy2Spawn:Spawn()
        self.BlueArmy2Spawned = self.BluArmy2
      end
     end
  else
     BASE:E({self.name,"Blu Army 2 was dead so it should be at the start again"})
     self.BluArmy2 = self.BluArmy2Spawn:Spawn()
     self.BlueArmy2Spawned = self.BluArmy2
  end

  BASE:E({self.name,"Command Center Persistences"})
  BASE:E({self.name,"Command Center Novo"})
  if PersistedStore.NovoCommand ~= nil then
    if PersistedStore.NovoCommand == 0 then
      if PersistedStore.NovoRound ~= CurrentRound then
        if novocommand:IsAlive() == true then
          SCHEDULER:New(nil,function()
           novocommand:Destroy() 
           BASE:E({self.name,"Novocommand was reported as 0 current round and Novoround don't match destroying",PersistedStore.NovoRound,PersistedStore.NovoCommand})
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
      if PersistedStore.MayRound ~= CurrentRound then
        if maycommand:IsAlive() == true then
          SCHEDULER:New(nil,function() maycommand:Destroy()
          BASE:E({self.name,"Maycommand was reported as 0 current round and Mayround don't match destroying",PersistedStore.MayRound,PersistedStore.MayCommand})
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
      if PersistedStore.KrazRound ~= CurrentRound then
        if krazcommand:IsAlive() == true then
          SCHEDULER:New(nil,function() krazcommand:Destroy()
          BASE:E({self.name,"Krazcommand was reported as 0 current round and Krazround don't match destroying",PersistedStore.KrazRound,PersistedStore.KrazCommand})
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
      if PersistedStore.MozRound ~= CurrentRound then
        if mozcommand:IsAlive() == true then
          SCHEDULER:New(nil,function() mozcommand:Destroy()
          BASE:E({self.name,"mozcommand was reported as 0 current round and Mozzround don't match destroying",PersistedStore.MozRound,PersistedStore.MozCommand})
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
   if noclients < 2 then
    self.BInsurgents(self)
   else
    BASE:E({self.name,"BInsurgent Tick did not run because No Clients was greater then 2"})
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
end 

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

 --- Spawn A2ACap instantates a unit and places it into the ai_cap_zone fsm.
 -- @param #Group Sqn the template group to use for the spawn
 -- @param #Table Templates Table of tempaltes to use for random spawning.
 -- @param #int maxair maximum allowed to be in the air at one time.
 -- @param #int maxtotal maximum allowed units in total
 -- @param #ZONE capzone the zone to patrol.
 -- @param #ZONE detectzone the zone to look for enemies in.
 -- @param #int engagerange Range in NM to engage units.
 -- @param #int minalt Minimum patrol altitude in ft.
 -- @param #int maxalt Max Patrol altitude in FT
 -- @param #int minspeed Min Speed in Knots.
 -- @param #int maxspeed Max Speed in knots.
 -- @param #int respawn number of seconds between spawns
 -- @param #int respawnhigh number of seconds between spawns
 -- @param #float varamount 0 - 1 variation in % of spawn amount. 
 function spawnA2ACap(Sqn,store,templates,maxair,maxtotal,capzone,detectzone,engagerange,minalt,maxalt,minspeed,maxspeed,respawn, respawnhigh,varamount)
    BASE:E({"setting up spawning sqn",Sqn})
    local respawntime = math.random(respawn,respawnhigh)
    local A2ASpawn = SPAWN:New(Sqn):InitRandomizeTemplatePrefixes(templates)
        :OnSpawnGroup(
            function(group)
                BASE:E({"spawning sqn",Sqn})
                --local patrol = AI_PATROL_ZONE:New(zone, 3000, 6000, 500, 800)
                local patrol = AI_CAP_ZONE:New(capzone, UTILS.FeetToMeters(minalt),UTILS.FeetToMeters(maxalt), UTILS.KnotsToKmph(minspeed),UTILS.KnotsToKmph(maxspeed))
                patrol:ManageFuel(0.30, 60)
                patrol:SetDetectionOn()
                patrol:SetRefreshTimeInterval(30)
                patrol:SetDetectionZone(detectzone)
                patrol:SetEngageZone(detectzone)
                patrol:SetEngageRange(UTILS.NMToMeters(engagerange))
                patrol:SetControllable(group)
                patrol:__Start(3)
                
                function patrol:OnAfterStart(Controllable, From, Event, To)
                    patrol:HandleEvent(EVENTS.PilotDead)
                    patrol:HandleEvent(EVENTS.Ejection)
                    
                end
                function patrol:onafterDestroy( Controllable, From, Event, To, EventData )
                  --  BASE:E(EventData.IniUnit:GetName() .. "Inside onafterDestroy")
                end
               
                function patrol:OnEventPilotDead(EventData)
                    BASE:E(EventData.IniUnit:GetName() .. " pilot has died")
                    if patrol.DetectedUnits and patrol.DetectedUnits[EventData.IniUnit] then
                        BASE:E(EventData.IniUnit:GetName() .. "Pilot died patrol2.DetectedUnits[EventData.IniUnit]")
                        BASE:E("Pilot Died __Destroy")
                        patrol:__Destroy(1, EventData)
                    end
                    
                end

                function patrol:OnEventEjection(EventData)
                    BASE:E(EventData.IniUnit:GetName() .. " pilot has ejected")
                    if patrol.DetectedUnits and patrol.DetectedUnits[EventData.IniUnit] then
                        BASE:E(EventData.IniUnit:GetName() .. "Pilot eject patrol2.DetectedUnits[EventData.IniUnit]")
                        BASE:E("Ejection __Destroy")
                        patrol:__Destroy(1, EventData)
                    end
                    
                end
                store = patrol
                
            end
        )
        :InitLimit(maxair, maxtotal)
        :InitRepeatOnLanding()
        :SpawnScheduled(respawntime, varamount)
        return A2ASpawn
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

rradar = SET_GROUP:New()
rradar:FilterPrefixes({"RSAM","REWR","Wizard"}):FilterActive(true):FilterStart()
rdet = DETECTION_AREAS:New(rradar,30000)
cap1coord = ZONE:New("cap1")
cap2coord = ZONE:New("cap2")
cap3coord = ZONE:New("cap3")
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
ra2adisp:SetSquadronCap("NovoSqn",RCAP,UTILS.FeetToMeters(14000),UTILS.FeetToMeters(34000),UTILS.KnotsToKmph(350),UTILS.KnotsToKmph(500),UTILS.KnotsToKmph(450),UTILS.KnotsToKmph(650),"BARO")
ra2adisp:SetSquadronCapRacetrack("NovoSqn",UTILS.NMToMeters(10),UTILS.NMToMeters(25),0,359,(60*15),(60*(60*1)),{cap1coord:GetRandomCoordinate(),cap2coord:GetRandomCoordinate()})
ra2adisp:SetSquadronCapInterval("MozSqn",1,(60*5),(60*15),1.0)
ra2adisp:SetSquadronCap("MozSqn",RCAP3,UTILS.FeetToMeters(14000),UTILS.FeetToMeters(34000),UTILS.KnotsToKmph(350),UTILS.KnotsToKmph(500),UTILS.KnotsToKmph(450),UTILS.KnotsToKmph(650),"BARO")
ra2adisp:SetSquadronCapRacetrack("MozSqn",UTILS.NMToMeters(10),UTILS.NMToMeters(25),0,359,(60*15),(60*(60*1)),{cap2coord:GetRandomCoordinate(),cap3coord:GetRandomCoordinate()})
ra2adisp:SetSquadronCapInterval("KrasSqn",1,(60*1),(60*1),1.0)
ra2adisp:SetSquadronCap("KrasSqn",RCAP2,UTILS.FeetToMeters(14000),UTILS.FeetToMeters(34000),UTILS.KnotsToKmph(350),UTILS.KnotsToKmph(500),UTILS.KnotsToKmph(450),UTILS.KnotsToKmph(650),"BARO")
ra2adisp:SetSquadronCapRacetrack("KrasSqn",UTILS.NMToMeters(10),UTILS.NMToMeters(25),0,359,(60*15),(60*(60*1)),{cap1coord:GetRandomCoordinate(),cap2coord:GetRandomCoordinate()})
ra2adisp:SetSquadronCap("MaySqn",RCAP2,UTILS.FeetToMeters(14000),UTILS.FeetToMeters(34000),UTILS.KnotsToKmph(350),UTILS.KnotsToKmph(500),UTILS.KnotsToKmph(450),UTILS.KnotsToKmph(650),"BARO")
ra2adisp:SetSquadronCapInterval("MaySqn",1,(60*5),(60*15),1.0)
ra2adisp:SetSquadronGci("SochiSqn",UTILS.KnotsToKmph(450),UTILS.KnotsToKmph(650))


--[[
mainthread.novosqn = spawnA2ACap("NovoSqn",novo,RCAPTEMPLATES,2,math.random(12,32),RCAP,RAS,120,15000,35000,300,450,600,0.5)
mainthread.mozsqn = spawnA2ACap("MozSqn",novo,RCAPTEMPLATES,2,math.random(12,32),RCAP3,RAS,120,15000,35000,300,450,600,0.5)
mainthread.maysqn = spawnA2ACap("MaySqn",may,RCAPTEMPLATES,2,math.random(12,32),RCAP2,RAS,120,15000,35000,300,500,600,0.5)
mainthread.krassqn = spawnA2ACap("KrasSqn",kras,RCAPTEMPLATES,2,math.random(12,32),RCAP3,RAS,120,15000,35000,300,450,120,0.5)
]]
mainthread.kobsqn = spawnA2ACap("kobSqn",kob,BCAPTEMPLATES,1,math.random(12,24),BCAP,BAS,120,15000,35000,300,450,(60*2),(60*15),0.5)
mainthread.kutsqn = spawnA2ACap("kutSqn",kut,BCAPTEMPLATES,1,math.random(12,24),BCAP2,BAS,120,15000,35000,300,450,(60*2),(60*15),0.5)
mainthread.sensqn = spawnA2ACap("senSqn",sen,BCAPTEMPLATES,1,math.random(12,24),BCAP3,BAS,120,15000,35000,300,450,(60*2),(60*15),0.5)
mainthread.vfa192 = spawnA2ACap("vfa192",vfa192,SCAPTEMPLATES,2,math.random(12,24),SAS1,SAS,60,20000,30000,350,450,(60*2),(60*15),0.5)

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
    BASE:E({"Getting Squadron amounts if any under 12 give them 4 new units if factory units alive"})
    if novocommand:IsAlive() == true then
      if RSweepAmount < 8 then
        RSweepAmount = RSweepAmount + 2
      end
      sqn = "NovoSqn"
      BASE:E({"Novorossiysk Sqn Amount is",ra2adisp:GetSquadronAmount(sqn)})
      local _amount = ra2adisp:GetSquadronAmount(sqn)
      if _amount < 8 then
        local addamount = math.random(2,6)
        ra2adisp:ReinforceSquadron(sqn,(_amount + addamount))
        local _amount2 = ra2adisp:GetSquadronAmount(sqn)
        MESSAGE:New("Novorossiysk CAP Sqn was just reinforced with ".. addamount .. "New Aircraft")
        BASE:E({"Novorossiysk Sqn Amount after add is",ra2adisp:GetSquadronAmount(sqn)})
      end
    end
    if mozcommand:IsAlive() == true then
    sqn = "MozSqn"
      BASE:E({"MozSqn Amount is",ra2adisp:GetSquadronAmount(sqn)})
      local _amount = ra2adisp:GetSquadronAmount(sqn)
      if _amount < 8 then
        local addamount = math.random(2,6)
        ra2adisp:ReinforceSquadron(sqn,(_amount + addamount))
        local _amount2 = ra2adisp:GetSquadronAmount(sqn)
        MESSAGE:New("Mozdok CAP Sqn was just reinforced with ".. addamount .. "New Aircraft")
        BASE:E({"Moz Sqn Amount after add is",ra2adisp:GetSquadronAmount(sqn)})
      end
    end
    if maycommand:IsAlive() == true then
      sqn = "MaySqn"
      BASE:E({"Novorossiysk Sqn Amount is",ra2adisp:GetSquadronAmount(sqn)})
      local _amount = ra2adisp:GetSquadronAmount(sqn)
      if _amount < 8 then
        local addamount = math.random(2,6)
        ra2adisp:ReinforceSquadron(sqn,(_amount + addamount))
        local _amount2 = ra2adisp:GetSquadronAmount(sqn)
        MESSAGE:New("Maydok CAP Sqn was just reinforced with ".. addamount .. "New Aircraft")
        BASE:E({"May Sqn Amount after add is",ra2adisp:GetSquadronAmount(sqn)})
      end
    end
    if krazcommand:IsAlive() == true then
      if RSweepAmount < 8 then
        RSweepAmount = RSweepAmount + 2
      end
      sqn = "KrasSqn"
      BASE:E({"Kras Sqn Amount is",ra2adisp:GetSquadronAmount(sqn)})
      local _amount = ra2adisp:GetSquadronAmount(sqn)
      if _amount < 8 then
        local addamount = math.random(2,6)
        ra2adisp:ReinforceSquadron(sqn,(_amount + addamount))
        local _amount2 = ra2adisp:GetSquadronAmount(sqn)
        MESSAGE:New("Krasnador CAP Sqn was just reinforced with ".. addamount .. "New Aircraft")
        BASE:E({"Kras Sqn Amount after add is",ra2adisp:GetSquadronAmount(sqn)})
      end
      sqn = "SochiSqn"
      BASE:E({"Sochi Sqn Amount is",ra2adisp:GetSquadronAmount(sqn)})
      local _amount = ra2adisp:GetSquadronAmount(sqn)
      if _amount < 2 then
        local addamount = math.random(2,6)
        ra2adisp:ReinforceSquadron(sqn,(_amount + addamount))
        local _amount2 = ra2adisp:GetSquadronAmount(sqn)
        MESSAGE:New("Sochi Adler GCI Sqn was just reinforced with ".. addamount .. "New Aircraft")
        BASE:E({"Sochi Sqn Amount after add is",ra2adisp:GetSquadronAmount(sqn)})
      end
    end
  else
    flipflop = false
  end
end, {}, 75,(30*60))

flipflop2 = false
redairspace = 0

function checkthings()
    BASE:E("Checking Command Groups")
  if novocommand:IsAlive() ~= true then
    if novo1 == 0 then
      BASE:E("NOVO Command is dead stopping sqns")
      novo1 = 1
      MESSAGE:New("Novorossiysk command has ceased to transmit, squadron is no longer active",15):ToAll()
      ra2adisp:SetSquadron("NovoSqn",AIRBASE.Caucasus.Novorossiysk,RCAPTEMPLATES,0)
      do
        _nc:RemoveMark(_nm)
        _nm = _nc:MarkToAll("Novorossisk Command Center, Destroyed",true)
        if PersistedStore.NovoCommand == 1 then
          PersistedStore.NovoCommand = 0
          PersistedStore.NovoRound = CurrentRound
        else
          BASE:E({"NovoCommand was reporting dead already not updating info."})
        end
      end
    --mainthread.novosqn:SpawnScheduleStop()
    end
  end
  if maycommand:IsAlive() ~= true then
    if may1 == 0 then
      may1 = 1 
      MESSAGE:New("Maykop command has ceased to transmit, squadrons are no longer active",15):ToAll()
      ra2adisp:SetSquadron("MaySqn",AIRBASE.Caucasus.Maykop_Khanskaya,RCAPTEMPLATES,0)
      do
        _mac:RemoveMark(_mam)
        _mam = _mac:MarkToAll("Maykop Command Center, Destroyed",true)
        if PersistedStore.MayCommand == 1 then
          PersistedStore.MayCommand = 0
          PersistedStore.MayRound = CurrentRound
        else
          BASE:E({"MayCommand was reporting dead already not updating info."})
        end
      end
    end
    -- mainthread.maysqn:SpawnScheduleStop()
    BASE:E("MAY Command is dead stopping sqns")
  end
  if mozcommand:IsAlive() ~= true then
    if moz1 == 0 then
      moz1 = 1 
      MESSAGE:New("Mozdok command has ceased to transmit, squadrons are no longer active",15):ToAll()
      ra2adisp:SetSquadron("MozSqn",AIRBASE.Caucasus.Mozdok,RCAPTEMPLATES,0)
      do
        _mc:RemoveMark(_mm)
        _mm = _mc:MarkToAll("Mozdok Command Center, Destroyed",true)
        if PersistedStore.MozCommand == 1 then
          BASE:E({"Moz Command was not dead in persistence updating"})
          PersistedStore.MozCommand = 0
          PersistedStore.MozRound = CurrentRound
        else
          BASE:E({"MozCommand was reporting dead already not updating info."})
        end
      end
    end
    -- mainthread.maysqn:SpawnScheduleStop()
    BASE:E("MAY Command is dead stopping sqns")
  end
  
  if krazcommand:IsAlive() ~= true then
    if kraz1 == 0 then
      kraz1 = 1
      ra2adisp:SetSquadron("KrasSqn",AIRBASE.Caucasus.Krasnodar_Center,RCAPTEMPLATES,0)
      MESSAGE:New("Krasnodar Center command has ceased to transmit, squadrons are no longer active",15):ToAll()
      do
        if PersistedStore.KrazCommand == 1 then
          _kc:RemoveMark(_km)
          _km = _km:MarkToAll("Krasnodar Command Center, Destroyed",true)
          PersistedStore.KrazCommand = 0
          PersistedStore.KrazRound = CurrentRound
        else
          BASE:E({"KrasCommand was reporting dead already not updating info."})
        end
      end
      --mainthread.krassqn:SpawnScheduleStop()
    end
    BASE:E("Kraz Command is dead stopping sqns")
  end
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
      ra2adisp:SetBorderZone(RAS)
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
        redairspace = 1
        BASE:E("Red controls Gud but not suk Border is extended to just beyond Gud")
      else
        BASE:E("Red controls Gud but not suk Border is already correct")
      end
    else
      if redairspace ~= 2 then
        ra2adisp:SetBorderZone(RAS2)
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
BASE:E("Stennis Heli")
-- start the airboss script
RescueheloStennis = RESCUEHELO:New(UNIT:FindByName("Stennis"), "SARBIRD")
RescueheloStennis:SetHomeBase(AIRBASE:FindByName("Normandy"))
RescueheloStennis:SetTakeoffHot()
RescueheloStennis:SetRescueOn()
RescueheloStennis:SetRespawnOn()
RescueheloStennis:SetTakeoffCold()
RescueheloStennis:SetRescueHoverSpeed(1)
RescueheloStennis:Start()
BASE:E("Stennis Tanker")
ShellStennis = RECOVERYTANKER:New(UNIT:FindByName("Stennis"), "Shell")
ShellStennis:SetRespawnOn()
ShellStennis:SetRespawnInAir()
ShellStennis:SetSpeed(290)
ShellStennis:SetCallsign(CALLSIGN.Tanker.Shell,1)
ShellStennis:SetRacetrackDistances(15,10)
ShellStennis:SetPatternUpdateDistance(10)
ShellStennis:SetRadio(254)
ShellStennis:SetModex(911)
ShellStennis:SetTACAN(9,"SHL")
ShellStennis:Start()
stanker = true

BASE:E("Stennis Airboss")

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

local AirbossStennis = AIRBOSS:New("Stennis","Mother")
-- Delete auto recovery window.
function AirbossStennis:OnAfterStart(From,Event,To)
  self:DeleteAllRecoveryWindows()
end
AirbossStennis:Load()
AirbossStennis:SetAutoSave(lsosavepath)
AirbossStennis:SetMarshalRadio(305)
AirbossStennis:SetLSORadio(118.30)
AirbossStennis:SetTACAN(55,"X","STN")
-- AirbossStennis:SetRadioRelayLSO(RescueheloStennis)
-- AirbossStennis:SetRadioRelayMarshal(NAWAC2)
AirbossStennis:SetSoundfilesFolder("Airboss Soundfiles/")
AirbossStennis:SetAirbossNiceGuy(true)
if stanker then
  AirbossStennis:SetRecoveryTanker(ShellStennis)
end
AirbossStennis:SetDespawnOnEngineShutdown(true)
AirbossStennis:SetRefuelAI(20)
AirbossStennis:SetTrapSheet(lsosavepath)
AirbossStennis:SetMenuRecovery(30,25,false,30)
AirbossStennis:SetHoldingOffsetAngle(0)
AirbossStennis:SetRadioRelayLSO("LSOComms")
AirbossStennis:SetRadioRelayMarshal("MarshallComms")
AirbossStennis:SetMenuSingleCarrier(true)
-- Start airboss script.
AirbossStennis:Start()

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
  elseif text:find("blue1") then
   mainthread:DestroyGround("blue1")
  elseif text:find("blue2") then
   mainthread:DestroyGround("blue2")
  elseif text:find("blue3") then
   mainthread:DestroyGround("blue3")
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
   mainthread.RedArmy:Destroy()
   mainthread.RedArmyX = coord.x
   mainthread.RedArmyY = coord.y
   if statem > -1 and statem < 6 then
    mainthread.RedArmyState = statem
   else
    mainthread.RedArmyState = 5
   end
   mainthread.RedArmy = mainthread.RedArmySpawn:SpawnFromCoordinate(coord)
   mainthread.RedArmySpawned = mainthread.RedArmy
  elseif text:find("red2") then
   mainthread.RedArmy1:Destroy()
   mainthread.RedArmyX1 = coord.x
   mainthread.RedArmyY1 = coord.y
   if statem > -1 and statem < 6 then
    mainthread.RedArmyState1 = statem
   else
    mainthread.RedArmyState1 = 5
   end
   mainthread.RedArmy1 = mainthread.RedArmySpawn1:SpawnFromCoordinate(coord)
   mainthread.RedArmy1Spawned = mainthread.RedArmy1
  elseif text:find("blue1") then
   mainthread.BluArmy:Destroy()
   mainthread.BluArmyX = coord.x
   mainthread.BluArmyY = coord.y
   if statem > -1 and statem < 6 then
    mainthread.BluArmyState = statem
   else
    mainthread.BluArmyState = 5
   end
   mainthread.BluArmy = mainthread.BluArmySpawn:SpawnFromCoordinate(coord)
   mainthread.BlueArmySpawned = mainthread.BluArmy
  elseif text:find("blue2") then
   mainthread.BluArmy1:Destroy()
   mainthread.BluArmyX1 = coord.x
   mainthread.BluArmyY1 = coord.y
   if statem > -1 and statem < 6 then
    mainthread.BluArmyState1 = statem
   else
    mainthread.BluArmyState1 = 5
   end
   mainthread.BluArmy1 = mainthread.BluArmySpawn1:SpawnFromCoordinate(coord)
   mainthread.BlueArmy1Spawned = mainthread.BluArmy1
  elseif text:find("blue3") then
   mainthread.BluArmy2:Destroy()
   mainthread.BluArmyX2 = coord.x
   mainthread.BluArmyY2 = coord.y
   if statem > -1 and statem < 6 then
    mainthread.BluArmyState2 = statem
   else
    mainthread.BluArmyState2 = 5
   end
   mainthread.BluArmy2 = mainthread.BluArmySpawn2:SpawnFromCoordinate(coord)
   mainthread.BlueArmy2 = mainthread.BluArmy2
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
        elseif Event.text:lower():find("-ribdestroy") then
          if ribadmin == true then
            handleDestroyRequest(text2,coord)
          else
            MESSAGE:New("Admin command denied, Not authorised",15):ToAll()
          end
        elseif Event.text:lower():find("-ribresetround") then
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
        elseif Event.text:lower():find("-ribredsmoke") then
          coord:SmokeRed()
        elseif Event.text:lower():find("-ribbluesmoke") then
          coord:SmokeBlue()
        elseif Event.text:lower():find("-ribgreensmoke") then
          coord:SmokeGreen()
        elseif Event.text:lower():find("-ribflare") then
          coord:FlareRed(math.random(0,360))
          SCHEDULER:New(nil,function() 
            coord:FlareRed(math.random(0,20))
          end,{},30)
        elseif Event.text:lower():find("-riblight") then
        elseif Event.text:lower():find("-ribexplode") then
          if ribadmin == true then
            MESSAGE:New("Admin command used something is gonna blow up in 10 seconds",15):ToAll()
            coord:Explosion(500,10)
          else
            MESSAGE:New("Admin command denied, Not authorised",15):ToAll()
          end
        elseif Event.text:lower():find("-ribadmin2020") then
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
    bcomms = "Overlord - E3 AWACS U251. | Magic - E2 AWACS U250 2Y |ARCO11 - KC135 Drogue 3x U252 \n Texaco - KC135 15X U253 | Shell - S3 9Y/X U254 \n Stennis: 55X STN, 1ICLS, A118.3, M305 (Check Kneeboard) | Tarawa: 75X | LONDON: 122.5 | AFAC 133AM"
    if GUDOWNER ~= 1 then
        redobject = "Retake Gudauta,"
        blueobject = "Defend Gudauta,"
    else
        redobject = "Defend Gudauta,"
        blueobject = "Capture Gudauta,"
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
      PlayerClient:AddBriefing("Welcome to Red Iberia By Rob Graham Version: "..version.." \n Last updated:".. lastupdate .." \n POWERED BY MOOSE \n Current Server time is: ".. nowHour .. ":" .. nowminute .."\n Mission Restart Time: restart time:".. restarttime .. "\n No Red on Red is Allowed \n Your current objective is to ".. redobject .."\n" ..rcomms .. "\n Remember Stores and Aircraft are limited and take time to resupply")
      if PlayerClient:GetGroup() ~= nil then
          local group = PlayerClient:GetGroup()
      end
      if PlayerClient:IsAlive() then
                PlayerRMap[PlayerID] = true
         else
                PlayerRMap[PlayerID] = false
         end
    end)
    SetPlayerBlue:ForEachClient(function(PlayerClient) 
      local PlayerID = PlayerClient.ObjectName
        PlayerClient:AddBriefing("Welcome to Red Iberia Rob Graham Version: "..version.." \n Last updated:".. lastupdate .." \n POWERED BY MOOSE \n Current Server time is: ".. nowHour .. ":" .. nowminute .."\n Mission Restart time:".. restarttime .. "\n No Blue on Blue is Allowed \n Your current objective is to ".. blueobject .."\n" ..bcomms .. "\n Remember Stores and Aircraft are limited and take time to resupply")
        if PlayerClient:GetGroup() ~= nil then
          local group = PlayerClient:GetGroup()
        end
         if PlayerClient:IsAlive() then
                PlayerBMap[PlayerID] = true
         else
                PlayerBMap[PlayerID] = false
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
        mainthread:BInsurgents()
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
  
BASE:E("SETTING UP TASKING MISSIONS")
reda2gmission = MISSION:New(RCC,"RED HAMMER","PRIMARY","Destroy the Western Forces so we can retake what is ours",coalition.side.RED)
bluea2gmission = MISSION:New(BCC,"IRON HAND","PRIMARY","Destroy Russian Forces",coalition.side.BLUE)
rreeceset = SET_GROUP:New():FilterPrefixes({"Russian Army","RAFD"}):FilterCoalitions("red"):FilterActive():FilterStart()
rattackset = SET_GROUP:New():FilterPrefixes({"RUS","USAFA"}):FilterActive():FilterStart()
rdetectionareas = DETECTION_AREAS:New(rreeceset,3000)
rTaskDispatcher = TASK_A2G_DISPATCHER:New(reda2gmission,rattackset,rdetectionareas)
brecceset = SET_GROUP:New():FilterPrefixes({"AFAC","BAF","US Army","Apaches","Overlord"}):FilterCoalitions("blue"):FilterActive():FilterStart()
bdetectionareas = DETECTION_AREAS:New(brecceset,3000)
battackset = SET_GROUP:New():FilterPrefixes({"USAF","FAF","GAF","RAAF","USMC","USN","GAA","RAA","UA","UAF","USAA"}):FilterActive():FilterStart()
bTaskDispatcher = TASK_A2G_DISPATCHER:New(bluea2gmission,battackset,bdetectionareas)

  
env.info("END MISSION SET UP")
do
lasthour = nil

SCHEDULER:New(nil,function()  
  do
  nowTable = os.date('*t')
  nowYear = nowTable.year
  nowMonth = nowTable.month
  nowDay = nowTable.day
  nowHour = nowTable.hour
  nowminute = nowTable.min
  nowDaylightsavings = nowTable.isdst
  nowDayofYear = nowTable.yday
  nowDayofWeek = nowTable.wday
end

  BASE:E({"Current Local time is:",nowYear,nowMonth,nowDay,nowHour,nowminute})
  if lasthour == nil then
    lasthour = nowHour
    MESSAGE:New("SERVER TIME IS NOW:" .. nowHour .. ":" .. nowminute .. " DATE IS: " .. nowDay .. "-" .. nowMonth .."-" .. nowYear .. "",30):ToAll()
  elseif nowHour ~= lasthour then
    lasthour = nowHour
    MESSAGE:New("SERVER TIME IS NOW:" .. nowHour .. ":" .. nowminute .. "",10):ToAll()
  end
  if nowhour == 19 then
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
      MESSAGE:New("A FORCED RESTART WILL OCCUR AT 8PM IN 1 MINUTES",30):ToAll()
    end
  end
 end,{},1,60)
 
 --[[ SCHEDULER:New(nil,function() 
 BASE:E({"completeAASystems",ctld.completeAASystems})
 BASE:E({"cratesinzone",ctld.cratesInZone})
 BASE:E({"extractzones",ctld.extractZones})
 BASE:E({"ctld.droppedTroopsRED",ctld.droppedTroopsRED})
 BASE:E({"ctld.droppedTroopsBLUE",ctld.droppedTroopsBLUE})
 BASE:E({"ctld.droppedVehiclesRED",ctld.droppedVehiclesRED})
 BASE:E({"ctld.droppedVehiclesBLUE",ctld.droppedVehiclesBLUE})
 BASE:E({"ctld.pickupzones",ctld.pickupZone})
 BASE:E({"ctld.jtacunits",ctld.jtacUnits})
 BASE:E({"ctld.jtacRadioAdded",ctld.jtacRadioAdded})
 BASE:E({"ctld.addedTo",ctld.addedTo})
 BASE:E({"ctld.builtFOBS",ctld.builtFOBS})
 BASE:E({"ctld.callbacks",ctld.callbacks})
   end,{},1,5) ]]

end

env.info("--------------RED IBERIA AIRBOSS CONTROLLER----------------------")
env.info("--------------By Robert Graham for TGW -------------------")
env.info("--------------LAST CHANGED IN VER: 2.2.20 -------------------")
env.info("--------------USES MOOSE AND CTDL ------------------------")

abossactive = true

if abossactive == true then

  awacsStennis = RECOVERYTANKER:New(UNIT:FindByName("Stennis"), "Magic")
  awacsStennis:SetAWACS(true,true)
  awacsStennis:SetCallsign(CALLSIGN.AWACS.Magic,1)
  awacsStennis:SetTakeoffAir()
  awacsStennis:SetAltitude(20000)
  awacsStennis:SetRadio(250)
  awacsStennis:SetTACAN(44,"MGK")
  awacsStennis:Start()
  
  awacsTeddy = RECOVERYTANKER:New(UNIT:FindByName("TeddyR"), "Magic-1")
  awacsTeddy:SetAWACS(true,true)
  awacsTeddy:SetCallsign(CALLSIGN.AWACS.Darkstar,1)
  awacsTeddy:SetTakeoffAir()
  awacsTeddy:SetAltitude(20000)
  awacsTeddy:SetRadio(250)
  awacsTeddy:SetTACAN(43,"DRK")
  awacsTeddy:Start()
  
  
  BASE:E("Stennis Tanker")
  ShellStennis = RECOVERYTANKER:New(UNIT:FindByName("Stennis"), "Shell")
  ShellStennis:SetCallsign(CALLSIGN.Tanker.Shell,2)
  ShellStennis:SetRespawnOn()
  ShellStennis:SetRespawnInAir()
  ShellStennis:SetSpeed(310)
  ShellStennis:SetCallsign(CALLSIGN.Tanker.Shell,1)
  ShellStennis:SetRacetrackDistances(15,10)
  ShellStennis:SetPatternUpdateDistance(10)
  ShellStennis:SetRadio(255)
  ShellStennis:SetModex(911)
  ShellStennis:SetTACAN(9,"SHL")
  ShellStennis:Start()
  
  ShellTeddyR = RECOVERYTANKER:New(UNIT:FindByName("TeddyR"), "Shell-1")
  ShellTeddyR:SetCallsign(CALLSIGN.Tanker.Shell,2)
  ShellTeddyR:SetRespawnOn()
  ShellTeddyR:SetRespawnInAir()
  ShellTeddyR:SetSpeed(310)
  ShellTeddyR:SetCallsign(CALLSIGN.Tanker.Shell,2)
  ShellTeddyR:SetRacetrackDistances(15,10)
  ShellTeddyR:SetPatternUpdateDistance(10)
  ShellTeddyR:SetRadio(255)
  ShellTeddyR:SetModex(911)
  ShellTeddyR:SetTACAN(9,"SHL")
  ShellTeddyR:Start()
  
  
  

  


AirbossTeddy = AIRBOSS:New("TeddyR","TeddyR")
AirbossTeddy:Load()
AirbossTeddy:SetLSORadio(119.30)
AirbossTeddy:SetMarshalRadio(304)
AirbossTeddy:SetTACAN(65,"X","TDY")
AirbossTeddy:SetICLS(5,"TDY")
AirbossTeddy:SetAirbossNiceGuy(true)
AirbossTeddy:SetMenuRecovery(30,25,false,0)
AirbossTeddy:SetHoldingOffsetAngle(0)
AirbossTeddy:SetDespawnOnEngineShutdown(true)
AirbossTeddy:SetMaxSectionSize(4)
AirbossTeddy:SetPatrolAdInfinitum(true)
AirbossTeddy:SetRefuelAI(30)
AirbossTeddy:SetSoundfilesFolder("Airboss Soundfiles/")
AirbossTeddy:SetRecoveryTurnTime(300)
AirbossTeddy:SetDefaultPlayerSkill("TOPGUN Graduate")
AirbossTeddy:SetHandleAIOFF()
AirbossTeddy:SetWelcomePlayers(false)
AirbossTeddy:SetDefaultMessageDuration(5)
AirbossTeddy:SetRecoveryTanker(ShellTeddyR)
function AirbossTeddy:OnAfterStart(From,Event,To)
  self:DeleteAllRecoveryWindows()
end
AirbossTeddy:Start()

function AirbossTeddy:OnAfterLSOGrade(From, Event, To, playerData, myGrade)
	myGrade.messageType = 2
	myGrade.name = playerData.name
	HypeMan.sendBotTable(myGrade)
end



AirbossStennis = AIRBOSS:New("Stennis","Stennis")
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
AirbossStennis:SetMenuRecovery(30,25,false,0)
AirbossStennis:SetHoldingOffsetAngle(0)
AirbossStennis:SetRecoveryTanker(ShellStennis)
AirbossStennis:SetRecoveryTurnTime(300)
AirbossStennis:SetPatrolAdInfinitum(true)
AirbossStennis:Start()

end

function AirbossStennis:OnAfterLSOGrade(From, Event, To, playerData, myGrade)
	myGrade.messageType = 2
	myGrade.name = playerData.name
	HypeMan.sendBotTable(myGrade)
end

awacsWash = RECOVERYTANKER:New(UNIT:FindByName("WASH1"), "Magic-2")
  awacsWash:SetAWACS(true,true)
  awacsWash:SetCallsign(CALLSIGN.AWACS.Darkstar,1)
  awacsWash:SetTakeoffAir()
  awacsWash:SetAltitude(20000)
  awacsWash:SetRadio(250)
  awacsWash:SetTACAN(49,"DRK")
  awacsWash:Start()
  
  ShellWash = RECOVERYTANKER:New(UNIT:FindByName("WASH1"), "Shell-2")
  ShellWash:SetCallsign(CALLSIGN.Tanker.Shell,2)
  ShellWash:SetRespawnOn()
  ShellWash:SetRespawnInAir()
  ShellWash:SetSpeed(310)
  ShellWash:SetCallsign(CALLSIGN.Tanker.Shell,1)
  ShellWash:SetRacetrackDistances(15,10)
  ShellWash:SetPatternUpdateDistance(10)
  ShellWash:SetRadio(255)
  ShellWash:SetModex(911)
  ShellWash:SetTACAN(3,"SHL")
  ShellWash:Start()

AirbossWash = AIRBOSS:New("WASH1","Wash")
function AirbossWash:OnAfterStart(From,Event,To)
  self:DeleteAllRecoveryWindows()
end


AirbossWash:Load()
AirbossWash:SetMarshalRadio(305)
AirbossWash:SetLSORadio(119.30)
AirbossWash:SetTACAN(69,"X","WSH")
AirbossWash:SetSoundfilesFolder("Airboss Soundfiles/")
AirbossWash:SetAirbossNiceGuy(true)
AirbossWash:SetDespawnOnEngineShutdown(true)
AirbossWash:SetRefuelAI(20)
AirbossWash:SetMenuRecovery(30,25,false,0)
AirbossWash:SetHoldingOffsetAngle(0)
AirbossWash:SetRecoveryTanker(ShellWash)
AirbossWash:SetRecoveryTurnTime(300)
AirbossWash:SetPatrolAdInfinitum(true)
AirbossWash:Start()

  

function AirbossWash:OnAfterLSOGrade(From, Event, To, playerData, myGrade)
	myGrade.messageType = 2
	myGrade.name = playerData.name
	HypeMan.sendBotTable(myGrade)
end


BASE:E({"TRAINING MISSION START"})

arco = GROUP:FindByName("ARC")
tex = GROUP:FindByName("TEX")
overlord = GROUP:FindByName("Overlord")
attacker = GROUP:FindByName("Attacker")
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

BASE:E({"TRAINING MISSION END"})
BASE:I({"Red Dawn Moose Load Start"})
BASE:I({"Airboss Start Up"})
lastupdate = "643am 14 March 2020"

trigger.action.setUserFlag("SSB",100) -- slot blocker active.
Slothandler = EVENTHANDLER:New() -- this sets up our event handler for if people die uses Simple Slot blocker (server side script)
Slothandler:HandleEvent(EVENTS.Crash) -- watch for crash, ejection and pilot dead
Slothandler:HandleEvent(EVENTS.Ejection)
Slothandler:HandleEvent(EVENTS.PilotDead)
PlayerBMap = {}
f18airgroup = 48
f14airgroup = 64
clients = SET_CLIENT:New():FilterActive(true):FilterStart() -- look at clients

  shell = GROUP:FindByName("shell11")
  shellspawn = SPAWN:NewWithAlias("shell11","Shell_11"):InitRepeatOnLanding()
  shell = shellspawn:Spawn()
  shell_respawncount = 6

---@param self
--@param Core.Event#EVENTDATA EventData
function Slothandler:OnEventCrash(EventData)
  BASE:E({EventData.IniGroupName})
  if EventData.IniGroupName == shell:GetName() then
    MESSAGE:New("Lost Contact with SHELL11",30,"Mother"):ToAll()
    if shell_respawncount > 0 then
      SCHEDULER:New(nil,function() 
        shell = shellspawn:Spawn()
        shell_respawncount = shell_respawncount - 1
        MESSAGE:New("New Recovery Tanker is Airborn we have " .. shell_respawncount .. " Remaining S-3's",30,"Mother"):ToAll()
      end,{},(60*15))
    else
      MESSAGE:New("All Recovery tankers lost, use alternate options at this time",30,"Mother"):ToAll()
    end
  
  end 
end
-- handle our ejection

function Slothandler:OnEventEjection(EventData)
  BASE:E({EventData})
  -- Lock that unit out so it can no longer be used.
  BASE:E({EventData.IniUnitName,"Ejection setting 5 minutes until launch"})
  clients:ForEachClient(function(cli) 
    BASE:E({cli})
    if cli.ClientAlive2 == true then
      cu = cli:GetClientGroupUnit()
      BASE:E({cu})
      cu = cu:GetName()
      BASE:E({cu})
      if cu == EventData.IniUnitName then
        trigger.action.setUserFlag(EventData.IniUnitName,100)
          f14airgroup = f14airgroup - 1
          if f14airgroup > 0 then
            Msgtosend = "Alert, We just Detected the SAR BEACON of " .. EventData.IniUnitName .. ", Unit is no longer avalible for use for 5 Minutes"
            MESSAGE:New(Msgtosend,30,"RIPCORD"):ToAll()
            SCHEDULER:New(nil,function() 
              Msgtosend = "A replacement for unit " .. EventData.IniUnitName .. " is now avalible" 
              trigger.action.setUserFlag(EventData.IniUnitName,0)
              MESSAGE:New(Msgtosend,30,"RIPCORD"):ToAll()
            end,{},(5*60))  
          else
            Msgtosend = "Alert, We just Detected the SAR BEACON of " .. EventData.IniGroupName .. ", Unit is no longer avalible airgroup is out of Airframes"
            MESSAGE:New(Msgtosend,30,"RIPCORD"):ToAll()
          end
      end
     end
   end)    
 end

-- handle a pilot dead.

function Slothandler:OnEventPilotDead(EventData)
  -- Lock that unit out so it can no longer be used.
  BASE:E({EventData.IniGroupName,"Ejection setting 10 minutes until launch"})
  clients:ForEachClient(function(cli) 
    cu = cli:GetClientGroupUnit()
    cu = cu:GetName()
    BASE:E({cu})
    if cu == EventData.IniUnitName then
      trigger.action.setUserFlag(EventData.IniUnitName,100)
        f14airgroup = f14airgroup - 1
        if f14airgroup > 0 then
          Msgtosend = "Alert, We just lost contact with " .. EventData.IniUnitName .. ", Unit is no longer avalible for use for 10 Minutes while we try and find new pilots"
          MESSAGE:New(Msgtosend,30,"RIPCORD"):ToAll()
          SCHEDULER:New(nil,function() 
            Msgtosend = "A replacement for unit " .. EventData.IniUnitName .. " is now avalible" 
            trigger.action.setUserFlag(EventData.IniUnitName,0)
            MESSAGE:New(Msgtosend,30,"RIPCORD"):ToAll()
          end,{},(10*60))  
        else
          Msgtosend = "Alert, We just lost contact with " .. EventData.IniunitName .. ", Unit is no longer avalible airgroup is out of aircraft"
          MESSAGE:New(Msgtosend,30,"RIPCORD"):ToAll()
        end
    end
  end)    
end
SCHEDULER:New(nil,function() 
  clients:ForEachClient(function(cli) 
    BASE:E({cli})
  end)
end,{},1,1)



-- set up our airboss
  BASE:I("Stennis Airboss")
  AirbossStennis = AIRBOSS:New("USS_Stennis","Mother")

  function AirbossStennis:OnAfterStart(From,Event,To)
  end
  AirbossStennis:SetRecoveryTanker(recoverytanker)
  AirbossStennis:SetMarshalRadio(305)
  AirbossStennis:SetLSORadio(118.30)
  AirbossStennis:SetTACAN(55,"X","STN")
  AirbossStennis:SetSoundfilesFolder("Airboss Soundfiles/")
  AirbossStennis:SetAirbossNiceGuy(true)
  AirbossStennis:SetDespawnOnEngineShutdown(true)
  AirbossStennis:SetMenuRecovery(15,25,false,0)
  AirbossStennis:SetHoldingOffsetAngle(0)
  AirbossStennis:Start()
 
  
  
  -- some stuff for the tankers etc.
  
  arco_respawncount = 2
  migcap1 = GROUP:FindByName("MIG_29_CAP_1")
  migcap2 = GROUP:FindByName("MIG_29_CAP_2")
  su27cap1 = GROUP:FindByName("SU-27_CAP_1")
  su27cap2 = GROUP:FindByName("SU-27_CAP_2")
  arco = GROUP:FindByName("ARCO")
  arcospawn = SPAWN:New("ARCO")
  message = false
  amessage = false
  migcap2active = false
  su27cap2Active = false
 
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
                MESSAGE:New("Welcome to Red Dawn Episode 1 By Rob Graham \n Last updated:".. lastupdate .." \n POWERED BY MOOSE \n Be aware gettign shot down will result in slot lock and reduction of AC count, 5 minutes for Eject, 10 Minutes for Dead Pilot \n Current AC Count is:" ..f14airgroup .. "",60):ToClient(PlayerClient)
           end    
         else
          if PlayerBMap[PlayerID] ~= false then
                PlayerBMap[PlayerID] = false
          end
       end
    end)
 
 end
 SCHEDULER:New(nil,playercheck,{},1,10)
  SCHEDULER:New(nil,function() 
    if migcap2active == true then
      if migcap2:IsAlive() == true then
        if migcap2:AllOnGround() == true then
          migcap2:Destroy()
          migcap2 = SPAWN:New("MIG_29_CAP_2")
          BASE:I({"MIG2 on ground respawn"})
        end
      end
    end
    if su27cap2Active == true then
      if su27cap2:IsAlive() == true then
        if su27cap2:AllOnGround() == true then
          su27cap2:Destroy()
          su27cap2 = SPAWN:New("SU-27_CAP_2")
          BASE:I({"SU27 on ground respawn"})
        end
      end
    end
  end,{},5,600)
 
 do
    nowTable = os.date('*t')
    nowYear = nowTable.year
    nowMonth = nowTable.month
    nowDay = nowTable.day
    nowHour = nowTable.hour
    nowminute = nowTable.min
end
 
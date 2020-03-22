BASE:I({"Red Dawn Moose Load Start"})
BASE:I({"Airboss Start Up"})
lastupdate = "643am 14 March 2020"
do
    nowTable = os.date('*t')
    nowYear = nowTable.year
    nowMonth = nowTable.month
    nowDay = nowTable.day
    nowHour = nowTable.hour
    nowminute = nowTable.min
end
trigger.action.setUserFlag("SSB",100) -- slot blocker active.
Slothandler = EVENTHANDLER:New() -- this sets up our event handler for if people die uses Simple Slot blocker (server side script)
Slothandler:HandleEvent(EVENTS.Crash) -- watch for crash, ejection and pilot dead
Slothandler:HandleEvent(EVENTS.Ejection)
Slothandler:HandleEvent(EVENTS.PilotDead)
PlayerBMap = {}
f18airgroup = 48
f14airgroup = 24 
clients = SET_CLIENT:New():FilterStart() -- look at clients

-- handle our ejection

function Slothandler:OnEventEjection(EventData)
  -- Lock that unit out so it can no longer be used.
  BASE:E({EventData.IniGroupName,"Ejection setting 10 minutes until launch"})
  clients:ForEachClient(function(cli) 
    cu = cli:GetClientGroupName()
    BASE:E({cu})
    if cu == EventData.IniGroupName then
      trigger.action.setUserFlag(EventData.IniGroupName,100)
      if cu == "USN - BobCat11 - Strike" then
        f14airgroup = f14airgroup - 1
        if f14airgroup > 0 then
          Msgtosend = "Alert, We just Detected the SAR BEACON of " .. EventData.IniGroupName .. ", Unit is no longer avalible for use for 5 Minutes"
          MESSAGE:New(Msgtosend,30,"RIPCORD"):ToAll()
          SCHEDULER:New(nil,function() 
            Msgtosend = "A replacement for unit " .. EventData.IniGroupName .. " is now avalible" 
            trigger.action.setUserFlag(EventData.IniGroupName,0)
            MESSAGE:New(Msgtosend,30,"RIPCORD"):ToAll()
          end,{},(5*60))  
        else
          Msgtosend = "Alert, We just Detected the SAR BEACON of " .. EventData.IniGroupName .. ", Unit is no longer avalible airgroup is out of F14s"
          MESSAGE:New(Msgtosend,30,"RIPCORD"):ToAll()
        end
      elseif cu == "USN - BobCat12 - Strike" then
        f14airgroup = f14airgroup - 1
        if f14airgroup > 0 then
          Msgtosend = "Alert, We just Detected the SAR BEACON of " .. EventData.IniGroupName .. ", Unit is no longer avalible for use for 5 Minutes"
          MESSAGE:New(Msgtosend,30,"RIPCORD"):ToAll()
          SCHEDULER:New(nil,function() 
            Msgtosend = "A replacement for unit " .. EventData.IniGroupName .. " is now avalible" 
            trigger.action.setUserFlag(EventData.IniGroupName,0)
            MESSAGE:New(Msgtosend,30,"RIPCORD"):ToAll()
          end,{},(5*60))
        else
          Msgtosend = "Alert, We just Detected the SAR BEACON of " .. EventData.IniGroupName .. ", Unit is no longer avalible airgroup is out of F14s"
          MESSAGE:New(Msgtosend,30,"RIPCORD"):ToAll()
        end
      else
        f18airgroup = f18airgroup - 1
        if f18airgroup > 0 then
          Msgtosend = "Alert, We just Detected the SAR BEACON of " .. EventData.IniGroupName .. ", Unit is no longer avalible for use for 5 Minutes"
          MESSAGE:New(Msgtosend,30,"RIPCORD"):ToAll()
          SCHEDULER:New(nil,function() 
            Msgtosend = "A replacement for unit " .. EventData.IniGroupName .. " is now avalible" 
            trigger.action.setUserFlag(EventData.IniGroupName,0)
            MESSAGE:New(Msgtosend,30,"RIPCORD"):ToAll()
          end,{},(5*60))
        else
          Msgtosend = "Alert, We just Detected the SAR BEACON of " .. EventData.IniGroupName .. ", Unit is no longer avalible airgroup is out of F18s"
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
    cu = cli:GetClientGroupName()
    BASE:E({cu})
    if cu == EventData.IniGroupName then
      trigger.action.setUserFlag(EventData.IniGroupName,100)
      if cu == "USN - BobCat11 - Strike" then
        f14airgroup = f14airgroup - 1
        if f14airgroup > 0 then
          Msgtosend = "Alert, We just lost contact with " .. EventData.IniGroupName .. ", Unit is no longer avalible for use for 10 Minutes while we try and find new pilots"
          MESSAGE:New(Msgtosend,30,"RIPCORD"):ToAll()
          SCHEDULER:New(nil,function() 
            Msgtosend = "A replacement for unit " .. EventData.IniGroupName .. " is now avalible" 
            trigger.action.setUserFlag(EventData.IniGroupName,0)
            MESSAGE:New(Msgtosend,30,"RIPCORD"):ToAll()
          end,{},(10*60))  
        else
          Msgtosend = "Alert, We just lost contact with " .. EventData.IniGroupName .. ", Unit is no longer avalible airgroup is out of F14s"
          MESSAGE:New(Msgtosend,30,"RIPCORD"):ToAll()
        end
      elseif cu == "USN - BobCat12 - Strike" then
        f14airgroup = f14airgroup - 1
        if f14airgroup > 0 then
                    Msgtosend = "Alert, We just lost contact with " .. EventData.IniGroupName .. ", Unit is no longer avalible for use for 10 Minutes while we try and find new pilots"
          MESSAGE:New(Msgtosend,30,"RIPCORD"):ToAll()
          SCHEDULER:New(nil,function() 
            Msgtosend = "A replacement for unit " .. EventData.IniGroupName .. " is now avalible" 
            trigger.action.setUserFlag(EventData.IniGroupName,0)
            MESSAGE:New(Msgtosend,30,"RIPCORD"):ToAll()
          end,{},(10*60))
        else
          Msgtosend = "Alert, We just lost contact with " .. EventData.IniGroupName .. ", Unit is no longer avalible airgroup is out of F14s"
          MESSAGE:New(Msgtosend,30,"RIPCORD"):ToAll()
        end
      else
        f18airgroup = f18airgroup - 1
        if f18airgroup > 0 then
           Msgtosend = "Alert, We just lost contact with " .. EventData.IniGroupName .. ", Unit is no longer avalible for use for 10 Minutes while we try and find new pilots"
          MESSAGE:New(Msgtosend,30,"RIPCORD"):ToAll()
          SCHEDULER:New(nil,function() 
            Msgtosend = "A replacement for unit " .. EventData.IniGroupName .. " is now avalible" 
            trigger.action.setUserFlag(EventData.IniGroupName,0)
            MESSAGE:New(Msgtosend,30,"RIPCORD"):ToAll()
          end,{},(10*60))
        else
          Msgtosend = "Alert, We just lost contact with " .. EventData.IniGroupName .. ", Unit is no longer avalible airgroup is out of F18s"
          MESSAGE:New(Msgtosend,30,"RIPCORD"):ToAll()
        end
      end
    end
  end)    
end


-- set up our airboss
  BASE:I("Stennis Airboss")
  AirbossStennis = AIRBOSS:New("USS_Stennis","Mother")

  function AirbossStennis:OnAfterStart(From,Event,To)
    self:AddRecoveryWindow("6:05","7:40",1,0,true,25,true)
    self:AddRecoveryWindow("7:40","8:20",1,0,true,25,true)
    self:AddRecoveryWindow("9:20","10:00",1,0,true,25,true)
    self:AddRecoveryWindow("11:00","11:40",1,0,true,25,true)
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
  
  shell = GROUP:FindByName("shell11")
  shellspawn = SPAWN:New("shell11")
  shell = shellspawn:Spawn()
  shell_respawncount = 6
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
                MESSAGE:New("Welcome to Red Dawn Episode 1 By Rob Graham \n Last updated:".. lastupdate .." \n POWERED BY MOOSE \n Be aware gettign shot down will result in slot lock and reduction of AC count, 5 minutes for Eject, 10 Minutes for Dead Pilot \n Current AC Count is: \n F-18C Lot 20: ".. f18airgroup .. "\n F-14B:" ..f14airgroup .. "\n S-3 Tankers:".. shell_respawncount .. "\n KC-135MPRS:"..arco_respawncount .. "",60):ToClient(PlayerClient)
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
  
    if shell:IsAlive() ~= true then
      if shell_respawncount > 0 then
        BASE:I({"Shell Respawn",shell_respawncount})
        shell = shellspawn:Spawn()
        shell_respawncount = shell_respawncount - 1
        MESSAGE:New("Stennis is Scrambling a new Tanker"):ToAll()
      else
        if message == false then
          BASE:I({"Shell Respawn",shell_respawncount})
          MESSAGE:New("Stennis is out of Tankers and unable to send a new one"):ToAll()
          message = true
        end
      end
    else
      if shell:GetVelocityKNOTS() < 31 then
        BASE:I({"Shell Respawn less then 31"})
        shell:Destroy()
        shell = shellspawn:Spawn()
        MESSAGE:New("Stennis is launching a new tanker."):ToAll()
      end
    end
    if arco:IsAlive() ~= true then
      if arco_respawncount > 0 then
      BASE:I({"ARCO Respawn",arco_respawncount})
        arco = arcospawn:Spawn()
        arco_respawncount = arco_respawncount - 1
        MESSAGE:New("A new KC-135MPRS is inbound from Turkey"):ToAll()
      else
        if amessage == false then
          BASE:I({"ARCO Respawn",arco_respawncount})
          MESSAGE:New("Turkey reports they are unable to send a new KC-135MPRS at this time."):ToAll()
          amessage = true
        end
      end
    end
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
 
 
 
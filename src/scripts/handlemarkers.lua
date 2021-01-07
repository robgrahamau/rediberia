
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
		elseif Event.text:lower():find("-load") then
          if ribadmin == true then
				dofile(lfs.writedir() .."rib\\input.lua")
			MESSAGE:New("Admin: Input File Loaded",15):ToAll()
          else
            MESSAGE:New("Admin Commands need to be active to input a file",15):ToAll()
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

BASE:E({"Done loading markerevents"})
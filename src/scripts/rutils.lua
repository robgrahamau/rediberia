
env.info("--------------RED IBERIA UTILITIES CONTROLLER----------------------")
env.info("--------------By Robert Graham for TGW -------------------")
env.info("--------------LAST CHANGED IN VER: 2.2.20 -------------------")
env.info("--------------USES MOOSE AND CTDL ------------------------")
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
    return "Off road"   
  end
  
  -- return "Off road" -- try and fix the @$@ routing issues of late.
end


function findclosest(main,u1,u2,u3)
  local d1 = nil
  local d2 = nil
  local d3 = nil
  local closest = nil
  local dp = main:GetCoordinate()
  
  if u1:IsAlive() == true then
    d1 = dp:Get2DDistance(u1:GetCoordinate())
    closest = u1
  end
  if u2:IsAlive() == true then
    d2 = dp:Get2DDistance(u2:GetCoordinate())
    if closest == nil then
      closest = u2
    end
  end
  if u3:IsAlive() == true then
    d3 = dp:Get2DDistance(u3:GetCoordinate())
    if closest == nil then
      closest = u3
    end
  end
  
  if d1 ~= nil and d2 ~= nil then
    if d2 < d1 then
      closest = u2
    else
      closest = u1
    end
  elseif d1 ~= nil and d2 == nil then
    closest = u1
  elseif d1 == nil and d2 ~= nil then
    closest = u2
  end
    
  if d3 ~= nil and closest == u1 then
    if d3 < d1 then
      closest = u3
    else
      closest = u1
    end
  elseif d3 ~= nil and closest == u2 then
    if d3 < d2 then
      closest = u3
    else 
      closest = u2
    end
  end
  if rdebug == true then
    BASE:E({"find Closest","closest debug d1,d2,d3,closest",d1,d2,d3,closest})
  end
  return closest
end

-- checks the distance between 2 points if they are less then ad returns true
-- else returns false.

function checkifclose(bp,rp,ad)
  if bp == nil then
    return false
  end
  if rp == nil then
    return false
  end
  local d2 = rp:Get2DDistance(bp)
  if d2 < ad then
    return true
  else
    return false
  end
end

function _split(str, sep)
  BASE:E({str=str, sep=sep})  
  local result = {}
  local regex = ("([^%s]+)"):format(sep)
  for each in str:gmatch(regex) do
    table.insert(result, each)
  end
  return result
end

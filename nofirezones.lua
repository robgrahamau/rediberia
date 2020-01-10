env.info("No Fire Zone") 
-------------------------------------------------------------------------
--OPTIONAL. Can have a no fire zone. Create a zone names "No Fire Zone" (case sensitive) in your mission
--CREDITS: Script by Pikey 2020 modified by rob.. Sven for MOOSE, FunkyFranky for FOX and Frosties for conceptual ideas

----------------LIST OF NO FIRE ZONES------------------------------------
 local rednofirezone=ZONE:New("REDONLY") -- need to add this to the miz
 local bluenofirezone=ZONE:New("BlueNoFireZone") -- need to add this to mission.
-------------------------------------------------------------------------
   local fox=FOX:New()
  fox:SetDisableF10Menu(true)
  fox:Start()

function fox:OnAfterMissileLaunch(From, Event, To, Missile)
  

if nofirezone:IsCoordinateInZone(missile.shotCoord) then
      missile.weapon:destroy()
      MESSAGE:New("Command has remotely disabled this weapon as it has been launched in a no fire zone! " .. CLIENT:FindByName(missile.shooterName):GetPlayerName(), 20):ToGroup(missile.shooterGroup)
end



end

function wepHelp(grp)
MESSAGE:New("Certain weapons are <limited> usage. To find out your current expenditure, use the 'Weapon Status' menu item.", 20):ToGroup(grp)
          for weapon, total in pairs (WeaponAmounts) do
                      MESSAGE:New("LIMIT: " ..total.." of '" ..weapon .. "'.", 20):ToGroup(grp)    
          end
MESSAGE:New("Whenever you safely land the aircraft, your limits are rest back to default.", 5):ToGroup(grp)
end

function AddMenu(aGroup)
  wepMenu1 = MENU_GROUP_COMMAND:New(aGroup, "Weapons Status", WepMenu, chkWeps, aGroup)
  wepMenu2 = MENU_GROUP_COMMAND:New(aGroup,"Help",WepMenu, wepHelp, aGroup)
end

SCHEDULER:New( nil, function()
ClientSet:ForEachClient(function (MooseClient)
    if MooseClient:GetGroup() ~= nil then 
      local Group = MooseClient:GetGroup()
      AddMenu(Group)
    end
end)
end, {},0, 10)

env.info("AMMOCOUNTER: Complete") 
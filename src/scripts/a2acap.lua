
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

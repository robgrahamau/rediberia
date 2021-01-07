-- This is our Globals File
-- it holds GLOBAL values for Red Iberia

env.info("--------------RED IBERIA GLBOALS CONTROLLER----------------------")
env.info("--------------By Robert Graham for TGW -------------------")
env.info("--------------LAST CHANGED IN VER: 2.3 -------------------")
env.info("--------------USES MOOSE AND CTDL ------------------------")

version = "2.3.06 - Barksalov's Revenge"
lastupdate = "23-May-2020"
rdebug = false
blue2active = true
red1active = true
do
  nowtime = os.time()
  nowTable = os.date('*t')
  nowDate = os.date()
  nowYear = nowTable.year
  nowMonth = nowTable.month
  nowDay = nowTable.day
  nowHour = nowTable.hour
  nowminute = nowTable.min
  nowDaylightsavings = nowTable.isdst
  nowDayofYear = nowTable.yday
  nowDayofWeek = nowTable.wday
  starttime = "" .. nowHour .. ":" .. nowminute .. ""
  restarthour = nowHour + 8
  if restarthour > 23 then 
    restarthour = restarthour - 24
  end

  restarttime = "" .. restarthour ..":".. nowminute ..""
end

env.info("---------- Date Time:" .. nowDate .. "-------------------")
env.info("---------- now Time:" .. nowtime .. "------------------")
env.info("---------- start time:".. starttime .. "------------------")
env.info("---------- restart time:".. restarttime .. "------------------")

roundreset = 8 -- This sets how many rounds before we reset to round one. each round is 6 hours so 4 = 24, 8 = 48. etc.
ribadmin = false
pstatic = false


JTAC_COOLDOWN = (10)*60
F15_COOLDOWN = (2)*60
SU27_COOLDOWN = (2)*60
TANKER_COOLDOWN = (15)*60
Round_COOLDOWN = ((60*60)*7)+(60*50)
CurrentRound = 0
commandrebuild = ((60*60) * 72) -- 72 hours.
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
factorytime = (60 * 60) * 2 -- Reinforce every 2 hours.  
reinforcehours = (60 * 60) * 1 -- 1 hour
noclients = 0
nooclients = true
RESETALL = 0
novosqnsize = 32
maysqnsize = 24
mozsqnsize = 24
krazsqnsize = 24
sochisqnsize = 12
redgroundsupply = 200
redairsupply = 0
blueairsupply = 8

lsosavepath = "D:\\lsodata\\"


insurgents = true

forceground = false
forceroad = true
AIBLUECAP = false
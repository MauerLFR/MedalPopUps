global
function MedalInit
global
function AddMedalEvent

var BadgeSlot1 = null //Badge foregound
var BadgeSlot2 = null //Badge main
var BadgeSlot3 = null //Badge background

void
function MedalInit() {
  entity player = GetLocalClientPlayer()
  AddLocalPlayerDidDamageCallback(OnDamage)
  AddCallback_OnPlayerKilled(KillEvent)
  BadgeRuiSetup()
  thread UpdateBadgeUI()
  TimeSinceLast = Time()
}
vector color = < 0.0, 0.0, 0.0 >
int Killstreak = 0
int Multikill = 0
int AiMultikill = 0

#if CLIENT

float TimeSinceLast = 0
float TimeNow = 0

float BadgeFGAlpha =1
float BadgeAlpha = 1
float BadgeBGAlpha = 0.75

float PosX1 = 0.8
float PosY1 = 0.2

bool InCombat = false

vector BasePos = < 0, 0, 0 >

 float hDistance = 0.0
float mDistance = 0.0
float BadgeSize = 400.0

string BadgeFGCont = ""
string BadgeCont = ""
string BadgeBGCont = ""
	/*
	TO DO:
	-Make ranks appropriate colors
	-Finish badge designs
	-Add EJECT kill badge
	-Add REVENGE kill badge
	-Add Kills while going fast / big airtime (with measures!)
	-Noscopes
	*/
array < vector > Rank = [ < 0.05, 0.99, 0.99 > , < 0.99, 0.0, 0.99 > , < 0.99, 0.5, 0.0 > , < 0.99, 0.05, 0.05 >, < 0.9, 0.75, 0.0 > ]	//0: movement, cyan; 1: high-rank movement, purple; 2: combat, orange; 3:high-rank combat, red; 4: AI kills & misc, yellow. 

void function KillEvent(ObituaryCallbackParams KillEventPerams) {
  entity player = GetLocalClientPlayer()
  if (KillEventPerams.victim == GetLocalClientPlayer()) {
    Killstreak = 0
    Multikill = 0
  }
  if (KillEventPerams.attacker == GetLocalClientPlayer()) {
    hDistance = Distance(player.EyePosition(), KillEventPerams.victim.GetOrigin())
    mDistance = hDistance * 0.07616 / 3
    TimeSinceLast = Time()

    if (KillEventPerams.victim == GetLocalClientPlayer()) {
      AddMedalEvent("", "", "", Rank[1]) //Suicides
    }
    if (KillEventPerams.victim.IsTitan() && KillEventPerams.victimIsOwnedTitan) {
      AddMedalEvent("", "", "", Rank[1]) // Structure: Background, Main badge, Foreground, Rank
      if (KillEventPerams.damageSourceId == 185) {
        AddMedalEvent("", "", "", Rank[1]) //Titan execution
      }
    }
    if (KillEventPerams.victim.IsPlayer() && !KillEventPerams.victimIsOwnedTitan) {
      Multikill++

      switch (Multikill) {
      case 1:// Pilot kills
        if (BadgeCont == "%$rui/gencard_icons/gc_icon_crosshair%") {
          AddMedalEvent("%$rui/gencard_icons/gc_icon_private%", "%$rui/gencard_icons/dlc3/gc_icon_pilot%", "%$rui/gencard_icons/gc_icon_crosshair%", Rank[2])
        }
        else AddMedalEvent("%$rui/gencard_icons/gc_icon_private%", "%$rui/gencard_icons/dlc3/gc_icon_pilot%", "", Rank[2]) 
        break
      case 2:// Double kill
        if (BadgeCont == "%$rui/gencard_icons/gc_icon_crosshair%") {
          AddMedalEvent("%$rui/gencard_icons/gc_icon_corporal%", "%$rui/gencard_icons/dlc3/gc_icon_pilot%", "%$rui/gencard_icons/gc_icon_crosshair%", Rank[2])
        }
         else AddMedalEvent("%$rui/gencard_icons/gc_icon_corporal%", "%$rui/gencard_icons/dlc3/gc_icon_pilot%", "", Rank[2]) 
        break
      case 3:// Triple kill
        if (BadgeCont == "%$rui/gencard_icons/gc_icon_crosshair%") {
          AddMedalEvent("%$rui/gencard_icons/gc_icon_sgt%", "%$rui/gencard_icons/dlc3/gc_icon_pilot%", "%$rui/gencard_icons/gc_icon_crosshair%", Rank[3])
        }
         else AddMedalEvent("%$rui/gencard_icons/gc_icon_sgt%", "%$rui/gencard_icons/dlc3/gc_icon_pilot%", "", Rank[3]) 
        break
      case 4: // Quad kill
        if (BadgeCont == "%$rui/gencard_icons/gc_icon_crosshair%") {
          AddMedalEvent("%$rui/gencard_icons/gc_icon_ordnance%", "%$rui/gencard_icons/dlc3/gc_icon_pilot%", "%$rui/gencard_icons/gc_icon_crosshair%", Rank[3])
        }
         else AddMedalEvent("%$rui/gencard_icons/gc_icon_ordnance%", "%$rui/gencard_icons/dlc3/gc_icon_pilot%", "", Rank[3])
        break
      }
      if (Multikill > 4) {
        	AddMedalEvent("%$rui/gencard_icons/dlc1/gc_icon_apex%", "%$rui/gencard_icons/dlc1/gc_icon_apex%", "%$rui/gencard_icons/dlc1/gc_icon_apex%", Rank[3])
        // Multikills 
      }

      if (mDistance >= 33.00 && KillEventPerams.damageSourceId != 107 && KillEventPerams.damageSourceId != 85) {
		AddMedalEvent("%$rui/gencard_icons/gc_icon_crosshair%", "%$rui/gencard_icons/dlc4/gc_icon_monarch%", "%$rui/gencard_icons/dlc4/gc_icon_monarch%", Rank[2]) //longshots without nades, smokes etc
      }
      if (mDistance <= 3.00 && KillEventPerams.damageSourceId != 151 && KillEventPerams.damageSourceId != 140 && KillEventPerams.damageSourceId != 186 && KillEventPerams.damageSourceId != 185) {
		AddMedalEvent("%$rui/gencard_icons/gc_icon_clawmark%", "%$rui/gencard_icons/gc_icon_skull%", "%$rui/gencard_icons/dlc5/gc_icon_trident%", Rank[2]) //point blank without melees etc
      }
      switch (KillEventPerams.damageSourceId) {
      case 110: case 75: case 237: case 40:   case 57:  case 81:
       	AddMedalEvent("%$rui/gencard_icons/gc_icon_fireball%", "%$rui/gencard_icons/gc_icon_skull%", "%$rui/gencard_icons/gc_icon_fireball%", Rank[2]) // Scorch stuff + Firestar
        break
      case 126: case 135: case 119:
        AddMedalEvent("%$rui/gencard_icons/gc_icon_ordnance%", "%$rui/gencard_icons/dlc3/gc_icon_pilot%", "%$rui/gencard_icons/gc_icon_bomb_02%", Rank[2]) // Cold war, EPG, Charge rifle
        break
      case 140:
        AddMedalEvent("%$rui/gencard_icons/gc_icon_dataknife%", "%$rui/gencard_icons/dlc3/gc_icon_pilot%", "%$rui/gencard_icons/gc_icon_dataknife%", Rank[2]) // Pilot melee
        break
      case 186:
        AddMedalEvent("%$rui/gencard_icons/dlc1/gc_icon_vinson%", "%$rui/gencard_icons/gc_icon_skull%", "%$rui/gencard_icons/dlc5/gc_icon_x%", Rank[3]) //Pilot execution
        break
      case 111:
        AddMedalEvent("%$rui/gencard_icons/dlc4/gc_icon_tone%", "%$rui/gencard_icons/dlc3/gc_icon_pilot%", "%$rui/gencard_icons/gc_icon_skull%", Rank[3]) //Pulse blade
        break
      case 85:
        AddMedalEvent("%$rui/gencard_icons/dlc3/gc_icon_crossed_lighting%", "%$rui/gencard_icons/dlc3/gc_icon_pilot%", "%$rui/gencard_icons/gc_icon_lightning%", Rank[2]) //Electric smoke nades
        break
      case 107:
        AddMedalEvent("%$rui/gencard_icons/gc_icon_frag%", "%$rui/gencard_icons/dlc3/gc_icon_pilot%", "%$rui/gencard_icons/gc_icon_frag%", Rank[2]) //Grenades
        break
      case 151:
        AddMedalEvent("%$rui/gencard_icons/dlc3/gc_icon_crossed_lighting%", "%$rui/gencard_icons/gc_icon_heartless%", "", Rank[2]) //Ronin melee
        break
      }
      if (KillEventPerams.victim.IsTitan() && !player.IsTitan()) {
        AddMedalEvent("%$rui/gencard_icons/dlc5/gc_icon_tri_chevron%", "%$rui/gencard_icons/dlc5/gc_icon_tri_chevron%", "", Rank[3]) //Titan kill as pilot
      }
	  switch (Killstreak) {
		case 3: //Killstreak 3
			AddMedalEvent("%$rui/gencard_icons/gc_icon_prowler%", "%$rui/gencard_icons/dlc3/gc_icon_pilot%", "%$rui/gencard_icons/dlc5/gc_icon_hammond%", Rank[2])
			break
		case 5: //Killstreak 5
			AddMedalEvent("%$rui/gencard_icons/gc_icon_ace%", "%$rui/gencard_icons/dlc3/gc_icon_pilot%", "%$rui/gencard_icons/dlc5/gc_icon_hammond%", Rank[2])
			break
		case 10: //Killstreak 10
			AddMedalEvent("%$rui/gencard_icons/dlc1/gc_icon_apex%", "%$rui/gencard_icons/dlc5/gc_icon_x%", "%$rui/gencard_icons/dlc1/gc_icon_apex%", Rank[3])
			break
      }
      if (!IsAlive(GetLocalClientPlayer())) {
        AddMedalEvent("%$rui/gencard_icons/gc_icon_ghostface%", "%$rui/gencard_icons/gc_icon_ghostface%", "", Rank[2]) //kills when player is dead
      }
    }
  }
}

void
function OnDamage(entity player, entity victim, vector Pos, int damageType) {
  if (damageType & DF_KILLSHOT) {
    if (!victim.IsPlayer() && AiMultikill%4 == 0) {
      AddMedalEvent("%$rui/gencard_icons/dlc5/gc_icon_militia%", "%$rui/gencard_icons/dlc5/gc_icon_militia%", "", Rank[4]) 
    } else {
      AiMultikill++
    }
    if (damageType & DF_HEADSHOT) {
      AddMedalEvent("%$rui/gencard_icons/gc_icon_crosshair%", "%$rui/gencard_icons/gc_icon_crosshair%", "", Rank[2])
    }
    if (damageType & DF_CRITICAL) {
      AddMedalEvent("%$rui/gencard_icons/gc_icon_bullseye%", "%$rui/gencard_icons/gc_icon_bullseye%", "", Rank[2]) // crits on titans
    }
  }
}

void
function AddMedalEvent(string badge_bg, string badge, string badge_fg, vector rank) {
	InCombat = true
 //if(BadgeFGCont != ("")){BadgeFGCont = badge_fg}
  //if(BadgeCont != ("")){BadgeCont = badge}
  //if(BadgeBGCont != ("")){BadgeBGCont = badge_bg}
  BadgeBGCont = badge_bg
  BadgeCont = badge
  BadgeFGCont = badge_fg
  color = rank
  BadgeFGAlpha = 1.0
  BadgeAlpha = 1.0
  BadgeBGAlpha = 0.75
  BadgeSize = 400.0
  TimeSinceLast = Time()
}

void
function UpdateBadgeUI() {
  while (true) {
    TimeNow = Time() 
	if (!IsLobby() && !IsWatchingReplay() && GetLocalClientPlayer() != null && IsAlive(GetLocalClientPlayer())) {
      AddStyleFromSpeed()
    }
	// Background
    RuiSetFloat2(BadgeSlot3, "msgPos", BasePos + < 0.415, 0.175, -0.1 > )
    RuiSetFloat(BadgeSlot3, "msgAlpha", BadgeBGAlpha)
    RuiSetFloat(BadgeSlot3, "msgFontSize", 500)
    RuiSetFloat3(BadgeSlot3, "msgColor", color)
    RuiSetString(BadgeSlot3, "msgText", BadgeBGCont)
    // Badge
    RuiSetFloat2(BadgeSlot2, "msgPos", BasePos + < 0.432, 0.315, 0 > )	
    RuiSetFloat(BadgeSlot2, "msgAlpha", BadgeAlpha)
    RuiSetFloat(BadgeSlot2, "msgFontSize", BadgeSize)
    RuiSetFloat3(BadgeSlot2, "msgColor", < 0.9, 0.9, 0.9 >)
    RuiSetString(BadgeSlot2, "msgText", BadgeCont)
	// Foreground
    RuiSetFloat2(BadgeSlot1, "msgPos", BasePos + < 0.466, 0.55, 0.1 > )		// + < -0.349, 0.4, 0 > 
    RuiSetFloat(BadgeSlot1, "msgAlpha", BadgeFGAlpha)
    RuiSetFloat(BadgeSlot1, "msgFontSize", 200)
    RuiSetFloat3(BadgeSlot1, "msgColor", color)
    RuiSetString(BadgeSlot1, "msgText", BadgeFGCont)


    if ((TimeNow - TimeSinceLast) > 4) {
      Multikill = 0
	  AiMultikill = 0
    }
    if (((TimeNow - TimeSinceLast) > 1.2)) {
      BadgeFGAlpha = BadgeFGAlpha - 0.05
      BadgeAlpha = BadgeAlpha - 0.05
      BadgeBGAlpha = BadgeBGAlpha - 0.05
      BadgeSize = BadgeSize + 4
	  InCombat = false
    }
	
    WaitFrame()
  }
  RuiDestroy(BadgeSlot1)
  RuiDestroy(BadgeSlot2)
  RuiDestroy(BadgeSlot3)
}

void
function BadgeRuiSetup() {
  // Puting these here to make me seam more orgainsed than I am :)  <-- Wow, he's so organised!

  BadgeSlot1 = RuiCreate($"ui/cockpit_console_text_top_left.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 1)
  BadgeSlot2 = RuiCreate($"ui/cockpit_console_text_top_left.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 0)
  BadgeSlot3 = RuiCreate($"ui/cockpit_console_text_top_left.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, -1)

  // Badge FG
  RuiSetInt(BadgeSlot1, "maxLines", 1)
  RuiSetInt(BadgeSlot1, "lineNum", 1)
  RuiSetFloat2(BadgeSlot1, "msgPos", < PosX1, PosY1, 0 > )
  RuiSetFloat(BadgeSlot1, "msgFontSize", 500)
  RuiSetFloat(BadgeSlot1, "msgAlpha", BadgeFGAlpha)
  RuiSetFloat(BadgeSlot1, "thicken", 0.0)
  RuiSetFloat3(BadgeSlot1, "msgColor", color)
  RuiSetString(BadgeSlot1, "msgText", BadgeBGCont)

  // Badge
  RuiSetInt(BadgeSlot2, "maxLines", 1)
  RuiSetInt(BadgeSlot2, "lineNum", 1)
  RuiSetFloat2(BadgeSlot2, "msgPos", < PosX1, PosY1, 0 > )
  RuiSetFloat(BadgeSlot2, "msgFontSize", BadgeSize)
  RuiSetFloat(BadgeSlot2, "msgAlpha", BadgeAlpha)
  RuiSetFloat(BadgeSlot2, "thicken", 0.0)
  RuiSetFloat3(BadgeSlot2, "msgColor", color)
  RuiSetString(BadgeSlot2, "msgText", BadgeCont)

  // Badge BG
  RuiSetInt(BadgeSlot3, "maxLines", 1) 
  RuiSetInt(BadgeSlot3, "lineNum", 1) 
  RuiSetFloat2(BadgeSlot3, "msgPos", < PosX1, PosY1, 0 > ) 
  RuiSetFloat(BadgeSlot3, "msgFontSize", 500)
  RuiSetFloat(BadgeSlot3, "msgAlpha", BadgeBGAlpha) 
  RuiSetFloat(BadgeSlot3, "thicken", 0.0) 
  RuiSetFloat3(BadgeSlot3, "msgColor", color) 
  RuiSetString(BadgeSlot3, "msgText", BadgeBGCont)
}

// Khalmee's stuff
/*
Goals:
-Speed calculation:
Every 2-3 seconds get the average speed by adding up the samples and dividing them by their amount, add that as points
Every 3 continuous cycles add movement bonus
(Some aspects came out differently, but DONE)
-Air time calculation:
If not touching the ground for 3+ seconds, give points
(Has issues, look in main loop)
-Points for AI kills
Requires modifying LocalPlayerDidDamageCallback, check if victim is not player and if you're not in replay
(TODO)
*/
array < float > SpeedBuffer // Where speed samples are stored
float LastSpeedMeasurement = 0 // Last point in time when speed was measured
float LastTimeTouchingGround = 10
float TimeToBeat = 3 // Next Air Time bonus
int movementChain = 0 // Number of consecutive speed bonuses

float
function GetSpeed(entity ent) { // returns horizontal speed of an entity
  vector vel = ent.GetVelocity()
  return sqrt(vel.x * vel.x + vel.y * vel.y) * (0.274176 / 3) // the const is for measurement in kph
}

void
function AddStyleFromSpeed() { // Adds style points based on speed
  entity p = GetLocalClientPlayer()
  float cumsum = 0 // Cumulative sum, what else did you think it means?
  float avgSpeed = 0
  SpeedBuffer.append(GetSpeed(p)) // Add current speed to the buffer
  if (Time() - LastSpeedMeasurement > 5) { // Every N seconds, check the average and apply bonuses (adjust the time)
    foreach(SpeedSample in SpeedBuffer) { // sum up speed
      cumsum += SpeedSample
    }
    avgSpeed = cumsum / SpeedBuffer.len() // and get the average

    // These values should be tweaked, speed:
    // 36, 48, 60, 72
    if(!p.IsTitan() && InCombat == false){
	if (avgSpeed < 36) {
      movementChain = 0
    } else if (avgSpeed < 48) {
      AddMedalEvent("", "", "", Rank[0])
      movementChain++
    } else if (avgSpeed < 60) {
      AddMedalEvent("", "", "", Rank[0])
      movementChain++
    } else if (avgSpeed < 72) {
      AddMedalEvent("%$rui/gencard_icons/gc_icon_flying_skull%", "%$rui/gencard_icons/gc_icon_flying_skull%", "", Rank[0])
      movementChain++
    } else {
      AddMedalEvent("%$rui/gencard_icons/gc_icon_flying_skull%", "%$rui/gencard_icons/gc_icon_flying_skull%", "", Rank[1])
      movementChain++
    }

    // Same here, movement:
    switch (movementChain) {
    case 3:
      AddMedalEvent("%$rui/gencard_icons/dlc5/gc_icon_pilot_circle%", "%$rui/gencard_icons/dlc5/gc_icon_pilot_circle%", "", Rank[0])
      break
    case 6:
      AddMedalEvent("%$rui/gencard_icons/dlc5/gc_icon_pilot_circle%", "%$rui/gencard_icons/dlc5/gc_icon_pilot_circle%", "", Rank[1])
      break
    default:
      if (movementChain % 3 == 0 && movementChain >= 9)
        AddMedalEvent("%$rui/gencard_icons/dlc5/gc_icon_pilot_circle%", "%$rui/gencard_icons/dlc5/gc_icon_pilot_circle%", "", Rank[1])
      break
    }}

    SpeedBuffer.clear() // eat up the buffer
    LastSpeedMeasurement = Time()
  }
}

void
function AddStyleFromAirTime() { // Air time bonus
  entity p = GetLocalClientPlayer()
  if (!p.IsOnGround() && !IsSpectating()) { // there should be some sort of check to see if player is in control
    if (Time() - LastTimeTouchingGround > TimeToBeat) {
      AddMedalEvent("", "%$rui/gencard_icons/gc_icon_bullseye%", "", Rank[1])
      TimeToBeat += 3
    }
  } else {
    TimeToBeat = 3 
	LastTimeTouchingGround = Time()
  }
}
// end

#endif
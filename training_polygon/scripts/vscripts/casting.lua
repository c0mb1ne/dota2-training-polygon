ROW_SCORE=0
TOP_SCORE=0
LIVES_COUNT=0
EVASION_TYPE=0

function refreshItems(hero)
	for i=0, 5, 1 do
		local current_item = hero:GetItemInSlot(i)
		if current_item ~= nil then
			current_item:EndCooldown()
		end
	end
end
function healHero(hero)
	local maxHp=hero:GetMaxHealth()
	hero:SetHealth(maxHp)
end
function casterAbilityTarget(hero,abilityName,caster,respawnPlace,castTime,castDelay,deathDelay)
	local faggot = CreateUnitByNameAsync(caster, respawnPlace, true, nil, nil, DOTA_TEAM_BADGUYS, function(unit)
		--unit:AddAbility(abilityName)
		unit:SetMoveCapability(1)
		unit:SetForwardVector((hero:GetOrigin() - respawnPlace):Normalized())
		unit:SetIdleAcquire(false)
		local ability = unit:FindAbilityByName(abilityName)
		ability:SetLevel(1)
		
		CustomGameEventManager:Send_ServerToAllClients("spell_casted",{castpoint=castTime, delay=castDelay, abil=abilityName})
		unit:SetContextThink(DoUniqueString("cast_ability"),
		function()

			unit:CastAbilityOnTarget(hero,ability,-1)
			ABILITY_CASTED=false
			unit:SetIdleAcquire(false)
			Timers:CreateTimer({
			    useGameTime = false,
			    endTime = 0.6, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
			    callback = function()
			    		unit:CastAbilityOnTarget(hero,ability,-1)
			    		unit:SetIdleAcquire(false)

			    	
			    end
			  })
		end,
		castDelay) 
		unit:SetContextThink(DoUniqueString("Remove_Self"),function()  unit:RemoveSelf() end, castDelay+deathDelay+castTime)
		return unit
    end)
end

function casterAbilityPosition(hero,abilityName,caster,respawnPlace,castTime,castDelay,deathDelay,level)
	if not level then
		level=1
	end
	local faggot = CreateUnitByNameAsync(caster, respawnPlace, true, nil, nil, DOTA_TEAM_BADGUYS, function(unit)
		--unit:AddAbility(abilityName)
		unit:SetMoveCapability(1)
		unit:SetForwardVector((hero:GetOrigin() - respawnPlace):Normalized())
		unit:SetIdleAcquire(false)
		local ability = unit:FindAbilityByName(abilityName)
		ability:SetLevel(level)

		CustomGameEventManager:Send_ServerToAllClients("spell_casted",{castpoint=castTime, delay=castDelay, abil=abilityName})
		unit:SetContextThink(DoUniqueString("cast_ability"),
		function()
			unit:CastAbilityOnPosition(hero:GetOrigin(),ability,-1)
			unit:SetIdleAcquire(false)
		end,
		castDelay) 
		unit:SetContextThink(DoUniqueString("Remove_Self"),function()  unit:RemoveSelf() end, castDelay+deathDelay+castTime)
		return unit
    end)
end

function casterAbilitySelf(hero,abilityName,caster,respawnPlace,castTime,castDelay,deathDelay)
	local faggot = CreateUnitByNameAsync(caster, respawnPlace, true, nil, nil, DOTA_TEAM_BADGUYS, function(unit)
		--unit:AddAbility(abilityName)
		unit:SetMoveCapability(1)
		unit:SetForwardVector((hero:GetOrigin() - respawnPlace):Normalized())
		unit:SetIdleAcquire(false)
		local ability = unit:FindAbilityByName(abilityName)
		ability:SetLevel(1)
		CustomGameEventManager:Send_ServerToAllClients("spell_casted",{castpoint=castTime, delay=castDelay, abil=abilityName})
		unit:SetContextThink(DoUniqueString("cast_ability"),
		function()
			unit:CastAbilityOnTarget(unit,ability,-1)
			unit:SetIdleAcquire(false)
		end,
		castDelay) 
		unit:SetContextThink(DoUniqueString("Remove_Self"),function()  unit:RemoveSelf() end, castDelay+deathDelay+castTime)
		return unit
    end)
end

function casterAbilityNotarget(hero,abilityName,caster,respawnPlace,castTime,castDelay,deathDelay)
	if not level then
		level=1
	end	
	local faggot = CreateUnitByNameAsync(caster, respawnPlace, true, nil, nil, DOTA_TEAM_BADGUYS, function(unit)
		--unit:AddAbility(abilityName)
		unit:SetMoveCapability(1)
		unit:SetForwardVector((hero:GetOrigin() - respawnPlace):Normalized())
		unit:SetIdleAcquire(false)
		local ability = unit:FindAbilityByName(abilityName)
		ability:SetLevel(level)
		CustomGameEventManager:Send_ServerToAllClients("spell_casted",{castpoint=castTime, delay=castDelay, abil=abilityName})
		unit:SetContextThink(DoUniqueString("cast_ability"),
		function()

			unit:CastAbilityNoTarget(ability,-1)
			unit:SetIdleAcquire(false)
		end,
		castDelay) 
		unit:SetContextThink(DoUniqueString("Remove_Self"),function()  unit:RemoveSelf() end, castDelay+deathDelay+castTime)
		return unit
    end)
end

function randomCirclePosition(range,hero)
	local x=RandomInt(-range,range)
	local znak=0;
	while znak==0 do
		local hui=RandomInt(-100,100)
		if hui<0 then
			znak=-1
		end
		if hui>0 then
			znak=1
		end
	end
	--print("znak:")
	--print(znak)
	local y=(math.sqrt((range-x)*(range+x)))*znak
	--print("x:")
	--print(x)
	--print("y:")
	--print(y)
	local respawn_place = hero:GetAbsOrigin() + Vector(x, y, 0)
	--print("vector:")
	--print(respawn_place)
	return respawn_place
end
function randomRingPosition(range1,range2,hero)
	local R=RandomInt(range1,range2)
	local x=RandomInt(-R,R)
	local znakY=0;
	while znakY==0 do
		local hui=RandomInt(-100,100)
		if hui<0 then
			znakY=-1
		end
		if hui>0 then
			znakY=1
		end
	end
	local y=math.floor(math.sqrt((R-x)*(R+x)))*znakY
	local respawn_place = hero:GetAbsOrigin() + Vector(x, y, 0)
	return respawn_place
end
function randomDisruptorPosition(range,hero)
	local hero_place=hero:GetAbsOrigin()
	local x=0
	local znak=0
	if hero_place.x>=0 and hero_place.y>=0 then
		x=RandomInt(-range,0)
		znak=-1
	elseif hero_place.x>=0 and hero_place.y<0 then
		x=RandomInt(-range,0)
		znak=1
	elseif hero_place.x<0 and hero_place.y<0 then
		x=RandomInt(0,range)
		znak=1
	else
		x=RandomInt(0,range)
		znak=-1
	end
	--print("znak:")
	--print(znak)
	local y=(math.sqrt((range-x)*(range+x)))*znak
	--print("x:")
	--print(x)
	--print("y:")
	--print(y)
	local respawn_place = hero:GetAbsOrigin() + Vector(x, y, 0)
	--print("vector:")
	--print(respawn_place)
	return respawn_place
end
function randomRingPositionVec(range1,range2,vec)
	local R=RandomInt(range1,range2)
	local x=RandomInt(-R,R)
	local znakY=0;
	while znakY==0 do
		local hui=RandomInt(-100,100)
		if hui<0 then
			znakY=-1
		end
		if hui>0 then
			znakY=1
		end
	end
	local y=math.floor(math.sqrt((R-x)*(R+x)))*znakY
	local respawn_place = vec + Vector(x, y, 0)
	return respawn_place
end
function randomLinePosition(range1,range2,hero)
	local direction=(hero:GetForwardVector()):Normalized()
	local x=direction.x
	local y=direction.y
	local R=RandomInt(range1,range2)
	x=x*R
	y=y*R
	local respawn_place = hero:GetAbsOrigin() + Vector(x,y,0)
	return respawn_place
end
function removeItems(hero)
	for i=0,14 do
	    local itemFind=hero:GetItemInSlot(i)
	    --print(itemFind)
	    if itemFind~=nil then
	      hero:RemoveItem(itemFind)
	    end
  	end
end

function evasionChecker(skill,hero,castDelay,castTime)
	local hpBefore=hero:GetHealth()
	--print("evasionChecker starts",Time())
	--local hui_v_zhope=castDelay+castTime+0.4
	--print("hui_v_zhope",hui_v_zhope)

	Timers:CreateTimer({
		endTime = hui_v_zhope, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
		callback = function()
		  --print ("checking hp")
		  --print(hero:GetHealth(),Time())
		  --print()
		  if hero:GetHealth()<hero:GetMaxHealth() then
		  	local badTime=MANTA_CASTED_TIME-MANTA_HERO_HURT_TIME
		  	--print("badTime",badTime)
		  	if math.abs(badTime)<1.5 then
		  		sendBad(skill,badTime)
		  	else
		  		sendBad(skill,nil)
		  	end
		  else
		  	sendGood(skill)
		  end
		  refreshItems(hero)
		  healHero(hero)
		end
	})
end
function evasionCheckerTarget(skill,hero,castDelay,castTime,castpoint)
	local hpBefore=hero:GetHealth()
	--print("evasionChecker starts")
	--print(Time())
	--print("hpBefore:")
	--print(hpBefore)
	  Timers:CreateTimer({
	    useGameTime = false,
	    endTime = castDelay+castTime+castpoint+0.9, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
	    callback = function()
	      --print ("checking hp")
	      --print(Time())
	      --print(hero:GetHealth())
	      if hero:GetHealth()<hero:GetMaxHealth() then
	      	local badTime=MANTA_CASTED_TIME-MANTA_HERO_HURT_TIME
	      	--print("badTime",badTime)
	      	if math.abs(badTime)<1.5 then
	      		sendBad(skill,badTime)
	      	else
	      		sendBad(skill,nil)
	      	end
	      else
	      	sendGood(skill)
	      end
	      hero:Purge(false,true,false,true,false)
	      refreshItems(hero)
	      healHero(hero)
	    end
	  })
end
function evasionCheckerDebuff(skill,hero,castDelay,castTime,debuff)
	local hpBefore=hero:GetHealth()
	--print("evasionCheckerD starts")
	  Timers:CreateTimer({
	    useGameTime = false,
	    endTime = castDelay+castTime+0.4, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
	    callback = function()
	      --print(hero:FindModifierByName(debuff))
	      if hero:FindModifierByName(debuff) then
	      	local badTime=MANTA_CASTED_TIME-MANTA_MODIFIER_GAINED
	      	--print("badTime",badTime)
	      	if math.abs(badTime)<1.5 then
	      		sendBad(skill,badTime)
	      	else
	      		sendBad(skill,nil)
	      	end
	      else
	      	sendGood(skill)
	      end
	      refreshItems(hero)
	      hero:RemoveModifierByName(debuff)
	      healHero(hero)
	    end
	  })
end
function evasionCheckerStun(skill,hero,castDelay,castTime)
	local hpBefore=hero:GetHealth()
	--print("evasionCheckerD starts")
	  Timers:CreateTimer({
	    useGameTime = false,
	    endTime = castDelay+castTime+0.4, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
	    callback = function()
	      
	      if hero:IsStunned() then
	      	local badTime=MANTA_CASTED_TIME-MANTA_MODIFIER_GAINED
	      	--print("badTime",badTime)
	      	if math.abs(badTime)<1.5 then
	      		sendBad(skill,badTime)
	      	else
	      		sendBad(skill,nil)
	      	end
	      else
	      	sendGood(skill)
	      end
	      
	      hero:Purge(false,true,false,true,false)
	      refreshItems(hero)
	      healHero(hero)
	    end
	  })
end
function sendGood(skill)
	ROW_SCORE=ROW_SCORE+1
	if ROW_SCORE>TOP_SCORE then
		TOP_SCORE=ROW_SCORE
	end
	CustomGameEventManager:Send_ServerToAllClients("top_score",{score=TOP_SCORE})
	CustomGameEventManager:Send_ServerToAllClients("evasion_check",{dodgestreak=ROW_SCORE, how="good", skillId=skill, lives=LIVES_COUNT})

end
function sendBad(skill,badTime)
	ROW_SCORE=0
	LIVES_COUNT=LIVES_COUNT-1
	if badTime~=nil then
		--print("AAAAAAAAA EBUT POMOGITE")
		CustomGameEventManager:Send_ServerToAllClients("evasion_check",{dodgestreak=ROW_SCORE, how="bad", skillId=skill, lives=LIVES_COUNT, time=badTime})
	else
		CustomGameEventManager:Send_ServerToAllClients("evasion_check",{dodgestreak=ROW_SCORE, how="bad", skillId=skill, lives=LIVES_COUNT})
	end

	
	CustomGameEventManager:Send_ServerToAllClients("update_lives",{lives=LIVES_COUNT})
end

function roundKek(num, idp)
  return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end

--casterAbilityPosition(hero,abilityName,caster,respawnPlace,castTime,castDelay,deathDelay)
function kunkkaGhostship(hero,castDelay,deathDelay)
	EVASION_TYPE=1
	local castpoint=0.3
	local casttime=3.077
	local castTime=castpoint+casttime
	local respawn_place = randomRingPosition(400,1000,hero)
	local ability_name = "kunkka_ghostship"
	local caster_name = "npc_dota_hero_kunkka"
	casterAbilityPosition(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionCheckerStun(ability_name,hero,castDelay,castpoint+casttime)
	return castTime
end

function linaLightStrike(hero,castDelay,deathDelay)
	EVASION_TYPE=1
	local castpoint=0.45
	local damageDelay=0.5
	local castTime=castpoint+damageDelay
	local respawn_place = randomRingPosition(400,600,hero)
	local ability_name = "lina_light_strike_array"
	local caster_name = "npc_dota_hero_lina"
	casterAbilityPosition(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionChecker(ability_name,hero,castDelay,castTime)
	return castTime
end
function linaLaguna(hero,castDelay,deathDelay)
	local castpoint=0.45
	local damageDelay=0.25
	local castTime=castpoint+damageDelay
	local respawn_place = randomRingPosition(400,600,hero)
	local ability_name = "lina_laguna_blade"
	local caster_name = "npc_dota_hero_lina"
	casterAbilityTarget(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionCheckerTarget(ability_name,hero,castDelay,castTime,castpoint)
	return castTime
end
function bseekerBloodBath(hero,castDelay,deathDelay)
	EVASION_TYPE=1
	local castpoint=0.3
	local damageDelay=2.6
	local castTime=castpoint+damageDelay
	local respawn_place = randomRingPosition(400,1000,hero)
	local ability_name = "bloodseeker_blood_bath"
	local caster_name = "npc_dota_hero_bloodseeker"
	casterAbilityPosition(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionChecker(ability_name,hero,castDelay,castTime)
	return castTime
end
function pugnaNetherBlast(hero,castDelay,deathDelay)
	EVASION_TYPE=1
	local castpoint=0.2
	local damageDelay=0.9
	local castTime=castpoint+damageDelay
	local respawn_place = randomCirclePosition(400,hero)
	local ability_name = "pugna_nether_blast"
	local caster_name = "npc_dota_hero_pugna"
	casterAbilityPosition(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionChecker(ability_name,hero,castDelay,castTime)
	return castTime
end
function meepoPoof(hero,castDelay,deathDelay)
	EVASION_TYPE=1
	local castTime=1.5
	local respawn_place = randomRingPosition(30,350,hero)
	local ability_name = "meepo_poof"
	local caster_name = "npc_dota_hero_meepo"
	casterAbilitySelf(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionChecker(ability_name,hero,castDelay,castTime)
	return castTime
end
function necroPulse(hero,castDelay,deathDelay)
	EVASION_TYPE=5
	local respawn_place = randomRingPosition(150,475,hero)
	local lenght=hero:GetAbsOrigin()-respawn_place
	local range=lenght:Length()
	local castTime=(range-48)/400
	local ability_name = "necrolyte_death_pulse"
	local caster_name = "npc_dota_hero_necrolyte"
	casterAbilityNotarget(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionChecker(ability_name,hero,castDelay,castTime)
	return castTime
end
function miranaStarfall(hero,castDelay,deathDelay)
	EVASION_TYPE=1
	local castTime=1.07
	local respawn_place = randomRingPosition(450,650,hero)
	local ability_name = "mirana_starfall"
	local caster_name = "npc_dota_hero_mirana"
	casterAbilityNotarget(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionChecker(ability_name,hero,castDelay,castTime)
	return castTime
end	
function sfCoil(hero,castDelay,deathDelay,coiltype)
	EVASION_TYPE=1
	if coiltype==0 then
		coiltype=RandomInt(1,3)
	end
	local castTime=0.55
	if coiltype==1 then
		ability_name = "nevermore_shadowraze1"
		range=200
	elseif coiltype==2 then
		ability_name = "nevermore_shadowraze2"
		range=450
	elseif coiltype==3 then
		ability_name = "nevermore_shadowraze3"
		range=700
	end
	local respawn_place = randomRingPosition(range-200,range+200,hero)
	local caster_name = "npc_dota_hero_nevermore"
	casterAbilityNotarget(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionChecker(ability_name,hero,castDelay,castTime)
	return castTime
end
function zeusBolt(hero,castDelay,deathDelay)
	EVASION_TYPE=1
	local castTime=0.4
	local respawn_place = randomRingPosition(300,700,hero)
	local ability_name = "zuus_lightning_bolt"
	local caster_name = "npc_dota_hero_zuus"
	casterAbilityPosition(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionChecker(ability_name,hero,castDelay,castTime)
	return castTime
end
function zeusUlt(hero,castDelay,deathDelay)
	EVASION_TYPE=1
	local castTime=0.4
	local respawn_place = randomRingPosition(300,700,hero)
	local ability_name = "zuus_thundergods_wrath"
	local caster_name = "npc_dota_hero_zuus"
	casterAbilityNotarget(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionChecker(ability_name,hero,castDelay,castTime)
	return castTime
end
function tideSmash(hero,castDelay,deathDelay)
	EVASION_TYPE=1
	local castTime=0.4
	local respawn_place = randomRingPosition(50,300,hero)
	local ability_name = "tidehunter_anchor_smash"
	local caster_name = "npc_dota_hero_tidehunter"
	casterAbilityNotarget(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionChecker(ability_name,hero,castDelay,castTime)
	return castTime
end
function ursaSmash(hero,castDelay,deathDelay)
	EVASION_TYPE=1
	local castTime=0.3
	local respawn_place = randomRingPosition(50,350,hero)
	local ability_name = "ursa_earthshock"
	local caster_name = "npc_dota_hero_ursa"
	casterAbilityNotarget(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionChecker(ability_name,hero,castDelay,castTime)
	return castTime
end
function omnikHeal(hero,castDelay,deathDelay)
	EVASION_TYPE=1
	local castTime=0.2
	local respawn_place = randomRingPosition(50,250,hero)
	local ability_name = "omniknight_purification"
	local caster_name = "npc_dota_hero_omniknight"
	casterAbilitySelf(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionChecker(ability_name,hero,castDelay,castTime)
	return castTime
end
function alcheBanka(hero,castDelay,deathDelay)
	EVASION_TYPE=4
	local nakrutka=RandomFloat(0.5,3)
	--nakrutka=3
	local respawn_place = randomRingPosition(200,750,hero)
	local lenght=hero:GetAbsOrigin()-respawn_place
	local range=lenght:Length()
	local castpoint=0.2
	local castTime=(range-48)/900+castpoint+nakrutka
	local ability_name1 = "alchemist_unstable_concoction"
	local ability_name2 = "alchemist_unstable_concoction_throw"
	local caster_name = "npc_dota_hero_alchemist"
		local faggot = CreateUnitByNameAsync(caster_name, respawn_place, true, nil, nil, DOTA_TEAM_BADGUYS, function(unit)
		unit:AddAbility(ability_name1)
		unit:SetForwardVector((hero:GetOrigin() - respawn_place):Normalized())
		unit:SetIdleAcquire(false)
		local ability = unit:FindAbilityByName(ability_name1)
		ability:SetLevel(1)
		CustomGameEventManager:Send_ServerToAllClients("spell_casted",{castpoint=castTime, delay=castDelay, abil=ability_name1})
		unit:SetContextThink(DoUniqueString("cast_ability"),
		function()

			unit:CastAbilityNoTarget(ability,-1)
			unit:SetIdleAcquire(false)
			local ability2 = unit:FindAbilityByName(ability_name2)
			Timers:CreateTimer({
			    useGameTime = false,
			    endTime = nakrutka, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
			    callback = function()
			    	unit:CastAbilityOnTarget(hero,ability2,-1)
			    	Timers:CreateTimer({
					    useGameTime = false,
					    endTime = 0.5, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
					    callback = function()
					    	unit:CastAbilityOnTarget(hero,ability2,-1)
					    end
					  })
			    end
			  })
		end,
		castDelay) 
		unit:SetContextThink(DoUniqueString("Remove_Self"),function()  unit:RemoveSelf() end, castDelay+deathDelay+castTime)
		return unit
    end)
	evasionCheckerTarget(ability_name1,hero,castDelay,castTime,castpoint)
	return castTime
end
function skymageBolt(hero,castDelay,deathDelay)
	EVASION_TYPE=4
	local respawn_place = randomRingPosition(100,750,hero)
	local lenght=hero:GetAbsOrigin()-respawn_place
	local range=lenght:Length()
	local castpoint=0.1
	local castTime=(range-48)/500+castpoint
	local ability_name = "skywrath_mage_arcane_bolt"
	local caster_name = "npc_dota_hero_skywrath_mage"
	casterAbilityTarget(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionCheckerTarget(ability_name,hero,castDelay,castTime,castpoint)
	return castTime
end
function medusaSnake(hero,castDelay,deathDelay)
	EVASION_TYPE=4
	local respawn_place = randomRingPosition(100,750,hero)
	--local respawn_place =randomCirclePosition(range,hero)
	local lenght=hero:GetAbsOrigin()-respawn_place
	local range=lenght:Length()
	--print("range:")
	--print(range)
	local castTime=(range-48)/800+0.4
	--print("Snake cast time:")
	--print(castTime)
	local ability_name = "medusa_mystic_snake"
	local caster_name = "npc_dota_hero_medusa"
	casterAbilityTarget(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionChecker(ability_name,hero,castDelay,castTime)
	return castTime
end
function medusaUlt(hero,castDelay,deathDelay,level)
	EVASION_TYPE=2
	local castTime=2.4
	local respawn_place = randomLinePosition(100,750,hero)
	local ability_name = "medusa_stone_gaze"
	local caster_name = "npc_dota_hero_medusa"
	local modifier_name="modifier_medusa_stone_gaze_stone"
	casterAbilityNotarget(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay,level)
	evasionCheckerDebuff(ability_name,hero,castDelay,castTime,modifier_name)
	return castTime
end
function disruptorGlimpse(hero,castDelay,deathDelay)
	--нахуй этот глимпс
	local respawn_place = randomRingPosition(100,575,hero)
	local ability_level=RandomInt(1,9)
	local range=(ability_level+1)*100

	local castTime=(range-32)/600+0.05
	local ability_name = "glimpse_datadriven"
	local caster_name = "npc_dota_hero_disruptor"
	print("level")
	print(ability_level)
	print("range")
	print(range)
	print("castTime")
	print(castTime)

	local faggot = CreateUnitByNameAsync(caster_name, respawn_place, true, nil, nil, DOTA_TEAM_BADGUYS, function(unit)
		unit:AddAbility(ability_name)
		unit:SetForwardVector((hero:GetOrigin() - respawn_place):Normalized())
		unit:SetIdleAcquire(false)
		local ability = unit:FindAbilityByName(ability_name)
		ability:SetLevel(ability_level)
		CustomGameEventManager:Send_ServerToAllClients("spell_casted",{castpoint=castTime, delay=castDelay, abil=ability_name})
		unit:SetContextThink(DoUniqueString("cast_ability"),
		function()

			unit:CastAbilityOnTarget(hero,ability,-1)
			unit:SetIdleAcquire(false)
		end,
		castDelay) 
		unit:SetContextThink(DoUniqueString("Remove_Self"),function()  unit:RemoveSelf() end, castDelay+deathDelay+castTime)
		return unit
    end)
	evasionChecker(hero,castDelay,castTime)
	return castTime
end
function sdUlt(hero,castDelay,deathDelay)
	EVASION_TYPE=3
	local respawn_place = randomRingPosition(100,757,hero)
	local castpoint=0.3
	local castTime=5+castpoint
	local caster_name = "npc_dota_hero_shadow_demon"
	local ability_name = "shadow_demon_demonic_purge"
	local faggot = CreateUnitByNameAsync(caster_name, respawn_place, true, nil, nil, DOTA_TEAM_BADGUYS, function(unit)
		--unit:AddAbility(ability_name)
		unit:SetForwardVector((hero:GetOrigin() - respawn_place):Normalized())
		unit:SetIdleAcquire(false)

		local ability = unit:FindAbilityByName(ability_name)
		ability:SetLevel(1)
		CustomGameEventManager:Send_ServerToAllClients("spell_casted",{castpoint=castTime, delay=castDelay, abil=ability_name})
		unit:SetContextThink(DoUniqueString("cast_ability"),
		function()

			unit:CastAbilityOnTarget(hero,ability,-1)
			unit:SetIdleAcquire(false)
			Timers:CreateTimer({
			    useGameTime = false,
			    endTime = 0.6, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
			    callback = function()
			    		unit:CastAbilityOnTarget(hero,ability,-1)
			    		unit:SetIdleAcquire(false)

			    	
			    end
			  })

		end,
		castDelay) 
		unit:SetContextThink(DoUniqueString("Remove_Self"),function()  unit:RemoveSelf() end, castDelay+deathDelay+castTime)
		return unit
    end)
	evasionCheckerTarget(ability_name,hero,castDelay,castTime,castpoint)
	return castTime
end
function shakerFisssure(hero,castDelay,deathDelay)
	EVASION_TYPE=1
	local castTime=0.69
	local respawn_place = randomRingPosition(300,1300,hero)
	local ability_name = "earthshaker_fissure"
	local caster_name = "npc_dota_hero_earthshaker"
	casterAbilityPosition(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionChecker(ability_name,hero,castDelay,castTime)
	return castTime
end
function shakerTotem(hero,castDelay,deathDelay,scepter)
	local castTime
	local respawn_place
	local ability_name = "earthshaker_enchant_totem"
	local ability_name2= "earthshaker_aftershock"
	local caster_name = "npc_dota_hero_earthshaker"
    if scepter==1 then
    	EVASION_TYPE=5
		castTime=1.03
		respawn_place = randomRingPosition(200,800,hero)
		local faggot = CreateUnitByNameAsync(caster_name, respawn_place, true, nil, nil, DOTA_TEAM_BADGUYS, function(unit)
			--unit:AddAbility(abilityName)
			unit:SetMoveCapability(1)
			unit:SetForwardVector((hero:GetOrigin() - respawn_place):Normalized())
			unit:SetIdleAcquire(false)
			local item = CreateItem("item_ultimate_scepter", unit, unit)  
        	unit:AddItem(item)
			local ability = unit:FindAbilityByName(ability_name)
			ability:SetLevel(1)
			local ability2 = unit:FindAbilityByName(ability_name2)
			ability2:SetLevel(4)
			CustomGameEventManager:Send_ServerToAllClients("spell_casted",{castpoint=castTime, delay=castDelay, abil=ability_name})
			unit:SetContextThink(DoUniqueString("cast_ability"),
			function()
				unit:CastAbilityOnPosition(hero:GetOrigin(),ability,-1)
				unit:SetIdleAcquire(false)
			end,
			castDelay) 
			unit:SetContextThink(DoUniqueString("Remove_Self"),function()  unit:RemoveSelf() end, castDelay+deathDelay+castTime)
			return unit
	    end)
	else
		EVASION_TYPE=1
		castTime=0.69
		respawn_place = randomRingPosition(50,250,hero)
		local faggot = CreateUnitByNameAsync(caster_name, respawn_place, true, nil, nil, DOTA_TEAM_BADGUYS, function(unit)
			--unit:AddAbility(abilityName)
			unit:SetMoveCapability(1)
			unit:SetForwardVector((hero:GetOrigin() - respawn_place):Normalized())
			unit:SetIdleAcquire(false)
			local ability = unit:FindAbilityByName(ability_name)
			ability:SetLevel(1)
			local ability2 = unit:FindAbilityByName(ability_name2)
			ability2:SetLevel(4)
			CustomGameEventManager:Send_ServerToAllClients("spell_casted",{castpoint=castTime, delay=castDelay, abil=ability_name})
			unit:SetContextThink(DoUniqueString("cast_ability"),
			function()

				unit:CastAbilityNoTarget(ability,-1)
				unit:SetIdleAcquire(false)
			end,
			castDelay) 
			unit:SetContextThink(DoUniqueString("Remove_Self"),function()  unit:RemoveSelf() end, castDelay+deathDelay+castTime)
			return unit
	    end)
	end
	evasionCheckerStun(ability_name,hero,castDelay,castTime)
	return castTime
end
function invokerEmp(hero,castDelay,deathDelay)
	EVASION_TYPE=1
	local castTime=2.95
	local respawn_place = randomRingPosition(300,900,hero)
	local ability_name = "invoker_emp"
	local invoke_name="invoker_invoke"
	local wex_name="invoker_wex"
	local caster_name = "npc_dota_hero_invoker"
	local faggot = CreateUnitByNameAsync(caster_name, respawn_place, true, nil, nil, DOTA_TEAM_BADGUYS, function(unit)		
		unit:SetForwardVector((hero:GetOrigin() - respawn_place):Normalized())
		unit:SetIdleAcquire(false)
		local invoke = unit:FindAbilityByName(invoke_name)
		invoke:SetLevel(1)
		local wex=unit:FindAbilityByName(wex_name)
		wex:SetLevel(3)
		CustomGameEventManager:Send_ServerToAllClients("spell_casted",{castpoint=castTime, delay=castDelay, abil=ability_name})
		unit:SetContextThink(DoUniqueString("cast_ability"),
		function()
			unit:CastAbilityNoTarget(wex,-1)
			unit:CastAbilityNoTarget(wex,-1)
			unit:CastAbilityNoTarget(wex,-1)
			unit:CastAbilityNoTarget(invoke,-1)
			local ability=unit:FindAbilityByName(ability_name)
			unit:CastAbilityOnPosition(hero:GetOrigin(),ability,-1)
			unit:SetIdleAcquire(false)
		end,
		castDelay) 
		unit:SetContextThink(DoUniqueString("Remove_Self"),function()  unit:RemoveSelf() end, castDelay+deathDelay+castTime)
		return unit
    end)
	evasionChecker(ability_name,hero,castDelay,castTime)
	return castTime
end
function odUlt(hero,castDelay,deathDelay)
	EVASION_TYPE=1
	local castTime=0.25
	local respawn_place = randomRingPosition(300,675,hero)
	local ability_name = "obsidian_destroyer_sanity_eclipse"
	local caster_name = "npc_dota_hero_obsidian_destroyer"
	casterAbilityPosition(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionChecker(ability_name,hero,castDelay,castTime)
	return castTime
end
function zombieDecay(hero,castDelay,deathDelay)
	EVASION_TYPE=1
	local castTime=0.45
	local respawn_place = randomRingPosition(300,600,hero)
	local ability_name = "undying_decay"
	local caster_name = "npc_dota_hero_undying"
	casterAbilityPosition(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionChecker(ability_name,hero,castDelay,castTime)
	return castTime
end
function titanStomp(hero,castDelay,deathDelay)
	EVASION_TYPE=1
	local castTime=1.7
	local respawn_place = randomRingPosition(50,475,hero)
	local ability_name = "elder_titan_echo_stomp"
	local caster_name = "npc_dota_hero_elder_titan"
	casterAbilityNotarget(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionCheckerStun(ability_name,hero,castDelay,castTime)
	return castTime
end
function clockRocket(hero,castDelay,deathDelay)
	EVASION_TYPE=5
	local respawn_place = randomRingPosition(500,1500,hero)
	local lenght=hero:GetAbsOrigin()-respawn_place
	local range=lenght:Length()
	local castTime=(range-24)/1750+0.3
	local ability_name = "rattletrap_rocket_flare"
	local caster_name = "npc_dota_hero_rattletrap"
	casterAbilityPosition(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionChecker(ability_name,hero,castDelay,castTime)
	return castTime
end
function clockHook(hero,castDelay,deathDelay,level)
	EVASION_TYPE=5
	local respawn_place = randomRingPosition(500,1500,hero)
	local lenght=hero:GetAbsOrigin()-respawn_place
	local range=lenght:Length()
	local castTime=(range-48)/4000+0.3
	local ability_name = "rattletrap_hookshot"
	local caster_name = "npc_dota_hero_rattletrap"
	local modifier_name = "modifier_stuned"
	casterAbilityPosition(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay,level)
	evasionCheckerStun(ability_name,hero,castDelay,castTime)
	return castTime
end
function wrPowershot(hero,castDelay,deathDelay)
	EVASION_TYPE=5
	local respawn_place = randomRingPosition(500,1500,hero)
	local lenght=hero:GetAbsOrigin()-respawn_place
	local range=lenght:Length()
	local castTime=(range-24)/3000+1
	local ability_name = "windrunner_powershot"
	local caster_name = "npc_dota_hero_windrunner"
	casterAbilityPosition(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionChecker(ability_name,hero,castDelay,castTime)
	return castTime
end
function huskarUlt(hero,castDelay,deathDelay)
	EVASION_TYPE=4
	local respawn_place = randomRingPosition(300,525,hero)
	local lenght=hero:GetAbsOrigin()-respawn_place
	local range=lenght:Length()
	local castpoint=0.3
	local castTime=(range-48)/1000+castpoint
	local ability_name = "huskar_life_break"
	local caster_name = "npc_dota_hero_huskar"
	casterAbilityTarget(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionCheckerTarget(ability_name,hero,castDelay,castTime,castpoint)
	return castTime
end
function gyroMissle(hero,castDelay,deathDelay)
	EVASION_TYPE=4
	local respawn_place = randomRingPosition(500,1000,hero)
	local lenght=hero:GetAbsOrigin()-respawn_place
	local range=lenght:Length()-174
	local speed=340
	local castpoint=0.3
	local castTime=2+castpoint
	while range>0 do
		if range>speed*0.05 then
			range=range-speed*0.05
			castTime=castTime+0.05
			speed=speed+1
		else
			speed=speed+1
			castTime=castTime+range/speed
			range=0
		end
	end
	local ability_name = "gyrocopter_homing_missile"
	local caster_name = "npc_dota_hero_gyrocopter"
	casterAbilityTarget(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionCheckerStun(ability_name,hero,castDelay,castTime)
	return castTime
end
function tinyToss(hero,castDelay,deathDelay)
	EVASION_TYPE=4
	local respawn_place = randomRingPosition(500,1200,hero)
	local lenght=hero:GetAbsOrigin()-respawn_place
	local range=lenght:Length()
	local castTime=1.3
	local ability_name = "tiny_toss"
	local caster_name = "npc_dota_hero_tiny"
	local wisp_name="npc_dota_hero_wisp"
	local faggot = CreateUnitByNameAsync(caster_name, respawn_place, true, nil, nil, DOTA_TEAM_BADGUYS, function(unit)
		--unit:AddAbility(abilityName)
		unit:SetMoveCapability(1)
		unit:SetForwardVector((hero:GetOrigin() - respawn_place):Normalized())
		unit:SetIdleAcquire(false)

		local wisp = CreateUnitByName(wisp_name,respawn_place+Vector(100,0,0),true,nil,nil,DOTA_TEAM_BADGUYS)
		wisp:SetIdleAcquire(false)
		wisp:SetMoveCapability(1)
		local ability = unit:FindAbilityByName(ability_name)
		ability:SetLevel(1)
		CustomGameEventManager:Send_ServerToAllClients("spell_casted",{castpoint=castTime, delay=castDelay, abil=ability_name})
		unit:SetContextThink(DoUniqueString("cast_ability"),
		function()

			unit:CastAbilityOnTarget(hero,ability,-1)
			unit:SetIdleAcquire(false)
			Timers:CreateTimer({
			    useGameTime = false,
			    endTime = 0.5, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
			    callback = function()
			    	unit:CastAbilityOnTarget(hero,ability,-1)
			    	unit:SetIdleAcquire(false)
			    end
			  })
		end,
		castDelay) 
		unit:SetContextThink(DoUniqueString("Remove_Self"),function()  unit:RemoveSelf();wisp:RemoveSelf() end, castDelay+deathDelay+castTime)
		return unit
    end)
	evasionCheckerTarget(ability_name,hero,castDelay,castTime,0)
	return castTime
end
function phoenixNova(hero,castDelay,deathDelay)
	EVASION_TYPE=2
	local castTime=6.01
	local respawn_place = randomRingPosition(200,900,hero)
	local ability_name = "phoenix_supernova"
	local caster_name = "npc_dota_hero_phoenix"
	casterAbilityNotarget(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionCheckerStun(ability_name,hero,castDelay,castTime)
	return castTime
end
function lcFirstskill(hero,castDelay,deathDelay)
	EVASION_TYPE=1
	local respawn_place = randomRingPosition(400,900,hero)
	local lenght=hero:GetAbsOrigin()-respawn_place
	local range=lenght:Length()
	local castTime=0.3
	local ability_name = "legion_commander_overwhelming_odds"
	local caster_name = "npc_dota_hero_legion_commander"
	casterAbilityPosition(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionChecker(ability_name,hero,castDelay,castTime)
	return castTime
end
function magnusRp(hero,castDelay,deathDelay)
	EVASION_TYPE=1
	local castTime=0.3
	local respawn_place = randomRingPosition(50,400,hero)
	local ability_name = "magnataur_reverse_polarity"
	local caster_name = "npc_dota_hero_magnataur"
	casterAbilityNotarget(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionCheckerStun(ability_name,hero,castDelay,castTime)
	return castTime
end
function slardarStun(hero,castDelay,deathDelay)
	EVASION_TYPE=1
	local castTime=0.35
	local respawn_place = randomRingPosition(50,300,hero)
	local ability_name = "slardar_slithereen_crush"
	local caster_name = "npc_dota_hero_slardar"
	casterAbilityNotarget(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionCheckerStun(ability_name,hero,castDelay,castTime)
	return castTime
end
function axeAgro(hero,castDelay,deathDelay)
	EVASION_TYPE=2
	local castTime=0.4
	local respawn_place = randomRingPosition(90,275,hero)
	local ability_name = "axe_berserkers_call"
	local caster_name = "npc_dota_hero_axe"
	local modifier_name="modifier_axe_berserkers_call"
	casterAbilityNotarget(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionCheckerDebuff(ability_name,hero,castDelay,castTime,modifier_name)
	return castTime
end
function brewClap(hero,castDelay,deathDelay)
	EVASION_TYPE=1
	local castTime=0.4
	local respawn_place = randomRingPosition(90,375,hero)
	local ability_name = "brewmaster_thunder_clap"
	local caster_name = "npc_dota_hero_brewmaster"
	casterAbilityNotarget(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionChecker(ability_name,hero,castDelay,castTime)
	return castTime
end
function centStun(hero,castDelay,deathDelay)
	EVASION_TYPE=1
	local castTime=0.5
	local respawn_place = randomRingPosition(50,300,hero)
	local ability_name = "centaur_hoof_stomp"
	local caster_name = "npc_dota_hero_centaur"
	casterAbilityNotarget(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionCheckerStun(ability_name,hero,castDelay,castTime)
	return castTime
end
function lionUlt(hero,castDelay,deathDelay)
	EVASION_TYPE=3
	local respawn_place = randomRingPosition(300,875,hero)
	local lenght=hero:GetAbsOrigin()-respawn_place
	local range=lenght:Length()
	local castpoint=0.3
	local castTime=0.25+castpoint
	local ability_name = "lion_finger_of_death"
	local caster_name = "npc_dota_hero_lion"
	casterAbilityTarget(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionCheckerTarget(ability_name,hero,castDelay,castTime,castpoint)
	return castTime
end
function qopScream(hero,castDelay,deathDelay)
	EVASION_TYPE=5
	local respawn_place = randomRingPosition(300,450,hero)
	local lenght=hero:GetAbsOrigin()-respawn_place
	local range=lenght:Length()
	local castTime=(range-48)/900
	local ability_name = "queenofpain_scream_of_pain"
	local caster_name = "npc_dota_hero_queenofpain"
	casterAbilityNotarget(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionChecker(ability_name,hero,castDelay,castTime)
	return castTime
end

function wwBlast(hero,castDelay,deathDelay)
	local respawn_creep = randomRingPosition(300,490,hero)
	local respawn_caster = randomRingPositionVec(300,1000,respawn_creep)
	
	local heroCreepV=hero:GetAbsOrigin()-respawn_creep
	local creepCasterV=respawn_creep-respawn_caster
	local creepCasterL=creepCasterV:Length()-40
	local heroCreepL=heroCreepV:Length()-40
	local initialTime=1
	if creepCasterL<650 then
		initialTime=creepCasterL/650
	end
	local castTime=(initialTime+(heroCreepL)/650)+0.3
	local ability_name = "winter_wyvern_splinter_blast"
	local caster_name = "npc_dota_hero_winter_wyvern"
	local creep_name="npc_dota_creep_goodguys_melee"
	local faggot = CreateUnitByNameAsync(caster_name, respawn_caster, true, nil, nil, DOTA_TEAM_BADGUYS, function(unit)
		--unit:AddAbility(abilityName)
		unit:SetMoveCapability(1)
		unit:SetForwardVector((respawn_creep - respawn_caster):Normalized())
		unit:SetIdleAcquire(false)
		local ability = unit:FindAbilityByName(ability_name)
		ability:SetLevel(1)
		local creep = CreateUnitByName(creep_name,respawn_creep,true,nil,nil,hero:GetTeamNumber())
		creep:SetIdleAcquire(false)
		creep:SetMoveCapability(0)
		CustomGameEventManager:Send_ServerToAllClients("spell_casted",{castpoint=castTime, delay=castDelay, abil=ability_name})
		unit:SetContextThink(DoUniqueString("cast_ability"),
		function()

			unit:CastAbilityOnTarget(creep,ability,-1)
			unit:SetIdleAcquire(false)
		end,
		castDelay) 
		unit:SetContextThink(DoUniqueString("Remove_Self"),function()  unit:RemoveSelf();creep:RemoveSelf() end, castDelay+deathDelay+castTime)
		return unit
    end)
	evasionChecker(ability_name,hero,castDelay,castTime)
	return castTime
end
function familiarStun(hero,castDelay,deathDelay)
	EVASION_TYPE=1
	local castTime=0.55
	local respawn_place = randomRingPosition(50,300,hero)
	local ability_name = "visage_summon_familiars_stone_form"
	local caster_name = "npc_dota_visage_familiar1"
	casterAbilityNotarget(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionCheckerStun(ability_name,hero,castDelay,castTime)
	return castTime
end
function neutralUrsaClap(hero,castDelay,deathDelay)
	EVASION_TYPE=1
	local castTime=0.5
	local respawn_place = randomRingPosition(50,275,hero)
	local ability_name = "polar_furbolg_ursa_warrior_thunder_clap"
	local caster_name = "npc_dota_neutral_polar_furbolg_ursa_warrior"
	local modifier_name="modifier_polar_furbolg_ursa_warrior_thunder_clap"
	casterAbilityNotarget(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionCheckerDebuff(ability_name,hero,castDelay,castTime,modifier_name)
	return castTime
end
function forestCentStun(hero,castDelay,deathDelay)
	EVASION_TYPE=1
	local castTime=0.5
	local respawn_place = randomRingPosition(50,225,hero)
	local ability_name = "centaur_khan_war_stomp"
	local caster_name = "npc_dota_neutral_centaur_khan"
	casterAbilityNotarget(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionCheckerStun(ability_name,hero,castDelay,castTime)
	return castTime
end

function monkeyTreeJump(hero,castDelay,deathDelay)
	EVASION_TYPE=5
	local ability_name1 = "monkey_king_tree_dance"
	local ability_name2 = "monkey_king_primal_spring"
	local caster_name = "npc_dota_hero_monkey_king"
	local tree_respawn_place = randomRingPosition(300,990,hero)
	local lenght=hero:GetAbsOrigin()-tree_respawn_place
	local range=lenght:Length()
	local castTime=1.6+(range/1300)
	CreateTempTree(tree_respawn_place,castDelay+deathDelay+castTime)
	local trees=GridNav:GetAllTreesAroundPoint(tree_respawn_place,200,true)
	local faggot = CreateUnitByNameAsync(caster_name, tree_respawn_place+Vector(50,0,0), true, nil, nil, DOTA_TEAM_BADGUYS, function(unit)
		--unit:AddAbility(abilityName)
		unit:SetMoveCapability(1)
		unit:SetForwardVector((hero:GetOrigin() - tree_respawn_place+Vector(50,0,0)):Normalized())
		unit:SetIdleAcquire(false)
		local ability1 = unit:FindAbilityByName(ability_name1)
		ability1:SetLevel(1)
		local ability2 = unit:FindAbilityByName(ability_name2)
		ability2:SetLevel(1)
		unit:SetContextThink(DoUniqueString("cast_ability"),
		function()
			unit:CastAbilityOnTarget(trees[1],ability1,-1)
			unit:SetIdleAcquire(false)
			CustomGameEventManager:Send_ServerToAllClients("spell_casted",{castpoint=castTime, delay=castDelay, abil=ability_name2})
			unit:SetContextThink(DoUniqueString("cast_ability2"),
			function()
				unit:CastAbilityOnPosition(hero:GetOrigin(),ability2,-1)
				unit:SetIdleAcquire(false)
			end,
			castDelay) 
		end,
		0) 
		unit:SetContextThink(DoUniqueString("Remove_Self"),function()  unit:RemoveSelf() end, castDelay+deathDelay+castTime)
		return unit
    end)
	evasionChecker(ability_name2,hero,castDelay,castTime)
	return castTime
end
function monkeyBarHit(hero,castDelay,deathDelay)
	EVASION_TYPE=1
	local castTime=0.4
	local respawn_place = randomRingPosition(300,1100,hero)
	local ability_name = "monkey_king_boundless_strike"
	local caster_name = "npc_dota_hero_monkey_king"
	casterAbilityPosition(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionChecker(ability_name,hero,castDelay,castTime)
	return castTime
end

function techiesSuicide(hero,castDelay,deathDelay)
	EVASION_TYPE=5
	local castTime=1.75
	local respawn_place = randomRingPosition(300,900,hero)
	local ability_name = "techies_suicide"
	local caster_name = "npc_dota_hero_techies"
	casterAbilityPosition(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionChecker(ability_name,hero,castDelay,castTime)
	return castTime
end

function ProwlerStun(hero,castDelay,deathDelay)
	EVASION_TYPE=1
	local castTime=0.9
	local respawn_place = randomRingPosition(50,225,hero)
	local ability_name = "spawnlord_master_stomp"
	local caster_name = "npc_dota_neutral_prowler_shaman"
	casterAbilityNotarget(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionChecker(ability_name,hero,castDelay,castTime)
	return castTime
end

function odAstral(hero,castDelay,deathDelay)
	EVASION_TYPE=1
	local castTime=0.25+4
	local respawn_place = randomRingPosition(50,200,hero)
	local ability_name = "obsidian_destroyer_astral_imprisonment"
	local caster_name = "npc_dota_hero_obsidian_destroyer"
	casterAbilitySelf(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionChecker(ability_name,hero,castDelay,castTime)
	return castTime
end
function roshanClap(hero,castDelay,deathDelay)
	EVASION_TYPE=1
	local castTime=0.47
	local respawn_place = randomRingPosition(80,300,hero)
	local ability_name = "roshan_slam"
	local caster_name = "npc_dota_roshan"
	casterAbilityNotarget(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionChecker(ability_name,hero,castDelay,castTime)
	return castTime
end
function invokerSunStrike(hero,castDelay,deathDelay)
	EVASION_TYPE=1
	local castTime=1.75
	local respawn_place = randomRingPosition(300,900,hero)
	local ability_name = "invoker_sun_strike"
	local invoke_name="invoker_invoke"
	local exort_name="invoker_exort"
	local caster_name = "npc_dota_hero_invoker"
	local faggot = CreateUnitByNameAsync(caster_name, respawn_place, true, nil, nil, DOTA_TEAM_BADGUYS, function(unit)		
		unit:SetForwardVector((hero:GetOrigin() - respawn_place):Normalized())
		unit:SetIdleAcquire(false)
		local invoke = unit:FindAbilityByName(invoke_name)
		invoke:SetLevel(1)
		local exort=unit:FindAbilityByName(exort_name)
		exort:SetLevel(3)
		CustomGameEventManager:Send_ServerToAllClients("spell_casted",{castpoint=castTime, delay=castDelay, abil=ability_name})
		unit:SetContextThink(DoUniqueString("cast_ability"),
		function()
			unit:CastAbilityNoTarget(exort,-1)
			unit:CastAbilityNoTarget(exort,-1)
			unit:CastAbilityNoTarget(exort,-1)
			unit:CastAbilityNoTarget(invoke,-1)
			local ability=unit:FindAbilityByName(ability_name)
			unit:CastAbilityOnPosition(hero:GetOrigin(),ability,-1)
			unit:SetIdleAcquire(false)
		end,
		castDelay) 
		unit:SetContextThink(DoUniqueString("Remove_Self"),function()  unit:RemoveSelf() end, castDelay+deathDelay+castTime)
		return unit
    end)
	evasionChecker(ability_name,hero,castDelay,castTime)
	return castTime
end
function kunkkaTorrent(hero,castDelay,deathDelay)
	EVASION_TYPE=5
	local castTime=2
	local respawn_place = randomRingPosition(300,900,hero)
	local ability_name = "kunkka_torrent"
	local caster_name = "npc_dota_hero_kunkka"
	casterAbilityPosition(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay,4)
	evasionChecker(ability_name,hero,castDelay,castTime+1.5)
	return castTime
end
function kunkkaTidebringer(hero,castDelay,deathDelay)
	EVASION_TYPE=5
	local castTime=0
	local respawn_place = randomRingPosition(300,900,hero)
	local ability_name = "kunkka_tidebringer"
	local caster_name = "npc_dota_hero_kunkka"
	local faggot = CreateUnitByNameAsync(caster_name, respawn_place, true, nil, nil, DOTA_TEAM_BADGUYS, function(unit)
		--unit:AddAbility(abilityName)
		unit:SetMoveCapability(1)
		unit:SetAttackCapability(1)
		unit:SetForwardVector((hero:GetOrigin() - respawn_place):Normalized())
		unit:SetIdleAcquire(false)
		local ability = unit:FindAbilityByName(ability_name)
		ability:SetLevel(4)
		local direction = (hero:GetAbsOrigin()-respawn_place):Normalized()
		local target_point_vector = respawn_place + 50 * direction
		local target="npc_dota_creep_goodguys_melee"
		local pizduk2=CreateUnitByName(target, target_point_vector, true, nil, nil, hero:GetTeam())
		pizduk2:SetIdleAcquire(false)
		castTime=unit:GetAttackAnimationPoint()
		CustomGameEventManager:Send_ServerToAllClients("spell_casted",{castpoint=castTime, delay=castDelay, abil=ability_name})
		unit:SetContextThink(DoUniqueString("cast_ability"),
		function()
			unit:CastAbilityOnTarget(pizduk2,ability,-1)
			unit:SetIdleAcquire(false)
		end,
		castDelay) 
		unit:SetContextThink(DoUniqueString("Remove_Self"),function()  unit:RemoveSelf();pizduk2:RemoveSelf() end, castDelay+deathDelay+castTime)
		return unit
    end)

	evasionChecker(ability_name,hero,castDelay,castTime+0.3)
	return castTime
end
function elderUlt(hero,castDelay,deathDelay)
	EVASION_TYPE=5
	local castTime=3.54
	local respawn_place = randomRingPosition(300,900,hero)
	local ability_name = "elder_titan_earth_splitter"
	local caster_name = "npc_dota_hero_elder_titan"
	casterAbilityPosition(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay+1.5)
	evasionChecker(ability_name,hero,castDelay,castTime)
	return castTime
end
function leshracStun(hero,castDelay,deathDelay)
	EVASION_TYPE=5
	local castTime=1.05
	local respawn_place = randomRingPosition(300,650,hero)
	local ability_name = "leshrac_split_earth"
	local caster_name = "npc_dota_hero_leshrac"
	casterAbilityPosition(hero,ability_name,caster_name,respawn_place,castTime,castDelay,deathDelay)
	evasionChecker(ability_name,hero,castDelay,castTime)
	return castTime
end

function castSpellById(id,hero,castDelay,deathDelay)
	--ID=1-46
	local castTime
	if id==1 then
		castTime=linaLightStrike(hero,castDelay,deathDelay)
	elseif id==2 then
		castTime=kunkkaGhostship(hero,castDelay,deathDelay)
	elseif id==3 then
		castTime=linaLaguna(hero,castDelay,deathDelay)
	elseif id==4 then
		castTime=bseekerBloodBath(hero,castDelay,deathDelay)
	elseif id==5 then
		castTime=pugnaNetherBlast(hero,castDelay,deathDelay)
	elseif id==6 then
		castTime=meepoPoof(hero,castDelay,deathDelay)
	elseif id==7 then
		castTime=necroPulse(hero,castDelay,deathDelay)
	elseif id==8 then
		castTime=miranaStarfall(hero,castDelay,deathDelay)
	elseif id==9 then
		castTime=sfCoil(hero,castDelay,deathDelay,1)
	elseif id==10 then
		castTime=sfCoil(hero,castDelay,deathDelay,2)
	elseif id==11 then
		castTime=sfCoil(hero,castDelay,deathDelay,3)
	elseif id==12 then
		castTime=zeusBolt(hero,castDelay,deathDelay)
	elseif id==13 then
		castTime=zeusUlt(hero,castDelay,deathDelay)
	elseif id==14 then
		castTime=tideSmash(hero,castDelay,deathDelay)
	elseif id==15 then
		castTime=ursaSmash(hero,castDelay,deathDelay)
	elseif id==16 then
		castTime=omnikHeal(hero,castDelay,deathDelay)
	elseif id==17 then
		castTime=alcheBanka(hero,castDelay,deathDelay)
	elseif id==18 then
		castTime=skymageBolt(hero,castDelay,deathDelay)
	elseif id==19 then
		castTime=medusaSnake(hero,castDelay,deathDelay)
	elseif id==20 then
		castTime=medusaUlt(hero,castDelay,deathDelay,1)
	elseif id==21 then
		castTime=techiesSuicide(hero,castDelay,deathDelay)
	elseif id==22 then
		castTime=monkeyBarHit(hero,castDelay,deathDelay)
	elseif id==23 then
		castTime=sdUlt(hero,castDelay,deathDelay)
	elseif id==24 then
		castTime=shakerFisssure(hero,castDelay,deathDelay)
	elseif id==25 then
		castTime=shakerTotem(hero,castDelay,deathDelay)
	elseif id==26 then
		castTime=shakerTotem(hero,castDelay,deathDelay,1)
	elseif id==27 then
		castTime=invokerEmp(hero,castDelay,deathDelay)
	elseif id==28 then
		castTime=odUlt(hero,castDelay,deathDelay)
	elseif id==29 then
		castTime=zombieDecay(hero,castDelay,deathDelay)
	elseif id==30 then
		castTime=titanStomp(hero,castDelay,deathDelay)
	elseif id==31 then
		castTime=clockRocket(hero,castDelay,deathDelay)
	elseif id==32 then
		castTime=clockHook(hero,castDelay,deathDelay,1)
	elseif id==33 then
		castTime=clockHook(hero,castDelay,deathDelay,2)
	elseif id==34 then
		castTime=clockHook(hero,castDelay,deathDelay,3)
	elseif id==35 then
		castTime=wrPowershot(hero,castDelay,deathDelay)
	elseif id==36 then
		castTime=huskarUlt(hero,castDelay,deathDelay)
	elseif id==37 then
		castTime=gyroMissle(hero,castDelay,deathDelay)
	elseif id==38 then
		castTime=tinyToss(hero,castDelay,deathDelay)
	elseif id==39 then
		castTime=phoenixNova(hero,castDelay,deathDelay)
	elseif id==40 then
		castTime=lcFirstskill(hero,castDelay,deathDelay)
	elseif id==41 then
		castTime=magnusRp(hero,castDelay,deathDelay)
	elseif id==42 then
		castTime=slardarStun(hero,castDelay,deathDelay)
	elseif id==43 then
		castTime=axeAgro(hero,castDelay,deathDelay)
	elseif id==44 then
		castTime=brewClap(hero,castDelay,deathDelay)
	elseif id==45 then
		castTime=centStun(hero,castDelay,deathDelay)
	elseif id==46 then
		castTime=lionUlt(hero,castDelay,deathDelay)
	elseif id==47 then
		castTime=qopScream(hero,castDelay,deathDelay)
	elseif id==48 then
		castTime=monkeyTreeJump(hero,castDelay,deathDelay)
	elseif id==49 then
		castTime=familiarStun(hero,castDelay,deathDelay)
	elseif id==50 then
		castTime=neutralUrsaClap(hero,castDelay,deathDelay)
	elseif id==51 then
		castTime=forestCentStun(hero,castDelay,deathDelay)
	elseif id==52 then
		castTime=ProwlerStun(hero,castDelay,deathDelay)
	elseif id==53 then
		castTime=odAstral(hero,castDelay,deathDelay)
	elseif id==54 then
		castTime=roshanClap(hero,castDelay,deathDelay)
	elseif id==55 then
		castTime=medusaUlt(hero,castDelay,deathDelay,2)
	elseif id==56 then
		castTime=medusaUlt(hero,castDelay,deathDelay,3)
	elseif id==57 then
		castTime=invokerSunStrike(hero,castDelay,deathDelay)
	elseif id==58 then
		castTime=kunkkaTorrent(hero,castDelay,deathDelay)
	elseif id==59 then
		castTime=kunkkaTidebringer(hero,castDelay,deathDelay)
	elseif id==60 then
		castTime=elderUlt(hero,castDelay,deathDelay)
	elseif id==61 then
		castTime=leshracStun(hero,castDelay,deathDelay)
	elseif id==62 then
		castTime=nil
	end

	return castTime
end

--ПОЧЕМУТО С ДЕЛЕЕМ В 2 НИХУЯ НЕ ПРАВИЛЬНО РАБОТАЕТ ПОЛОСА, ЗАДУМАЙСЯ
--с дестаймом <2 игра крашится, не задумывайся
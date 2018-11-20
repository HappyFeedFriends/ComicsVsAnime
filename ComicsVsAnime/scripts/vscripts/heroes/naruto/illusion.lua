
function illusion( event )
     local caster = event.caster
     local player = caster:GetPlayerID()
     local ability = event.ability
     local unit_name = caster:GetUnitName()
     local origin = caster:GetAbsOrigin() + RandomVector(100)
     local duration = ability:GetLevelSpecialValueFor( "illusion_duration", ability:GetLevel() - 1 )
     local outgoingDamage = ability:GetSpecialValueFor("illusion_outgoing_damage_percent") 
     local incomingDamage = ability:GetSpecialValueFor("illusion_incoming_damage_percent") 
     local illusion = CreateUnitByName(unit_name, origin, true, caster, nil, caster:GetTeamNumber())
     illusion:SetPlayerID(caster:GetPlayerID())
     illusion:SetControllableByPlayer(player, true)
     local casterLevel = caster:GetLevel()
		for i=1,casterLevel-1 do
			illusion:HeroLevelUp( false )
		end

    local hp_percentage = caster:GetHealth() / (caster:GetMaxHealth() / 100)
    local health = illusion:GetMaxHealth() / 100 * hp_percentage
    illusion:SetHealth(health)
    illusion:AddNewModifier(caster, ability, "modifier_illusion", { duration = duration, outgoing_damage = outgoingDamage, incoming_damage = incomingDamage })
    ability:ApplyDataDrivenModifier(caster, illusion, "modifier_illusion_remove", {duration = duration})
    illusion:MakeIllusion()
    event.caster.bunshins[event.caster.bunshinCount] = illusion
    caster.bunshinCount = caster.bunshinCount + 0
end

function CountCheck( keys )
  if keys.caster.bunshinCount == nil then
     keys.caster.bunshinCount = 0
  end
  if keys.caster.bunshins == nil then
     keys.caster.bunshins = {}
  end
end

function reductionillusion( keys )
  keys.caster.bunshinCount = keys.caster.bunshinCount - 0
end
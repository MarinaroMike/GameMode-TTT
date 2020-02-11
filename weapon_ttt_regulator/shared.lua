if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "pistol"

if CLIENT then

   SWEP.PrintName = "Regulator"			
   SWEP.Slot = 1

   SWEP.Icon = "VGUI/ttt/icon_regulator"

     SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "While the Regulator is deployed all unarmed players\n gain 1hp/second to a max of 115.\n\nThe Regulator gains 5 bonus dmg for each\n unarmed player.\n\n Damage = 30 +(7*#holstered players)"
   };
end


SWEP.Base = "weapon_tttbase"

SWEP.Kind = WEAPON_PISTOL
SWEP.WeaponID = AMMO_REG

SWEP.CanBuy = {ROLE_DETECTIVE}
local dmggun = 0
local powernum = 0

SWEP.Primary.Ammo       = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil			= 4
SWEP.Primary.Damage = 30
SWEP.Primary.Delay = 0.4
SWEP.Primary.Cone = 0.01
SWEP.Primary.ClipSize = 6
SWEP.Primary.ClipMax = 36
SWEP.Primary.DefaultClip = 36
SWEP.Primary.Automatic = true

SWEP.AmmoEnt = "item_ammo_revolver_ttt"
SWEP.Primary.Sound			= Sound("Remington.single")	

SWEP.AutoSpawnable = false
--SWEP.AmmoEnt = "item_ammo_smg1_ttt"

SWEP.ViewModel				= "models/weapons/v_pist_re1858.mdl"	
SWEP.WorldModel				= "models/weapons/w_remington_1858.mdl"	-- Weapon world model


SWEP.HeadshotMultiplier = 2
SWEP.IronSightsPos = Vector(2.7, 0, 1.72)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.SightsPos = Vector(5.44, 0, 1.72)
SWEP.SightsAng = Vector(0, 0, 0)


SWEP.DeploySpeed = 1


local powernumex = 0
function SWEP:Deploy()      --On taking out weapon
	local ply = self.Owner	--setting ply to the player with the gun
   if SERVER and IsValid(self.Owner) and (ply:GetActiveWeapon():GetClass() == "weapon_ttt_regulator") then	-- if the server is running and the player is currently holding the gun
	for k, v in pairs(player.GetAll()) do
	v:PrintMessage(HUD_PRINTTALK, "Holster to gain health and empower your Detective.")
	end
	
	timer.Create("regulation", 1,0, function() --loop running every second

	for k, v in pairs(player.GetAll()) do		-- for all players, v is each player as they are selected
		powernumex = 0							--an iterated value
	
		--Healing a player and counting them
	if v:GetActiveWeapon():GetClass() == "weapon_ttt_unarmed" and (v:Health() < 115) and (v:Health() > 0) and (ply:GetActiveWeapon():GetClass() == "weapon_ttt_regulator") then
		v:SetHealth(v:Health()+1)
		powernumex = powernumex+1
		--Not healing but counting a player
	elseif v:GetActiveWeapon():GetClass() == "weapon_ttt_unarmed" and (v:Health() >= 115) and (v:Health() > 0) and (ply:GetActiveWeapon():GetClass() == "weapon_ttt_regulator") then --a player is unarmed and is getting healed
		powernumex = powernumex+1
	--elseif not (ply:GetActiveWeapon():GetClass() == "weapon_ttt_regulator") then
		--timer.Stop("regulation")	--kill the loop because the gun has been put away
     end
end
		powernum = powernumex
		dmggun = (10*powernumex +30)
	--	if powernum != powernumex then 
	--	ply:PrintMessage(HUD_PRINTTALK, "+".. 5*powernum .." dmg")
	--	end
end)
end
return	--return normal deploy functions, ie quickswap
end


function SWEP:ShootBullet( dmg, recoil, numbul, cone )
   local sights = self:GetIronsights()

   numbul = numbul or 1
   cone   = cone   or 0.01

   -- 10% accuracy bonus when sighting
   cone = sights and (cone * 0.7) or cone

   local bullet = {}
   bullet.Num    = numbul
   bullet.Src    = self.Owner:GetShootPos()
   bullet.Dir    = self.Owner:GetAimVector()
   bullet.Spread = Vector( cone, cone, 0 )
   bullet.Tracer = 4
   bullet.Force  = 5
   bullet.Damage = dmggun

   bullet.Callback = function(att, tr, dmginfo)
                        if SERVER or (CLIENT and IsFirstTimePredicted()) then
                           local ent = tr.Entity
                           if (not tr.HitWorld) and IsValid(ent) then
                              local edata = EffectData()

                              edata:SetEntity(ent)
                              edata:SetMagnitude(3)
                              edata:SetScale(2)

                              util.Effect("TeslaHitBoxes", edata)

                              if SERVER and ent:IsPlayer() then
                                 local eyeang = ent:EyeAngles()

                                 local j = 10
                                 eyeang.pitch = math.Clamp(eyeang.pitch + math.Rand(-j, j), -90, 90)
                                 eyeang.yaw = math.Clamp(eyeang.yaw + math.Rand(-j, j), -90, 90)
                                 ent:SetEyeAngles(eyeang)
                              end
                           end
                        end
                     end


   self.Owner:FireBullets( bullet )
   self.Weapon:SendWeaponAnim(self.PrimaryAnim)

   -- Owner can die after firebullets, giving an error at muzzleflash
   if not IsValid(self.Owner) or not self.Owner:Alive() then return end

   self.Owner:MuzzleFlash()
   self.Owner:SetAnimation( PLAYER_ATTACK1 )

   if self.Owner:IsNPC() then return end

   if ((game.SinglePlayer() and SERVER) or
       ((not game.SinglePlayer()) and CLIENT and IsFirstTimePredicted() )) then

      -- reduce recoil if ironsighting
      recoil = sights and (recoil * 0.75) or recoil

      local eyeang = self.Owner:EyeAngles()
      eyeang.pitch = eyeang.pitch - recoil
      self.Owner:SetEyeAngles( eyeang )

   end
end

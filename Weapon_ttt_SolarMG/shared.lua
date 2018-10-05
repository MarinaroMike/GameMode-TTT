if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "ar2"

SWEP.Author = "Dagon Mike"

if CLIENT then

   SWEP.PrintName = "SolarMG"			
   SWEP.Slot = 2

   SWEP.Icon = "VGUI/ttt/icon_mac"
end

SWEP.Base = "weapon_tttbase"

SWEP.Kind = WEAPON_HEAVY
SWEP.WeaponID = AMMO_SOLAR

SWEP.Primary.Damage      = 6
SWEP.Primary.Delay       = 0.06
SWEP.Primary.Cone        = 0.03
SWEP.Primary.ClipSize    = 80
SWEP.Primary.ClipMax     = 80
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Automatic   = true
SWEP.Primary.Recoil      = 1.0
SWEP.Primary.Sound			= Sound( "Weapon_P90.Single" )

SWEP.AutoSpawnable = true

SWEP.ViewModel  = "models/weapons/v_smg_p90.mdl"
SWEP.WorldModel = "models/weapons/w_smg_p90.mdl"


SWEP.HeadshotMultiplier = 1.6
SWEP.IronSightsPos = Vector(2.014, -1.216, 2.135)
SWEP.IronSightsAng = Vector(0, 0, 0)


SWEP.DeploySpeed = 1

function SWEP:Deploy()
	local owner = self.Owner
	if SERVER and IsValid(self.Owner) then
		timer.Create("solarTimer", 1,0, function()
			if (self.Weapon:Clip1() < 80) and owner:GetActiveWeapon():GetClass() == "weapon_ttt_solarmg" then
				self.Weapon:SetClip1( self.Weapon:Clip1() + 3 )
			else
				return
			end
		end)
	end
return
end

	--Drains ammo to heal target player. Cannot heal above 80.
function SWEP:SecondaryAttack()
	if self.Weapon:Clip1() >= 60 then
		local tr = self.Owner:GetEyeTrace(MASK_SHOT)
		local ent = tr.Entity
	if SERVER and ent:IsPlayer() then
		if ent:Health() <= 60 then
			ent:SetHealth( ent:Health() + 20)
			self.Weapon:SetClip1( self.Weapon:Clip1() - 60 )
			self.Owner:EmitSound("items/medshot4.wav")
		elseif ent:Health() > 60 and ent:Health() < 80 then
			ent:SetHealth(80)
			self.Weapon:SetClip1( self.Weapon:Clip1() - 60 )
			self.Owner:EmitSound("items/medshot4.wav")
		elseif ent:Health() > 80 then
			end
		end
	end
end
if SERVER then
	AddCSLuaFile( "shared.lua" )
end
     
SWEP.HoldType           = "smg"
     
SWEP.Author = "Dagon Mike"
	 
if CLIENT then
	SWEP.PrintName          = "T+ Syringe"
	SWEP.Slot               = 7
	
	SWEP.Icon = "VGUI/ttt/icon_syringe"
	SWEP.EquipMenuData = {
		type="Weapon",
		desc="Drain 5HP from yourself to heal your target\nfor 10HP, to a max of 80."
	};
end
	
SWEP.AutoSpawnable      = false
SWEP.CanBuy = {ROLE_TRAITOR}
SWEP.LimitedStock = true

SWEP.Base               = "weapon_tttbase"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV		= 65
SWEP.Kind = WEAPON_EQUIP2
SWEP.WeaponID = AMMO_SYRINGE

SWEP.NoSights = true
SWEP.IsSilent = true

SWEP.Primary.Delay          = 1
SWEP.Primary.Recoil         = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Damage = 0
SWEP.Primary.Cone = 0.01
SWEP.Primary.ClipSize = -1
SWEP.Primary.ClipMax = -1
SWEP.Primary.DefaultClip = -1

SWEP.HeadshotMultiplier = 0

SWEP.AmmoEnt = "nil"
SWEP.ViewModel      = "models/weapons/v_smg1.mdl"
SWEP.WorldModel   = "models/weapons/w_smg1.mdl"
SWEP.Primary.Sound = Sound("WallHealth.Recharge")
  
function SWEP:PrimaryAttack()
	local giverT = self.Owner
	local tr = self.Owner:GetEyeTrace(MASK_SHOT)
	local healedT = tr.Entity
	self.Weapon:SetNextPrimaryFire( CurTime() + 1)
		if IsValid(giverT:GetEyeTrace().Entity) then
			if (giverT:GetEyeTrace().Entity:IsPlayer()) and  (giverT:EyePos() - tr.HitPos):Length() < 200 then
			if (healedT:Health() <= 70) and (giverT:Health()) > 5 then
				self:EmitSound("WallHealth.Recharge")
				healedT:SetHealth( healedT:Health() + 10 )
				giverT:SetHealth( giverT:Health() - 5 )
			end
		end
	end
end
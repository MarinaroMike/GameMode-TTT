


if SERVER then
   AddCSLuaFile( "shared.lua" )  
end

SWEP.HoldType = "camera"

SWEP.Author = "Dagon Mike"

if CLIENT then
   SWEP.PrintName			= "Garrote"
   SWEP.Slot				= 7

   SWEP.ViewModelFOV = 54
   
    SWEP.EquipMenuData = {
		type="Weapon",
		desc="Choke target by holding down Left Click.\n\nChoked players may be heard attempting to breath.\nDisables and damages."
	};
	
	SWEP.Icon = "VGUI/ttt/icon_jr_strangle"   
end

SWEP.Base		= "weapon_tttbase"
SWEP.ViewModel	= "models/weapons/v_knife_t.mdl"
SWEP.WorldModel	= "models/weapons/w_knife_t.mdl"
SWEP.DrawCrosshair	= false
SWEP.ViewModelFlip	= false
SWEP.Primary.Damage	= 2
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic	= true
SWEP.Primary.Delay	= 1.2
SWEP.Primary.Ammo	= "none"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo		= "none"
SWEP.Secondary.Delay	= 1

SWEP.Kind = WEAPON_EQUIP2
SWEP.WeaponID = AMMO_CHOKE

SWEP.CanBuy = {ROLE_TRAITOR}

SWEP.NoSights = true
SWEP.IsSilent = true

SWEP.AutoSpawnable = false

SWEP.Ischokeing = false
SWEP.chokevictim = nil

function SWEP:PrimaryAttack()	--Primary attack freezes target and deals some damage while attack is held.
	local tr = self.Owner:GetEyeTrace(MASK_SHOT)
	if tr.Hit and IsValid(tr.Entity) and tr.Entity:IsPlayer() and (self.Owner:EyePos() - tr.HitPos):Length() < 150 then
		local ply = tr.Entity
		self.Ischokeing = true
		self.chokevictim = ply
		
		self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		
		if SERVER then
			local dmg = DamageInfo()
			dmg:SetAttacker(self.Owner)
			dmg:SetInflictor(self)
			dmg:SetDamage(10)
			dmg:SetDamageType(DMG_GENERIC)
		
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
			ply:EmitSound( "d1_canals.citizenpunch_pain_0")
			ply:PrintMessage(HUD_PRINTCENTER, "YOU ARE BEING CHOKED!")
			ply:TakeDamageInfo(dmg)

		end
	end
end

function SWEP:Think()	--Freeze and unfreeze victim when in range and holding attack.
	local ply = self.chokevictim
	local ent = self.Owner
	if self.Ischokeing and IsValid(self.Owner) then
		ply:Freeze(true)

		if not self.Owner:KeyDown(IN_ATTACK) or (self.Owner:GetLocalPos( )  - ply:GetLocalPos( ) ):Length() > 150 then
			self.Ischokeing = false
			ply:Freeze(false)
			self.chokevictim = nil
			return true
		end
	
	end
end

function SWEP:PreDrop(death_drop)
	self.chokevictim = nil
	ply:Freeze(false)
	self.Ischokeing = false
end

function SWEP:OnRemove()
   self.Ischokeing = false
   self.chokevictim = nil
end

function SWEP:Deploy()
   self.Ischokeing = false
   self.chokevictim = nil
   return true
end

function SWEP:Holster()
   self.chokevictim = nil
   return not self.Ischokeing
end

function SWEP:DrawWorldModel()
end

function SWEP:DrawWorldModelTranslucent()
end
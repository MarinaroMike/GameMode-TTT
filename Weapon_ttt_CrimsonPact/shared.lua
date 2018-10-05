if SERVER then
   AddCSLuaFile( "shared.lua" )
end
   
SWEP.HoldType			= "pistol"

SWEP.Author = "Dagon Mike"

if CLIENT then
   SWEP.PrintName	= "Crimson Pact"			

   SWEP.Slot	= 1
   SWEP.SlotPos	= 1
   
   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "Headshots return 75 Health.\n\n Firing costs 10 Health.\n\n\n\n\nThe Scoop:\nCan not kill you or be fired\nif the health loss would kill you."
   };
 
   SWEP.Icon = "VGUI/ttt/icon_vlad"
end

SWEP.Base				= "weapon_tttbase"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModelFlip = true
SWEP.CanBuy = {ROLE_TRAITOR}
SWEP.Kind = WEAPON_PISTOL
SWEP.WeaponID = AMMO_VLAD

SWEP.DrawAmmo = false

SWEP.Primary.Ammo       = "none"
SWEP.Primary.Recoil		= 6
SWEP.Primary.Damage = 40
SWEP.Primary.Delay 	= 0.6
SWEP.Primary.Cone 	= 0.02
SWEP.Primary.ClipSize 	= 1
SWEP.Primary.DefaultClip 	= 1
SWEP.Primary.ClipMax 		= 1
SWEP.Primary.Automatic = true

SWEP.AutoSpawnable      = false

SWEP.Primary.Sound			= Sound("357magfire.wav")
SWEP.ViewModel             = Model("models/weapons/c_357.mdl")
SWEP.WorldModel            = Model("models/weapons/w_357.mdl")

SWEP.IronSightsPos = Vector(1.35, 0, 1.846)
SWEP.IronSightsAng = Vector(-0.157, 0, 0)
SWEP.SightsPos = Vector(2.773, 0, 0.846)
SWEP.SightsAng = Vector(-0.157, 0, 0)

SWEP.DeploySpeed = 0.6


function SWEP:PrimaryAttack(worldsnd)
	if self.Owner:Health() > 10 then
		self.Owner:SetHealth( self.Owner:Health() - 10 )
	end
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	if not self:CanPrimaryAttack() then return end
	if self.Owner:Health() > 10 then
		self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone() )
		self.Weapon:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
	end

	local owner = self.Owner
	if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end
	owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
end

function SWEP:GetHeadshotMultiplier(victim, dmginfo)
	if self.Owner:Health() >= 5000 then
		self.Owner:SetHealth(5000)
	else
		self.Owner:SetHealth( self.Owner:Health() + 85 )
		if self.Owner:Health() >= 5000 then
			self.Owner:SetHealth( 5000)
		end
		return 6
	end
end

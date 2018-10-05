if SERVER then
	AddCSLuaFile( "shared.lua" )
end
     
SWEP.HoldType           = "knife"
     
SWEP.Author = "Dagon Mike"
	 
if CLIENT then
	SWEP.PrintName          = "Infector Knife"
	SWEP.Slot               = 7
     
	SWEP.Icon = "VGUI/ttt/icon_jr_zombknife"
	SWEP.EquipMenuData = {
	type="Weapon",
	desc="PRIMARY FIRE:\nInfects the target and will cause them, or their corpse\n to explode in 20 seconds.\nCannot be used on Ts.\n\nSECONDARY FIRE:\nInfect yourself.\nAfter laughing maniacally for 2 seconds you will explode!"
	};
end

SWEP.ViewModelFOV	= 54
SWEP.AutoSpawnable      = false
SWEP.CanBuy = {ROLE_TRAITOR}
SWEP.LimitedStock = true
     
SWEP.Base               = "weapon_tttbase"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModelFlip = false
	
SWEP.Kind = WEAPON_EQUIP2
SWEP.WeaponID = AMMO_INFECT
	
SWEP.NoSights = true
SWEP.IsSilent = true

SWEP.Primary.Delay          = 0.1
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
SWEP.ViewModel              = "models/weapons/cstrike/c_knife_t.mdl"
SWEP.WorldModel             = "models/weapons/w_knife_t.mdl"

function SWEP:PrimaryAttack()	--Stab other player with explosion
	if self.Owner.LagCompensation then
		self.Owner:LagCompensation(true)
	end
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.1 )
	local tr = self.Owner:GetEyeTrace(MASK_SHOT)
	local ply = tr.Entity   
	if tr.Hit and IsValid(tr.Entity) and tr.Entity:IsPlayer() and not (ply:GetRole() == ROLE_TRAITOR) and (self.Owner:EyePos() - tr.HitPos):Length() < 200 then            
		self:Remove()																
		timer.Simple(20,function()
			if SERVER then
				local explode = ents.Create( "env_explosion" )
				explode:SetPos( ply:GetPos() )
				explode:Spawn()
				explode:SetKeyValue( "iMagnitude", "350" )
				explode:Fire( "Explode", 0, 0 )
				explode:EmitSound( "siege/big_explosion.wav", 500, 500 )
			end
		end)
	end
end

function SWEP:Initialize()
    util.PrecacheSound("siege/big_explosion.wav")
end
 
function SWEP:Think()  
end
 
function SWEP:SecondaryAttack()		--Target self with explosion.
	local effectdata = EffectData()
	effectdata:SetOrigin( self.Owner:GetPos() )
	effectdata:SetNormal( self.Owner:GetPos() )
	effectdata:SetMagnitude( 8 )
	effectdata:SetScale( 1 )
	effectdata:SetRadius( 16 )
  
	self.Owner:SetPlayerColor(Vector(0, 1, 0))
	self.Owner:SetColor(Color(255,150,150,255))
	self.Owner:EmitSound("ravenholm.madlaugh03")
	if (SERVER) then
		timer.Simple(2, function() self:BOOM() end )
	end 
end
 

function SWEP:BOOM()
	local k, v           
	local ent = ents.Create( "env_explosion" )
	ent:SetPos( self.Owner:GetPos() )
	ent:SetOwner( self.Owner )
	ent:SetKeyValue( "iMagnitude", "350" )
	ent:Spawn()
	ent:Fire( "Explode", 0, 0 )
	ent:EmitSound( "siege/big_explosion.wav", 500, 500 )
	self.Owner:SetColor(Color(255,255,255,255))
	self.Owner:Kill()
	self:Remove()
end

SWEP.AllowDrop = false
 
function SWEP:PreDrop()
	self.Owner:SetColor(Color(255,255,255,255))
end
 
function SWEP:OnRemove()
	self.Owner:SetColor(Color(255,255,255,255))
end
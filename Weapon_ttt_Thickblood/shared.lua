
if SERVER then
   AddCSLuaFile( "shared.lua" ) 
end

SWEP.HoldType = "knife"

SWEP.Author = "Dagon Mike"

if CLIENT then
	SWEP.PrintName = "Thickblood"
	SWEP.Slot = 7
	
	SWEP.EquipMenuData = {
		type = "item_weapon",
		desc = "Gain 1000 health for 10 seconds.\n\nHealth reduced to 1 after duration so keep buying."
	};
	
	SWEP.Icon = "vgui/ttt/icon_drug"
end

SWEP.Base				= "weapon_tttbase"
SWEP.ViewModel             = "models/weapons/v_eq_flashbang.mdl"
SWEP.WorldModel            = "models/weapons/w_eq_flashbang.mdl"
SWEP.ViewModelFOV			= 60
SWEP.DrawCrosshair		= false
SWEP.ViewModelFlip		= false
SWEP.Primary.Damage 	= 0
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Delay 		= 1
SWEP.Primary.Ammo		= "none"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo		= "none"
SWEP.Secondary.Delay = 1

SWEP.Kind = WEAPON_EQUIP2
SWEP.WeaponID = AMMO_DRUG

SWEP.CanBuy = {ROLE_TRAITOR}

SWEP.NoSights = true
SWEP.IsSilent = false

SWEP.AutoSpawnable = false

local sound_single = Sound("Weapon_Crowbar.Single")

function SWEP:PrimaryAttack()
	local ply = self.Owner
	ply:EmitSound("Buttons.snd47")
	ply:SetHealth(1000)
	col = Color(255,0,0,15)
	ply:ScreenFade(2, col, 1 ,9)	--Redden screen to players know when it wears off.
	self:Remove()
	timer.Simple( 10, function()
		ply:SetHealth(1)
	end)
end

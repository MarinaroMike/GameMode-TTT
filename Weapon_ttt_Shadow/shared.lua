if SERVER then
   AddCSLuaFile( "shared.lua" )  
end
 
concommand.Add( "ttt_cloakplayer", cloakPlayer)
concommand.Add( "ttt_uncloakplayer", uncloakPlayer)
   
SWEP.HoldType = "normal"
 
SWEP.Author = "Dagon Mike"
 
if CLIENT then
	SWEP.PrintName    = "Shadow"
	SWEP.Slot         = 6
 
	SWEP.ViewModelFlip = false
 
	SWEP.EquipMenuData = {
		type = "item_weapon",
		desc = "knife_desc"
	};
 
	SWEP.Icon = "VGUI/ttt/icon_cloak"
end
 
SWEP.Base               = "weapon_tttbase"
SWEP.ViewModel          = "models/weapons/v_knife_t.mdl"	--model is invis until dropped.
SWEP.WorldModel         = "models/weapons/w_knife_t.mdl"
SWEP.NoSights 			= true
SWEP.DrawCrosshair      = false
SWEP.Primary.Damage         = 0
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Delay 		= 1
SWEP.Primary.Ammo       = "none"
SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo     = "none"
SWEP.Secondary.Delay 	= 1

SWEP.Kind = WEAPON_EQUIP1
SWEP.CanBuy = {ROLE_TRAITOR}
SWEP.LimitedStock = true
 
SWEP.IsSilent = true

SWEP.DeploySpeed = 2
 
function SWEP:Deploy()
	local ent = self.Owner
	ent:SetColor(Color(255,255,255,10))
	ent:SetRenderMode( RENDERMODE_TRANSALPHA )
	self.Owner:DrawViewModel(false)
   return true
end

function SWEP:Holster()
	local ent = self.Owner
	ent:SetColor(Color(255,255,255,255))
	ent:SetRenderMode( RENDERMODE_NORMAL)		
   return true
end

function cloakPlayer( ply )
	ply:SetColor(Color(255, 255, 255, 10))
	ply:SetRenderMode( RENDERMODE_TRANSALPHA )
end
 
function uncloakPlayer( ply )
	ply:SetColor(Color(255, 255, 255, 255))
	ply:SetRenderMode( RENDERMODE_NORMAL)
end
 

 
function SWEP:PreDrop()
	local ent = self.Owner
	ent:SetColor(Color(255,255,255,255))
	ent:SetRenderMode( RENDERMODE_NORMAL)
	self.fingerprints = {}
end
 
function SWEP:OnRemove()
	local ent = self.Owner
	ent:SetColor(Color(255,255,255,255))
	ent:SetRenderMode( RENDERMODE_NORMAL)
	if CLIENT and ValidEntity(self.Owner) and self.Owner == LocalPlayer() and self.Owner:Alive() then
	RunConsoleCommand("lastinv")
	end
end

function SWEP:DrawWorldModel()
end

function SWEP:DrawWorldModelTranslucent()
end
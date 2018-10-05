if SERVER then
   AddCSLuaFile( "shared.lua" ) 
end
 
SWEP.HoldType = "normal"

SWEP.Author = "Dagon Mike"
 
if CLIENT then
   SWEP.PrintName    = "Explsive Heels"
   SWEP.Slot         = 6
 
   SWEP.ViewModelFlip = false
 
   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "While equipped if you were to take fall damage you\n create a small explosion.\n You will not receive fall or explosive damage\nwhile equipped."
   };
 
   SWEP.Icon = "VGUI/ttt/icon_goomba"
end

SWEP.Base               = "weapon_tttbase"
 
SWEP.ViewModel          = "models/weapons/v_knife_t.mdl"
SWEP.WorldModel         = "models/weapons/w_knife_t.mdl"
SWEP.NoSights = true
SWEP.DrawCrosshair      = false
SWEP.Primary.Damage         = 0
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Delay = 1
SWEP.Primary.Ammo       = "none"
SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo     = "none"
SWEP.Secondary.Delay = 1

SWEP.Kind = WEAPON_EQUIP1
SWEP.CanBuy = {ROLE_TRAITOR}
SWEP.LimitedStock = true
 
SWEP.IsSilent = true
 

SWEP.DeploySpeed = 2


local function RemoveFallDamage(target, dmginfo)
	if target:IsPlayer() and target.ShouldRemoveFallDamage then
		if dmginfo:IsFallDamage() then
			local explode = ents.Create( "env_explosion" )
			explode:SetPos( target:GetPos() )
			explode:SetOwner( target )
			explode:Spawn()
			explode:SetKeyValue( "iMagnitude", "100" )
			explode:Fire( "Explode", 0, 0 )
			explode:EmitSound( "weapon_AWP.Single", 400, 400 )
		end
		if dmginfo:IsFallDamage() or dmginfo:IsExplosionDamage() then
			dmginfo:SetDamage(0)		
		end
	end
end
 
hook.Add("EntityTakeDamage", "RemoveFallDamage", RemoveFallDamage)


function SWEP:Deploy()
	if SERVER and IsValid(self.Owner) then
      self.Owner:DrawViewModel(false)
	end
	self.Owner.ShouldRemoveFallDamage = true
	return true
end

function SWEP:Holster()
	self.Owner.ShouldRemoveFallDamage = false	
   return true
end
 
function SWEP:PreDrop()
	self.Owner.ShouldRemoveFallDamage = false	
end
 
function SWEP:OnRemove()
	self.Owner.ShouldRemoveFallDamage = false	
end

function SWEP:DrawWorldModel()
end

function SWEP:DrawWorldModelTranslucent()
end


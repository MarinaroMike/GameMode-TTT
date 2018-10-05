
if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "magic"

SWEP.Author = "Dagon Mike"

if CLIENT then
   SWEP.PrintName = "Hand of the D"
   SWEP.Slot = 7

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "PRIMARY ATTACK:/nSet all players' healths to 100./nIncludes Traitors./n/nSECONDARY ATTACK:/n Freeze all players for 15 seconds./n/nConsumed on use, may only use on ability."
   };

   SWEP.Icon = "VGUI/ttt/icon_handofd"
end

SWEP.Base = "weapon_tttbase"
SWEP.Primary.Recoil	= 1
SWEP.Primary.Damage = 0
SWEP.Primary.Delay = 1
SWEP.Primary.Cone = 1
SWEP.Primary.ClipSize = -1
SWEP.Primary.Automatic = false
SWEP.Primary.DefaultClip = -1
SWEP.Primary.ClipMax = -1

SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = {ROLE_DETECTIVE}
SWEP.WeaponID = AMMO_HAND


SWEP.NoSights = true
SWEP.ViewModel				= ""
SWEP.WorldModel            = "models/weapons/w_pist_deagle.mdl"
SWEP.ViewModelFlip	= false

function SWEP:PrimaryAttack()	--Set all players to full, even traitors.
	self.Owner:EmitSound( "ravenholm.monk_givehealth01" )
	self:Remove()

	timer.Simple( 1.5,function()
		for k, v in pairs(player.GetAll()) do
			v:SetHealth(100)
			v:EmitSound( "NPC_CombineGunship.SearchPing")
		end
	end)
end

function SWEP:SecondaryAttack()	--Freeze all players for a few seconds
	self.Owner:EmitSound( "ravenholm.monk_kill01" )
	self:Remove()

	timer.Simple( 1.5,function()
		for k, v in pairs(player.GetAll()) do
			v:Freeze(true)
			v:PrintMessage(HUD_PRINTCENTER, "FROZEN BY DETECTIVE!")
		end
	end)

	timer.Simple( 15,function()
		for k, v in pairs(player.GetAll()) do
			v:Freeze(false)
			v:EmitSound( "NPC_CombineGunship.SearchPing")
		end
	end)

end

function SWEP:DrawWorldModel()
end

function SWEP:DrawWorldModelTranslucent()
end

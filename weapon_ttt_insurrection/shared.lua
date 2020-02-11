
if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType			= "pistol"

if CLIENT then
   SWEP.PrintName = "The Insurrection"
   SWEP.Slot = 7

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "Give innocents a 30 second window to join the Traitors\nby killing the Detective.\n\nAll players are alerted upon use."
   };

   SWEP.Icon = "VGUI/ttt/icon_regulator"
end

SWEP.Base = "weapon_tttbase"
SWEP.Primary.Recoil	= 1.35
SWEP.Primary.Damage = 30
SWEP.Primary.Delay = 1
SWEP.Primary.Cone = 0.0001
SWEP.Primary.ClipSize = -1
SWEP.Primary.Automatic = false
SWEP.Primary.DefaultClip = -1
SWEP.Primary.ClipMax = -1
--SWEP.Primary.Ammo = "none"

SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = {ROLE_TRAITOR} -- only traitors can buy
SWEP.WeaponID = AMMO_INSUR


SWEP.IsSilent = true

SWEP.ViewModel				= "models/weapons/v_tcom_deagle.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_tcom_deagle.mdl"	-- Weapon world model
SWEP.ViewModelFlip	= false

SWEP.AllowDrop = false
SWEP.LimitedStock = true

function SWEP:OnDrop()
	self:Remove()
end


local InsurrectionStatus = false
local Dkilled = false
----------------------------------------
function SWEP:PrimaryAttack()
	InsurrectionStatus = true
	
	timer.Simple( 30, function()
		InsurrectionStatus = false
		
		if (Dkilled == false) then
			for k, v in pairs(player.GetAll()) do
				v:EmitSound( "ravenholm.monk_kill05" )
				v:PrintMessage( 3 , "The Insurrection has failed!" )
			end
		end
	end)
	
	self:Remove()

	for k, v in pairs(player.GetAll()) do
		v:EmitSound( "ravenholm.monk_mourn06" )
		v:PrintMessage( 3 , "An Insurrection has begun! You have 30 seconds to join the Traitors by killing the Detective. (Normal karma loss incurred)" )
	end
	
		function Dbetray( playerVictim, detectiveKiller, detectiveDamageInfo )

				if (playerVictim:GetRole() == ROLE_DETECTIVE) and not (detectiveKiller:GetRole() == ROLE_TRAITOR) and (InsurrectionStatus != false) then
					Dkilled = true
					detectiveKiller:SetRole(ROLE_TRAITOR)
					detectiveKiller:AddCredits(1)
				end
		end
		hook.Add( "DoPlayerDeath" , "betrayer" , Dbetray )
		
		---DETECTIVE KARMA REPERATIONS
		if SERVER and (InsurrectionStatus == true) then
	--		function DefendDetective(ply, penalty, victim)
	--			if ply:GetRole == ROLE_DETECTIVE and (InsurrectionStatus == true) then
	--				return true
	--			end
	--		end
	--		hook.Add( "TTTKarmaGivePenalty" , "defender" , DefendDetective )
		end
end
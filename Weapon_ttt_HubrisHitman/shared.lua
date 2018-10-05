
if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "pistol"

SWEP.Author = "Dagon Mike"

if CLIENT then
   SWEP.PrintName = "Hubris Hitman"
   SWEP.Slot = 7

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "Announce a random target to the world and \nprove that you are the greatest Hitman!\n\n-5 seconds after marking your target everyone will be\nalerted that they are marked.\n\n-30 seconds later the contract will go live for\n120 seconds, if by the end of that period they are \ndead they will grant 2 bonus credits, full health, and \nanother shot.\n-However, if you fail to kill\nthe target after the time is up your identity will be\nrevealed."
   };

   SWEP.Icon = "VGUI/ttt/icon_hitman"
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
SWEP.CanBuy = {ROLE_TRAITOR}
SWEP.WeaponID = AMMO_HITMAN


SWEP.IsSilent = true

SWEP.ViewModel             = "models/weapons/cstrike/c_pist_deagle.mdl"
SWEP.WorldModel            = "models/weapons/w_pist_deagle.mdl"
SWEP.ViewModelFlip	= false

SWEP.AllowDrop = false


function SWEP:OnDrop()
	self:Remove()
end

function SWEP:PrimaryAttack()
	local ply = self.Owner
	local Mark = table.Random(player.GetAll())
	if Mark:Alive() and not (Mark:GetRole() == ROLE_TRAITOR) then
	self:Remove()
				--Reveal the Mark
		if Mark:Alive() then
			PrintMessage( HUD_PRINTTALK, Mark:Nick() .. " has been marked by a Hubris Hitman and will be worth 2 bonus credits." )
		else
			ply:PrintMessage(HUD_PRINTTALK,"The Mark has died before the contract was live.")
		end
				--Make them worth credits
		if Mark:Alive() then
			PrintMessage( HUD_PRINTTALK, Mark:Nick() .. "'s contract is live for the next 90 seconds!" )
				--Give credits or Reveal Traitor
			timer.Simple( 90, function()
				if Mark:Alive() then
					PrintMessage( HUD_PRINTTALK, "Contract Failed! ".. ply:Nick() .. " was the Hubris Hitman!" )
				else
					PrintMessage( HUD_PRINTTALK, "Contract Fulfilled! The Hubris Hitman was awarded 2 credits & Full Health!" )
					ply:AddCredits(2)
					ply:Give "weapon_ttt_hitman"
					if ply:Health() <100 then
						ply:SetHealth(100)
					end
				end
			end)
			else
				PrintMessage( HUD_PRINTTALK, Mark:Nick() .." has died before the contract was live." )
			end
	else
		ply:PrintMessage(HUD_PRINTTALK,"Something went wrong. Try Again")
	end
end
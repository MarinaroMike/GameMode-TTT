
if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "pistol"

SWEP.Author = "Dagon Mike"

if CLIENT then
   SWEP.PrintName = "Manhunt"
   SWEP.Slot = 7

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "Announce a manhunt on target player.\nWhen a player comes within 30ft of the hunted player\nthey will emit an audible beep allowing players to be aware\nof their presence.\n\nThis effect ends if the target is disguised or the Detective is killed."
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
SWEP.CanBuy = {ROLE_DETECTIVE}
SWEP.WeaponID = AMMO_MANHUNT


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
	if IsValid(self.Owner:GetEyeTrace().Entity) then
		if self.Owner:GetEyeTrace().Entity:IsPlayer() then
			local Hunted = player.GetByID(self.Owner:GetEyeTrace().Entity:EntIndex())
			if Hunted:Alive() then
				self:Remove()
				PrintMessage( HUD_PRINTTALK, "There is a Manhunt out on " .. Hunted:Nick() .. "!" )
					--Reveal the hunt
				timer.Create("ManHunt", 1,0, function()
					for k, v in pairs(player.GetAll()) do
						if ply:Alive() and (v == Hunted) and (v:GetPos():Distance(Hunted:GetPos()) < 481) then
							Hunted:EmitSound( "NPC_CombineCamera.BecomeIdle")
							
							--Death should not be revealed globally. Commented out below.
						elseif not ply:Alive() then
							timer.Stop("ManHunt")
							--PrintMessage( HUD_PRINTTALK, "The Manhunt on " .. Hunted:Nick() .. " has ended!" )
							Hunted = nil
							elseif not Hunted:Alive() then
							timer.Stop("ManHunt")
							--PrintMessage( HUD_PRINTTALK, "The Manhunt on " .. Hunted:Nick() .. " has ended!" )
							Hunted = nil
						end
					end
				end)
			end
		end
	end
end

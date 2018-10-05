
if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "pistol"

SWEP.Author = "Dagon Mike"

if CLIENT then
   SWEP.PrintName = "The Jester"
   SWEP.Slot = 7

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "Turn an innocent into a Jester!\n\n15 seconds after being hit they, alone,\nwill know they are a Jester.\n\nWhen killed by innocents Jesters also\nkill their jesterkiller.\n\nTraitors do not die from killing a Jester.\nTraitors can not become Jesters."
   };

   SWEP.Icon = "VGUI/ttt/icon_jester"
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
SWEP.WeaponID = AMMO_JESTER
SWEP.LimitedStock = true

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
			local Jester = player.GetByID(self.Owner:GetEyeTrace().Entity:EntIndex())
			if Jester:Alive() and not (Jester:GetRole() == ROLE_TRAITOR) then
				self:Remove()
				
						--Reveal to Jester
				timer.Simple( 15, function()
					if Jester:Alive() then
						--The Jester being notified tends to curve their playstyle, reducing the
						--	effectiveness of the weapons. Commented out below.
						
						--Jester:PrintMessage(HUD_PRINTCENTER, "You have become a Jester! If you are killed by an innocent they will die too." )
						ply:PrintMessage(HUD_PRINTTALK, Jester:Nick().. " is now a Jester!" )
					else
						ply:PrintMessage(HUD_PRINTTALK, "The Jester has died too quickly.")
					end
				end)		
		

				function KillTheJESTER( jestervictim, jesterkiller, jesterDamageInfo )
				--BUG: If the jester survives the round they will still be jester on the next round.
				
				--if CurTime() == 0
				--jester = nil
				--end
					if (jestervictim == Jester) and not (jesterkiller:GetRole() == ROLE_TRAITOR) then
						jesterkiller:PrintMessage( HUD_PRINTTALK , "You've been Bested, hilariously Jested." )
						timer.Simple( 3 , function() jesterkiller:Kill()
							jestervictim:PrintMessage( HUD_PRINTTALK , "You've Jested!" )
						end)
					end
				end
				hook.Add( "DoPlayerDeath" , "jestthejester" , KillTheJESTER )
			end
		end
	end
end



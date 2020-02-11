AddCSLuaFile()

SWEP.HoldType = "magic"

if CLIENT then
   SWEP.PrintName = "Instigator's Kit"
   SWEP.Slot = 8

   SWEP.ViewModelFOV = 10
end

SWEP.Base = "weapon_tttbase"

SWEP.ViewModel          = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel         = "models/props/cs_office/paper_towels.mdl"

		--What does this do?
			-- Mark target, if that target kills you it alerts everyone.

SWEP.DrawCrosshair      = false
SWEP.ViewModelFlip      = false
SWEP.Primary.ClipSize       = 2
SWEP.Primary.DefaultClip    = 2
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo       = "none"
SWEP.Primary.Delay = 1.0

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo     = "none"
SWEP.Secondary.Delay = 0.2

SWEP.Kind = WEAPON_ROLE
--SWEP.CanBuy = {ROLE_DETECTIVE} -- only detectives can buy
SWEP.WeaponID = AMMO_FRISK2


function SWEP:OnDrop()
   self:Remove()
end

function SWEP:Deploy()
   if SERVER and IsValid(self.Owner) then
      self.Owner:DrawViewModel(false)
   end
   return true
end

function SWEP:ShouldDropOnDie()
   return false
end

SWEP.AllowDelete            = false
SWEP.AllowDrop              = false

---FUNCTION----
function SWEP:PrimaryAttack()
local Defendant = nil
local ply = self.Owner

	if IsValid(self.Owner:GetEyeTrace().Entity) then
		if self.Owner:GetEyeTrace().Entity:IsPlayer() then
			Defendant = player.GetByID(self.Owner:GetEyeTrace().Entity:EntIndex())
			if Defendant:Alive() then
			ply:PrintMessage(HUD_PRINTTALK, Defendant:Nick().. " has been marked. If they kill you, the world will know." )
			self:Remove()
			----------------REVEAL------------------

				function WhistleBlow( victim, killer, DamageInfo )
				
				if (killer == Defendant) and (victim == ply) and not (Defendant == h) then
					for k, v in pairs(player.GetAll()) do
						v:PrintMessage(HUD_PRINTTALK,  ply:Nick().. " was killed by their target, ".. Defendant:Nick())
					end
					
					else
					Defendant = h
					end
					
					
				end
				end
				hook.Add( "DoPlayerDeath" , "whistleblow" , WhistleBlow )
				
				
end

	function RemoveDefendant(Defendant)
	Defendant = h
	hook.Add("PlayerSpawn", "removedefendant", RemoveDefendant)
	
end
end
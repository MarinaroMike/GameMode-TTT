AddCSLuaFile()

SWEP.HoldType = "magic"

if CLIENT then
   SWEP.PrintName = "Bug Kit"
   SWEP.Slot = 8

   SWEP.ViewModelFOV = 10
end

SWEP.Base = "weapon_tttbase"

SWEP.ViewModel          = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel         = "models/props/cs_office/paper_towels.mdl"

		--What does this do?
			-- Mark target, when they fire their weapon or die, alert you.

SWEP.DrawCrosshair      = false
SWEP.ViewModelFlip      = false
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
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
SWEP.WeaponID = AMMO_BUG


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
local trgt = nil
local ply = self.Owner
local tr = taker:GetEyeTrace(MASK_SHOT)

	if tr.Hit and IsValid(tr.Entity) and tr.Entity:IsPlayer() and ((taker:EyePos() - tr.HitPos):Length() < 100) then
			trgt = player.GetByID(self.Owner:GetEyeTrace().Entity:EntIndex())
				if trgt:Alive() then
				ply:PrintMessage(HUD_PRINTTALK, trgt:Nick().. " has been bugged." )
				self:Remove()
			----------------REVEAL------------------

					function Listen( victim, killer, DamageInfo )
				
						if (killer == trgt) and (victim == ply) and not (trgt == h) then
							for k, v in pairs(player.GetAll()) do
								v:PrintMessage(HUD_PRINTTALK,  ply:Nick().. " was killed by their target, ".. trgt:Nick())
							end
					
						else
						trgt = h
						end
					
					
					end
					end
					hook.Add( "DoPlayerDeath" , "listen" , Listen )
				
				
				end

	function Removetrgt(trgt)
		trgt = h
	hook.Add("PlayerSpawn", "removetrgt", Removetrgt)
	
	end
end
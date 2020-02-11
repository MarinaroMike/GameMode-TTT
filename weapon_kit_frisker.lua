AddCSLuaFile()

SWEP.HoldType = "magic"

if CLIENT then
   SWEP.PrintName = "Frisker's Kit"
   SWEP.Slot = 8

   SWEP.ViewModelFOV = 10
end

SWEP.Base = "weapon_tttbase"

SWEP.ViewModel          = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel         = "models/props/cs_office/paper_towels.mdl"

SWEP.DrawCrosshair      = false
SWEP.ViewModelFlip      = false
SWEP.Primary.ClipSize       = 2
SWEP.Primary.DefaultClip    = 2
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo       = "none"
SWEP.Primary.Delay = .10

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
SWEP.AllowDrop              = true

---FUNCTION----

function SWEP:PrimaryAttack()
   self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	local taker = self.Owner					--set taker as owner of the frisker
   
    local tr = taker:GetEyeTrace(MASK_SHOT)		-- set tr as what taker is aimed at
	local ply = tr.Entity   					-- set ply as the entity(player) they are aimed at	
	
    if tr.Hit and IsValid(tr.Entity) and tr.Entity:IsPlayer() and ((taker:EyePos() - tr.HitPos):Length() < 100) and self.Weapon:Clip1() >= 1 then	--everyone is valid and target is in range, and frisker has ammo
		local friskfound = table.Random(ply:GetWeapons())	--set friskfound as a random weapon selected from the ply's inventory
		if !IsValid(friskfound) then return end				-- making sure everything is valid
		
															--following two lines removed because gun names arent server side
		--taker:PrintMessage(HUD_PRINTTALK, "You have found " .. friskfound:GetPrintName() .. " hidden on " .. ply:Nick() .. "!")
		--ply:PrintMessage(HUD_PRINTTALK, taker:Nick() .. " has found " .. friskfound:GetPrintName() .. " hidden on you!" )
		
		if friskfound:GetClass() == "weapon_zm_improvised" or friskfound:GetClass() == "weapon_zm_carry" or friskfound:GetClass() == "weapon_ttt_unarmed" or friskfound:GetClass() == "weapon_kit_candyman" or friskfound:GetClass() == "weapon_kit_frisker" or friskfound:GetClass() == "weapon_kit_lookout" or friskfound:GetClass() == "weapon_kit_psychic" or friskfound:GetClass() == "weapon_kit_runner" or friskfound:GetClass() == "weapon_kit_vigilante" or friskfound:GetClass() == "weapon_kit_spray" or friskfound:GetClass() == "weapon_kit_wizard" then
			ply:PrintMessage(HUD_PRINTTALK, taker:Nick() .. " frisked you to no avail!")
			ply:EmitSound("Player.WeaponSelectionClose")
			taker:PrintMessage(HUD_PRINTTALK, "You could not find anything dangerous on " .. ply:Nick() .. ".")		--what was found is part of base loadout
		else	
			if not taker:CanCarryWeapon(friskfound) then		--can the taker carry the weapon he has found
				for k,v in pairs(taker:GetWeapons()) do			--loop through map of the taker's weapons
					if v.Kind == friskfound.Kind then			--find the weapon with the same slot as the one found
						taker:StripWeapon(v:GetClass())
						--v:Remove()								--remove it from the taker's inventory
						break									--kill the loop
					end
				end
					ply:StripWeapon(friskfound:GetClass())							
					ply:EmitSound("Player.WeaponSelectionClose")
					ply:PrintMessage(HUD_PRINTTALK, taker:Nick() .. " took something from you!")
					taker:PrintMessage(HUD_PRINTTALK, "You found something dangerous on ".. ply:Nick() )
					
					taker:Give(friskfound:GetClass())					--give the taker the weapon they found
					self:TakePrimaryAmmo(1)								--remove a shot from the frisker
					ply:PrintMessage(HUD_PRINTTALK, taker:Nick() .. " has taken something from your!" )		--let ply know its been taken
			end
		end
		
		if self.Weapon:Clip1() == 0 then						--remove if there's no ammo
		self:Remove()
		end
		

	end
end


function SWEP:DrawWorldModel()
end

function SWEP:DrawWorldModelTranslucent()
end
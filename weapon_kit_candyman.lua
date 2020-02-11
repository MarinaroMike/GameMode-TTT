AddCSLuaFile()

SWEP.HoldType               = "normal"

if CLIENT then
   SWEP.PrintName           = "Milkman's Kit"
   SWEP.Slot                = 8

   SWEP.ViewModelFOV        = 10
end

SWEP.Base                   = "weapon_tttbase"

SWEP.ViewModel              = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel             = "models/weapons/w_crowbar.mdl"

SWEP.Primary.ClipSize       = 10
SWEP.Primary.DefaultClip    = 10
SWEP.Primary.ClipMax       = 10
SWEP.Primary.Delay         = 0.2
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo           = "none"

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"

SWEP.Kind                   = WEAPON_ROLE
--SWEP.InLoadoutFor           = {ROLE_INNOCENT, ROLE_TRAITOR, ROLE_DETECTIVE}

SWEP.AllowDelete            = true
SWEP.AllowDrop              = true
SWEP.NoSights               = true

function SWEP:PrimaryAttack()
   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
   if self:Clip1() >= 2 then
   self:CandyDrop()
   self:SetClip1( self:Clip1() - 1 )
   local laughtbl = {"npc_barney.ba_laugh01", "npc_barney.ba_laugh02", "npc_barney.ba_laugh04", "npc_barney.ba_laugh03" ,"", "", "",""}
   self:EmitSound(table.Random(laughtbl))
   else
   self:CandyDrop()
   self:Remove()
   end
   
end


function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	local ply = self.Owner
    if ply:Health() <= 98 and self:Clip1() >= 2 then
	ply:SetHealth(ply:Health()+2)
	--ply:EmitSound(healsound)
	self:SetClip1( self:Clip1() - 1 )
	self:EmitSound("Geiger.BeepLow")
	
	elseif ply:Health() <= 98 and self:Clip1() == 1 then
	ply:SetHealth(ply:Health()+2)
	self:EmitSound("Geiger.BeepLow")
	self:Remove()

	elseif ply:Health() > 98 then
	return
	
   else
   self:CandyDrop()
   self:Remove()
   
	end
end


function SWEP:CandyDrop()
   if SERVER then
      local ply = self.Owner
      if not IsValid(ply) then return end

     -- if self.Planted then return end

      local vsrc = ply:GetShootPos()
      local vang = ply:GetAimVector()
      local vvel = ply:GetVelocity()
      
      local vthrow = vvel + vang * 200

      local candy = ents.Create("ttt_candybar")
      if IsValid(candy) then
         candy:SetPos(vsrc + vang * 30)
         candy:Spawn()

         candy:SetPlacer(ply)

         candy:PhysWake()
         local phys = candy:GetPhysicsObject()
         if IsValid(phys) then
            phys:SetVelocity(vthrow)
         end

        -- self.Planted = true
      end
   end

  -- self:EmitSound(throwsound)
end


function SWEP:Reload()
end

function SWEP:Deploy()
   if SERVER and IsValid(self.Owner) then
      self.Owner:DrawViewModel(false)
   end
   return true
end

function SWEP:Holster()
   return true
end

function SWEP:DrawWorldModel()
end

function SWEP:DrawWorldModelTranslucent()
end

function SWEP:OnDrop()
   self:Remove()
end

function SWEP:ShouldDropOnDie()
   return false
end



function SWEP:Holster()
   return true
end

function SWEP:DrawWorldModel()
end

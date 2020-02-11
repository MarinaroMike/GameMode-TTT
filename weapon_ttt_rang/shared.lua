
if SERVER then
   AddCSLuaFile( "shared.lua" )
end
    
SWEP.HoldType = "knife"

if CLIENT then

   SWEP.PrintName    = "Magneto-rang"
   SWEP.Slot         = 3
  
   SWEP.ViewModelFlip = false

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "knife_desc"
   };

   SWEP.Icon = "VGUI/ttt/icon_knife"
end

SWEP.Base               = "weapon_tttbase"

SWEP.AutoSpawnable      = true

SWEP.ViewModel          = Model("models/weapons/v_stunbaton.mdl")
SWEP.WorldModel         = Model("models/weapons/w_stunbaton.mdl")

SWEP.DrawCrosshair      = false
SWEP.Primary.Damage         = 10
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false
SWEP.Primary.Delay = 10
SWEP.Primary.Ammo       = "none"
SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo     = "none"
SWEP.Secondary.Delay = 1.4

SWEP.Kind = WEAPON_NADE
SWEP.WeaponID = AMMO_RANG


function SWEP:PrimaryAttack()

   if SERVER then
      self.Owner:SetAnimation( PLAYER_ATTACK1 )

      local ply = self.Owner
      if not IsValid(ply) then return end

      local ang = ply:EyeAngles()

      if ang.p < 90 then
         ang.p = -10 + ang.p * ((90 + 10) / 90)
      else
         ang.p = 360 - ang.p
         ang.p = -10 + ang.p * -((90 + 10) / 90)
      end

      local vel = math.Clamp((90 - ang.p) * 5.5, 550, 800)

      local vfw = ang:Forward()*1.7
      local vrt = ang:Right()
      
      local src = ply:GetPos() + (ply:Crouching() and ply:GetViewOffsetDucked() or ply:GetViewOffset())

      src = src + (vfw * 1) + (vrt * 3)

      local thr = vfw * vel + ply:GetVelocity()

      local knife_ang = Angle(-28,0,0) + ang
      knife_ang:RotateAroundAxis(knife_ang:Right(), -90)

      local knife = ents.Create("ttt_rang_proj")
      if not IsValid(knife) then return end
      knife:SetPos(src)
      knife:SetAngles(knife_ang)

      knife:Spawn()

      knife.Damage = self.Primary.Damage

      knife:SetOwner(ply)

      local phys = knife:GetPhysicsObject()
      if IsValid(phys) then
         phys:SetVelocity(thr)
         phys:AddAngleVelocity(Vector(100, 1500, 0))
         phys:Wake()
      end

      self:Remove()
   end
   end

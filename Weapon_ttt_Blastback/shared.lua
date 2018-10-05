
if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType			= "shotgun"

SWEP.Author = "Dagon Mike"

if CLIENT then
   SWEP.PrintName = "Double Barrel"

   SWEP.Slot = 2
   SWEP.Icon = "VGUI/ttt/icon_jr_dub"

end
--Raw DPS: 177.27

SWEP.Base				= "weapon_tttbase"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModelFlip		= false
SWEP.Kind = WEAPON_HEAVY
SWEP.LimitedStock = false
SWEP.WeaponID = AMMO_SHOTGUN2
SWEP.ViewModelFOV		= 60
SWEP.Primary.Ammo = "Buckshot"
SWEP.Primary.Damage = 1
SWEP.Primary.Cone = 0.088
SWEP.Primary.Delay = 0.17
SWEP.Primary.ClipSize = 2
SWEP.Primary.ClipMax = 24
SWEP.Primary.DefaultClip = 2
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 1
SWEP.AutoSpawnable      = true
SWEP.AmmoEnt = "item_box_buckshot_ttt"
SWEP.ViewModel				= "models/weapons/v_doublebarrl.mdl"
SWEP.WorldModel			= "models/weapons/db/w_coachgun.mdl"

--SWEP.Primary.Sound			= Sound("Double_Barrel.Single")		
SWEP.Primary.Sound 		= Sound("weapons/coachgun/coach_fire1.wav")
SWEP.Primary.Recoil			= 12

SWEP.reloadtimer = 0
SWEP.HeadshotMultiplier = 2

SWEP.IronSightsPos = Vector( -1.43, -1, 2.3 )
SWEP.IronSightsAng = Vector(0, 0, 0)


--------------Knockback---------
function SWEP:PrimaryAttack()
	if ( !self:CanPrimaryAttack() ) then return end
	
   self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
   self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )

   self:FirePulse(600, 300)
end

function SWEP:FirePulse(force_fwd, force_up)
   if not IsValid(self.Owner) then return end

   self.Owner:SetAnimation( PLAYER_ATTACK1 )

   sound.Play(self.Primary.Sound, self.Weapon:GetPos(), self.Primary.SoundLevel)

   self.Weapon:SendWeaponAnim(ACT_VM_IDLE)

   local cone = self.Primary.Cone
   local num = 1

   local bullet = {}
   bullet.Num    = 16
   bullet.Src    = self.Owner:GetShootPos()
   bullet.Dir    = self.Owner:GetAimVector()
   bullet.Spread = Vector( cone, cone, 0 )
   bullet.Tracer = 4
   bullet.Force  = 3
   bullet.Damage = 2
   self:TakePrimaryAmmo( 1 )
   
	local rnda = self.Primary.Recoil * -1
	local rndb = 0
 
	self:ShootEffects()
 
	self.Owner:FireBullets( bullet ) 
	self:EmitSound(Sound(self.Primary.Sound)) 
	self.Owner:ViewPunch( Angle( rnda,rndb,rnda ) )

   local owner = self.Owner
   local fwd = 50
   local up = 15
   bullet.Callback = function(att, tr, dmginfo)
                        local ply = tr.Entity
                        if SERVER and IsValid(ply) and ply:IsPlayer() and (not ply:IsFrozen()) then
                           local pushvel = tr.Normal * fwd

                           pushvel.z = math.max(pushvel.z, up)

                           ply:SetGroundEntity(nil)
                           ply:SetLocalVelocity(ply:GetVelocity() + pushvel)

                           ply.was_pushed = {att=owner, t=CurTime()}

                        end
                     end

   self.Owner:FireBullets( bullet )
   

end
--------------Reload----------
function SWEP:SetupDataTables()
   self:DTVar("Bool", 0, "reloading")

   return self.BaseClass.SetupDataTables(self)
end

function SWEP:Reload()
   self:SetIronsights( false )
   
   --if self.Weapon:GetNetworkedBool( "reloading", false ) then return end
   if self.dt.reloading then return end

   if not IsFirstTimePredicted() then return end
   
   if self.Weapon:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 then
      
      if self:StartReload() then
         return
      end
   end

end

function SWEP:StartReload()
   --if self.Weapon:GetNWBool( "reloading", false ) then
   if self.dt.reloading then
      return false
   end

   if not IsFirstTimePredicted() then return false end

   self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
   
   local ply = self.Owner
   
   if not ply or ply:GetAmmoCount(self.Primary.Ammo) <= 0 then 
      return false
   end

   local wep = self.Weapon
   
   if wep:Clip1() >= self.Primary.ClipSize then 
      return false 
   end

   wep:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)

   self.reloadtimer =  CurTime() + wep:SequenceDuration()

   --wep:SetNWBool("reloading", true)
   self.dt.reloading = true

   return true
end

function SWEP:PerformReload()
   local ply = self.Owner
   
   -- prevent normal shooting in between reloads
   self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   if not ply or ply:GetAmmoCount(self.Primary.Ammo) <= 0 then return end

   local wep = self.Weapon

   if wep:Clip1() >= self.Primary.ClipSize then return end

   self.Owner:RemoveAmmo( 1, self.Primary.Ammo, false )
   self.Weapon:SetClip1( self.Weapon:Clip1() + 1 )

   wep:SendWeaponAnim(ACT_VM_RELOAD)

   self.reloadtimer = CurTime() + wep:SequenceDuration()
end

function SWEP:FinishReload()
   self.dt.reloading = false
   self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
   
   self.reloadtimer = CurTime() + self.Weapon:SequenceDuration()
end

function SWEP:CanPrimaryAttack()
   if self.Weapon:Clip1() <= 0 then
      self:EmitSound( "Weapon_Shotgun.Empty" )
      self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
      return false
   end
   return true
end

function SWEP:Think()
   if self.dt.reloading and IsFirstTimePredicted() then
      if self.Owner:KeyDown(IN_ATTACK) then
         self:FinishReload()
         return
      end
      
      if self.reloadtimer <= CurTime() then

         if self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
            self:FinishReload()
         elseif self.Weapon:Clip1() < self.Primary.ClipSize then
            self:PerformReload()
         else
            self:FinishReload()
         end
         return            
      end
   end
end

function SWEP:Deploy()
   self.dt.reloading = false
   self.reloadtimer = 0
   return self.BaseClass.Deploy(self)
end
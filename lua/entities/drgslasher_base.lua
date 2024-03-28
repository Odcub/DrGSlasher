if not DrGBase then return end
ENT.Base = "drgbase_nextbot"

-- Misc --
ENT.PrintName = "TEMPLATE"
ENT.Category = "DrG-Slasher Base"
ENT.Models = {"models/odcub/slasher/pipann/pipdummy_male.mdl"}
ENT.ModelScale = 1
ENT.BloodColor = BLOOD_COLOR_RED
ENT.RagdollOnDeath = true
ENT.CollisionBounds = Vector(10, 10, 72)
ENT.BehaviourType = AI_BEHAV_BASE

-- Stats --
ENT.SpawnHealth = 1500
ENT.HealthRegen = 1
ENT.MinPhysDamage = 10
ENT.MinFallDamage = 10

-- Locker --
ENT.LockerEnt = nil
ENT.UseLockers = true
ENT.SearchingLocker = false
ENT.GiveUpPlayerLockerCD = 0
ENT.CancelLockerSearchCD = 0
ENT.OpenCD = 0
ENT.LockerCD = 0
ENT.RandomPlayerCD = 0 ---- Pick random player to "Patrol" near every once in a while
ENT.FindCD = 0

-- Sounds --
ENT.OnSpawnSounds = {}
ENT.OnIdleSounds = {}
ENT.IdleSoundDelay = 2
ENT.ClientIdleSounds = false
ENT.OnDamageSounds = {}
ENT.DamageSoundDelay = 0.25
ENT.OnDeathSounds = {}
ENT.OnDownedSounds = {}
ENT.Footsteps = {}

-- AI --
ENT.SpotDuration = 8
ENT.StunCD = 0
ENT.WanderDist = 3000
ENT.DoorOpenCD = 0
ENT.DoorCheckCD = 0
ENT.GiveUpPatrolCD = 0
ENT.IsKicking = false
ENT.HasPower = true
ENT.CanKickDoors = true
ENT.CanBloodLust = true
ENT.BloodlustTime = 15
ENT.MaxBloodlustCharges = 3
ENT.BloodlustCharges = 0
ENT.BloodlustSpeedAdd = 25

ENT.MiniBloodLustCD = 0
ENT.BloodLustCD = 0
ENT.BloodLustLevel = 0

ENT.StuckCharges = 0
ENT.StuckDrainCD = 0
ENT.StuckMaxDist = 1

-- Relationships --
ENT.DefaultRelationship = D_HT
ENT.Factions = {
    "FACTION_DRGSLASHER"
}
ENT.Frightening = true
ENT.AllyDamageTolerance = 0
ENT.AfraidDamageTolerance = 0
ENT.NeutralDamageTolerance = 0

-- Locomotion --

ENT.Acceleration = 1000
ENT.Deceleration = 2000
ENT.JumpHeight = 50
ENT.StepHeight = 20
ENT.MaxYawRate = 300

-- Melee Attack --

ENT.IsMeleeAttacking = false
ENT.CanMelee = true
ENT.IsWiping = false 
ENT.MeleeDist = 180
ENT.MeleeAttackRange = 70
ENT.MeleeHitSpeedDecrease = 250
ENT.LungeTime = 1
ENT.LungeSpeedAdd = 250
ENT.MeleeDamage = 50
ENT.MeleeCD = 0
ENT.MeleeDamageCD = 0
ENT.EndMeleeCD = 0

-- Sounds --

ENT.SoundTbl_FootStep = {"dbd/shared/boots/concretestep1.wav","dbd/shared/boots/concretestep2.wav", "dbd/shared/boots/concretestep3.wav", "dbd/shared/boots/concretestep4.wav"}

ENT.StepSoundLevel = 70
ENT.StepVolume = 1
ENT.StepSound = nil
ENT.BreathSet = 1
ENT.BreathCD = 0
ENT.BreathSoundLevel = 40
ENT.BreathSound = nil

ENT.StunSet = 1
ENT.StunSoundCD = 0
ENT.StunSound = nil

ENT.ImpactSoundCD = 0

-- Climbing --
ENT.ClimbLedges = true

-- Animations --
ENT.WalkAnimation = "move"
ENT.WalkAnimRate = 1
ENT.RunAnimation = "move"
ENT.RunAnimRate = 1
ENT.IdleAnimation = "idle"
ENT.IdleAnimRate = 1

-- Movements --
ENT.UseWalkframes = false
ENT.WalkSpeed = 300
ENT.RunSpeed = 300
ENT.DefaultRunSpeed = 300

-- Detection --
ENT.EyeBone = "bip_head"
ENT.EyeOffset = Vector(0, 0, 0)
ENT.EyeAngle = Angle(0, 0, 0)
ENT.SightFOV = 300
ENT.SightRange = 15000
ENT.MinLuminosity = 0
ENT.MaxLuminosity = 1
ENT.HearingCoefficient = 1

if SERVER then
------------------------------------------------  
function ENT:CustomInitialize()
	self:SetNWBool('DBD_IsNextbot',true)
	self.LockerCD = CurTime() + math.random(4,8)
	self.RandomPlayerCD = CurTime() + math.random(16,24)

	self:AvoidObstacles(false)
	self.StunSet = math.random(1,2)
	self:ReactInCoroutine(function(self)
	self:AddPatrolPos(self:GetPos())
	self.BloodLustCD = CurTime() + 1
	end)
	timer.Simple(0.05,function() if IsValid(self) then self:SetCustomStats()

	end end)

end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetCustomStats()

	if IsValid(self:GetCreator()) then
	
	local Creator = self:GetCreator()

	self.MeleeDamage = Creator:GetInfoNum( "dbd_basetemplate_damage", 1 )
	self:SetMaxHealth(Creator:GetInfoNum( "dbd_basetemplate_health", 1 ))
	self:SetHealth(Creator:GetInfoNum( "dbd_basetemplate_health", 1 ))

	self.WalkSpeed = Creator:GetInfoNum( "dbd_basetemplate_speed", 1 )
	self.RunSpeed = Creator:GetInfoNum( "dbd_basetemplate_speed", 1 )
	self.DefaultRunSpeed = Creator:GetInfoNum( "dbd_basetemplate_speed", 1 )
	self.MeleeHitSpeedDecrease = Creator:GetInfoNum( "dbd_basetemplate_wipespeed_decrease", 1 )
	self.LungeSpeedAdd = Creator:GetInfoNum( "dbd_basetemplate_lungespeedadd", 1 )
	self.LungeTime = Creator:GetInfoNum( "dbd_basetemplate_lungetime", 1 )
	
	self.MaxBloodlustCharges = Creator:GetInfoNum( "dbd_basetemplate_bloodlust_max", 1 )
	self.BloodlustSpeedAdd = Creator:GetInfoNum( "dbd_basetemplate_bloodlust_add", 1 )
	self.BloodlustTime = Creator:GetInfoNum( "dbd_basetemplate_bloodlust_time", 1 )
	self.BloodLustCD = CurTime() + self.BloodlustTime
	
	self.StepSoundLevel = Creator:GetInfoNum( "dbd_basetemplate_stepsndlvl", 1 )
	self.BreathSoundLevel = Creator:GetInfoNum( "dbd_basetemplate_breathsndlvl", 1 )
	self.SpotDuration = Creator:GetInfoNum( "dbd_basetemplate_spotdur", 1 )	
	
	self.WanderDist = Creator:GetInfoNum( "dbd_basetemplate_wanderdistance", 1 )

	if Creator:GetInfoNum( "dbd_basetemplate_cankickdoors", 1 ) == 0 then self.CanKickDoors = true else self.CanKickDoors = false end
	
	if Creator:GetInfoNum( "dbd_basetemplate_bloodlust", 1 ) == 0 then self.CanBloodLust = false else self.CanBloodLust = true end

	if Creator:GetInfoNum( "dbd_basetemplate_climb", 1 ) == 0 then self.ClimbLedges = false else self.ClimbLedges = true end
	
	if Creator:GetInfoNum( "dbd_basetemplate_checklockers", 1 ) == 0 then self.UseLockers = false else self.UseLockers = true end
	
	
	local lungespeed = self.LungeSpeedAdd*0.1
	local meleedist = math.min(220,100+lungespeed)
	meleedist = math.max(45,meleedist*self.LungeTime)
	self.MeleeDist = math.min(225,meleedist)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAnimEvent(event, data, cycle)
    if event == "DBD.Step" then
 		self:Custom_StopSound(self.StepSound)
		local filter = RecipientFilter()
		filter:AddAllPlayers()
		self.StepSound = CreateSound(self,table.Random(self.SoundTbl_FootStep),filter)
		self.StepSound:SetSoundLevel(self.StepSoundLevel)
		
		self.StepSound:PlayEx(self.StepVolume,math.random(95,105))
    end
	
	if event == "DBDLocker.OpenFast" then
	self:EmitSound("dbd/lockerent/open"..math.random(1,2)..".mp3",90,100)
	end
	if event == "DBDLocker.CloseFast" then
	self:EmitSound("dbd/lockerent/squeak"..math.random(1,2)..".mp3",90,100)
	end
	if event == "DBDLocker.Slam" then
	self:EmitSound("dbd/lockerent/closefast.mp3",90,100)
	end
	if event == "DBDLocker.CloseSlow" then
	self:EmitSound("dbd/lockerent/closeslow.mp3",90,100)
	end
	
	if event == "DBDLocker.Stinger" then
	self:EmitSound("dbd/lockerent/stinger.mp3",90,100)
	end
	
	if event == "DBDLocker.Attack" then
	self:EmitSound("dbd/lockerent/wood"..math.random(1,4)..".mp3",90,100)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetWeaponModel()
end
------------------------------------------------    
function ENT:OnIdle()
	if IsValid(self.Locker) then
	local attach = self.Locker:GetAttachment(6)
	self.SearchingLocker = true
	self:GoTo(attach.Pos,1,function() if CurTime() > self.CancelLockerSearchCD  then return false end end)
	else
	
		if CurTime() > self.LockerCD and self.UseLockers == true then
		self.LockerCD = CurTime() + math.random(4,8)
		self:FindLocker()
		
		
			if IsValid(self.Locker) then
			local attach = self.Locker:GetAttachment(6)
				self.SearchingLocker = true
				self:GoTo(attach.Pos,1,function() if CurTime() > self.CancelLockerSearchCD  then return false end end)
				debugoverlay.Sphere(attach.Pos, 25, 8, Color( 125, 255, 255 ),true )
			end
	
		elseif CurTime() > self.RandomPlayerCD then
	
		self:PickRandomPatrolPlayer()
	
		else
	
		self:AddPatrolPos(self:RandomPos(self.WanderDist))
		self.GiveUpPatrolCD = CurTime() + math.random(6,10)
	
		end
	end
end
------------------------------------------------
function ENT:PickRandomPatrolPlayer()
	if self.SearchingLocker == false then

		local tbl = {}
		for k,v in RandomPairs(player.GetAll()) do
			table.insert(tbl,v)
		end
		
		if table.Count(tbl) != 0 then
		local lockcd = math.Round(self.LockerCD-CurTime(),0)
		self.LockerCD = CurTime() + lockcd + 3
		self.RandomPlayerCD = CurTime() + math.random(12,24)
		self.GiveUpPatrolCD = CurTime() + math.random(8,14)
		local ppos = tbl[1]:DrG_RandomPos(350,650)
		self:AddPatrolPos(ppos)
		 debugoverlay.Sphere(ppos, 25, 8, Color( 255, 125, 255 ),true )
		else
		self:AddPatrolPos(self:RandomPos(self.WanderDist))
		self.GiveUpPatrolCD = CurTime() + math.random(6,10)
		end
	
	end
end
------------------------------------------------    
function ENT:FindLocker()
	if !self:HasEnemy() and self.UseLockers == true then
		if table.Count(ents.FindByClass("prop_vehicle_prisoner_pod")) != 0 then
		for k,v in RandomPairs(ents.FindByClass("prop_vehicle_prisoner_pod")) do
			if CurTime() > self.FindCD and v:GetPos():Distance(self:GetPos()) < 800 and v:GetNWBool('DBDLocker_Targeted',false) != true and v:GetNWBool('DBDLocker_RecentlySearched',false) != true then
			local randomcd = math.random(10,15)
			self.FindCD = CurTime() + 1
			self.LockerCD = CurTime() + randomcd + 2
			self.Locker = v
			
			self.Locker:SetNWBool('DBDLocker_Targeted',true)
			self:RemovePatrol(self:GetPatrol())
			self.CancelLockerSearchCD = CurTime() + randomcd
			local plycd = math.Round(self.RandomPlayerCD-CurTime(),0)
			self.RandomPlayerCD = CurTime() + plycd + 6
			end
		end
		else
		self.LockerCD = CurTime() + 6
	end
	end
end
------------------------------------------------
function ENT:LockerSearchExpired()
	if self:HasEnemy() || CurTime() > self.CancelLockerSearchCD || !IsValid(self.Locker) then
	return true
	else
	return false
	end
end
------------------------------------------------    
function ENT:CancelLockerSearchChecks()
	if self:LockerSearchExpired() and self.SearchingLocker == true  then
	self:CancelLockerSearch()
	self.Locker = nil
	end
end
------------------------------------------------ 
function ENT:CancelLockerSearch()
	self.LockerCD = CurTime() + math.random(4,6)
	self.SearchingLocker = false
	if IsValid(self.Locker) then
	self.Locker:SetNWBool('DBDLocker_Targeted',false)
	end
end
------------------------------------------------------------------------------------------------
function ENT:OpenTargetedLocker()
	if self.IsKicking == false and self.SearchingLocker == true and IsValid(self.Locker) and CurTime() > self.OpenCD then
		
		if self.Locker:GetPos():Distance(self:GetPos()) < 80 and self.Locker:Visible(self) then
			self:CancelLockerSearch()
			self:OpenLocker(self.Locker)
			self.Locker = nil
		end
	
	end
end
function ENT:IsViableLockerVictim(lock)
	
	if IsValid(lock:GetDriver()) and GetConVarNumber("ai_ignoreplayers") == 0 then
	return true
	else
	return false
	end

end
------------------------------------------------------------------------------------------------
function ENT:OpenLocker(lock)
		if lock:GetModel() == "models/dbd/dbdnb_entities/dbd_locker.mdl" then
		self.IsKicking = true
		self.MeleeCD = CurTime() + 3
		self.StunCD = CurTime() + 3
		self.OpenCD = CurTime() + 3
		self:FaceInstant(lock)
		local attach = lock:GetAttachment(6)
		
		timer.Simple(0.25,function() if IsValid(self) then
		self:SetPos(attach.Pos)
		self:SetAngles(attach.Ang)
		end end)


		if self:IsViableLockerVictim(lock) then 
		self:Custom_PlaySequence("SearchAttack")
		lock:SearchFound(self)		
		else
		self:Custom_PlaySequence("Search")
		lock:SearchEmpty(self)
		end
		
		timer.Simple(3,function() if IsValid(self) then
		self.IsKicking = false
		end end)

		end
end
------------------------------------------------    
function ENT:OnReachedPatrol()
    self:Wait(math.random(1, 2))
end  
------------------------------------------------    
function ENT:OnChaseEnemy(enemy)
end
------------------------------------------------    
function ENT:OnSpawn()
 	
end
------------------------------------------------    
function ENT:DBDBreathSound()
	if CurTime() > self.BreathCD then
	
	if self.BreathSet == 1 and CurTime() > self.BreathCD then
	
	self.BreathCD = CurTime() + 1
	self.BreathSet = 2
	self.BreathSound = CreateSound( self, "dbd/trapper/breath"..math.random(1,3)..".mp3" )
	self.BreathSound:PlayEx(1,100)
	self.BreathSound:SetSoundLevel(self.BreathSoundLevel)
	end
	
	if self.BreathSet == 2 and CurTime() > self.BreathCD then
	self.BreathSound = CreateSound( self, "dbd/trapper/breath"..math.random(4,6)..".mp3" )
	self.BreathSound:PlayEx(1,100)
	self.BreathSound:SetSoundLevel(self.BreathSoundLevel)	
	self.BreathCD = CurTime() + math.random(3,4)
	self.BreathSet = 1
	
	end
	end
end
------------------------------------------------   
function ENT:Custom_PlaySequence(anim,playback)
	self:ReactInCoroutine(function(self)
	self:PlaySequenceAndWait( anim, playback ) end)
end
------------------------------------------------ 
function ENT:StuckDetection()

	local stucktrace = util.TraceHull( {
	start = self:GetPos(),
	endpos = self:GetPos() + self:GetUp()*50,
	filter = self,
	mins = Vector( -5, -5, 1 ),
	maxs = Vector( 5, 5, 50 ),
	mask = MASK_SHOT_HULL
} ) 
	local stucktbl = {
	prop_dynamic = true,
	prop_physics = true
	}

	if stucktrace.HitWorld || stucktbl[stucktrace.HitEntity]  then 
	self.StuckCharges = math.min(100,self.StuckCharges + 3)
	end

	if self:IsStuckInEnemy() then 
	self.StuckCharges = math.min(100,self.StuckCharges + 3)
	end

	
	if !stucktrace.HitWorld and !stucktbl[stucktrace.HitEntity] and CurTime() > self.StuckDrainCD then 
	self.StuckDrainCD = CurTime() + 0.5
	self.StuckCharges = math.max(0,self.StuckCharges - 10)
	end
	
	if self.StuckCharges == 100 || self:IsStuck() then
	local nav = navmesh.GetNearestNavArea( self:GetPos(), true,99999999,false,false,TEAM_ANY)
	if nav:IsValid() then
	self.StuckCharges = 0
	
	local dir = math.random(-33,33)
	self:SetPos(nav:GetRandomPoint() + self:GetRight()*dir )
	self:ClearStuck()
	else return
	end
	
	end


end
------------------------------------------------
function ENT:IsStuckInEnemy()
	local trace = self:DrG_TraceHull(Vector(0,0,0),{start = self:GetPos()})
	if trace.Entity:IsPlayer() || trace.Entity:IsNextBot() || trace.Entity:IsNPC() then
	return true
	else
	return false
	end
end
------------------------------------------------------------------------------------------------
  function ENT:BehaveUpdate() ---- bruh weird ass gesture glitch
	self:CustomThink_AIEnabled()
  	if not self.BehaveThread then return end
  	if coroutine.status(self.BehaveThread) ~= "dead" then
      local ok, args = coroutine.resume(self.BehaveThread)
    	if not ok then
    		self.BehaveThread = nil
        if not self:OnError(args) then
          ErrorNoHalt(self, " Error: ", args, "\n")
        else self:BehaveStart() end
    	end
  	else self.BehaveThread = nil end
  end
------------------------------------------------   
function ENT:CustomThink()
	self:DBDBreathSound()
	self:DBDNetworkValues()
end
------------------------------------------------   
function ENT:DBDNetworkValues()
	
	
	-------------- Door Button Pop up ---------
	
	if self:IsPossessed() then
	local ply = self:GetPossessor()
	local door = self:GetNWEntity('DBDNB_DoorEntity',nil)
	
	if IsValid(door) then
	
		if  door:GetClass() != "prop_vehicle_prisoner_pod" and ply:KeyDown(IN_ZOOM) and CurTime() > self.OpenCD and CurTime() > self.DoorCheckCD and self.IsKicking == false then
			if self:IsDoorLocked(door) == false then
			self.DoorCheckCD = CurTime() + 1.5
			self:GetNWEntity('DBDNB_DoorEntity',nil):Fire("Use",self,0,self,self)
			else
			self.OpenCD = CurTime() + 4
			self.DoorCheckCD = CurTime() + 1.5
			self:KickOpenDoor(door)
			end
		end
		
		if door:GetClass() == "prop_vehicle_prisoner_pod" and ply:KeyDown(IN_ZOOM) and CurTime() > self.OpenCD and CurTime() > self.LockerCD and !self:IsMeleeBusy() then
		self:OpenLocker(door)
		
		end
		
		
	end
	
	local startpos = self:GetShootPos() + self:GetUp()*10
	local endpos2 = startpos + ply:GetAimVector()*75
	local doortbl = {
	prop_door_rotating = true,
	prop_door = true,
	func_door = true,
	func_door_rotating = true,
	prop_vehicle_prisoner_pod = true }

		local tr = util.TraceLine( {
			start = startpos,
			endpos = endpos2,
			filter = self,
			mask = MASK_OPAQUE_AND_NPCS})
			
			local ent = tr.Entity
			
			if IsValid(ent) and doortbl[ent:GetClass()] then
			self:SetNWBool('DBDNB_DoorEntity',ent)
			else
			self:SetNWBool('DBDNB_DoorEntity',"NONE")
			end
	end
	
end
------------------------------------------------   
function ENT:CustomThink_AIEnabled() 
	if !self:IsAIDisabled() then
	self:PossessorMeleeCode()
	self:PrepareMeleeAttack()
	self:DoMeleeDamage()
	self:CancelMeleePossessor()
	self:OpenDoors()
	self:SearchForLockedDoor()
	self:MissMeleeAttack()
	self:BloodLust()
	self:FootstepSurfaceCode()
	self:DoEnemyPoseParameters()
	self:OpenTargetedLocker()
	self:CancelLockerSearchChecks()
	self:StuckDetection()
	self:MeleeFaceEnemy()
	if self.SearchingLocker == false and CurTime() > self.GiveUpPatrolCD and !self:HasEnemy() then
	self.GiveUpPatrolCD = CurTime() + 3
	self:ClearPatrols()
	end
	end 
end
------------------------------------------------   
function ENT:MeleeFaceEnemy() 
	self:ReactInCoroutine(function(self)
	if self.IsMeleeAttacking == true and self:HasEnemy() then
	local trace = util.QuickTrace(self:GetPos() + self:GetUp()*25, self:GetAimVector()*100,self)
	
	if !trace.HitWorld then
	self:FaceInstant(self:GetEnemy())
	end end
	end)
end
------------------------------------------------  
function ENT:PossessorMeleeCode()
	if self:IsPossessed() then
	
	local ply = self:GetPossessor()

      if !self.IsKicking and !self:IsMeleeBusy() and CurTime() > self.MeleeCD and ply:KeyDown(IN_ATTACK) then
	  self:StartMeleeAttack()
	  self.MeleeDamageCD = CurTime() + 0.15
	  end
	end
end
------------------------------------------------   
------------------------------------------------   
function ENT:DoEnemyPoseParameters()
	local pos = self:GetPos() + self:GetUp()*75
	local trace = self:DrG_TraceLine(self:GetAimVector()*75,{start = pos})
	local trace2 = self:PossessorTrace()
	
	if self:IsPossessed() then
	
	local ply = self:GetPossessor()
	self:AimAt(trace2.HitPos + self:GetAimVector()*33)
	
	end
	
	if !self:IsPossessed() then
	 
	self:AimAt(trace.HitPos)
	
	end

end
---------------------------------------------------------------------------------------------------------------------------------------------
  function ENT:AimAt(pos)
    self:DirectPoseParametersAt(pos, "aim", self:EyePos())
  end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FootstepSurfaceCode() 
	local pos = self:GetPos() + self:GetUp()*4
	local ang = self:GetUp()*-30
	local tracedata = {}
	tracedata.start = pos 
	tracedata.endpos = pos + (ang*50)
	tracedata.filter = self
	local trace = util.TraceLine(tracedata)
	if trace.MatType == 85 || 68 and trace.HitWorld then
self.SoundTbl_FootStep = { "dbd/shared/boots/dirtstep1.wav","dbd/shared/boots/dirtstep2.wav", "dbd/shared/boots/dirtstep3.wav", "dbd/shared/boots/dirtstep4.wav" } end
self.StepVolume = 0.25
	if trace.MatType == 67 and trace.HitWorld then 
self.SoundTbl_FootStep = { "dbd/shared/boots/concretestep1.wav","dbd/shared/boots/concretestep2.wav", "dbd/shared/boots/concretestep3.wav", "dbd/shared/boots/concretestep4.wav" } end
self.StepVolume = 0.15
	if trace.MatType == 84 and trace.HitWorld then 
self.SoundTbl_FootStep = { "dbd/shared/boots/concretestep1.wav","dbd/shared/boots/concretestep2.wav", "dbd/shared/boots/concretestep3.wav", "dbd/shared/boots/concretestep4.wav" } end
self.StepVolume = 0.15
	if trace.MatType == 77 and trace.HitWorld then 
self.SoundTbl_FootStep = { "dbd/shared/boots/metalstep1.wav","dbd/shared/boots/metalstep2.wav", "dbd/shared/boots/metalstep3.wav", "dbd/shared/boots/metalstep4.wav" } end
self.StepVolume = 0.45
	if trace.MatType == 87 and trace.HitWorld then 
self.SoundTbl_FootStep = { "dbd/shared/boots/woodstep1.wav","dbd/shared/boots/woodstep2.wav", "dbd/shared/boots/woodstep3.wav", "dbd/shared/boots/woodstep4.wav" } end
self.StepVolume = 0.25
	if trace.MatType == 89 and trace.HitWorld then 
self.SoundTbl_FootStep = { "dbd/shared/boots/glasstep1.wav","dbd/shared/boots/glasstep2.wav", "dbd/shared/boots/glasstep3.wav", "dbd/shared/boots/glasstep4.wav" } end
self.StepVolume = 0.25
	if trace.MatType == 75 then 
self.SoundTbl_FootStep = { "dbd/shared/boots/snowstep1.wav","dbd/shared/boots/snowstep2.wav", "dbd/shared/boots/snowstep3.wav", "dbd/shared/boots/snowstep4.wav" } end
self.StepVolume = 0.25
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnNewEnemy()
	self.BloodLustCD = CurTime() + self.BloodlustTime
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BloodLust()
	if  self.BloodLustLevel >= self.MaxBloodlustCharges and !self:IsPossessed() then return elseif 

	self:HasEnemy() and CurTime() > self.BloodLustCD then
	self.BloodLustCD = CurTime() + self.BloodlustTime
	self.RunSpeed = self.RunSpeed + self.BloodlustSpeedAdd
	self.WalkSpeed = self.WalkSpeed + self.BloodlustSpeedAdd
	self.BloodLustLevel = math.min(self.MaxBloodlustCharges, self.BloodLustLevel + 1)
	
	end
end
------------------------------------------------
function ENT:ResetBloodLust()
	self.BloodLustCD = CurTime() + self.BloodlustTime + 3
	self.RunSpeed = self.DefaultRunSpeed
	self.WalkSpeed = self.DefaultRunSpeed
	self.BloodLustLevel = 0
end
------------------------------------------------   
function ENT:IsMeleeBusy()
	if self.IsMeleeAttacking == true || self.IsWiping == true || self.IsKicking == true || self:IsClimbing() then
	return true
	else
	return false
	end
end
------------------------------------------------
function ENT:IsDoorLocked( entity )

	return ( entity:GetInternalVariable( "m_bLocked" ) )

end

------------------------------------------------
function ENT:DoorIsOpen( door )
	
	local doorClass = door:GetClass()

	if ( doorClass == "func_door" or doorClass == "func_door_rotating" ) then

		return door:GetInternalVariable( "m_toggle_state" ) == 0

	else

		return door:GetInternalVariable( "m_eDoorState" ) == 0
	end

end
------------------------------------------------   
function ENT:OpenDoors() 
	if CurTime() > self.DoorCheckCD and self.IsKicking == false and !self:IsMeleeBusy() and CurTime() > self.MeleeCD then
	
	for k,v in pairs(ents.FindInSphere(self:GetPos() + self:GetForward()*12,65))
	
	do 
	
	local doortbl = {
	prop_door_rotating = true,
	prop_door = true,
	func_door = true,
	func_door_rotating = true }
	
	if doortbl[v:GetClass()] and self:IsDoorLocked(v) == false and self:DoorIsOpen(v) == true then

	for k,v in pairs(ents.FindInSphere(v:GetPos(),65))
	
	do if doortbl[v:GetClass()] and self:IsDoorLocked(v) == false and self:DoorIsOpen(v) == true then
	
	local doortbl = {
	prop_door_rotating = true,
	prop_door = true,
	func_door = true,
	func_door_rotating = true }
	

		if !self:IsPossessed() then
		self.DoorCheckCD = CurTime() + 1
		v:Fire("Use",self,0,self,self)
		end
	
	end end end
	
	
	end
	
	
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CanUseLockedDoor()
	if !self:IsPossessed() then
	return true
	end

	if self:IsPossessed() then
	if self:GetPossessor():KeyDown(IN_ZOOM) then
	return true
	end end

end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SearchForLockedDoor()

	if CurTime() > self.DoorCheckCD and self.CanKickDoors != true and self.IsKicking == false and !self:IsMeleeBusy() and CurTime() > self.MeleeCD then

	for k,v in pairs(ents.FindInSphere(self:GetPos() + self:GetForward()*12,30))
	
	do 

	if CurTime() > self.DoorCheckCD and v:GetClass() == "prop_door_rotating" and self:IsDoorLocked(v) == true and self:DoorIsOpen(v) == true and self:CanUseLockedDoor() then
	self:KickOpenDoor(v)
	
	end
	
	end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:KickOpenDoor(v)  
	self.MeleeCD = CurTime() + 3
	v:Fire("Use") 
	self:Custom_PlaySequence("Destroy",1)
	self.DoorCheckCD = CurTime() + 0.5
	self.IsKicking = true
	timer.Simple(0.85,function() if IsValid(self) then self:EmitSound( "SolidMetal.ImpactHard" ) end end)
	timer.Simple(2,function() if IsValid(v) and IsValid(self) then self:EmitSound( "physics/metal/metal_box_break1.wav", 80, 100, 1 ) self.IsKicking = false v:Fire("SetSpeed","500",0) v:Fire("Unlock") v:Fire("Use",self,0,self,self)
	timer.Simple(0.5,function() if IsValid(v) then v:Fire("SetSpeed","100",0) end end) end end)
end
------------------------------------------------   
function ENT:CancelMeleePossessor()
	if IsValid(self:GetPossessor()) then
	
	local ply = self:GetPossessor()
	
	if self.IsMeleeAttacking == true and !ply:KeyDown(IN_ATTACK) and CurTime() > self.MeleeDamageCD then
	
	self:Custom_PlaySequence("Miss",1)
	self:EndMeleeAttack()
	self.RunSpeed = self.DefaultRunSpeed 
	self.WalkSpeed = self.DefaultRunSpeed
	self:EmitSound("dbd/trapper/swing"..math.random(1,3)..".mp3",80,100)
	self.MeleeCD = CurTime() + 2.25
	self:DoPropDamage()
	self.IsWiping = true
	timer.Simple(2,function() if IsValid(self) then self.IsWiping = false end end)
	end
	
	end

end
------------------------------------------------   
function ENT:PrepareMeleeAttack()
	if !self:IsMeleeBusy() and self.IsKicking == false and CurTime() > self.MeleeCD and self:HasEnemy() then
	local Enemy = self:GetEnemy()
	
	if Enemy:GetPos():Distance(self:GetPos()) < self.MeleeDist and self:Visible(Enemy) then
	
	local trace = util.QuickTrace(self:GetPos() + self:GetUp()*25, self:GetAimVector()*100,self)
	
	if !trace.HitWorld then
	
	self:StartMeleeAttack()
	
	end end end
end
------------------------------------------------ 
function ENT:StartMeleeAttack()
    self.IsMeleeAttacking = true
    self:EmitSound("dbd/trapper/arm" .. math.random(1, 3) .. ".mp3", 80, 100)
    self.MeleeDamageCD = CurTime() + 0.4
    self.RunSpeed = self.DefaultRunSpeed + self.BloodlustSpeedAdd * self.BloodLustLevel
    self.WalkSpeed = self.DefaultRunSpeed + self.BloodlustSpeedAdd * self.BloodLustLevel
    self.WalkSpeed = self.WalkSpeed + self.LungeSpeedAdd
    self.RunSpeed = self.RunSpeed + self.LungeSpeedAdd
    if self:LookupSequence("swing") ~= -1 then
        self:AddGestureSequence(self:LookupSequence("swing"))
    end
    self.EndMeleeCD = CurTime() + self.LungeTime
end
------------------------------------------------   
function ENT:EndMeleeAttack()
    if self:LookupSequence("swing") != -1 then
        self:ResetSequence("swing")
    end
    self.IsMeleeAttacking = false
end

------------------------------------------------   
function ENT:MissMeleeAttack()
	if CurTime() > self.EndMeleeCD and self.IsMeleeAttacking == true then
	self:EndMeleeAttack()
	self.OpenCD = CurTime() + 3
	self.MeleeCD = CurTime() + 2
	self:Custom_PlaySequence("Miss",1)
	self.RunSpeed = self.DefaultRunSpeed 
	self.WalkSpeed = self.DefaultRunSpeed
	self:ResetBloodLust()
	self:EmitSound("dbd/trapper/swing"..math.random(1,3)..".mp3",80,100)
	self:DoPropDamage()
	self.IsWiping = true
	timer.Simple(2,function() if IsValid(self) then self.IsWiping = false end end)
	end
end
------------------------------------------------   
function ENT:DoMeleeDamage()
    if self.IsMeleeAttacking == true and CurTime() > self.MeleeDamageCD then
        for k,v in pairs(ents.FindInSphere(self:GetPos() + self:GetAimVector()*20, self.MeleeAttackRange)) do 
            if v:IsNPC() or v:IsPlayer() or v:IsNextBot() then
                if self:Disposition(v) == D_HT then
                    self:DoPropDamage()
                    self.IsWiping = true
                    self.MeleeDamageCD = CurTime() + 1
                    self.OpenCD = CurTime() + 3.5
                    self:ResetBloodLust()
                    self.RunSpeed = self.DefaultRunSpeed - self.MeleeHitSpeedDecrease
                    self.WalkSpeed = self.DefaultRunSpeed - self.MeleeHitSpeedDecrease
                    
                    if self:LookupSequence("hit") ~= -1 then
                        local gestureID = self:AddGestureSequence(self:LookupSequence("hit"))
                        
                        self.RunAnimRate = math.min(0.15, self.MeleeHitSpeedDecrease * 0.0012)
                        self.WalkAnimRate = math.min(0.15, self.MeleeHitSpeedDecrease * 0.0012)
                        self:EndMeleeAttack()
                        self:EmitSound("dbd/trapper/swing" .. math.random(1, 3) .. ".mp3", 80, 100)
                        self.MeleeCD = CurTime() + 2.5
                        self:DoImpactSound()
                        local dmg = DamageInfo()
                        dmg:SetDamage(self.MeleeDamage)
                        dmg:SetAttacker(self)
                        dmg:SetDamageType(DMG_SLASH)
                        dmg:SetInflictor(self)
                        v:TakeDamageInfo(dmg)
                        
                        timer.Simple(1.8, function() 
                            if IsValid(self) and self.IsWiping == true then
                                self:EmitSound("dbd/trapper/clean" .. math.random(1, 2) .. ".mp3", 70, 100)
                            end 
                        end)
                        
                        timer.Simple(2.5, function() 
                            if IsValid(self) then
                                self.RunSpeed = self.DefaultRunSpeed
                                self.WalkSpeed = self.DefaultRunSpeed
                                self.RunAnimRate = 1
                                self.WalkAnimRate = 1
                                self:RemoveGesture(gestureID)
                                self.IsWiping = false
                            end 
                        end)
                    end
                end
            end
        end
    end
end

------------------------------------------------
function ENT:DoImpactSound()
	if CurTime() > self.ImpactSoundCD then
	self:EmitSound("dbd/trapper/impact"..math.random(1,3)..".mp3",80,100)
	end
end
------------------------------------------------   
function ENT:DoPropDamage()
	for k,v in pairs(ents.FindInSphere(self:GetPos() + self:GetAimVector()*20,self.MeleeAttackRange*1.5)) do
	local proptbl = {
	func_glass = true,
	prop_physics = true,
	prop_dynamic = true,
	func_breakable = true,
	func_breakable_surf = true
	}
	
	if proptbl[v:GetClass()] and v:Health() > 0 then
	local dmgprop = DamageInfo()

	dmgprop:SetDamage(self.MeleeDamage)
	dmgprop:SetAttacker(self)
	dmgprop:SetDamageType(DMG_SLASH)
	dmgprop:SetInflictor(self)
	v:TakeDamageInfo(dmgprop)
	
	end


	end
end
------------------------------------------------  
function ENT:OnTookDamage(dmg, hitgroup) 

	if dmg:GetDamageType() == DMG_CRUSH and CurTime() > self.StunCD and self.IsKicking == false then
	self.PlacingTrap = false
	self.StunCD = CurTime() + 5
	self:Custom_PlaySequence("Stun",1)
	self:EndMeleeAttack()
	self:RemoveGesture("hit")
	self.RunSpeed = self.DefaultRunSpeed
	self.WalkSpeed = self.DefaultRunSpeed
	self:ResetBloodLust()
	self.TrapPlaceCD = CurTime() + self.TrapPlaceCDAdd + 3
	self.MeleeCD = CurTime() + 2.8
	self:StopCustomSounds()
	self:StunSoundCode()


	
	end
end
------------------------------------------------ 
function ENT:StunSoundCode()
	if self.StunSet == 1 and CurTime() > self.StunSoundCD then
	
	self.StunSoundCD = CurTime() + 1
	self.StunSet = 2
	self.StunSound = CreateSound( self, "dbd/trapper/stun"..math.random(1,2)..".mp3" )
	self.StunSound:SetSoundLevel(70)
	self.StunSound:PlayEx(1,100)
	
	end


	if self.StunSet == 2 and CurTime() > self.StunSoundCD then
	
	self.StunSoundCD = CurTime() + 1
	self.StunSet = 1
	self.StunSound = CreateSound( self, "dbd/trapper/stun"..math.random(3,4)..".mp3" )
	self.StunSound:SetSoundLevel(70)
	self.StunSound:PlayEx(1,100)
	
	end	
end
------------------------------------------------  
function ENT:OnPossessed() 
	self.TrapPlaceCDAdd = math.max(1,self.TrapPlaceCDAdd*0.5)
	self.RunSpeed = self.DefaultRunSpeed
	self.WalkSpeed = self.DefaultRunSpeed
	
	self:CancelLockerSearch()
	self.CancelLockerSearchCD = 0
	self.Locker = nil
	
	local ply = self:GetPossessor()
	ply:SetCanZoom(false)
	ply:PrintMessage(3,"[JUMP (Default : Spacebar)] to jump")
	ply:PrintMessage(3,"[ATTACK1 (Default : Left click)] to Melee Attack")
end
------------------------------------------------  
function ENT:OnDispossessed(old)
	old:SetCanZoom(true)
end
------------------------------------------------  
function ENT:OnRemove()
	if IsValid(self.Locker) then
	self.Locker:SetNWBool('DBDLocker_Targeted',false)
	end
	
	self:StopCustomSounds()
end
------------------------------------------------  
function ENT:StopCustomSounds() 
	self:Custom_StopSound(self.BreathSound)
	self.BreathCD = CurTime() + math.random(3,4)
	self.BreathSet = 1
end
------------------------------------------------  
function ENT:Custom_StopSound(sound) 
	if sound then sound:Stop()
	end
end
------------------------------------------------
 function ENT:OnLastEnemy(ent)
	self.GiveUpPatrolCD = CurTime() + 5
	self.RandomPlayerCD = CurTime() + math.random(15,25)
	self.RunSpeed = self.RunSpeed - self.BloodlustSpeedAdd*self.BloodLustLevel
	self.WalkSpeed = self.WalkSpeed - self.BloodlustSpeedAdd*self.BloodLustLevel
	self.BloodLustLevel = 0
	self.BloodLustCD = CurTime() + self.BloodlustTime + 3
	
	-------- Locker Actions ----------------
		if ent:IsPlayer() and ent:InVehicle() then
		local veh = ent:GetVehicle()
		if ent:Visible(self) then
		
			self:HuntPlayerLockerVisible(ent,veh)

		
		else
		self:HuntPlayerLockerGuess(ent,veh)
		end
		
	end
	
end
------------------------------------------------
 function ENT:HuntPlayerLockerVisible(ent,veh)
	if veh:GetModel() == "models/dbd/dbdnb_entities/dbd_locker.mdl" then
		local cancelcd = math.random(7,10)
			self.CancelLockerSearchCD = CurTime() + cancelcd
			self.GiveUpPlayerLockerCD = CurTime() + cancelcd
			local plycd = math.Round(self.RandomPlayerCD-CurTime(),0)
			self.RandomPlayerCD = CurTime() + plycd + 6
			
			self.OpenCD = CurTime() + 2
			self.FindCD = CurTime() + 1
			self.LockerCD = CurTime() + 6
			
			self.Locker = veh
			self.SearchingLocker = true
			self.Locker:SetNWBool('DBDLocker_Targeted',true)
			self:RemovePatrol(self:GetPatrol())

			
			local attach = veh:GetAttachment(6)
			self:RemovePatrol(self:GetPatrol())
			self:CallInCoroutine(function() self:GoTo(attach.Pos,1,function() if CurTime() > self.CancelLockerSearchCD  then return false end end) end)
			debugoverlay.Sphere(attach.Pos, 25, 8, Color( 125, 255, 255 ),true )
	end
end
 ------------------------------------------------
 function ENT:HuntPlayerLockerGuess(ent,veh)
	if veh:GetModel() == "models/dbd/dbdnb_entities/dbd_locker.mdl" then
		if table.Count(ents.FindByClass("prop_vehicle_prisoner_pod")) != 0 then
		for k,v in RandomPairs(ents.FindByClass("prop_vehicle_prisoner_pod")) do
			if v:GetPos():Distance(ent:GetPos()) < 600 and v:GetNWBool('DBDLocker_Targeted',false) != true then
			self.FindCD = CurTime() + 1
			self.Locker = v
			
			self.OpenCD = CurTime() + 2
			self.Locker:SetNWBool('DBDLocker_Targeted',true)
			self:RemovePatrol(self:GetPatrol())
			self.CancelLockerSearchCD = CurTime() + 10
			local plycd = math.Round(self.RandomPlayerCD-CurTime(),0)
			self.RandomPlayerCD = CurTime() + plycd + 6
			end
		end
	
		else
		self.LockerCD = CurTime() + 6
	end
	end
end
------------------------------------------------
end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)
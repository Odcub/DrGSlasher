-------------- Locker Entity --------------

local function AddVehicle( t, class )
	list.Set( "Vehicles", class, t )
end

AddVehicle( {
	Name = "Locker",
	Model = "models/dbd/dbdnb_entities/dbd_locker.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = "Dead By Daylight Nextbots",

	Author = "JMAR",
	Information = "Lockers to hide in",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "1"
	},
	Members = {
		HandleAnimation = HandlePHXSeatAnimation,
	}

}, "Locker" )

--------- Locker Hooks --------------
local function IsInLocker(ply,veh)
	
	if veh:GetClass() == "prop_vehicle_prisoner_pod" and veh:GetModel() == "models/dbd/dbdnb_entities/dbd_locker.mdl" then
	return true 
	end

end

hook.Add("PhysgunDrop", "DBD_LockerSetUpRight" ,function(ply,veh)
		if veh:GetModel() == "models/dbd/dbdnb_entities/dbd_locker.mdl" then
		local ang = veh:GetAngles()
		veh:SetAngles(Angle(0,ang.y,0))
		
		local phys = veh:GetPhysicsObject()
		if IsValid(phys) then
		phys:EnableMotion(false)
		end
	end
end) 

hook.Add("PlayerSpawnedVehicle", "DBD_LockerSetUpRightSpawn" ,function(ply,veh)
		if veh:GetModel() == "models/dbd/dbdnb_entities/dbd_locker.mdl" then
		veh:SetNWBool('DBDLocker_Targeted',false)
		veh.IsDBDItem = true
		local ang = veh:GetAngles()
		veh:SetAngles(Angle(0,ang.y,0))
		local phys = veh:GetPhysicsObject()
		if IsValid(phys) then
		phys:EnableMotion(false)
		end 
	end
end) 

hook.Add("PlayerEnteredVehicle", "DBD_TriggerLockerEnterAnimation" ,function(ply,veh,role)
	if veh:GetModel() == "models/dbd/dbdnb_entities/dbd_locker.mdl" then
	veh:ResetSequence(11)
	veh:SetSequence(11)
	print("AAA")
	ply:AddFlags(FL_NOTARGET)
	veh:SetNWBool('DBDLocker_RecentlySearched',false)
	timer.Remove("DBD_LockerJM_"..veh:EntIndex())
	end 
end) 

hook.Add("PlayerLeaveVehicle", "DBD_TriggerLockerLeaveAnimation" ,function(ply,veh,role)
	veh:ResetSequence(11)
	veh:SetSequence(11)
	ply:RemoveFlags(FL_NOTARGET)
	veh:SetNWBool('DBDLocker_RecentlySearched',false)
	timer.Remove("DBD_LockerJM_"..veh:EntIndex())
end) 

hook.Add("CalcMainActivity", "DBD_LockerPlayerAnimation" ,function(ply)
	if ply:InVehicle() then
	local veh = ply:GetVehicle()

		if IsInLocker(ply,veh) then
		
		return ACT_DRIVE_POD, 3
		
		end

	end
end)

---------------- Killer Interaction ---------------

local vmeta = FindMetaTable( "Vehicle" )

function vmeta:SearchEmpty(bot)
	bot.StunCD = CurTime() + 2
	self:SetNWBool('DBDLocker_RecentlySearched',true)
	self:ResetSequence(4)
	timer.Create( "DBD_LockerJM_"..self:EntIndex(), math.random(45,60), 1, function() self:SetNWBool('DBDLocker_RecentlySearched',false) end )	
end

function vmeta:SearchFound(bot)
	bot.StunCD = CurTime() + 4
	self:SetNWBool('DBDLocker_RecentlySearched',true)
	self:ResetSequence(5)
	timer.Create( "DBD_LockerJMFOUND_"..self:EntIndex(),2, 1, function() if IsValid(self:GetDriver()) and IsValid(bot) then
	self:GetDriver():Kill()
	end end )
end
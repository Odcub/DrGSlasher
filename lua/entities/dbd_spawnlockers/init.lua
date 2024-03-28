AddCSLuaFile( "shared.lua" )
include('shared.lua')

-- Misc --
ENT.PrintName = "Locker Populator"

function ENT:Initialize()
	
	timer.Simple(0.1,function() if IsValid(self) then
	local Creator = self:GetCreator()
	local spcorners = 4
	local mindist = 80
		if IsValid(Creator) then
		spcorners = Creator:GetInfoNum( "dbdnb_lockercorner", 1 )
		mindist = Creator:GetInfoNum( "dbdnb_lockermindist", 1 )
		end
	
	--------- Remove Pre existing populated lockers ----------
	
	for k,v in pairs(ents.FindByClass("dbd_spawnlockers")) do
		if v != self then
		v:Remove()
		end
	end
	
	for k,v in pairs(navmesh.GetAllNavAreas()) do
	local hidingspots = v:GetHidingSpots(1)
	if !v:IsBlocked(0,false) and v:GetSizeY() > 85 and v:GetSizeX() > 85 and table.Count(hidingspots) != 0 then
	
	for count = 1, math.max(1,math.min(spcorners,table.Count(hidingspots))),1 do
	local vec1 = v:GetCenter()
	local vec2 = hidingspots[count]

	for k,v in pairs(ents.FindByClass("prop_vehicle_prisoner_pod")) do
		if vec2:Distance(v:GetPos()) <= math.max(10,mindist) then
		v:Remove()
		end
	end



	local ent = ents.Create("prop_vehicle_prisoner_pod")
	ent:SetModel("models/vehicles/prisoner_pod_inner.mdl")
	ent:SetAngles(( vec1 - vec2 ):Angle())
	ent.IsDBDItem = true
	ent:Spawn()
	ent:SetModel("models/dbd/dbdnb_entities/dbd_locker.mdl")
	
	ent:SetPos(vec2)
	ent:SetOwner(self)
	ent:SetKeyValue("vehiclescript","scripts/vehicles/prisoner_pod.txt")
	ent:SetKeyValue("limitview",1)

			local phys = ent:GetPhysicsObject()
			if IsValid(phys) then
			phys:EnableMotion(false)
			end
			
		local attach = ent:GetAttachment(8)
		ent:SetPos(attach.Pos)
		
		
local tr = util.TraceHull( {
	start = ent:GetPos(),
	endpos = ent:GetPos() + ent:GetUp()*50,
	filter = ent,
	mins = Vector( -10, -10, 1 ),
	maxs = Vector( 10, 10, 50 ),
	mask = MASK_PLAYERSOLID
} ) 

		if tr.Hit then
		ent:Remove()
		else debugoverlay.Sphere( ent:GetPos(), 33, 8, Color( 255, 255, 255 ), true)
		end
		
	
	for k,v in pairs(ents.FindByClass("prop_door*")) do
			if ent:GetPos():Distance(v:GetPos()) < 100 then
			ent:Remove()
		end
	end
	
	for k,v in pairs(ents.FindByClass("func_door*")) do
			if ent:GetPos():Distance(v:GetPos()) < 100 then
			ent:Remove()
		end
	end
		
	end


	end
	end
	
	end end)
end



function ENT:OnRemove()

for k,v in pairs(ents.FindByClass("prop_vehicle_prisoner_pod"))

	do 
		if v:GetOwner() == self then
		v:Remove()
		end
	end
end
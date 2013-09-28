include("shared.lua")
AddCSLuaFile"shared.lua"
AddCSLuaFile"cl_init.lua"
local meshes = {}
local targetpoint = nil
local function selectpoint(ent)
	if not ValidEntity(targetpoint) then
		repeat
			if table.Count(meshes) == 0 then
				targetpoint = ent
				break
			end
			targetpoint = table.Random(meshes)
			if not ValidEntity(targetpoint) and targetpoint ~= nil then
				meshes[targetpoint] = nil
			end
		until ValidEntity(targetpoint)
		if targetpoint ~= ent then
			return selectpoint(ent)
		end
	elseif not ValidEntity(targetpoint._corners.n) then
		targetpoint._corners.n = ent
		ent._corners.s = targetpoint
		ent.target = targetpoint
		ent.targetpoint = Vector(100,0,0)
	elseif not ValidEntity(targetpoint._corners.e) then
		targetpoint._corners.e = ent
		ent._corners.w = targetpoint
		ent.target = targetpoint
		ent.targetpoint = Vector(0,100,0)
	elseif not ValidEntity(targetpoint._corners.s) then
		targetpoint._corners.s = ent
		ent._corners.n = targetpoint
		ent.target = targetpoint
		ent.targetpoint = Vector(-100,0,0)
	elseif not ValidEntity(targetpoint._corners.w) then
		targetpoint._corners.w = ent
		ent._corners.e = targetpoint
		ent.target = targetpoint
		ent.targetpoint = Vector(0,-100,0)
	else
		targetpoint = nil
		return selectpoint(ent)
	end
end
function ENT:SpawnFunction( ply, tr )
	if not tr.Hit then return end
	local ent = ents.Create("sent_mesh")
	ent:SetPos( tr.HitPos + tr.HitNormal * 50--
	)
	ent:Spawn()
	ent:Activate()
	ent._corners = {}
	selectpoint(ent)
	meshes[ent] = ent
	if ent.targetpoint and ValidEntity(ent.target) then
		ent:GetNeighbors(ent.target:GetPos()+ent.targetpoint)
	end
	local phys = ent:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(true)
		phys:Wake()
		ent:ToggleMotion()
	else
		ent:Remove()
		error"Mesh point spawned with no physics!"
	end
	return ent
end 

function ENT:Initialize()
	self:SetModel("models//props_junk/Rock001a.mdl")
	self:PhysicsInit( SOLID_VPHYSICS)
	self:SetMoveType( MOVETYPE_VPHYSICS)
	self:SetSolid( SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:DrawShadow(false)
	self.MovinTooFast = false
	self.ShadowParams = {}
end

function ENT:Use(activator,caller)
	if activator:IsPlayer() then
		self:ToggleMotion()
	end
end
function ENT:ToggleMotion()
	local phys = self:GetPhysicsObject()
	if not IsValid(phys) then return end
	if self.MovinTooFast then
		self:StopMotionController()
		phys:EnableGravity(true)
		phys:EnableMotion(false)
		self.MovinTooFast = nil
	else
		self:StartMotionController()
		phys:EnableGravity(false)
		phys:Wake()
		self.MovinTooFast = true
	end
end
local vector0 = Vector(0,0,0)
function ENT:GetNeighbors(pos)
	if not ValidEntity(self._corners.n) then
		for _,ent in ipairs(ents.FindInSphere(pos+Vector(100,0,0),5)) do
			if ent:GetClass() == self:GetClass() then
				self._corners.n = ent
				ent._corners.s = self
			end
		end
	end
	if not ValidEntity(self._corners.e) then
		for _,ent in ipairs(ents.FindInSphere(pos+Vector(0,100,0),5)) do
			if ent:GetClass() == self:GetClass() then
				self._corners.e = ent
				ent._corners.w = self
			end
		end
	end
	if not ValidEntity(self._corners.s) then
		for _,ent in ipairs(ents.FindInSphere(pos+Vector(-100,0,0),5)) do
			if ent:GetClass() == self:GetClass() then
				self._corners.s = ent
				ent._corners.n = self
			end
		end
	end
	if not ValidEntity(self._corners.w) then
		for _,ent in ipairs(ents.FindInSphere(pos+Vector(0,-100,0),5)) do
			if ent:GetClass() == self:GetClass() then
				self._corners.w = ent
				ent._corners.e = self
			end
		end
	end
end
function ENT:ConstrainNeighbors()
	if ValidEntity(self._corners.n) then
		constraint.Rope(self,self._corners.n,0,0,vector0,vector0,self:GetPos():Distance(self._corners.n:GetPos()),0,0,10,"cable/redlaser",true)
	end
	if ValidEntity(self._corners.e) then
		constraint.Rope(self,self._corners.e,0,0,vector0,vector0,self:GetPos():Distance(self._corners.e:GetPos()),0,0,10,"cable/redlaser",true)
	end
	if ValidEntity(self._corners.s) then
		constraint.Rope(self,self._corners.s,0,0,vector0,vector0,self:GetPos():Distance(self._corners.s:GetPos()),0,0,10,"cable/redlaser",true)
	end
	if ValidEntity(self._corners.w) then
		constraint.Rope(self,self._corners.w,0,0,vector0,vector0,self:GetPos():Distance(self._corners.w:GetPos()),0,0,10,"cable/redlaser",true)
	end
end
function ENT:PhysicsSimulate(phys,deltatime)
	phys:Wake()
	local pos = self:GetPos()
	if not (self.targetpoint and ValidEntity(self.target))then
	
		self:ToggleMotion()
		return
	end
	local target = self.target:GetPos() + self.targetpoint
	if math.floor(pos.x) == math.floor(target.x)
	and math.floor(pos.y) == math.floor(target.y)
	and math.floor(pos.z) == math.floor(target.z) then
		self:SetPos(target)
		self:ToggleMotion()
		if ValidEntity(self.target) then
			timer.Simple(0.01,function()
				self:GetNeighbors(self:GetPos())
				self:ConstrainNeighbors()
				self.targetpoint,self.target = nil,nil
			end)
		end
		return
	elseif self.PrevPos == pos then
		self:ToggleMotion()
		phys:EnableMotion(true)
		phys:Wake()
		print"ERROR ENTITY BLOCKED"
		return
	else
		self.PrevPos = pos
	end
	self.ShadowParams.secondstoarrive = 1 // How long it takes to move to pos and rotate accordingly - only if it _could_ move as fast as it want - damping and maxspeed/angular will make this invalid
	self.ShadowParams.pos = target // Where you want to move to
	self.ShadowParams.angle = Angle( 0, 0, 0 ) // Angle you want to move to
	self.ShadowParams.maxangular = 5000 //What should be the maximal angular force applied
	self.ShadowParams.maxangulardamp = 10000 // At which force/speed should it start damping the rotation
	self.ShadowParams.maxspeed = 1000000 // Maximal linear force applied
	self.ShadowParams.maxspeeddamp = 10000// Maximal linear force/speed before  damping
	self.ShadowParams.dampfactor = 0.2 // The percentage it should damp the linear/angular force if it reachs it's max ammount
	self.ShadowParams.teleportdistance = 0 // If it's further away than this it'll teleport (Set to 0 to not teleport)
	self.ShadowParams.deltatime = deltatime // The deltatime it should use - just use the PhysicsSimulate one
 
	phys:ComputeShadowControl(self.ShadowParams)

end
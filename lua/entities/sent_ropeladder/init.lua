include("shared.lua")
AddCSLuaFile"shared.lua"
AddCSLuaFile"cl_init.lua"
local other
function ENT:SpawnFunction( ply, tr )
	if not tr.Hit then return end
	local ent = ents.Create("sent_ropeladder")
	ent:SetPos( tr.HitPos)
	ent:Spawn()
	ent:Activate()
	local phys = ent:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(false)
	end
	if ValidEntity(other) then
		ent:SetDTInt(0,2);
		ent:SetDTEntity(0,other);
		other:SetDTEntity(0,ent);
		local pos = ents.Create("func_useableladder")
		pos:SetAngles(ent:GetAngles())
		pos:SetPos(ent:GetPos())
		pos:SetKeyValue("point0", tostring(ent:GetPos()))
		pos:SetKeyValue("point1", tostring(other:GetPos()))
		pos:SetParent(ent)
		pos:Spawn()
		pos:Activate()
		ent.ladder = pos
		ent.other = other
		other = nil
	else
		ent:SetDTInt(0,1);
		other = ent
	end
	return ent
end 
function ENT:Think()
	if (not IsValid(self.ladder)) then return end
	if (not IsValid(self.other)) then return end
	local opos = self.other:GetPos();
	local ipos = self:GetPos();
	if (opos == self.opos and ipos == self.ipos) then return end
	self.opos = opos;
	self.ipos = ipos;
	self.ladder:SetKeyValue("point1",tostring(opos - self:GetPos()));
end

function ENT:Initialize()
	self:SetModel("models//props_junk/Rock001a.mdl")
	self:PhysicsInit( SOLID_VPHYSICS)
	self:SetMoveType( MOVETYPE_NONE)
	self:SetSolid( SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:DrawShadow(false)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD);
	local phys = self:GetPhysicsObject();
	if IsValid(phys) then
		phys:SetDamping(0,10000);
	end
end

function ENT:Use(activator,caller)
	if self:GetMoveType() == MOVETYPE_VPHYSICS then
		self:SetMoveType(MOVETYPE_NONE)
	else
		self:SetMoveType(MOVETYPE_VPHYSICS)
	end
end
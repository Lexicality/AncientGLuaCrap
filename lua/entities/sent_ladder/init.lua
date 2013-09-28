AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')
function ENT:SpawnFunction ( ply, tr )
	if not tr.Hit then return end
	local ent = ents.Create("sent_ladder")
	ent:SetPos( tr.HitPos + tr.HitNormal * 1)
	ent:Spawn		()
	ent:Activate	()
	local phys = ent:GetPhysicsObject()
	if  phys:IsValid() then
		phys:EnableMotion(false)
	end
	return ent
end 

function ENT:Initialize()  
	self:SetModel( "models/props_c17/metalladder002d.mdl"    )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )   
	self:SetSolid( SOLID_VPHYSICS )      

	local phys = self:GetPhysicsObject()  	
	if (phys:IsValid()) then  		
		phys:Wake()
		phys:EnableMotion(false)
	end
	local pos = ents.Create("func_useableladder")
	pos:SetAngles(self:GetAngles())
	pos:SetPos(self:GetPos() + (self:GetForward() * 30) + Vector(0,0,22))
	pos:SetKeyValue("point0", tostring(self:GetPos() + (self:GetForward() * 30) + Vector(0,0,0)))
	pos:SetKeyValue("point1", tostring(self:GetPos() + (self:GetForward() * 30) + Vector(0,0,270)))
	pos:SetParent(self)
	pos:Spawn()
	pos:Activate()
	self.ladder = pos;
end

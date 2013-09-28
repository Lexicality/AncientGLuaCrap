--[[
	~ BLACK HOLE OF DOOOM ~
	~ Lexi ~
--]]
ENT.Type			= "anim"
ENT.Base			= "base_gmodentity"--"base_anim"

ENT.PrintName		= "Black Hole Of Doom"
ENT.Author			= "Lexi"
ENT.Contact			= ""
ENT.Purpose			= "To suck all matter into itself"
ENT.Instructions	= "Do not use under pain of being sucked into a black hole"

ENT.Spawnable		= true
ENT.AdminSpawnable	= true
ENT.RenderGroup		= RENDERGROUP_TRANSLUCENT;
ENT.Category		= "Lexi's Dev Stuff"

function ENT:SetupDataTables()
	self:DTVar("Int", 0, "mass");
end

local model, modelradius = "models/combine_helicopter/helicopter_bomb01.mdl", 28
local scale = modelradius * 100

if (CLIENT) then
--[[
	ENT.lastmass = 0;
	function ENT:Think()
		local m1, m2 = self.dt.mass, self.lastmass
		if (m1 ~= m2) then
			self.lastmass = m1;
			local num = m1 / scale;
			self:SetModelScale(Vector(num, num, num));
		end
	end
	--]]
	return;
end

local G = 6.67428e-5
local function gravity(mass1,mass2,dist)
	return G * mass1 * mass2 / dist * dist;
end
function ENT:Initialize()
	self:SetModel(model)
	self.dt.mass = modelradius;
	self:PhysicsInitSphere(self.dt.mass)
--	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)
	self:SetMaterial("models/debug/debugwhite")
	self:SetColor(0,0,0,255)
	local ent = self;
	self:SetOverlayText("- Black Hole -\nInternal Mass: " .. self.dt.mass);
--	hook.Add("Tick", "Black Hole Sucking: " .. self:EntIndex(), function() ent:Suck(); end);
end
--[[
function ENT:OnRemove()
	hook.Remove("Tick", "Black Hole Sucking: " .. self:EntIndex());
end
--]]
function ENT:Think()
	self:Suck();
--	self:NextThink(CurTime() + 0.1);
--	return true;
end

function ENT:Suck()
	local phys, mass, dir, pos, entpos, grav;
	pos = self:GetPos();
	mass = self.dt.mass;
	for _,ent in ipairs(ents.GetAll()) do
		phys = ent:GetPhysicsObject();
		if (phys:IsValid() and ent ~= self and not ent:IsWorld()) then
			entpos = ent:GetPos();
			grav = gravity(mass, phys:GetMass(), entpos:Distance(pos));
			dir = (entpos - pos):Normalize() * -grav;
			if (ent:IsPlayer()) then
				ent:SetVelocity(dir);
			else
				phys:AddVelocity(dir);
			end
			if (not phys:IsMoveable() and dir:LengthSqr() > 100000000) then
				phys:EnableMotion(true);
			end
		--	debugoverlay.Line(entpos, entpos + dir, 0.5);
		--	debugoverlay.Text(entpos, grav, 0.5);
		end
	end
end
function ENT:SpawnFunction( ply, tr )
	local ClassName = ClassName or "sent_blackhole"
	if not tr.Hit then return end
	local ent = ents.Create(ClassName)
	ent:SetPos( tr.HitPos + tr.HitNormal * 52)
	ent:Spawn()
	ent:Activate()
	return ent
end 
function ENT:PhysicsCollide(data)
	local ent = data.HitEntity;
--	print(ent);
	if (not(ent:IsValid() and ent ~= self and not ent:IsWorld())) then return; end
	local physobj = ent:GetPhysicsObject();
	if (not(physobj:IsValid())) then return end
	self.dt.mass = self.dt.mass + physobj:GetMass();
	--self:PhysicsInitSphere(self.dt.mass)
	if (ent:IsPlayer()) then
		ent:TakeDamage(200, self, self);
	else
		ent:Remove();
	end
	self:SetOverlayText("- Black Hole -\nInternal Mass: " .. self.dt.mass);
end
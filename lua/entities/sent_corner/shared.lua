ENT.Type			= "anim"
ENT.Base			= "base_gmodentity"

ENT.PrintName		= "Dynamic Box Corner"
ENT.Author			= "Lexi"
ENT.Contact			= "mwaness@gmail.com"
ENT.Purpose			= "Making finding box-based areas easier / Fun"
ENT.Instructions	= "press 'use' to print out coords. 'sprint+use' to change movetype."
ENT.Information		= "Spawn two to draw a dynamic box.\nPress 'use' on one to make it print informations.\nPress 'sprint' and 'use' on one to switch its movetype"
ENT.Category		= "Util"

ENT.Spawnable		= true
ENT.AdminSpawnable	= true
ENT.RenderGroup		= RENDERGROUP_TRANSLUCENT;

function math.DecimalPlaces(numb,places)
	return math.Round(numb*10^places)/10^places
end
if SERVER then
	AddCSLuaFile"shared.lua"
	AddCSLuaFile"cl_init.lua"
	resource.AddFile"materials/VGUI/entities/sent_corner.vtf"
	local other
	function ENT:SpawnFunction( ply, tr )
		if not tr.Hit then return end
		local ent = ents.Create("sent_corner")
		ent:SetPos( tr.HitPos --+ tr.HitNormal * 50--
		)
		ent:Spawn()
		ent:Activate()
		local phys = ent:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:EnableMotion(false)
		end
		if ValidEntity(other) then
			ent:SetNWEntity("other",other)
			other:SetNWEntity("other",ent)
			other = nil
		else
			other = ent
		end
		return ent
	end 

	function ENT:Initialize()
		self:SetModel("models//props_junk/Rock001a.mdl")
		self:PhysicsInit( SOLID_VPHYSICS)
		self:SetMoveType( MOVETYPE_NONE)
		self:SetSolid( SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:DrawShadow(false)
	end
	
	function ENT:Use(activator,caller)
		if not activator:IsPlayer() then return end
		if activator:KeyDown(IN_SPEED) then
			if self:GetMoveType() == MOVETYPE_VPHYSICS then
				self:SetMoveType(MOVETYPE_NONE)
			else
				self:SetMoveType(MOVETYPE_VPHYSICS)
			end
			return
		end
		local other = self:GetNWEntity"other"
		if not ValidEntity(other) then return end
		local pos = self:GetPos()
		local pos2 = other:GetPos()
		if pos.z < pos2.z then
			pos,pos2 = pos2, pos
		end
		local words = "top = Vector("..	math.DecimalPlaces( pos.x,4)..","..math.DecimalPlaces( pos.y,4)..","..math.DecimalPlaces( pos.z,4).."); "..
												"bottom = Vector("..math.DecimalPlaces(pos2.x,4)..","..math.DecimalPlaces(pos2.y,4)..","..math.DecimalPlaces(pos2.z,4)..");"
		activator:PrintMessage(HUD_PRINTCONSOLE,words)
		activator:SendLua("SetClipboardText'"..words.."'")
	end
	return
end
local rot = Vector(0, -90, 0)
local width = 10
local Laser = Material( "cable/redlaser" )
function ENT:Draw()
	self:DrawModel()
	local other = self:GetNWEntity"other"
	if not ValidEntity(other) then return end
	local pos = self:GetPos()
	local pos2 = other:GetPos()
	if (pos ~= self.pos1 or pos2 ~= self.pos2) then
		--self:SetRenderBounds(pos,pos2);
		self.pos1 = pos;
		self.pos2 = pos2;
	end
	render.SetMaterial( Laser )
	render.DrawBeam( 		pos,							Vector( pos.x,	pos2.y,	pos.z	), width, 0, 0, color_white )
	render.DrawBeam( 		pos,							Vector( pos2.x,	pos.y,	pos.z	), width, 0, 0, color_white )
	render.DrawBeam( 		pos,							Vector( pos.x,	pos.y,	pos2.z	), width, 0, 0, color_white )
	render.DrawBeam( 		pos2,							Vector( pos2.x,	pos2.y,	pos.z	), width, 0, 0, color_white )
	render.DrawBeam( 		pos2,							Vector( pos2.x,	pos.y,	pos2.z	), width, 0, 0, color_white )
	render.DrawBeam( 		pos2,							Vector( pos.x,	pos2.y,	pos2.z	), width, 0, 0, color_white )
	render.DrawBeam(Vector( pos.x, 	pos.y,	pos2.z	),		Vector( pos.x,	pos2.y,	pos2.z	), width, 0, 0, color_white )
	render.DrawBeam(Vector( pos.x,	pos.y,	pos2.z	),		Vector( pos2.x,	pos.y,	pos2.z	), width, 0, 0, color_white )
	render.DrawBeam(Vector( pos2.x,	pos.y,	pos2.z	),		Vector( pos2.x,	pos.y,	pos.z	), width, 0, 0, color_white )
	render.DrawBeam(Vector( pos.x,	pos2.y,	pos2.z	),		Vector( pos.x,	pos2.y,	pos.z	), width, 0, 0, color_white )
	render.DrawBeam(Vector( pos2.x,	pos2.y,	pos.z	),		Vector( pos.x,	pos2.y,	pos.z	), width, 0, 0, color_white )
	render.DrawBeam(Vector( pos2.x,	pos2.y,	pos.z	),		Vector( pos2.x,	pos.y,	pos.z	), width, 0, 0, color_white )
end
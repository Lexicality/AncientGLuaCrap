ENT.Type			= "anim"
ENT.Base			= "base_anim"

ENT.PrintName		= "Light/Dark checker"
ENT.Author			= "Lexi"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.Spawnable		= true
ENT.AdminSpawnable	= true
ENT.RenderGroup		= RENDERGROUP_TRANSLUCENT;
ENT.Category		= "Lexi's Dev Stuff"

if SERVER then
	AddCSLuaFile( "shared.lua" )
	AddCSLuaFile( "cl_init.lua" )
	function ENT:SpawnFunction( ply, tr )
		if not tr.Hit then return end
		local ent = ents.Create("sent_lightdark")
		ent:SetPos( tr.HitPos + tr.HitNormal * 50)
		ent:Spawn()
		ent:Activate()
		local phys = ent:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:EnableMotion(false)
		end
		return ent
	end 

	function ENT:Initialize()
		self:SetModel("models/props_junk/sawblade001a.mdl")
		self:PhysicsInit( SOLID_VPHYSICS)
		self:SetMoveType( MOVETYPE_VPHYSICS)
		self:SetSolid( SOLID_VPHYSICS)
		self:DrawShadow(false)
	end
	return
end
local rot = Vector(0, -90, 0)
surface.CreateFont("Impact",{size=30,weight=400,font="Impact"})
function ENT:Draw()
	--self:DrawModel()
	local lightdata = render.GetLightColor(self:GetPos())
	cam.Start3D2D(self:GetPos(), self:GetAngles() ,0.5)
		surface.SetTextColor(0,0,0,255)
		surface.SetDrawColor(127,127,127,255)
		local word = "Light"
		if lightdata.r < 0.5 and lightdata.b < 0.5 and lightdata.g < 0.5 then
		surface.SetTextColor(255,255,255,255)
			word = "Dark"
		end
		surface.SetFont("Impact")
		local a,b = surface.GetTextSize(word)
		surface.SetTextPos(-a/2,-b/2)
		surface.DrawRect(-25,-25,50,50)
		surface.DrawText(word)
	cam.End3D2D()
end
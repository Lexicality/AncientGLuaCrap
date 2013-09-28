ENT.Type			= "anim"
ENT.Base			= "base_anim"--base_gmodentity"

ENT.PrintName		= "Prizedraw"
ENT.Author			= "Lexi"
ENT.Contact			= ""
ENT.Purpose			= "An excessively complicated way of choosing a number."
ENT.Instructions	= "Numpad enter to dispense, then use twice."

ENT.Spawnable		= true
ENT.AdminSpawnable	= true
ENT.RenderGroup		= RENDERGROUP_TRANSLUCENT;
ENT.Category		= "Lexi's Dev Stuff"
NUMBER_OF_TICKETS	= 827
if SERVER then
	AddCSLuaFile( "shared.lua" )
	AddCSLuaFile( "cl_init.lua" )
	function ENT:SpawnFunction( ply, tr )
		if not tr.Hit then return end
		--[[
		local ent = ents.Create("prop_dynamic")
		ent:SetPos( tr.HitPos + tr.HitNormal * 50)
		ent:SetModel"models/props_combine/combine_dispenser.mdl"
		ent:Spawn()
		ent:Activate()
		local phys = ent:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:EnableMotion(false)
		end
		--]]
		local ont = ent
		ent = ents.Create"sent_prizedraw"
		ent:SetPos( tr.HitPos + tr.HitNormal * 50)
		ent:SetAngles(Angle(-90, 180+math.NormalizeAngle(ply:GetAngles().y), 180))
		ent:Spawn()
		ent:Activate()
		return ent
	end 

	function ENT:Initialize()
		self:SetModel("models/weapons/w_c4_planted.mdl")
		self:PhysicsInit( SOLID_VPHYSICS)
		self:SetMoveType( MOVETYPE_VPHYSICS)
		self:SetSolid( SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:DrawShadow(false)
		local phys = ent:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:EnableMotion(false)
		end
		local w = ""
		local n = math.random(NUMBER_OF_TICKETS)/100000
		for i=1,6 do
			local f = math.floor(n)
			w = w..f
			n = n - math.floor(n)
			n = n * 10
		end
		self:SetNWString("number",w)
	end
			
	return
end
surface.CreateFont("breachtxt", {font="Lucida Console",size=15,weight=400})
function ENT:Draw()
	self:DrawModel()
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Up(), -90)
	cam.Start3D2D(self:GetPos() + self:GetUp() * 8.8, ang ,0.1)
		surface.SetTextColor(255,0,0,math.abs(math.sin(CurTime()*7)*255))
		surface.SetFont("breachtxt")
		surface.SetTextPos(20,-38)
		surface.DrawText(self:GetNWString"number")
	cam.End3D2D()
end
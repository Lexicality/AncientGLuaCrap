ENT.Type			= "anim"
ENT.Base			= "base_anim"--base_gmodentity"

ENT.PrintName		= "Texture Example"
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
		local ent = ents.Create("sent_example")
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
		self:SetModel("models//props_lab/clipboard.mdl")
		self:PhysicsInit( SOLID_VPHYSICS)
		self:SetMoveType( MOVETYPE_VPHYSICS)
		self:SetSolid( SOLID_VPHYSICS)
		--self:DrawShadow(false)
	end
	return
end
function math.DecimalPlaces(numb,places)
	return math.Round(numb*10^places)/10^places
end
--[[
local rot = Vector(0, 90, 0)
surface.CreateFont("Impact",30,400,true,false,"Impact")
local camdata = {
    origin = Vector(0,0,100),
    angles = Angle(0,0,0),
    x = 0,
    y = 0,
    w = 200,
    h = 200,
    drawhud = true,
}
local tex = surface.GetTextureID"sprites/640hud5"
local tex = surface.GetTextureID"Animarrowdown"
local tex = surface.GetTextureID"lift/shinyfuckingarrow"
--[[
local poly = {
	{ x = -5, y = -5, u = 0.71, v = 0.285},
	{ x =  5, y = -5, u = 0.71, v = 0.24},
	{ x =  5, y =  5, u = 0.9, v = 0.24},
	{ x = -5, y =  5, u = 0.9, v = 0.285}
}
--]
local poly = {
	{ x =  4, y = -4, u = 0.71,	v = 0.24},
	{ x =  4, y =  4, u = 0.71,	v = 0.285},
	{ x = -4, y =  4, u = 0.9,	v = 0.285},
	{ x = -4, y = -4, u = 0.9,	v = 0.24},
}
local w,h,ang,word
function ENT:Draw()
	--self:DrawModel()#
	ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Up(),90)
	cam.Start3D2D(self:GetPos(), ang ,0.25)	
		surface.SetDrawColor(200,200,200,255)
		surface.DrawRect(-18,-8,26,37);
		surface.SetDrawColor(0,0,0,255);
		surface.DrawRect(-15,-5,20,11);	
		surface.SetDrawColor(100,100,100,255);
		surface.DrawOutlinedRect(-16,-6,22,13);
		--surface.SetDrawColor(255,0,0,255)
		surface.SetDrawColor(255,255,255,255);
		surface.SetTexture(tex);
		surface.DrawTexturedRect(-4,-4,8,8);
		--surface.DrawPoly(poly);
		surface.SetTextColor(255,0,0,255);
		surface.SetFont"DefaultFixed";
		word = math.floor(CurTime() % 4) + 1
		w,h = surface.GetTextSize(word);
		surface.SetTextPos(-9-w/2,1-h/2);
		surface.DrawText(word);
	cam.End3D2D()
end
--]]
--[[
function ENT:Draw()
	self:DrawModel();
	cam.Start3D2D(self:GetPos(), self:GetAngles(),0.5)
        camdata.origin = LocalPlayer():EyePos();
        camdata.angles = LocalPlayer():EyeAngles();
        render.RenderView( camdata )
	cam.End3D2D();
end
--]]
--[[
function ENT:Draw()
	self:DrawModel()
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
--]]
--[[
function ENT:Draw()
	--self:DrawModel()
	cam.Start3D2D(self:GetPos(), self:GetAngles() ,1)
		surface.SetTextColor(0,0,0,255)
		surface.SetFont("Impact")
		local p = EyePos()
		local e = LocalPlayer():EyePos()
		local word = "Eyes"
		if p.x-e.x ~= 0 and p.y-e.y ~= 0 then
			word = "not eyes"
		end
		local a,b = surface.GetTextSize(word)
		surface.SetTextPos(-a/2,-b/2)
		surface.DrawText(word)
	cam.End3D2D()
end
--]]--[
function ENT:Draw()
	--self:DrawModel()
	cam.Start3D2D(self:GetPos(), self:GetAngles() ,1)
		surface.SetDrawColor(255,255,255,255)
		surface.DrawOutlinedRect(-10,-10,20,20)
		surface.SetDrawColor(255,0,0,255)
		surface.DrawRect(-10,-10,10,10)
		surface.DrawRect(0,0,10,10)
	cam.End3D2D()
end
--]]
--[[
local t = surface.GetTextureID"blib"
local w,h = 240,120
local f = { {x=-w/2,y=-h/2,u=0.025,v=0.002},{x=w/2,y=-h/2,u=0.985,v=0.001},{x=w/2,y=h/2,u=0.985,v=0.21},{x=-w/2,y=h/2,u=0.025,v=0.21}}
function ENT:Draw()
	--self:DrawModel()
	cam.Start3D2D(self:GetPos(), self:GetAngles() ,1)
		surface.SetDrawColor(255,255,255,255)
		surface.SetTexture(t)
		surface.DrawPoly(f)
--		surface.DrawTexturedRect(-w/2,-h/2,w,h)
		--[
		surface.DrawOutlinedRect(-w/2,-h/2,w,h)
		surface.SetDrawColor(255,0,0,255)
		surface.DrawRect(-w/2,-h/2,w/2,h/2)
		surface.DrawRect(0,0,w/2,h/2)
		--]
	cam.End3D2D()
end--]]
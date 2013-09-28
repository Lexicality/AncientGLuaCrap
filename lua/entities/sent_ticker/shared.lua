ENT.Type			= "anim"
ENT.Base			= "base_anim"--gmodentity"

ENT.PrintName		= "Ticker"
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
		local ent = ents.Create("sent_ticker")
		ent:SetPos( tr.HitPos + tr.HitNormal * 50)
		ent:Spawn()
		ent:Activate()
		return ent
	end 

	function ENT:Initialize()
		self:SetModel("models/props_wasteland/controlroom_monitor001b.mdl")
		self:PhysicsInit( SOLID_VPHYSICS)
		self:SetMoveType( MOVETYPE_VPHYSICS)
		self:SetSolid( SOLID_VPHYSICS)
		self:DrawShadow(true)
	--	self:SetColor(255,255,255,200)
		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:EnableMotion(false)
		end
		self.text = "Help me, help me. I am trapped inside a ticker factory and I can't get out. "
		self:SetNWString("txt", self.text)
		local i = 0
		timer.Create(self:EntIndex().."tick",0.5,0,function()
			local txt = self.text
			i = i + 1
			local len = txt:len()
			if i > len then
				i = 1
			end
			local t1 = txt:sub(1,i)
			local t2 = ""
			if i ~= len then
				t2 = txt:sub(i+1,-1)
			end
			--print(t1,t2,txt)
			self:SetNWString("txt", t2..t1)
		end)
	end
	function ENT:OnRemove()
		timer.Destroy(self:EntIndex().."tick")
	end
	return
end
function ENT:Initialize()
	--self:SetRenderBounds(Vector(-50,-50,-10),Vector(50,5,10))
end
local rot = Vector(-90, 90, 10)
local w,h = 200,160
--local w,h = 2000,2000
surface.CreateFont("ticker_font",{font="Lucinda Console",size=30,weight=400})
local mat = surface.GetTextureID"effects/tvscreen_noise003a"
function ENT:CheckTextLength(text)
	surface.SetFont("ticker_font")
	return surface.GetTextSize(text) > w - 5
end
function ENT:GetMaxTextLength(text)
	for i = text:len() -1,1,-1 do
		text = text:sub(1,-2)
		if not self:CheckTextLength(text) then
			return i
		end
	end
end
function ENT:Draw()
	self:DrawModel()
	--if true then return true end
	local lightdata = render.GetLightColor(self:GetPos())
	local ang = self:GetAngles()
--	ang.y = EyeAngles().y
	--[
	ang:RotateAroundAxis(ang:Right(), 	rot.x)
	ang:RotateAroundAxis(ang:Up(), 		rot.y)
	ang:RotateAroundAxis(ang:Forward(), rot.z)
	--]]
	cam.Start3D2D(self:GetPos() + self:GetUp() * -7.2 + self:GetForward() * 12 + self:GetRight()*-0.19, ang ,0.1)
		surface.SetDrawColor(150, 150, 150, 255)
		surface.DrawRect(-w/2,-h/2,w,h)
		----------------------------------------------------------------------------------------
		--[[
		surface.DrawOutlinedRect(-w/2		,-h/2		,w/10	,h/10)
		surface.DrawOutlinedRect( w/2-w/10	,-h/2		,w/10	,h/10)
		surface.DrawOutlinedRect(-w/2		, h/2-h/10	,w/10	,h/10)
		surface.DrawOutlinedRect( w/2-w/10	, h/2-h/10	,w/10	,h/10)
		surface.SetDrawColor	( 225		, 5			,5		, 255)
		surface.DrawRect		(-w/2		,-h/2		,w/20 	,h/20)
		surface.DrawRect		(-w/2+w/20	,-h/2+h/20	,w/20 	,h/20)
		surface.DrawRect		( w/2-w/20	,-h/2		,w/20 	,h/20)
		surface.DrawRect		( w/2-w/10	,-h/2+h/20	,w/20 	,h/20)
		surface.DrawRect		(-w/2		, h/2-h/20	,w/20 	,h/20)
		surface.DrawRect		(-w/2+w/20	, h/2-h/10	,w/20 	,h/20)
		surface.DrawRect		( w/2-w/10	, h/2-h/10	,w/20 	,h/20)
		surface.DrawRect		( w/2-w/20	, h/2-h/20	,w/20 	,h/20)
		--]]
		surface.SetTextColor(255,255,255,255)
		surface.SetFont("ticker_font")
		local txt = self:GetNWString("txt")
		txt = txt:sub(1,self:GetMaxTextLength(txt))
		local wt,ht = surface.GetTextSize(txt)
		surface.SetTextPos(-wt/2,h/2-ht)
		surface.DrawText(txt)
		--[
		do
			surface.SetDrawColor(255,255,255,255)
			local	h  = h/2-h/16
			local	w2 = w/4+w/8
			local	v  = 10
			for i = 0,w2-2 do
				local	ct  = CurTime()*10+i
				local	dt2 = math.rad(ct+1)*v
				local	dt  = math.rad(ct)  *v
				local	ct2 = math.sin(dt2)
						ct  = math.sin(dt )
				surface.DrawLine(-w/2+i+1,ct2*1.0*h/4	,-w/2+i, ct*0.5*h/4 - 1)
				surface.DrawLine(-w/2+i+1,ct2*0.5*h/4	,-w/2+i, ct*1.0*h/4 - 1)
				surface.DrawLine(-w/2+i+1,ct2*0.25*h/4	,-w/2+i, ct*0.5*h/4)
				surface.DrawLine(-w/2+i+1,ct2*0.5*h/4	,-w/2+i, ct*0.25*h/4)
			end
		end
		--]]
		surface.SetDrawColor(100,123,255,255)
		surface.DrawRect	(-w/2,			-h/8,		w/8, -1*math.abs((-1-math.sin(math.rad(CurTime()*30)))*h/4+h/8))
		surface.SetDrawColor(255,100,123,255)
		surface.DrawRect	(-w/2+w/8,		-h/8,		w/8, -h/16)
		surface.DrawRect	(-w/2+w/8,		-h/8-h/16,	w/8, -math.abs(math.cos(math.rad(CurTime()*20))*h/8+h/8))
		surface.SetDrawColor(124, 212, 012, 255)
		surface.DrawRect	(-w/2+w/8+w/8,	-h/8,		w/8, -h/8+h/16)
		surface.DrawRect	(-w/2+w/8+w/8,	-h/8-h/8+h/16,	w/8, -math.abs(math.cos(math.rad(CurTime()*40))*h/16+h/8))
		
		surface.SetDrawColor(225, 225, 225, 255)
		surface.DrawOutlinedRect(-w/2,h/2-30,w,30)
		surface.DrawOutlinedRect(-w/2,-h/2,w,h)
		surface.DrawOutlinedRect(-w/2,-h/2,w/4+w/8,h/2-h/8)
		surface.DrawOutlinedRect(-w/2,-h/8,w/4+w/8,2*h/8)
		surface.DrawOutlinedRect(-w/2, h/8,w/4+w/8,h/2-30-h/8)
		--[[
		local c = (math.cos(math.Deg2Rad(CurTime()*30))+1)*10
		surface.DrawPoly({{x=c*3,y=0},{x=c,y=c},{x=0,y=c*3},{x=-c,y=c},{x=-c*3,y=0},{x=-c,y=-c},{x=0,y=-c*3},{x=c,y=-c}})
		--]]
		--[[
		surface.SetDrawColor(255,255,255,100)
		surface.SetTexture(mat)
		surface.DrawTexturedRect(-w/2,-h/2,w,h)
		--]]
	
	cam.End3D2D()
end
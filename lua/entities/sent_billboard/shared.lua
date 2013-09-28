ENT.Type			= "anim"
ENT.Base			= "base_anim"--"base_gmodentity"

ENT.PrintName		= "Billboard"
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
		if not ( tr.Hit and IsValid(tr.Entity) and tr.Entity:GetModel():find"billboard") then return end
		local ent = ents.Create"sent_billboard"
		ent:SetPos( tr.Entity:GetPos() + tr.Entity:GetForward() * 3)
		ent:SetAngles( tr.Entity:GetAngles() )
		ent:Spawn()
		ent:Activate()
		local phys = ent:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:EnableMotion(false)
		end
		--ent:SetParent(tr.Entity)
		return ent
	end 

	function ENT:Initialize()
		self:SetModel"models/props_wasteland/interior_fence002d.mdl"
		self:PhysicsInit( SOLID_VPHYSICS)--NONE )
		self:SetMoveType( MOVETYPE_VPHYSICS)--NONE )
		self:SetSolid( SOLID_VPHYSICS)--NONE )
		--self:SetCollisionGroup(COLLISION_GROUP_WORLD)
		self:DrawShadow(false)
		self:SetNWString("bb_Text1","WARNING! Idiot in charge!")
		self:SetNWString("bb_Text2","He forgot to set the text!")
	end
	function ENT:SetText(line1,line2)
		self:SetNWString("bb_Text1",line1)
		self:SetNWString("bb_Text2",line2)
	end
	return
end
for i = 50,25,-1 do
	surface.CreateFont("bb"..i, {font="Impact", size=i*2, weight=400})
end
local rot = Vector(-90, 90, 0)
ENT.Scale	  = 0.5
ENT.Width	  = 225
ENT.Height	  = 122
ENT.ScreenPos = 0-- -2.6
ENT.BackgroundMaterial = surface.GetTextureID "paperboy"--"Brick/brickfloor001a"--
ENT.vals = {}
function ENT:Initialize()
	self.Width  = self.Width  * 1/self.Scale
	self.Height = self.Height * 1/self.Scale
end
function ENT:GetTextSize(text,pos,new,force)
	local w,h,n = 0,0,0
	if not self.vals[pos] or new then
		if force then
			surface.SetFont("bb"..force)
			w,h = surface.GetTextSize(text)
			n = force
		else
			for i = 50,25,-1 do
				n = i
				--surface.CreateFont("Trebuchet", i, 400, true,false, "bb"..i )
				surface.SetFont("bb"..i)
				w,h = surface.GetTextSize(text)
				if not (w and h) then
					error("wtf? ",w," ",h," ",n)
				end
				if w < self.Width - 5 then
					break
				end
			end
		end
		self.vals[pos] = {w,h,n}
	else
		w,h,n = self.vals[pos][1],self.vals[pos][2],force and force or self.vals[pos][3]
	end
	if not (w and h and n) then
		print(w,h,n)
	end
	return w,h,n
end
function ENT:CheckTextLength(text)
	surface.SetFont("bb25")
	return surface.GetTextSize(text) > self.Width - 5
end
function ENT:GetMaxTextLength(text)
	for i = text:len() -1,1,-1 do
		text = text:sub(1,-2)
		if not self:CheckTextLength(text) then
			return i
		end
	end
end
--local maxWidth = 21
function ENT:ProcessText(text,new,pos)
	if text == "" then text = " " end
	pos = pos or 1
	if self:CheckTextLength(text) then
		local text1,text2
		local maxWidth = self:GetMaxTextLength(text)
		text1,text2 = text:sub(1,maxWidth),text:sub(maxWidth+1,-1)
		if self:CheckTextLength(text2)then
			local maxWidth = self:GetMaxTextLength(text2)
			text2 = text2:sub(1,maxWidth)
		end
		local w1,h1,n1 = self:GetTextSize(text1,pos,new)
		local w2,h2,n2 = self:GetTextSize(text2,pos*2,new,n1)
		surface.SetFont("bb"..n1)
		if pos < 0 then
			surface.SetTextPos(w1 * -0.5, self.Height * -0.25 - h1 )
		else
			surface.SetTextPos(w1 * -0.5, self.Height *  0.25 - h1 )
		end
		surface.DrawText(text1)
		surface.SetFont("bb"..n2)
		if pos < 0 then
			surface.SetTextPos(w2 * -0.5,self.Height * -0.25)
		else
			surface.SetTextPos(w2 * -0.5,self.Height *  0.25)
		end
		surface.DrawText(text2)
	else
		local w1,h1,n1 = self:GetTextSize(text,pos,new)
		if pos < 0 then
			surface.SetTextPos(w1 * -0.5,self.Height * -0.25 - h1 * 0.5)
		else
			surface.SetTextPos(w1 * -0.5,self.Height *  0.25 - h1 * 0.5)
		end
		surface.DrawText(text)
	end	
end
function ENT:Think()
	if self.MyNextThink and self.MyNextThink > CurTime() then return end
	if self:GetNWString "bb_Text1" ~= self.text1 then
		self.text1 = self:GetNWString "bb_Text1"
		self.text1U = true
	end
	if self:GetNWString "bb_Text2" ~= self.text2 then
		self.text2 = self:GetNWString "bb_Text2"
		self.text2U = true
	end
	self.MyNextThink = CurTime() + 1
end
function ENT:Draw()
	--self:DrawModel()
	local pos = self:GetPos() + self:GetForward() * self.ScreenPos
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Right(), 	rot.x)
	ang:RotateAroundAxis(ang:Up(), 		rot.y)
	ang:RotateAroundAxis(ang:Forward(), rot.z)
--	self:SetRenderBounds(self.Width*-0.5
	cam.Start3D2D(pos, ang,self.Scale)
		--render.SuppressEngineLighting( true )
		surface.SetDrawColor(220, 220, 220, 255)
		surface.DrawRect(self.Width * -0.5,self.Height * -0.5,self.Width,self.Height)
		--[
		surface.SetDrawColor(225, 225, 225, 255)
		surface.SetTexture(self.BackgroundMaterial)
		surface.DrawTexturedRect(self.Width * -0.5,self.Height * -0.5,self.Width,self.Height)
		--]]
		--[[
		surface.SetDrawColor(0,0,0,255)
		surface.DrawLine(self.Width * -0.5,0,self.Width*0.5,0)
		surface.SetDrawColor(255,0,0,255)
		surface.DrawLine(self.Width * -0.5,self.Height *0.25,self.Width*0.5,self.Height *0.25)
		surface.DrawLine(self.Width * -0.5,self.Height *-0.25,self.Width*0.5,self.Height *-0.25)
		--]]
		surface.SetTextColor(0,0,0,255)
		self:ProcessText(self.text1,self.text1U,-1)
	--	surface.SetTextColor(0,255,0,255)
		self:ProcessText(self.text2,self.text2U,1)
		--render.SuppressEngineLighting( false )
	cam.End3D2D()

end
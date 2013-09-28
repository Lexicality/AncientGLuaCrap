ENT.Type			= "anim"
ENT.Base			= "base_anim"--"base_gmodentity"

ENT.PrintName		= "Scoreboard"
ENT.Author			= "Lexi"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.Spawnable		= true
ENT.AdminSpawnable	= true
ENT.RenderGroup		= RENDERGROUP_TRANSLUCENT;
ENT.Category		= "Lexi's Dev Stuff"

function math.DecimalPlaces(numb,places)
	return math.Round(numb*10^places)/10^places
end
if SERVER then
	AddCSLuaFile( "shared.lua" )
	AddCSLuaFile( "cl_init.lua" )
	function ENT:SpawnFunction( ply, tr )
		if not tr.Hit then return end
		local ent = ents.Create("sent_scoreboard")
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
		self:SetModel"models/props_wasteland/interior_fence002d.mdl"
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		--self.PhysgunDisabled = true
		--self.m_tblToolsAllowed = {}
		--self:SetCollisionGroup(COLLISION_GROUP_WORLD)
		self:DrawShadow(false)
	end
	return
end
for i = 50,25,-1 do
	surface.CreateFont("bb"..i, {font="Impact", size=i*2, weight=400})
end
local rot = Vector(-90, 90, 0)
ENT.Scale	  = 0.1
ENT.Width	  = 250 --225
ENT.Height	  = 122
ENT.ScreenPos = 1
ENT.White				= surface.GetTextureID "debug/env_cubemap_model"
ENT.BackgroundMaterial	= surface.GetTextureID "headarka"--"Brick/brickfloor001a"--
ENT.BackgroundLogo		= surface.GetTextureID "faintlinklogo"--"Brick/brickfloor001a"--
ENT.vals = {}
local lpl = NULL
function ENT:Initialize()
	lpl = LocalPlayer()
	self.Width  = self.Width  * 1/self.Scale
	self.Height = self.Height * 1/self.Scale
end
function ENT:CheckTextLength(text,width)
	return surface.GetTextSize(text,width) > width
end
function ENT:GetMaxTextLength(text,width)
	for i = text:len() -1,1,-1 do
		text = text:sub(1,-2)
		if not self:CheckTextLength(text,width) then
			return i
		end
	end
end
local words = {"#","Name                                                               ","Kills","Deaths","KDR","Captures","Time Played","Group         "}
local wordn = #words
local a = {}
local ran
local nopad = { [2]=true,[8]=true}
ENT.sort = 3
ENT.asc = false
function ENT:Draw()
	--self:DrawModel()
	local tr = lpl:GetEyeTrace()
	local pos = self:GetPos() + self:GetForward() * self.ScreenPos
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Right(), 	rot.x)
	ang:RotateAroundAxis(ang:Up(), 		rot.y)
	ang:RotateAroundAxis(ang:Forward(), rot.z)
--	self:SetRenderBounds(self.Width*-0.5
	cam.Start3D2D(pos, ang,self.Scale)
		--render.SuppressEngineLighting( true )
		--70,89,124,255

		local x,y = self.Width * -0.5,self.Height * -0.5
		local w,h = self.Width,self.Height
		surface.SetTexture(self.White)
		surface.SetDrawColor(70,89,124,255)
		surface.DrawRect(x,y,w,h)
		--print(x,y,w,h)
		
		surface.SetDrawColor(225, 225, 225, 255)
		surface.SetTexture(self.BackgroundMaterial)
		local tw,th = surface.GetTextureSize(self.BackgroundMaterial)
		h = th*2
		surface.DrawTexturedRect(x,y,w,h)
		surface.SetTexture(self.BackgroundLogo)
		x = x + self.Width / 32
		local tw,th = surface.GetTextureSize(self.BackgroundLogo)
		w = tw*2
		surface.DrawTexturedRect(x,y,w,h)
		--[[
		-- Hee hee
		surface.SetTextColor(255,255,255,255)
		surface.SetFont"bb50"
		surface.SetTextPos(x+w+30,y+h/2-20)
		surface.DrawText"sucks"
		--]]
		surface.SetDrawColor(0,0,0,255)
		y = y + self.Height / 32 + 244
		w = self.Width - 2 * self.Width / 32
		h = self.Height - (244 + 2 * self.Height / 32)
		surface.DrawRect(x,y,w,h)
		surface.SetDrawColor(200,200,255,255)
		x = x + 10--20
		y = y + 10--20
		w = w - 20--40
		h = h - 20--40
		surface.DrawRect(x,y,w,h)
		surface.SetDrawColor(0,0,0,255)
		surface.SetTextColor(0,0,0,255)
		surface.SetFont("bb40")	
		x = x + 10
		local bx = x
		local px,py,hilight
		if ran and tr.Entity == self then -- and not lpl.KeyOnce and lpl:KeyDown(IN_USE) then
			px,py = tr.Entity:WorldToLocal(tr.HitPos).y * 10, tr.Entity:WorldToLocal(tr.HitPos).z * -10
			for i,d in pairs(a) do
				if  px > d[3] - 10 and px < d[3] + d[1] + 20 and
					py > d[4] and py < d[4] + h then
					hilight = i
					if not lpl.KeyOnce and lpl:KeyDown(IN_USE) then
						if self.sort ~= i then
							self.sort = i
						else
							self.asc = not self.asc
						end
						lpl.KeyOnce = true
					end
				end
			end
		end
		for i,word in ipairs(words) do
			local tw,th = surface.GetTextSize(word)
			if not ran then
				a[i] = {tw,th,x,y}
			end
			if i == self.sort then
				surface.SetDrawColor(0,0,0,100)
				surface.DrawRect(x-10,y,tw+20,h)
				surface.SetDrawColor(0,0,0,255)
			end
			if hilight == i then
				surface.SetDrawColor(0,0,0,50)
				surface.DrawRect(x-10,y,tw+20,h)
				surface.SetDrawColor(0,0,0,255)
			end
			surface.SetTextPos(x,y)
			if i == 2 then
				word = "Name"
			end
			surface.DrawText(word)
			x = x + 10 + tw
			if i < wordn then
				surface.DrawRect(x,y,10,h)
				x = x + 20
			end
		end
		x = bx
		local tw,th = surface.GetTextSize("#")
		surface.DrawRect(x-10,y + th,w,10)
		ran = true
		y = y + th + 10
		surface.SetFont"bb30"
		local i = 1
		local b = {}
		for _,ply in ipairs(player.GetAll()) do
			local name,width = ply:Name(),a[2][1]
			if self:CheckTextLength(name,width) then
				name = name:sub(1,self:GetMaxTextLength(name,width)).."..."
			end
			b[i] = {i, name, ply:Frags(), ply:Deaths(),
					math.DecimalPlaces((ply:Frags() ~= 0 and ply:Frags() or 1) / (ply:Deaths() ~= 0 and ply:Deaths() or 1),2),
					ply:GetNWInt"Captures", string.ToMinutesSeconds(ply:GetNWInt"Time_Played"), ply:GetNWString("usergroup","User")
					}
			i = i + 1
		end
		table.sort(b,function(a,b) if self.asc then return a[self.sort] < b[self.sort] else return a[self.sort] > b[self.sort] end end)
		for i,v in pairs(b) do
			v[1] = i 
			if i > 10 then
				b[i] = nil
			end
		end
		for k,data in pairs(b) do
			for i,word in pairs(data) do
				local tw,th = surface.GetTextSize(word)
				local p = 0
				if not nopad[i] then
					p = (a[i][1] - tw) /2
				end
				x = x + p
				surface.SetTextPos(x,y)
				surface.DrawText(word)
				if nopad[i] then
					p = a[i][1] - tw
				end
				x = x + 30 + tw + p
			end
			x = bx
			y = y + th
			surface.DrawRect(x-10,y-10,w,5)
		end
	--	self:ProcessText(self.text1,self.text1U,-1)
	--	surface.SetTextColor(0,255,0,255)
	--	self:ProcessText(self.text2,self.text2U,1)
		--render.SuppressEngineLighting( false )

	cam.End3D2D()

end
local function KeyRelease(Ply, key)
	Ply.KeyOnce = false
end
hook.Add("KeyRelease", "Keypad_KeyReleased", KeyRelease)
ENT.Type			= "anim"
ENT.Base			= "base_anim"--gmodentity"

ENT.PrintName		= "Security Station"
ENT.Author			= "Lexi"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.Spawnable		= true
ENT.AdminSpawnable	= true
ENT.RenderGroup		= RENDERGROUP_TRANSLUCENT;
ENT.Category		= "Lexi's Dev Stuff"

local cams = {
	[1] = {"Cells",  Angle(013, 180, 0),Vector(-7420.9443, -9152.8320, 0951.3124)},
	[2] = {"Mayor",  Angle(030, 050, 0),Vector(-8145.6978, -8914.0605, 2603.2195)},
	[3] = {"Lift",   Angle(038, 117, 0),Vector(-7127.9814, -9461.8818, 0220.7526)},
	[4] = {"Lobby",  Angle(027, 131, 0),Vector(-6534.7114, -9494.1396, 0380.4578)},
	[5] = {"Lobby 2",Angle(027,-053, 0),Vector(-7379.5786, -8839.0039, 0420.8096)},
	[6] = {"Walkway",Angle(45, -135, 0),Vector(-7018.9951, -8968.0713, 2715.4849)},
	[7] = {"QMaster",Angle(18,  036, 0),Vector(-8120.1514, -9176.4580, 1850.2092)},
	[8] = {"Stairs" ,Angle(037, 139, 0),Vector(-6637.8105, -9235.8037, 2726.3408)},	
}
if SERVER then
	local function mySetupVis(ply)
		--print("Setting up "..tostring(ply).."'s vis!")
		for _,camdata in ipairs(cams) do
			AddOriginToPVS(camdata[3])
		end
	end
	hook.Add("SetupPlayerVisibility", "mySetupVis", mySetupVis)
	AddCSLuaFile( "shared.lua" )
	AddCSLuaFile( "cl_init.lua")
	function ENT:SpawnFunction ( ply, tr )
		if not tr.Hit then return end
		local ent = ents.Create("sent_secstation")
		ent:SetPos( tr.HitPos + tr.HitNormal * 100)
		ent:Spawn		()
		ent:Activate	()
		local phys = ent:GetPhysicsObject()
		if  phys:IsValid() then
			phys:EnableMotion(false)
		end
		return ent
	end 

	function ENT:Initialize()
		self:SetModel   ( "models/u4lab/ceiling_monitor_a.mdl")
		self:PhysicsInit( SOLID_VPHYSICS		)
		self:SetMoveType( MOVETYPE_VPHYSICS	)
		self:SetSolid   ( SOLID_VPHYSICS		)
		self:SetUseType ( SIMPLE_USE			)
		self:DrawShadow ( true				)
	--	self.PhysgunDisabled = true
	--	self.m_tblToolsAllowed = {}
	--	self:SetColor(255,255,255,200)
		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:EnableMotion(false)
		end
		self:SetNWInt("c",1)
	end
	function ENT:Use(player)
		local c = self:GetNWInt"c"
		c = c +1
		if c > #cams then
			c = 1
		end
		self:SetNWInt("c",c)
	end
	return
end
function ENT:C()
	return self:GetNWInt"c"
end

local rot		= Vector(-90, 90, 15)
local rot2		= Vector(-90, 90,-55)
local rot3		= Vector(-90, 90,-40)
local w,h		= 230,230
local w2,h2		= 240,120
local w3,h3		=  38,12
local mat		= surface.GetTextureID	"effects/tvscreen_noise003a"
local rt		= GetRenderTarget(		"Testies",512,512)
local mot		= Material				"testies"
local screentx	= surface.GetTextureID	"blib"
local poly		= {
					[1] = {x=-w2/2,y=-h2/2,u=0.025,v=0.002},
					[2] = {x= w2/2,y=-h2/2,u=0.985,v=0.001},
					[4] = {x=-w2/2,y= h2/2,u=0.025,v=0.210},
					[3] = {x= w2/2,y= h2/2,u=0.985,v=0.210},
				}-- Seriously, I sacrafice sensibleness for prettyness hurf durf

--lua_run Entity(1):SetPos(Vector(-6549.9033, -9231.4844, 840.0313))

local	CamData   = {}
		CamData.x = 0
		CamData.y = 0
		CamData.w = w * 5
		CamData.h = h * 5
ENT.blib = -64
function ENT:Draw()
	self:DrawModel()
	
	local savedy		= cams[self:C()][2].y
	CamData.angles		= cams[self:C()][2]
	CamData.angles.y	= CamData.angles.y + math.sin(CurTime()*0.5) * 10 -- Make the cam slowly turn
	CamData.origin		= cams[self:C()][3]
	local OldRT			= render.GetRenderTarget()
	mot:SetMaterialTexture	( "$basetexture", rt )
	render.SetRenderTarget	( rt				 )
	render.ClearDepth		(					 )
	render.RenderView		( CamData			 )
	render.SetRenderTarget	( OldRT 			 )
	cams[self:C()][2].y	= savedy
	
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Right(), 	rot.x)
	ang:RotateAroundAxis(ang:Up(), 		rot.y)
	ang:RotateAroundAxis(ang:Forward(), rot.z)
	-----------------------------
	--	Security camera for observing parts of the GHQ
	-----------------------------
	cam.Start3D2D(self:GetPos() + self:GetUp() * -39 + self:GetForward() * 1.3 + self:GetRight()*4, ang ,0.2)
		-----------------------------
		--Draw the screen capture created above
		-----------------------------
		surface.SetDrawColor(255,255,255,100)
		surface.SetMaterial(mot)
		surface.DrawTexturedRect(-w/2,-h/2,w,h)
		-----------------------------
		--Draw some TV effects over the top of the screen 
		-----------------------------
		surface.SetDrawColor(255,255,255,1)
		surface.SetTexture(mat)
		surface.DrawTexturedRect(-w/2,-h/2,w,h)
	cam.End3D2D()
	-----------------------------
	--	Cameara choice indicator
	-----------------------------
	cam.Start3D2D(self:GetPos() + self:GetUp() * -51 + self:GetForward() * 0.52 + self:GetRight()*-28, ang ,0.2)
		local w,h = 16,128
		surface.SetDrawColor(055,055,055,255)
		surface.DrawRect(-w/2,-h/2,w,h)
		surface.SetDrawColor(120,120,120,255)
		surface.SetTextColor(120,120,120,255)
		surface.DrawOutlinedRect(-w/2,-h/2,w,h)
		for i = 0,#cams-1 do
			if i + 1 == self:C() then
				if self.blib ~= -h/2+i*w then
					if self.blib >= h/2 - w then
						self.blib = -h/2 - 1
					end
					self.blib = self.blib + 1
				end
				surface.SetDrawColor(255,255,255,160)
				surface.DrawRect(-w/2,self.blib,w,w)
				surface.SetFont"DefaultFixed"
			else
				surface.SetDrawColor(0,0,0,255)
				surface.DrawOutlinedRect(-w/2+1,-h/2+i*w+1,w-1,w-1	)
				surface.SetFont"DefaultFixedDropShadow"
			end
			surface.SetDrawColor(120,120,120,255)
			surface.DrawOutlinedRect(-w/2,-h/2+i*w,w,w)
			local tw,th = surface.GetTextSize(i+1)
			local a = (w-tw)/2
			local b = (w-th)/2+1
			surface.SetTextPos(-w/2+a,-h/2+i*w+b)
			surface.DrawText(i+1)
		end
	cam.End3D2D()	
end
hook.Remove("HUDPaint","tv")
hook.Add("HUDPaint","tv",function()
	if not ValidEntity(LocalPlayer().Cammin) then return end
	local w,h = ScrW(),ScrH()
	surface.SetDrawColor(255,255,255,1)
	surface.SetTexture(mat)
	surface.DrawTexturedRect(0,0,w,h)
end)
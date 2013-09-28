ENT.Type			= "anim"
ENT.Base			= "base_anim"

ENT.PrintName		= "Postaa"
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
		local ent = ents.Create("sent_poster")
		ent:SetPos( tr.HitPos + tr.HitNormal * 52)
		ent:Spawn()
		ent:Activate()
		local phys = ent:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:EnableMotion(false)
		end
		return ent
	end 

	function ENT:Initialize()
		self:SetModel("models/props_borealis/borealis_door001a.mdl")
		self:PhysicsInit( SOLID_VPHYSICS)
		self:SetMoveType( MOVETYPE_VPHYSICS)
		self:SetSolid( SOLID_VPHYSICS)
		self:DrawShadow(false)
	end
	return
end
local rot = Vector(90, -90, 0)
local tex = surface.GetTextureID"combineposter" -- This is the path/name of your material. You need to do this because of the way it works. You can't just plug the name into SetTexture. You can shove a material into surface.SetMaterial though.
function ENT:Draw()
	--self:DrawModel() -- We don't want to draw the model, as it'd get in the way
	local ang = self:GetAngles() -- You need to rotate the 3d2d's orentation somewhat, otherwise it'll end up say, on the floor. Experement.
	ang:RotateAroundAxis(ang:Right(), 	rot.x)
	ang:RotateAroundAxis(ang:Up(), 		rot.y)
	ang:RotateAroundAxis(ang:Forward(), rot.z)
	cam.Start3D2D(self:GetPos(), ang ,0.1)
		surface.SetDrawColor(225, 225, 225, 255)
		local width,height = surface.GetTextureSize(tex) -- Grab the width and height of the material. Better than guessing!
		surface.SetTexture(tex) -- Make the brush draw the texture
		surface.DrawTexturedRect(-width,-height,width*2,height*2) -- Draw the texture twice as large, centred.
	cam.End3D2D()
end
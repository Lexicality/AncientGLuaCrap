include('shared.lua')local rot = Vector(0, -90, 0)
local width = 10
local Laser = Material( "cable/redlaser" )
local vec1,vec2 = Vector(0,16,0),Vector(0,-16,0);
function ENT:Draw()
	self:DrawModel()
	local other = self:GetDTEntity(0);
	if not ValidEntity(other) then return end
	local pos1 = self:GetPos()
	local pos2 = other:GetPos()
	local r = self:GetRight();
	render.SetMaterial( Laser )
	render.DrawBeam( pos1,       pos2	   , width, 0, 0, color_white )
	render.DrawBeam( pos1+r* 16, pos2+r* 16, width, 0, 0, color_white )
	render.DrawBeam( pos1+r*-16, pos2+r*-16, width, 0, 0, color_white )
end
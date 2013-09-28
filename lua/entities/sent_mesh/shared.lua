ENT.Type			= "anim"
ENT.Base			= "base_gmodentity"

ENT.PrintName		= "Dynamic Mesh Point"
ENT.Author			= "Lexi"
ENT.Contact			= "mwaness@gmail.com"
ENT.Purpose			= ""
ENT.Instructions	= ""
ENT.Information		= ""
ENT.Category		= "Util"

ENT.Spawnable		= true
ENT.AdminSpawnable	= true
ENT.RenderGroup		= RENDERGROUP_TRANSLUCENT;

function math.DecimalPlaces(numb,places)
	return math.Round(numb*10^places)/10^places
end
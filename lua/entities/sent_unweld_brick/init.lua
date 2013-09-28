
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )




function ENT:Initialize() 

self:SetModel( "models/props_junk/CinderBlock01a.mdl" ) 	
self:PhysicsInit( SOLID_VPHYSICS )     
self:SetMoveType( MOVETYPE_VPHYSICS )   
self:SetSolid( SOLID_VPHYSICS )               
local phys = self:GetPhysicsObject()  
if (phys:IsValid()) then  		
phys:Wake()  	
end 
 
end   



function ENT:SpawnFunction( ply, tr)

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	
	local ent = ents.Create( "sent_unweld_brick" )
		ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	
	return ent

end

	function ENT:PhysicsCollide( data, physobj )
	local hitphys
	--ear candy
	
	if (data.Speed > 200 && data.DeltaTime > 0.5 ) then
		self:EmitSound( "Rubber.BulletImpact" )
	if (!data.HitEntity:IsValid() || data.HitEntity:IsPlayer() ) then 
	
	else
	local  bool = constraint.RemoveConstraints( data.HitEntity, "Weld" )
	local hitphys = data.HitEntity:GetPhysicsObject()  
	hitphys:EnableMotion(true)
	hitphys:SetVelocity(Vector(0,0,500))
	end
	
		
		
		
		
	end
	--bouncy
	local LastSpeed = math.max( data.OurOldVelocity:Length(), data.Speed )
	local NewVelocity = physobj:GetVelocity()
	NewVelocity:Normalize()
	
	LastSpeed = math.max( NewVelocity:Length(), LastSpeed )
	
	local TargetVelocity = NewVelocity * LastSpeed * 0.9
	
	physobj:SetVelocity( TargetVelocity )
	
	
	return bool
	
	
	end

	





	
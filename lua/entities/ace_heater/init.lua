AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

DEFINE_BASECLASS( "base_wire_entity" )

function ENT:Initialize()

	self.Heat = ACE.AmbientTemp
	self.Inputs	= WireLib.CreateInputs( self, { "Heat" } )

	self:SetModel( "models/phxtended/cab2x2x2.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetMass(3000)
	end

	self:SetNWString( "WireName", "Scalable Temperature tester" )
	self:UpdateOverlayText()

end

function ENT:TriggerInput( inp, value )
	if inp == "Heat" then
		self.Heat = math.max( value, ACE.AmbientTemp)
		self:UpdateOverlayText()
	end
end

function ENT:UpdateOverlayText()

	local txt = "Temperature: " .. math.Round( self.Heat, 2 ) .. "°C"
	self:SetOverlayText(txt)

end

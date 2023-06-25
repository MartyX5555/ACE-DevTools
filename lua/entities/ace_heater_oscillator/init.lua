AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

DEFINE_BASECLASS( "base_wire_entity" )

function ENT:Initialize()

	self.Var = 1
	self.Counter = 0
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

	self:SetNWString( "WireName", "Oscillator Temperature tester" )
	self:UpdateOverlayText()

	table.insert( ACE.contraptionEnts, self )

end

function ENT:Think()

	if self.Counter >= 500 and not self.HitTop then
		self.HitTop = true
		self.Var = -1
	else
		if self.Counter == 0 and self.HitTop then
			self.HitTop = false
			self.Var = 1
		end
	end

	self.Counter = self.Counter + self.Var

	self.Heat = math.max( self.Counter, ACE.AmbientTemp )

	self:UpdateOverlayText()

	self:NextThink( CurTime() + 0.05 )
	return true
end

function ENT:UpdateOverlayText()

	local txt = "Osci Temperature: " .. math.Round( self.Heat, 2 ) .. "°C"
	self:SetOverlayText(txt)

end

function ENT:OnRemove()
	for i = 1, #ACE.contraptionEnts do
		--check if it's valid
		if not IsValid(ACE.contraptionEnts[i]) or not IsValid(Ent) then continue end
		local MEnt = ACE.contraptionEnts[i]

		-- Finally, remove this Entity from the main list
		if MEnt:EntIndex() == Ent:EntIndex() then
			table.remove(ACE.contraptionEnts, i) --if same, remove it
			return
		end
	end

end
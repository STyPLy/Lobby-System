local Party = {}
Party.__index = Party

local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService('RunService')

function Party:Init(plr,isPublic)
	self.Leader = plr
	self.Public = isPublic
	self:AddMember(plr)
	
end

function Party:ChangeStatus(plr)
	if self.Leader == plr then
		self.Public = not(self.Public)
	end
	
end

function Party:GetStatus()
	return self.Public
end

function Party:AddMember(plr)
	if RunService:IsClient() then print('Client Request?'); return end
	table.insert(self.Members,plr)
end

function Party:GetLeader()
	return self.Leader
end

function Party:RemoveMember(plr)
	if RunService:IsClient() then return end
	local index = table.find(self.Members,plr)
	if index then
		table.remove(self.Members,index)
	end
	
end

function Party:Start()
	if RunService:IsClient() then print('Client Request?'); return end
	local id = 1
	
	local success, err = pcall(function()
		local reservation = TeleportService:ReserveServer(id)
		TeleportService:TeleportToPrivateServer(id,reservation,self.Members)
	end)
	if not success then
		warn(err)
	end
end


function Party:GetAllMembers()
	return self.Members
end

-- TODO: Add Start Function
--function Party:Start()
	
--end

function Party.new()
	if RunService:IsClient() then return end
	local self = setmetatable({},Party)
	self.Members = {}
	return self
end


return Party

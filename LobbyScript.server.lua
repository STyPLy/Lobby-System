
local ReplicatedStorage = game:GetService('ReplicatedStorage')




remotes = Instance.new("Folder",ReplicatedStorage)
remotes.Name = "RemoteEvents"

CreateParty = Instance.new("RemoteEvent",remotes)
CreateParty.Name = "CreateParty"
JoinParty = Instance.new("RemoteEvent",remotes)
JoinParty.Name = "JoinParty"
LeaveParty = Instance.new("RemoteEvent",remotes)
LeaveParty.Name = "LeaveParty"
UpdateListings = Instance.new("RemoteEvent",remotes)
UpdateListings.Name = "UpdateListings"

local LobbyScript = require(game:GetService('ServerStorage').Modules.Lobby)
local Lobby = LobbyScript.new()
Lobby:Init()

JoinParty.OnServerEvent:Connect(function(plr,key)
	local party = Lobby:GetAllParties()[key]
	
	if not plr:GetAttribute("Party") then
		print("Party Join Request from",plr.Name)
		party:AddMember(plr)
		plr:SetAttribute("Party",key)
	end
	
end)

LeaveParty.OnServerEvent:Connect(function(plr)
	print("Party Leave Request from", plr.Name)
	local key = plr:GetAttribute("Party")
	if key then
		local party = Lobby:GetAllParties()[key]
		if plr == party.Leader then
			local members = party.Members
			for _,member in pairs(members) do
				party:RemoveMember(member)
				LeaveParty:FireClient(member)
			end
			Lobby:DeleteParty(key)
		else
			party:RemoveMember(plr)
			
			print("Left Party")
		end
		plr:SetAttribute("Party",nil)
	end
	
end)

CreateParty.OnServerEvent:Connect(function(plr:Player,isPublic:boolean)
	if not plr:GetAttribute("Party") then
		local party = Lobby:CreateParty(plr,isPublic)
	end
	
end)

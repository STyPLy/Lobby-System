local Lobby = {}
Lobby.__index = Lobby

local PartyModule = require(script.Party)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local remotes = ReplicatedStorage:WaitForChild('RemoteEvents')
local CreateParty = remotes.CreateParty
local JoinParty = remotes.JoinParty
local LeaveParty = remotes.LeaveParty
local UpdateListings = remotes.UpdateListings

function Lobby.new()
	local self = setmetatable({},Lobby)
	return self
end

function Lobby:Init()
	self.Parties = {}
	
	coroutine.wrap(function()
		while task.wait(1) do
			self:UpdateListings()
		end
	end)()
	
end

local function GenerateKey(length)
	local letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
	local numbers = "1234567890"
	
	-- SCRAPPED: -> To hard to type
	--local symbols = "!@#$%^&*()_+=-[]'/?{}><.,:;"
	
	local key = {}
	for i=1, length do
		local t = math.random(1,2)
		if t == 1 then
			table.insert(key,letters:split("")[math.random(1,letters:len())])
		elseif t == 2 then
			table.insert(key,numbers:split("")[math.random(1,numbers:len())])
		--elseif t == 3 then
		--	table.insert(key,symbols:split("")[math.random(1,symbols:len())])
		end
		
	end
	
	return table.concat(key)
end

function Lobby:CreateParty(plr,isPublic)
	local key = GenerateKey(8)
	
	self.Parties[key] = PartyModule.new()
	self.Parties[key]:Init(plr,isPublic)
	plr:SetAttribute("Party",key)
	return self.Parties[key]
end

function Lobby:DeleteParty(key)
	self.Parties[key] = nil
end

function Lobby:UpdateListings()
	local parties = self:GetAllParties()
	local data = {}
	
	for i, Party in pairs(parties) do
		if Party:GetStatus() then
			data[i] = Party
		end
	end
	UpdateListings:FireAllClients(data)
end


function Lobby:GetAllParties()
	return self.Parties
end



return Lobby

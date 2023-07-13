
Structure:

![image](https://github.com/STyPLy/Roblox/assets/87618871/118521ba-0e6a-43e0-9e3b-e850c7a2124f)


This system works using RemoteEvents. All RemoteEvents are created by the LobbyScript and are located inside a folder named "RemoteEvents") inside of ReplicatedStorage.

Example code (Client Side/Local Script):
```
  local ReplicatedStorage = game:GetService("ReplicatedStorage")
  local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
  local CreateParty = RemoteEvents.CreateParty

  CreateParty:FireServer()

  
```

If you have any questions msg me on discord: @styply

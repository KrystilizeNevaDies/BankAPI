# BankAPI
Economy API for Cuberite

This plugin provides a storage for players' accounts that other plugins can use (and share between them).





# Interfacing

To make your plugin use BankAPI, simply add this to your HOOK_PLUGINS_LOADED handler:
```lua
dofile(cPluginManager:CallPlugin("BankAPI", "GetExternalAPIPath"))
```
(This can be called multiple times with no ill effects)

Then you can use all the functions in the API/ExternalAPI.lua file. 
See the individual functions there for their documentation.
There is also minimal documentation below.





# API Functions

#### Hooking into BankAPI

In order to load BankAPI, call the following function anywhere in your plugin.
```lua
dofile(cPluginManager:CallPlugin("BankAPI", "GetExternalAPIPath"))
```





The following is a sample of each function that BankAPI provides:

##### BankGetPlayerBalance

```lua

PlayersUUID = cMojangAPI:GetUUIDFromPlayerName("xoft", false)
-- All functions require player's UUID

PlayersBalance = BankGetPlayerBalance(PlayersUUID)
-- Gets player's balance
```

##### BankSetPlayerBalance

```lua

PlayersUUID = cMojangAPI:GetUUIDFromPlayerName("xoft", false)
-- All functions require player's UUID

PlayersNewBalance = BankSetPlayerBalance(PlayersUUID)
-- Sets player's balance and returns the new balance
```

##### BankChangePlayerBalance

```lua

PlayersUUID = cMojangAPI:GetUUIDFromPlayerName("xoft", false)
-- All functions require player's UUID

PlayersNewBalance = BankGetPlayerBalance(PlayersUUID)
-- Changes player's balance by the specified amount and returns the new balance
```



# Sample client plugin

The following is a simple client plugin that uses the BankAPI:
```lua
local function TestBankAPI()
	-- Load the BankAPI external API:
	dofile(cPluginManager:CallPlugin("BankAPI", "GetExternalAPIPath"))

	-- Use the BankAPI:
	LOG("Adding 1000 to xoft's balance...")
	local uuid = cMojangAPI:GetUUIDFromPlayerName("xoft", false)
	local bal = BankChangePlayerBalance(uuid, 1000)
	if (bal) then
		LOG("Added successfully, new balance is " .. bal)
	else
		LOG("Failed to change balance")
	end
end

function Initialize()
	cPluginManager:BindConsoleCommand("add", TestBankAPI, "Tests the BankAPI by trying to add 1000 to xoft's balance")
	return true
end
```


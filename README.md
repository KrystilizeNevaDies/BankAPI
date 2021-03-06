# BankAPI
Economy API for Cuberite

This plugin provides a storage for players' accounts that other plugins can use (and share between them).





# Interfacing

To make your plugin use BankAPI, download and install the plugin.
Then add this to your HOOK_PLUGINS_LOADED handler:
```lua
dofile(cPluginManager:CallPlugin("BankAPI", "GetExternalAPIPath"))
```
(This can be called multiple times with no ill effects)

Then you can use all the functions in the API/ExternalAPI.lua file. 
See below for documentation.






# API Functions

#### Hooking into BankAPI

```lua
dofile(cPluginManager:CallPlugin("BankAPI", "GetExternalAPIPath"))
-- Hooks into BankAPI
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

Balance = 10 - 5

PlayersNewBalance = BankSetPlayerBalance(PlayersUUID, Balance)
-- Sets player's balance and returns the new balance
```

##### BankChangePlayerBalance

```lua

PlayersUUID = cMojangAPI:GetUUIDFromPlayerName("xoft", false)
-- All functions require player's UUID

Balance = 10 - 5

PlayersNewBalance = BankChangePlayerBalance(PlayersUUID, Balance)
-- Changes player's balance by the specified amount and returns the new balance
```


##### BankTransferPlayerBalance

```lua

aPlayersUUID = cMojangAPI:GetUUIDFromPlayerName("xoft", false)
bPlayersUUID = cMojangAPI:GetUUIDFromPlayerName("Krystilize", false)
-- All functions require player's UUID

Balance = 10 - 5

PlayersNewBalance = BankGetPlayerBalance(aPlayersUUID, bPlayersUUID, Balance)
-- Transfers a specific amount from aPlayer to bPlayer, this is safer then using plugin logic due to SQLite transactions
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


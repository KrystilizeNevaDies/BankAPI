-- ExternalAPI.lua

--[[
  This file is to be loaded by any plugin that wishes to use the BankAPI for its money management:
-- In HOOK_PLUGINS_LOADED handler:
dofile(cPluginManager:CallPlugin("BankAPI", "GetExternalAPIPath"))

-- In eg. a command handler:
BankGetPlayerBalance(uuid)...
`--]]





--- Returns the player's current account balance
--[[
WARNING: As soon as this function returns, another plugin may change that balance,
so DO NOT base any critical calculations on this value, and especially DO NOT USE code like the following:
SetPlayerBalance(somePlayer, GetPlayerBalance(somePlayer) + 100)
Use ChangePlayerBalance() or TransferPlayerBalance() instead.
--]]
function BankGetPlayerBalance(aPlayerUuid)
	assert(type(aPlayerUuid) == "string")

	-- Call into the BankAPI plugin:
	local bal = cPluginManager:CallPlugin("BankAPI", "GetBalance", aPlayerUuid)

	-- Report failure if the plugin call failed:
	if not(bal) then
		-- Either the plugin call failed (bal == nil) or the plugin ran into a problem (bal == false)
		-- Report an error either way
		error("Failed to call the BankAPI plugin")
	end

	-- All ok, return the balance:
	return bal
end





--- Sets the player's current account balance
--[[
Returns the player's new balance
WARNING: Another plugin may change the balance at any time, DO NOT USE code like the following:
SetPlayerBalance(somePlayer, GetPlayerBalance(somePlayer) + 100)
Use ChangePlayerBalance() or TransferPlayerBalance() instead.
--]]
function BankSetPlayerBalance(aPlayerUuid, aNewBalance)
	assert(type(aPlayerUuid) == "string")
	assert(type(aNewBalance) == "number")

	-- Call into the BankAPI plugin:
	local bal = cPluginManager:CallPlugin("BankAPI", "SetBalance", aPlayerUuid, aNewBalance)

	-- Report failure if the plugin call failed:
	if not(bal) then
		-- Either the plugin call failed (bal == nil) or the plugin ran into a problem (bal == false)
		-- Report an error either way
		error("Failed to call the BankAPI plugin")
	end

	-- All ok, return the new balance:
	return bal
end





--- Changes the player's current account balance by the specified delta
-- Returns the player's new balance
function BankChangePlayerBalance(aPlayerUuid, aDelta)
	assert(type(aPlayerUuid) == "string")
	assert(type(aDelta) == "number")

	-- Call into the BankAPI plugin:
	local bal = cPluginManager:CallPlugin("BankAPI", "ChangeBalance", aPlayerUuid, aDelta)

	-- Report failure if the plugin call failed:
	if not(bal) then
		-- Either the plugin call failed (bal == nil) or the plugin ran into a problem (bal == false)
		-- Report an error either way
		error("Failed to call the BankAPI plugin")
	end

	-- All ok, return the new balance:
	return bal
end





--- Transfers aAmount from aFromPlayer to aToPlayer, if aFromPlayer has enough funds
-- Returns true if transfer succeeds, false if not
function BankTransferPlayerBalance(aFromPlayer, aToPlayer, aAmount)
	assert(aFromPlayer)
	assert(aToPlayer)
	assert(type(aAmount) == "number")

	-- Call into the BankAPI plugin:
	local bal = cPluginManager:CallPlugin("BankAPI", "TransferBalance", aFromPlayer, aToPlayer, aAmount)

	-- Report failure if the plugin call failed:
	if (bal == nil) then
		error("Failed to call the BankAPI plugin")
	end

	-- Plugin call succeeded, return the result:
	return bal
end





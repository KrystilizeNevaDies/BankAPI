-- Manage.lua

--[[
Implements functions that can be called by external plugins
Note that usually external plugins will want to use the ExternalAPI instead (see that file for details)
--]]





--- Returns the player's current balance
-- Returns the balance (number) on success, false on failure
function GetBalance(aPlayerUuid)
    return GetPlayerBalance(aPlayerUuid)
end





--- Sets the player's current balance
-- Returns the player's current balance on success, false on failure
function SetBalance(aPlayerUuid, aNewBalance)
    return SetPlayerBalance(aPlayerUuid, aNewBalance)
end





--- Modifies the player's current balance by the specified amount
-- Returns the player's new balance on success, false on failure
function ChangeBalance(aPlayerUuid, aDelta)
    return ChangePlayerBalance(aPlayerUuid, aDelta)
end





--- Transfers aAmount from aFromPlayer to aToPlayer, if aFromPlayer has enough funds
-- Returns true if transfer succeeds, false if not
function TransferBalance(aFromPlayerUuid, aToPlayerUuid, aAmount)
    return TransferPlayerBalance(aFromPlayerUuid, aToPlayerUuid, aAmount)
end





--- Returns the location of the ExternalAPI.lua file so that other plugins can load it directly
function GetExternalAPIPath()
	return cPluginManager:GetCurrentPlugin():GetLocalFolder() .. "/API/ExternalAPI.lua"
end

-- main.lua

--[[
Implements the main logic for the plugin
--]]





--- The SQLite database used for the storage
-- Initialized in InitDB()
local gDB





--- If the player is not yet in the DB, create an entry for them
local function MakeSurePlayerIsPresent(aPlayerUuid)
    assert(type(aPlayerUuid) == "string")

	-- Insert the player; this will fail silently if the player already exists thanks to the UNIQUE constraint
	gDB:exec('INSERT INTO PlayerBalances (UUID, Balance) VALUES ("' .. aPlayerUuid .. '", 0);')
end





--- Returns the player's current balance
function GetPlayerBalance(aPlayerUuid)
    assert(type(aPlayerUuid) == "string")

	MakeSurePlayerIsPresent(aPlayerUuid)
    for aBal in gDB:urows("SELECT Balance FROM PlayerBalances WHERE UUID='" .. aPlayerUuid .. "';") do
		LOG("Balance found: " .. aBal)
        return aBal
    end

	-- DB error?
    return false
end





function SetPlayerBalance(aPlayerUuid, aNewBalance)
    assert(type(aPlayerUuid) == "string")
    assert(type(aNewBalance) == "number")
    
    gDB:exec("BEGIN TRANSACTION")
	MakeSurePlayerIsPresent(aPlayerUuid)
    gDB:exec("UPDATE PlayerBalances SET Balance = " .. aNewBalance .. " WHERE UUID = '" .. aPlayerUuid .. "';")
    gDB:exec("COMMIT;")
    return true
end





--- Modifies the player's current balance by the specified amount
-- Returns the player's new balance on success, false on failure
function ChangePlayerBalance(aPlayerUuid, aDelta)
    assert(type(aPlayerUuid) == "string")
    assert(type(aDelta) == "number")

	gDB:exec("BEGIN TRANSACTION")
	MakeSurePlayerIsPresent(aPlayerUuid)
    local NewBalance = GetPlayerBalance(aPlayerUuid) + aDelta
    SetPlayerBalance(aPlayerUuid, NewBalance)
    gDB:exec("COMMIT;")
    return NewBalance
end





--- Transfers aAmount from aFromPlayer to aToPlayer, if aFromPlayer has enough funds
-- Returns true if transfer succeeds, false if not
function TransferPlayerBalance(aFromPlayerUuid, aToPlayerUuid, aAmount)
    assert(type(aFromPlayerUuid) == "string")
    assert(type(aToPlayerUuid) == "string")
    assert(type(aAmount) == "number")

    gDB:exec("BEGIN TRANSACTION")
	MakeSurePlayerIsPresent(aFromPlayerUuid)
	MakeSurePlayerIsPresent(aToPlayerUuid)
    if (GetPlayerBalance(aFromPlayerUuid) < aAmount) then
        return false
    else
        ChangePlayerBalance(aFromPlayerUuid, -aAmount)
        ChangePlayerBalance(aToPlayerUuid, aAmount)
        return true
    end
    gDB:exec("COMMIT;")
end





--- Opens the DB file and initializes the structure:
local function InitDB()
    gDB = sqlite3.open('PlayerBalances.sqlite3')
	-- TODO: We need a migration from when the table had no UNIQUE constraint
    gDB:exec("CREATE TABLE IF NOT EXISTS PlayerBalances(UUID text(36) UNIQUE, Balance decimal);")
end





--- The main entrypoint, called by Cuberite upon plugin load
function Initialize(Plugin)
	InitDB()

	-- Allow the external API, callable by other plugins:
    dofile(cPluginManager:GetCurrentPlugin():GetLocalFolder() .. "/API/manage.lua")

	return true
end

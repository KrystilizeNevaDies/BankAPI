function Initialize(Plugin)
	PLUGIN = Plugin;
	
	Plugin:SetName("BankAPI");
	Plugin:SetVersion(1);
	
	local cPluginManager = cRoot:Get():GetPluginManager();
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_JOINED, OnPlayerJoined);
    cPluginManager:AddHook(cPluginManager.HOOK_PLUGINS_LOADED, OnPluginsLoaded);
    dofile(cPluginManager:GetCurrentPlugin():GetLocalFolder() .. "/API/manage.lua")

	LOG("Initialized " .. PLUGIN:GetName() .. " v" .. PLUGIN:GetVersion())
	return true;
end





function OnPluginsLoaded()
    cRoot:Get():ForEachPlayer(function (aPlayer)
        RegisterPlayer(aPlayer)
    end)
end






function OnPlayerJoined(aPlayer)
    Register(aPlayer)
end



function GetPlayerBalance(aPlayer)
    assert(type(aPlayer) == "userdata", "Player expects a cPlayer")
    local Bal
    local DB = sqlite3.open("PlayerBalances.sqlite3")
    for _, aBal in DB:urows("SELECT * FROM PlayerBalances WHERE UUID='" .. aPlayer:GetUUID() .. "';") do 
        Bal = aBal
    end
    DB:close()
    return Bal
end

function SetPlayerBalance(aPlayer, Bal)
    assert(type(Bal) == "number", "Balance expects a number")
    assert(type(aPlayer) == "userdata", "Player expects a cPlayer")
    local DB = sqlite3.open("PlayerBalances.sqlite3")
    DB:exec("UPDATE PlayerBalances SET BALANCE=" .. Bal .. " WHERE UUID='" .. aPlayer:GetUUID() .. "';")
    DB:close()
    return true
end

function AddPlayerBalance(aPlayer, Bal)
    assert(type(Bal) == "number", "Balance expects a number")
    assert(type(aPlayer) == "userdata", "Player expects a cPlayer")
    local Total = GetBalance(aPlayer) + tonumber(Bal)
    SetBalance(aPlayer, Total)
    return true
end

function RemovePlayerBalance(aPlayer, Bal)
    assert(type(Bal) == "number", "Balance expects a number")
    assert(type(aPlayer) == "userdata", "Player expects a cPlayer")
    local Total = GetBalance(aPlayer) - tonumber(Bal)
    if not(Bal >= 0) then
        return false
    else
        SetBalance(aPlayer, Total)
        return true
    end
end

function TransferPlayerBalance(aPlayer, bPlayer, Bal)
    assert(type(Bal) == "number", "Balance expects a number")
    assert(type(aPlayer) == "userdata", "Player expects a cPlayer")
    assert(type(bPlayer) == "userdata", "Player expects a cPlayer")
    if not(GetBalance(aPlayer) >= Bal) then
        return false
    else
        RemoveBalance(aPlayer, Bal)
        GiveBalance(bPlayer, Bal)
        return true
    end
end



function RegisterPlayer(aPlayer)
    local DB = sqlite3.open('PlayerBalances.sqlite3')
    local aQuery = false
    DB:exec("CREATE TABLE IF NOT EXISTS PlayerBalances(UUID text(36),BALANCE decimal);")
    for _ in DB:urows("SELECT * FROM PlayerBalances WHERE UUID='" .. aPlayer:GetUUID() .. "';") do 
        aQuery = true
    end
    if aQuery == false then
        DB:exec("INSERT INTO PlayerBalances(UUID,BALANCE) VALUES('" .. aPlayer:GetUUID() .. "', " .. 0 .. ");")
    end
    DB:close()
end

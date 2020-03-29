
-- Manage.lua

-- Implements functions that can be called by external plugins



--- Sets the player's selection to the specified cuboid.
-- Returns true on success, false on failure.
function GetBalance(Player)
    return GetPlayerBalance(Player)
end

function SetBalance(Player, Bal)
    return SetPlayerBalance(Player, Bal)
end

function AddBalance(Player, Bal)
    return AddPlayerBalance(Player, Bal)
end

function RemoveBalance(Player, Bal)
    return RemovePlayerBalance(Player, Bal)
end

function TransferBalance(aPlayer, bPlayer, Bal)
    return TransferPlayerBalance(aPlayer, bPlayer, Bal)
end
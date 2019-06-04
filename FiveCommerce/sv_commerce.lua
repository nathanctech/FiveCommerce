--
-- FiveCommerce
--
-- By: Nathan_C (Discord: Era#1337)
-- Released under MIT license. See LICENSE.txt

-- ADDITIONAL CODE IS REQUIRED TO USE. See USING.txt for details.

local DEBUG = false  -- set to true to see some useful debug prints


-- SET THE BELOW TO YOUR CONFIGURED PACKAGES. See USING.txt for full syntax.
local SkuMapping = {
    ["pack1"] = { id=1, description="Vehicle Pack" },
    ["pack2"] = { id=2, description="Vehicle Pack2" }
}



-- DO NOT TOUCH THE BELOW UNLESS YOU KNOW WHAT YOU'RE DOING.
local PermissionList = {}


-- example: /buy pack1
RegisterCommand("buy", function(source, args)
    if SkuMapping[args[1]] ~= nil then
        RequestPlayerCommerceSession(source, SkuMapping[args[1]].id)
    else
        TriggerClientEvent("Commerce:DisplayNotification", s, "Option "..tostring(args[1]).." was invalid")
    end
end, false)

-- Primary Event Fired
RegisterNetEvent("Commerce:HandlePackage")
AddEventHandler("Commerce:HandlePackage", function(package)
    if package_id == "pack1" then
        SetPlayerPermission(source, "vip2")
    elseif package_id == "pack2" then
        SetPlayerPermission(source, "vip4")
    end
end)


-- ACE permission helper
function SetPlayerPermission(source, perm)
    if not perm then
        return
    end
    DebugPrint("add_principal identifier."..GetPlayerIdentifier(source, 0).." group."..perm)
    ExecuteCommand("add_principal identifier."..GetPlayerIdentifier(source, 0).." group."..perm)
	if PermissionList[s] == nil then
		PermissionList[s] = {}
	end
    table.insert(PermissionList[s], SkuMapping[sku].ace)
end

-- Primary handling function

function LoadAndHandleSkus(s)
    if CanPlayerStartCommerceSession(s) then
        LoadPlayerCommerceData(s)
        while not IsPlayerCommerceInfoLoaded(s) do
            Wait(10)
        end
        for k, v in pairs(SkuMapping) do
            if DoesPlayerOwnSku(s, v.id) then
                TriggerEvent("Commerce:HandlePackage", k)
            end
        end
    else
        TriggerClientEvent("Commerce:DisplayNotification", s, "Failed to start commerce session. Ensure your forum account is linked on the main menu.")
    end
end

-- Client startup and cleanup actions

RegisterNetEvent("Commerce:Startup")
AddEventHandler("Commerce:Startup", function()
	DebugPrint("Got Startup from "..tostring(source))
    LoadAndHandleSkus(source)
end)

AddEventHandler("playerDropped", function(player)
    if PermissionList[player] ~= nil then
        for _, v in pairs(PermissionList[player]) do
            DebugPrint("remove_principal identifier."..GetPlayerIdentifier(player, 0).." group."..v)
            ExecuteCommand("remove_principal identifier."..GetPlayerIdentifier(player, 0).." group."..v)
        end
    end
end)    

function DebugPrint(message)
    if DEBUG then
        print(message)
    end
end
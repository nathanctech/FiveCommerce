Citizen.CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do
        Citizen.Wait(10)
    end
    TriggerServerEvent("Commerce:Startup")
end)

RegisterCommand("buyconfirm", function(source, args, raw)
	TriggerEvent('Commerce:DisplayNotification', "Your purchases are being refreshed. Please wait a few seconds.", true)
	TriggerServerEvent("Commerce:Startup")
end)


-- Helper functions
RegisterNetEvent("Commerce:DisplayNotification")
AddEventHandler("Commerce:DisplayNotification", function(text, blink, picName1, picName2, flash, iconType, sender, subject)
    local DRS = RandomString(10)
    AddTextEntry(DRS, text)
    SetNotificationTextEntry(DRS)
    if picName1 then
        SetNotificationMessage(picName1, picName2, flash, iconType, sender, subject)
    end
    DrawNotification(blink, true)
end)
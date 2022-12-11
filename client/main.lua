ESX = nil
local OpenMenu = nil

RMenu.Add('information', 'main', RageUI.CreateMenu("Informateur", " "))
RMenu:Get('information', 'main'):SetSubtitle("~b~Sélectionner l'information que vous voulez")
RMenu:Get('information', 'main').EnableMouse = false
RMenu:Get('information', 'main').Closed = function()
end;

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSh4587poiaredObj4587poiect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RageUI.CreateWhile(1.0, RMenu:Get('information', 'main'), nil, function()
    RageUI.IsVisible(RMenu:Get('information', 'main'), true, true, true, function()
        for k,v in pairs(Config.Informateur) do
			for k,info in pairs(Config.Information) do
				if OpenMenu == v.label then
					if v.label == info.type then
						RageUI.Button(info.name, nil, { RightLabel = info.price.."~r~$" }, true, function(Hovered, Active, Selected)
							if (Selected) then
								ESX.TriggerServerCallback('ns_infoill:CheckMoney', function(hasEnoughMoney)
									if hasEnoughMoney then
										TriggerEvent("chatMessage", "", {255, 0, 0}, "Informateur : ^7"..info.info)
									else
										ESX.ShowNotification("Vous n'avez pas l'argent requis !")
									end
								end, info.price)
							end
						end)
					end
				end
			end
		end
    end, function()
    end)
end)

Citizen.CreateThread(function()
	for k,v in pairs(Config.Informateur) do
		local model = GetHashKey(v.ped)
		RequestModel(model)
		while not HasModelLoaded(model) do Wait(1) end

		local ped = CreatePed(5, model, v.coords.x, v.coords.y, v.coords.z-1, v.heading, 0, 0)
		SetEntityInvincible(ped, 1)
		FreezeEntityPosition(ped, 1)
		SetBlockingOfNonTemporaryEvents(ped, 1)
	end
	while true do
		local _Wait = 500
		for k,v in pairs(Config.Informateur) do
			local dst = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), v.coords, true)
			if dst <= 3.0 then
				_Wait = 1
				ShowHelpNotification("Appuyer sur ~b~E~w~ pour parler au monsieur")
				if IsControlJustPressed(1, 38) then
					OpenMenu = v.label
					RageUI.Visible(RMenu:Get('information', 'main'), not RageUI.Visible(RMenu:Get('information', 'main')))
				end
			end
		end
		Citizen.Wait(_Wait)
	end
end)

ShowHelpNotification = function(msg)
	AddTextEntry('HelpNotif', msg)
	DisplayHelpTextThisFrame('HelpNotif', false)
end
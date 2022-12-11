ESX = nil

TriggerEvent('esx:getSh4587poiaredObj4587poiect', function(obj) ESX = obj end)

ESX.RegisterServerCallback('ns_infoill:CheckMoney', function(source, cb, price)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if price > 0 then
		if xPlayer.getAccount('black_money').money >= price then
			xPlayer.removeAccountMoney('black_money', tonumber(price))
			cb(true)
		else
			cb(false)
		end
	else
		DropPlayer(source, "Vraiment ? T'essaye de cheat sur ça ?")
	end
end)
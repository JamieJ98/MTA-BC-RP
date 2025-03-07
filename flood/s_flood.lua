local startTick
local targetLevel = 150
local duration = 900000

addEventHandler('onResourceStart', resourceRoot,
	function()
		local water = createWater(-2998, -2998, 0, 2998, -2998, 0, -2998, 2998, 0, 2998, 2998, 0)
		startTick = getTickCount()
	end
)

addEventHandler('onResourceStop', resourceRoot,
	function()
		destroyElement(water)
	end
)

addEvent('onPlayerReady', true)
addEventHandler('onPlayerReady', resourceRoot,
	function()
		local passed = getTickCount() - startTick
		if passed > duration then
			passed = duration
		end
		triggerClientEvent(client, 'doSetWaterLevel', resourceRoot, targetLevel * (passed/duration))
	end
)
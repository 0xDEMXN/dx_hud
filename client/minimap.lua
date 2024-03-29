local mapState = 1
local persistentRadar = GetConvarInt('hud:persistentRadar', false) == 1
local circlemap = GetConvarInt('hud:circleMap', true) == 1
local mapLimit = circlemap == 1 and circlemap or 3

if persistentRadar then
    local function setRadarState()
        if mapState == 0 then
            DisplayRadar(false)
        elseif mapState == 1 then
            DisplayRadar(true)
            SetBigmapActive(false, false)
        elseif mapState == 2 then
            DisplayRadar(true)
            SetBigmapActive(true, false)
        elseif mapState == 3 then
            DisplayRadar(true)
            SetBigmapActive(true, true)
        end
    end

    CreateThread(function()
        repeat Wait(100) until HUD
        setRadarState()
    end)

    lib.addKeybind({
        name = 'cyclemap',
        description = 'Cycle Map',
        defaultKey = GetConvar('hud:cyclemapKey', 'Z'),
        onPressed = function()
            if mapState == mapLimit then
                mapState = 0
            else
                mapState += 1
            end

            setRadarState()
        end,
    })
end

CreateThread(function()
    local minimap = RequestScaleformMovie('minimap')
    repeat Wait(100) until HasScaleformMovieLoaded(minimap)
    while true do
        if HUD then
            BeginScaleformMovieMethod(minimap, 'SETUP_HEALTH_ARMOUR')
            ScaleformMovieMethodAddParamInt(3)
            EndScaleformMovieMethod()

            if not persistentRadar then
                local isRadarHidden = IsRadarHidden()
                local isPedUsingAnyVehicle = cache.vehicle and true or false
                if isPedUsingAnyVehicle == isRadarHidden then
                    DisplayRadar(isPedUsingAnyVehicle)
                    SetRadarZoom(1150)
                end
            end
        end
        Wait(500)
    end
end)

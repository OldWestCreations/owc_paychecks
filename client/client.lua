local Core = exports.vorp_core:GetCore()
local myJob = nil
local T = Translation.Langs[Lang]

local function SetupPromptGroup()
    local GroupsClass = {}
    GroupsClass.PromptGroup = GetRandomIntInRange(0, 0xffffff)

    function GroupsClass:ShowGroup(text)
        PromptSetActiveGroupThisFrame(self.PromptGroup, CreateVarString(10, 'LITERAL_STRING', text or "Interaction"))
    end

    function GroupsClass:RegisterPrompt(title, button, enabled, visible, pulsing, mode, options)
        local PromptClass = {}
        PromptClass.Prompt = PromptRegisterBegin()
        PromptClass.Mode = mode

        PromptSetControlAction(PromptClass.Prompt, button or 0x4CC0E2FE)
        PromptSetText(PromptClass.Prompt, CreateVarString(10, 'LITERAL_STRING', title or "Prompt"))
        PromptSetEnabled(PromptClass.Prompt, enabled ~= false)
        PromptSetVisible(PromptClass.Prompt, visible ~= false)

        if mode == "click" then
            PromptSetStandardMode(PromptClass.Prompt, 1)
        elseif mode == "hold" then
            Citizen.InvokeNative(0x74C7D7B72ED0D3CF, PromptClass.Prompt, options and options.timedeventhash or 'MEDIUM_TIMED_EVENT')
        elseif mode == "customhold" then
            Citizen.InvokeNative(0x94073D5CA3F16B7B, PromptClass.Prompt, options and options.holdtime or 3000)
        end

        PromptSetGroup(PromptClass.Prompt, self.PromptGroup)
        Citizen.InvokeNative(0xC5F428EE08FA7F2C, PromptClass.Prompt, pulsing ~= false)
        PromptRegisterEnd(PromptClass.Prompt)

        function PromptClass:HasCompleted()
            if self.Mode == "click" then
                return Citizen.InvokeNative(0xC92AC953F0A982AE, self.Prompt)
            elseif self.Mode == "hold" or self.Mode == "customhold" then
                local result = Citizen.InvokeNative(0xE0F65F0640EF0617, self.Prompt)
                if result then Wait(500) end
                return result
            end
            return false
        end

        return PromptClass
    end

    return GroupsClass
end

local paycheckPromptGroup = SetupPromptGroup()

RegisterNetEvent("owc_paychecks:receiveJob")
AddEventHandler("owc_paychecks:receiveJob", function(job)
    myJob = job
end)

Citizen.CreateThread(function()
    while myJob == nil do
        TriggerServerEvent("owc_paychecks:requestJob")
        Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.timer * 60000)
        TriggerServerEvent("owc_paychecks:getpaycheck")
    end
end)

Citizen.CreateThread(function()
    for _, jobData in pairs(Config.availableJobs) do
        jobData.prompt = paycheckPromptGroup:RegisterPrompt(T.prompt_collect, 0x760A9C6F, true, true, true, 'hold', {timedeventhash = 'MEDIUM_TIMED_EVENT'})
    end

    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, jobData in pairs(Config.availableJobs) do
            if myJob == jobData.job then
                local distance = #(playerCoords - jobData.paycheckLocation)
                if distance < 2.0 then
                    paycheckPromptGroup:ShowGroup(T.prompt_group)
            
                    if IsControlJustReleased(0, 0x760A9C6F) then
                        print("DEBUG: Taste G gedrückt! (Job: " .. tostring(myJob) .. ")")
                        TriggerServerEvent("owc_paychecks:collectpaycheck")
                        Wait(1500)
                    end
                end
            end            
        end
    end
end)

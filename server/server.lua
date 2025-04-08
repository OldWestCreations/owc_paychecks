local VorpCore = {}
local T = Translation.Langs[Lang]

TriggerEvent("getCore", function(core)
    VorpCore = core
end)

RegisterNetEvent("owc_paychecks:getpaycheck")
AddEventHandler("owc_paychecks:getpaycheck", function()
    local _source = source
    local User = VorpCore.getUser(_source)
    local Character = User.getUsedCharacter
    local job = Character.job
    local grade = Character.jobGrade
    local identifier = Character.identifier

    for _, v in pairs(Config.availableJobs) do
        if job == v.job then
            for _, j in pairs(v.jobgrade) do
                if grade == j.grade then
                    local paycheck = j.paycheck

                    exports.ghmattimysql:execute(
                        "INSERT INTO paycheck_storage (identifier, amount, job) VALUES (@identifier, @amount, @job) ON DUPLICATE KEY UPDATE amount = amount + @amount",
                        {["@identifier"] = identifier, ["@amount"] = paycheck, ["@job"] = job}
                    )
                end
            end
        end
    end
end)

RegisterNetEvent("owc_paychecks:collectpaycheck")
AddEventHandler("owc_paychecks:collectpaycheck", function()
    local _source = source
    local User = VorpCore.getUser(_source)
    local Character = User.getUsedCharacter
    local identifier = Character.identifier
    local job = Character.job

    print("Versuche Gehalt abzuholen für:", identifier, "Job:", job)

    exports.ghmattimysql:execute("SELECT amount FROM paycheck_storage WHERE identifier = @identifier AND job = @job", 
        {["@identifier"] = identifier, ["@job"] = job}, 
        function(result)
            if result and result[1] and result[1].amount > 0 then
                local amount = result[1].amount
                Character.addCurrency(0, amount)
            
                exports.ghmattimysql:execute("DELETE FROM paycheck_storage WHERE identifier = @identifier AND job = @job", {
                    ["@identifier"] = identifier, ["@job"] = job
                })
            
                VORPcore.NotifyRight(_source, T.notify_title, string.format(T.notify_success, amount), "BLIPS", "blip_money", 3000, "COLOR_GREEN")
            else
                VORPcore.NotifyRight(_source, T.notify_title, T.notify_nothing, "BLIPS", "blip_destroy", 3000, "COLOR_RED")
            end
    end)
end)

RegisterNetEvent("owc_paychecks:requestJob")
AddEventHandler("owc_paychecks:requestJob", function()
    local _source = source
    local User = VorpCore.getUser(_source)
    local Character = User.getUsedCharacter 
    local job = Character.job

    TriggerClientEvent("owc_paychecks:receiveJob", _source, job)
end)

Translation = {}

Translation.Langs = {
    de = {
        prompt_collect = "Gehalt abholen",
        prompt_group = "Kasse",
        notify_title = "Gehalt",
        notify_success = "Du hast dein Gehalt von %s$ abgeholt!",
        notify_nothing = "Kein ausstehendes Gehalt!",
    },
    en = {
        prompt_collect = "Collect paycheck",
        prompt_group = "Cashier",
        notify_title = "Payroll",
        notify_success = "You have collected your paycheck of %s$!",
        notify_nothing = "No outstanding paycheck!",
    }, -- add more here
}

Lang = "de" -- set your language here
T = Translation.Langs[Lang]

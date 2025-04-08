# 💼 OWC Paychecks

A simple, configurable **paycheck system** for **RedM (VorpCore)**.  
Automated salary payouts and manual collection at configured locations with job/grade-based pay.

![Framework](https://img.shields.io/badge/Framework-VorpCore-blue?style=flat-square)
![UI](https://img.shields.io/badge/UI-vorp_utils-orange?style=flat-square)
![Database](https://img.shields.io/badge/Storage-MySQL-green?style=flat-square)
![Translation](https://img.shields.io/badge/Locale-Enabled-purple?style=flat-square)

---

## ✨ Features

- 🕒 **Timed paychecks** added automatically to storage  
- 👔 Supports **multiple jobs & grades** with custom salary values  
- 🧾 Salary collected manually at configured locations  
- 🔐 Built-in **job check** to ensure only valid jobs access paycheck locations  
- 🌍 Fully **translatable via `locale.lua`**  
- 🧱 MySQL-based **persistent salary storage**  
- ✅ Optimized for **VorpCore** + `vorp_utils`  

---

## ⚙️ Dependencies

- [vorp_core](https://github.com/VORPCORE/VORP-Core)  
- [vorp_utils](https://github.com/VORPCORE/vorp_utils)  
- [oxmysql](https://github.com/overextended/oxmysql)  

---

## 🛠️ Installation

1. Clone or download the repository:
   ```bash
   git clone https://github.com/OldWestCreations/owc_paychecks.git
   ```

2. Add the resource to your `server.cfg`:
   ```cfg
   ensure vorp_core
   ensure vorp_utils
   ensure oxmysql
   ensure owc_paychecks
   ```

3. Import the following table into your database:
   ```sql
   CREATE TABLE IF NOT EXISTS `paycheck_storage` (
     `identifier` VARCHAR(64) NOT NULL,
     `amount` FLOAT DEFAULT 0,
     `job` VARCHAR(50),
     PRIMARY KEY (`identifier`, `job`)
   );
   ```

4. Open `config.lua` and define:
   - Timers  
   - Allowed jobs  
   - Job grades with salary  
   - Locations to collect salary  

---

## 🔧 Configuration Example

```lua
Config.timer = 1 -- Paycheck interval in minutes

Config.availableJobs = {
    {
        job = 'doctor_val',
        paycheckLocation = vector3(-289.85, 816.26, 119.38),
        jobgrade = {
            {grade = 0, paycheck = 0.035},
            {grade = 1, paycheck = 0.028},
        }
    },
    {
        job = 'doj',
        paycheckLocation = vector3(-292.49, 773.41, 119.33),
        jobgrade = {
            {grade = 0, paycheck = 0.025},
            {grade = 1, paycheck = 0.030},
        }
    }
}
```

---

## 🌍 Translations

All messages, prompts and notifications are managed via `locale.lua`.

```lua
Lang = "de"

Translation.Langs = {
    de = {
        prompt_collect = "Gehalt abholen",
        prompt_group = "Kasse",
        notify_title = "Lohnbüro",
        notify_success = "Du hast dein Gehalt von %s$ abgeholt!",
        notify_nothing = "Kein ausstehendes Gehalt!",
    }
}
```

---

## 🧠 How It Works

- Players receive their salary automatically every X minutes  
- The amount depends on their job and job grade  
- The money is stored in the `paycheck_storage` table  
- Players must go to a configured location and press `G` to collect  
- If no salary is pending, a red notification informs them  

---

## 📃 License

This resource is licensed for **personal or server use only**.  
Do not redistribute or resell.
Please do **not rename** this resource to give credits.

---

## 🙌 Credits

- Script by [HerrScaletta]  
- Based on the VORP framework  

---

## 💬 Support

Issues or feature requests?  
Open an issue or contact me on Discord: `herrscaletta`

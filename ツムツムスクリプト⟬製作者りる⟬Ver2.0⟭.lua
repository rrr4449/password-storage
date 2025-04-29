function AutoSave()
    local state = gg.choice({"有効にする", "無効にする"}, nil, "自動保存設定")
    if state == nil then
        gg.toast("自動保存設定をキャンセルしました")
        return
    end

    local file = io.open("/storage/emulated/0/TsumState.lua", "w")
    if file then
        if state == 1 then
            file:write("return true")
            gg.alert("自動保存が有効になりました")
        elseif state == 2 then
            file:write("return false")
            gg.alert("自動保存が無効になりました")
        end
        file:close()
    else
        gg.alert("ファイル書き込みに失敗しました")
    end
end

function LLL()
    os.exit()
end

local choices = {
    ["TopMenu"] = {
        title = "ツムツムスクリプト\n製作者: りる",
        menuType = "choice",
        items = {
            {
                Name = "メインMenu",
                Func = function() currentMenu = "MainMenu" end,
                NoSave = true
            },
            {
                Name = "サブMenu",
                Func = function() currentMenu = "SubMenu" end,
                NoSave = true
            },
            {
                Name = "試合即終了",
                NoSave = true,
                Func = function()
                  ApplyPatch({0x176C2C4}, {"1F 20 03 D5"}, {"08 20 20 1E"}, true)
                  gg.sleep(500) -- 1000ミリ秒 = 1秒
                  ApplyPatch({0x176C2C4}, {"1F 20 03 D5"}, {"08 20 20 1E"}, false)
                  gg.toast("試合即終了")
              end
            },
            {
                Name = "自動保存+復元",
                Func = AutoSave,
                NoSave = true
            },
            {
                Name = "スクリプト終了",
                Func = LLL,
                NoSave = true
            }
        }
    },
    ["MainMenu"] = {
        title = "メインMenu",
        menuType = "multiChoice",
        items = {
            {
                Name = "メダルMenu",
                Func = function() currentMenu = "MedalMenu" end,
                NoSave = true
            },
            {
                Name = "コインMenu",
                Func = function() currentMenu = "CoinMenu" end,
                NoSave = true
            },
            {
                Name = "倍速Menu",
                Func = function() currentMenu = "BaisokuMenu" end,
                NoSave = true
            },
            {
                RadioTag = "倍速",
                GroupTag = "代行者専用",
                Name = "1.5倍速",
                Offset = {0x1F3AB00},
                OnHex = {"00 10 28 1E"},
                NoSave = false
            },
            {
                GroupTag = "代行者専用",
                Name = "ガチャスキップ",
                Offset = {0x17B0DD0},
                OnHex = {"C0 03 5F D6"},
                OffHex = {"FF 43 01 D1"},
                NoSave = false
            },
            {
                Name = "代行者専用機能",
                Ongroup = "代行者専用",
                NoSave = false
            },
            {
                Name = "代行者専用機能を確認",
                Func = function() Kakuninn() end,
                NoSave = true
            },
            {
                Name = "プレイヤーLv.Max",
                Offset = {0x17827BC},
                OnHex = {"F4 07 25 32"},
                OffHex = {"F4 03 01 2A"},
                NoSave = false
            },
            {
                Name = "ツムLv.Max",
                Offset = {0x1772CD0},
                OnHex = {"01 6A 98 52"},
                OffHex = {"21 05 00 11"},
                NoSave = false
            },
            {
                Name = "戻る",
                Func = function() currentMenu = "TopMenu" end,
                NoSave = true
            }
        }
    },
    ["MedalMenu"] = {
        title = "メダルMenu",
        menuType = "choice",
        items = {
            {
                RadioTag = "メダル",
                Name = "1億メダル",
                Offset = {0x1783434, 0x178D0B8},
                OnHex = {"21 27 00 94", "12 E2 84 52 11 E2 84 52 54 7E 11 1B C0 03 5F D6"},
                NoSave = false
            },
            {
                RadioTag = "メダル",
                Name = "2億メダル",
                Offset = {0x1783434, 0x178D0B8},
                OnHex = {"21 27 00 94", "12 E2 84 52 11 C4 89 52 54 7E 11 1B C0 03 5F D6"},
                NoSave = false
            },
            {
                RadioTag = "メダル",
                Name = "メダル指定: OFF",
                Offset = {0x1783434, 0x178D0B8},
                OnHex = {"F4 03 01 2A", "00 01 3F D6 88 0A 40 B9 08 05 00 71 88 0A 00 B9"},
                NoSave = false
            },
            {
                Name = "戻る",
                Func = function() currentMenu = "MainMenu" end,
                NoSave = true
            }
        }
    },
    ["CoinMenu"] = {
        title = "コインMenu",
        menuType = "choice",
        items = {
            {
                RadioTag = "コイン",
                Name = "1億コイン",
                Offset = {0x175AA34, 0x1769DA4},
                OnHex = {"DC 3C 00 94", "12 E2 84 52 11 E2 84 52 54 7E 11 1B C0 03 5F D6"},
                NoSave = false
            },
            {
                RadioTag = "コイン",
                Name = "2億コイン",
                Offset = {0x175AA34, 0x1769DA4},
                OnHex = {"DC 3C 00 94", "12 E2 84 52 11 C4 89 52 54 7E 11 1B C0 03 5F D6"},
                NoSave = false
            },
            {
                RadioTag = "コイン",
                Name = "コイン指定: OFF",
                Offset = {0x175AA34, 0x1769DA4},
                OnHex = {"F4 03 01 2A", "68 3E 46 39 48 17 00 34 68 EA 45 39 08 17 00 34"},
                NoSave = false
            },
            {
                Name = "戻る",
                Func = function() currentMenu = "MainMenu" end,
                NoSave = true
            }
        }
    },
    ["BaisokuMenu"] = {
        title = "倍速Menu",
        menuType = "choice",
        items = {
            {
                RadioTag = "倍速",
                Name = "2倍速",
                Offset = {0x1F3AB00},
                OnHex = {"00 50 29 1E"},
                NoSave = false
            },
            {
                RadioTag = "倍速",
                Name = "5倍速",
                Offset = {0x1F3AB00},
                OnHex = {"00 90 20 1E"},
                NoSave = false
            },
            {
                RadioTag = "倍速",
                Name = "倍速: OFF",
                Offset = {0x1F3AB00},
                OnHex = {"00 18 21 1E"},
                NoSave = false
            },
            {
                Name = "戻る",
                Func = function() currentMenu = "MainMenu" end,
                NoSave = true
            }
        }
    },
    ["SubMenu"] = {
        title = "サブMenu",
        menuType = "multiChoice",
        items = {
            {
                GroupTag = "代行者専用",
                Name = "時間停止",
                Offset = {0x176BFF4},
                OnHex = {"h 00 20 20 1E"},
                OffHex = {"08 20 20 1E"},
                NoSave = false
            },
            {
                GroupTag = "代行者専用",
                Name = "繋ぎ終了",
                Offset = {0x17782EC},
                OnHex = {"20 07 00 54"},
                OffHex = {"21 07 00 54"},
                NoSave = false
            },
            {
                GroupTag = "代行者専用",
                Name = "オートチェーン",
                Offset = {0x1C9E248},
                OnHex = {"1F 18 45 B9"},
                OffHex = {"08 18 45 B9"},
                NoSave = false
            },
            {
                GroupTag = "代行者専用",
                Name = "試合開始時間短縮",
                Offset = {0x176B268},
                OnHex = {"01 10 28 1E"},
                OffHex = {"01 10 2F 1E"},
                NoSave = false
            },
            {
                GroupTag = "代行者専用",
                Name = "リザルトスキップ",
                Offset = {0x1784644},
                OnHex = {"A8 01 00 35"},
                OffHex = {"A8 01 00 34"},
                NoSave = false
            },
            {
                GroupTag = "代行者専用",
                Name = "イベント情報無効化",
                Offset = {0x1D894C4},
                OnHex = {"C1 00 00 54"},
                OffHex = {"C0 00 00 54"},
                NoSave = false
            },
            {
                Name = "指定Menu",
                Func = function() Sitei() end,
                NoSave = true
            },
            {
                Name = "追加予定機能",
                Func = function() Kakuninn1() end,
                NoSave = true
            },
            {
                Name = "戻る",
                Func = function() currentMenu = "TopMenu" end,
                NoSave = true
            }
        }
    }
}

function Kakuninn()
 gg.alert("-> ガチャスキップ\n-> 時間停止\n-> 繋ぎ終了\n-> オートチェーン\n-> 試合開始時間短縮\n-> リザルトスキップ\n->イベント情報無効化")
end

function Kakuninn1()
 gg.alert("指定系、倍速[追加予定]")
end

local state = {}
for _, menu in pairs(choices) do
    for _, option in ipairs(menu.items) do
        state[option.Name] = false
    end
end

local searchHex = "h7F 45 4C 46 02 01 01 00 00 00 00 00 00 00 00 00 03 00 B7 00 01 00 00 00 00 00 00 00 00 00 00 00 40 00 00 00 00 00 00 00 40 DA 95 0D"
local baseAddr = nil -- 基準アドレスを保持するための変数

function ApplyPatch(offsets, onHexes, offHexes, isOn)
    -- すでに検索結果が存在していれば再検索しない
    if not baseAddr then
        gg.setRanges(gg.REGION_CODE_APP)
        gg.clearResults()
        gg.searchNumber(searchHex, gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1)

        local resultCount = gg.getResultsCount()
        if resultCount == 0 then
            gg.alert("該当するHexが見つかりませんでした。")
            return
        end

        local results = gg.getResults(resultCount)
        baseAddr = results[1].address -- 基準アドレスを保存
    end

    local function hexToBytes(hexStr)
        local bytes = {}
        hexStr = hexStr:gsub("[^%x]", "")
        for i = 1, #hexStr, 2 do
            table.insert(bytes, tonumber(hexStr:sub(i, i + 1), 16))
        end
        return bytes
    end

    local patch = {}
    for idx, offset in ipairs(offsets) do
        local targetAddr = baseAddr + offset
        local onBytes = hexToBytes(onHexes[idx])
        local offBytes = (offHexes and offHexes[idx]) and hexToBytes(offHexes[idx]) or {}
        local bytesToApply = isOn and onBytes or offBytes
        for i, byte in ipairs(bytesToApply) do
            table.insert(patch, { address = targetAddr + (i - 1), flags = gg.TYPE_BYTE, value = byte })
        end
    end

    gg.setValues(patch)
end

local autoRestore = false
local ok, result = pcall(loadfile, "/storage/emulated/0/TsumState.lua")
if ok and result then
    autoRestore = result()
end

if autoRestore then
    local ok2, saved = pcall(loadfile, "/storage/emulated/0/TsumSaveData.lua")
    if ok2 and saved then
        local savedState = saved()

        -- Step 1: 状態だけ先にセット
        for _, menu in pairs(choices) do
            for _, option in ipairs(menu.items) do
                if savedState[option.Name] ~= nil then
                    state[option.Name] = savedState[option.Name]
                end
            end
        end

        -- Step 2: ApplyPatch と関数呼び出し
        for _, menu in pairs(choices) do
            for _, option in ipairs(menu.items) do
                if state[option.Name] == true and option.Offset then
                    ApplyPatch(option.Offset, option.OnHex, option.OffHex, true)
                    if type(option.Func) == "function" then
                        option.Func()
                    end
                end
            end
        end

        -- Step 3: Ongroup が ON なら GroupTag も ON にする
        for _, menu in pairs(choices) do
            for _, option in ipairs(menu.items) do
                if option.Ongroup and state[option.Name] == true then
                    local tag = option.Ongroup
                    for _, menu2 in pairs(choices) do
                        for _, opt2 in ipairs(menu2.items) do
                            if opt2.GroupTag == tag then
                                if opt2.Offset then
                                    ApplyPatch(opt2.Offset, opt2.OnHex, opt2.OffHex, true)
                                end
                                state[opt2.Name] = true
                                if type(opt2.Func) == "function" then
                                    opt2.Func()
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

local function syncRadioGroup(radioTag, selectedName)
    for _, menu in pairs(choices) do
        for _, option in ipairs(menu.items) do
            if option.RadioTag == radioTag and option.Name ~= selectedName then
                if option.Offset then
                    ApplyPatch(option.Offset, option.OnHex, option.OffHex, false)
                end
                state[option.Name] = false
            end
        end
    end
end

function ShowMenu(menuName)
    local menu = choices[menuName]
    local choiceNames = {}

    -- メニュー項目の名前と現在の状態を表示
    for _, option in ipairs(menu.items) do
        if not option.NoSave then
            local status = state[option.Name] and "⟬ON⟭" or "⟬OFF⟭"
            table.insert(choiceNames, option.Name .. " " .. status)
        else
            table.insert(choiceNames, option.Name)
        end
    end

    local choice

    if menu.menuType == "multiChoice" then
        choice = gg.multiChoice(choiceNames, nil, menu.title)
    elseif menu.menuType == "choice" then
        choice = gg.choice(choiceNames, nil, menu.title)
    elseif menu.menuType == "prompt" then
        local promptLabels = {}
        local promptDefaults = {}
        local promptTypes = {}

        for _, opt in ipairs(menu.items) do
            table.insert(promptLabels, opt.Name)
            table.insert(promptDefaults, opt.Default or "")
            table.insert(promptTypes, opt.InputType or "text") -- optional: "text", "number"
        end

        local result = gg.prompt(promptLabels, promptDefaults, promptTypes)

        if result then
            for i, input in ipairs(result) do
                local opt = menu.items[i]
                if type(opt.Func) == "function" then
                    opt.Func(input)
                end
            end
        else
            gg.toast("入力をキャンセルしました")
        end
        return
    end

    if choice == nil then return end

    local shouldReopen = false

    -- グループ制御関数定義
    local function syncChildren(parentTag, newState)
        for _, menu2 in pairs(choices) do
            for _, opt2 in ipairs(menu2.items) do
                if opt2.GroupTag == parentTag then
                    if opt2.Offset then
                        ApplyPatch(opt2.Offset, opt2.OnHex, opt2.OffHex, newState)
                    end
                    state[opt2.Name] = newState
                    if type(opt2.Func) == "function" then
                        opt2.Func()
                    end
                end
            end
        end
    end

    local function syncParent(childTag)
        local allOn, allOff = true, true
        local parentOption = nil

        for _, menu2 in pairs(choices) do
            for _, opt2 in ipairs(menu2.items) do
                if opt2.GroupTag == childTag then
                    if not state[opt2.Name] then allOn = false end
                    if state[opt2.Name] then allOff = false end
                end
                if opt2.Ongroup == childTag then
                    parentOption = opt2
                end
            end
        end

        if parentOption then
            local parentState = state[parentOption.Name]
            local targetState = parentState
            if allOn then
                targetState = true
            elseif allOff then
                targetState = false
            end

            if targetState ~= parentState then
                if parentOption.Offset then
                    ApplyPatch(parentOption.Offset, parentOption.OnHex, parentOption.OffHex, targetState)
                end
                state[parentOption.Name] = targetState
                if type(parentOption.Func) == "function" then
                    parentOption.Func()
                end
            end
        end
    end

    local function syncRadioGroup(radioTag, selectedName)
        for _, menu2 in pairs(choices) do
            for _, opt2 in ipairs(menu2.items) do
                if opt2.RadioTag == radioTag and opt2.Name ~= selectedName and state[opt2.Name] == true then
                    if opt2.Offset then
                        ApplyPatch(opt2.Offset, opt2.OnHex, opt2.OffHex, false)
                    end
                    state[opt2.Name] = false
                end
            end
        end
    end

    if menu.menuType == "multiChoice" then
        for i, selected in pairs(choice) do
            if selected then
                local opt = menu.items[i]

                if state[opt.Name] then
                    if opt.RadioTag then return end
                    local newState = false
                    if opt.Offset then
                        ApplyPatch(opt.Offset, opt.OnHex, opt.OffHex, newState)
                    end
                    state[opt.Name] = newState
                    if opt.Ongroup then syncChildren(opt.Ongroup, newState) end
                    if opt.GroupTag then syncParent(opt.GroupTag) end
                    if type(opt.Func) == "function" then
                        opt.Func()
                        shouldReopen = true
                    end
                else
                    local newState = not state[opt.Name]
                    if opt.Offset then
                        ApplyPatch(opt.Offset, opt.OnHex, opt.OffHex, newState)
                    end
                    state[opt.Name] = newState
                    if opt.RadioTag and newState then syncRadioGroup(opt.RadioTag, opt.Name) end
                    if opt.Ongroup then syncChildren(opt.Ongroup, newState) end
                    if opt.GroupTag then syncParent(opt.GroupTag) end
                    if type(opt.Func) == "function" then
                        opt.Func()
                        shouldReopen = true
                    end
                end
            end
        end
    elseif menu.menuType == "choice" then
        local opt = menu.items[choice]

        if state[opt.Name] then
            if opt.RadioTag then return end
            local newState = false
            if opt.Offset then
                ApplyPatch(opt.Offset, opt.OnHex, opt.OffHex, newState)
            end
            state[opt.Name] = newState
            if opt.Ongroup then syncChildren(opt.Ongroup, newState) end
            if opt.GroupTag then syncParent(opt.GroupTag) end
            if type(opt.Func) == "function" then
                opt.Func()
                shouldReopen = true
            end
        else
            local newState = not state[opt.Name]
            if opt.Offset then
                ApplyPatch(opt.Offset, opt.OnHex, opt.OffHex, newState)
            end
            state[opt.Name] = newState
            if opt.RadioTag and newState then syncRadioGroup(opt.RadioTag, opt.Name) end
            if opt.Ongroup then syncChildren(opt.Ongroup, newState) end
            if opt.GroupTag then syncParent(opt.GroupTag) end
            if type(opt.Func) == "function" then
                opt.Func()
                shouldReopen = true
            end
        end
    end

    if shouldReopen then
        ShowMenu(currentMenu)
    end
end


function SaveState()
    local file = io.open("/storage/emulated/0/TsumSaveData.lua", "w")
    if file then
        file:write("return {\n")
        for _, menu in pairs(choices) do
            for _, option in ipairs(menu.items) do
                if not option.NoSave then
                    local value = state[option.Name] or false
                    file:write(string.format("    [\"%s\"] = %s,\n", option.Name, tostring(value)))
                end
            end
        end
        file:write("}")
        file:close()
    end
end

currentMenu = "TopMenu"
while true do
    if gg.isVisible(true) then
        gg.setVisible(false)
        ShowMenu(currentMenu)
        SaveState()
    end
end
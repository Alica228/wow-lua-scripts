local frame = CreateFrame("Frame", "MuteMenuFrame", UIParent, "BasicFrameTemplateWithInset")
frame:SetSize(350, 250)
frame:SetPoint("CENTER")

frame.title = frame:CreateFontString(nil, "OVERLAY")
frame.title:SetFontObject("GameFontHighlight")
frame.title:SetPoint("LEFT", frame.TitleBg, "LEFT", 5, 0)
frame.title:SetText("Выбор наказания для: " .. name)

frame.subtitle = frame:CreateFontString(nil, "OVERLAY")
frame.subtitle:SetFontObject("GameFontHighlight")
frame.subtitle:SetPoint("TOPLEFT", 10, -30)
frame.subtitle:SetText("Нарушители чата")

-- Создаем кнопки для причин
local reasons = {
    ["Оскорбление по национальному признаку"] = {300, 3600},
    ["Оскорбление родителей (завуал)"] = 5000,
    ["Оскорбление родителей"] = 10000,
    ["Розжиг межнациональной розни"] = 20000,
}
local reasonCheckboxes = {}
local timeRadios = {}

local yOffset = -40
for reason, duration in pairs(reasons) do
    local checkbox = CreateFrame("CheckButton", nil, frame, "UICheckButtonTemplate")
    checkbox:SetPoint("TOPLEFT", 10, yOffset)
    checkbox.text = checkbox:CreateFontString(nil, "OVERLAY")
    checkbox.text:SetFontObject("GameFontNormal")
    checkbox.text:SetPoint("LEFT", checkbox, "RIGHT", 5, 0)
    checkbox.text:SetText(reason)
    reasonCheckboxes[reason] = checkbox

    if type(duration) == "table" then
        local radio1 = CreateFrame("CheckButton", nil, frame, "UIRadioButtonTemplate")
        radio1:SetPoint("TOPLEFT", 200, yOffset-2)
        radio1.text = radio1:CreateFontString(nil, "OVERLAY")
        radio1.text:SetFontObject("GameFontNormal")
        radio1.text:SetPoint("LEFT", radio1, "RIGHT", 5, 0)
        radio1.text:SetText((duration[1] / 60).." минут")
        radio1:SetChecked(true);
        radio1.duration = duration[1]

        local radio2 = CreateFrame("CheckButton", nil, frame, "UIRadioButtonTemplate")
        radio2:SetPoint("TOPLEFT", 280, yOffset-2)
        radio2.text = radio2:CreateFontString(nil, "OVERLAY")
        radio2.text:SetFontObject("GameFontNormal")
        radio2.text:SetPoint("LEFT", radio2, "RIGHT", 5, 0)
        radio2.text:SetText((duration[1] / 60).." минут")
        radio2.duration = duration[2]

        table.insert(timeRadios, {radio1, radio2})

        checkbox:SetScript("OnClick",
            function()
                if checkbox:GetChecked() and radio1 then
                    abc
                end
            end
        );
    end

    yOffset = yOffset - 20
end

-- Создаем поле для ввода номера поста
local postEditBox = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
postEditBox:SetSize(100, 30)
postEditBox:SetPoint("TOPLEFT", 10, yOffset - 20)
postEditBox:SetAutoFocus(false)
postEditBox:SetText("#номер поста")

-- Кнопка подтверждения
local confirmButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
confirmButton:SetPoint("BOTTOM", frame, "BOTTOM", 0, 10)
confirmButton:SetSize(80, 40)
confirmButton:SetText("OK")
confirmButton:SetScript("OnClick", function()
    local selectedReasons = {}
    local totalDuration = 0

    for reason, checkbox in pairs(reasonCheckboxes) do
        if checkbox:GetChecked() then
            if type(reasons[reason]) == "table" then
                -- Если для причины есть варианты времени, проверяем радио-кнопки
                for _, radios in ipairs(timeRadios) do
                    if radios[1]:GetChecked() then
                        totalDuration = totalDuration + radios[1].duration
                    elseif radios[2]:GetChecked() then
                        totalDuration = totalDuration + radios[2].duration
                    end
                end
                table.insert(selectedReasons, reason:sub(4)) -- убираем "НЧ "
            else
                totalDuration = totalDuration + reasons[reason]
                table.insert(selectedReasons, reason:sub(4)) -- убираем "НЧ "
            end
        end
    end

    local postNumber = postEditBox:GetText()
    local punishmentText = "НЧ " .. table.concat(selectedReasons, " + ") .. "(" .. postNumber .. ")"
    MuteReason:SetText(punishmentText)
    NotesFu:Show()
    MuteCharName:SetText(name)
    MuteLength:SetText(tostring(totalDuration))
frame:Hide()
    end) -- Закрываем функцию confirmButton:SetScript
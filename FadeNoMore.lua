local FadeNoMore = LibStub("AceAddon-3.0"):NewAddon("FadeNoMore", "AceConsole-3.0", "AceEvent-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

local defaults = {
    profile = {
        DisableFading = true,
    },
}

local options = {
    name = "Fade No More",
    handler = FadeNoMore,
    type = "group",
    args = {
        description = {
            type = "description",
            name = "Disable chat fading for all chat frames. When enabled, messages will stay visible forever.",
            order = 0,
        },
        DisableFading = {
            type = "toggle",
            name = "Disable Chat Fading",
            desc = "Disable fading for all chat frames.",
            order = 1,
            get = function(info) return FadeNoMore.db.profile.DisableFading end,
            set = function(info, value)
                FadeNoMore.db.profile.DisableFading = value
                FadeNoMore:ApplySettings()
                if value then
                    FadeNoMore:Print("Chat fading disabled.")
                else
                    FadeNoMore:Print("Chat fading enabled.")
                end
            end,
        },
    },
}

function FadeNoMore:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("FadeNoMoreDB", defaults, true)
    AceConfig:RegisterOptionsTable("FadeNoMore", options)
    self.optionsFrame = AceConfigDialog:AddToBlizOptions("FadeNoMore", "Fade No More")
end

function FadeNoMore:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "ApplySettings")
end

function FadeNoMore:ApplySettings()
    local disableFading = self.db.profile.DisableFading

    for i = 1, 10 do
        local frame = _G["ChatFrame" .. i]
        if frame then
            frame:SetFading(not disableFading)
        end
    end
end

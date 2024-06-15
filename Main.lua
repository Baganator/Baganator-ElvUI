local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")
local LSM = E.Libs.LSM

local function ConvertTags(tags)
  local res = {}
  for _, tag in ipairs(tags) do
    res[tag] = true
  end
  return res
end

local skinners = {
  ItemButton = function(frame)
    frame.bgrElvUISkin = true
    S:HandleItemButton(frame, true)
    S:HandleIconBorder(frame.IconBorder)
    if frame.SetItemButtonTexture then
      hooksecurefunc(frame, "SetItemButtonTexture", function()
        frame.icon:SetTexCoord(unpack(E.TexCoords))
      end)
    end
    if frame.JunkIcon then
      frame.JunkIcon:SetAtlas('bags-junkcoin', true)
    end
    -- Fix search overlay being removed by ElvUI in classic
    if Baganator.Constants.IsClassic then
      frame.searchOverlay:SetColorTexture(0, 0, 0, 0.8)
    end
  end,
  IconButton = function(frame)
    S:HandleButton(frame)
  end,
  Button = function(frame)
    S:HandleButton(frame)
  end,
  ButtonFrame = function(frame)
    S:HandlePortraitFrame(frame)
  end,
  SearchBox = function(frame)
    S:HandleEditBox(frame)
  end,
  EditBox = function(frame)
    S:HandleEditBox(frame)
  end,
  TabButton = function(frame)
    S:HandleTab(frame)
  end,
  TopTabButton = function(frame)
    S:HandleTab(frame)
  end,
  SideTabButton = function(frame)
    frame.Background:Hide()

    frame.Icon:ClearAllPoints()
    frame.Icon:SetPoint("CENTER")
    frame.Icon:SetSize(25, 25)
    frame.Icon:SetTexCoord(unpack(E.TexCoords))

    frame.SelectedTexture:ClearAllPoints()
    frame.SelectedTexture:SetPoint("CENTER")
    frame.SelectedTexture:SetSize(25, 25)
    frame.SelectedTexture:SetTexture(E.Media.Textures.Melli)
    frame.SelectedTexture:SetVertexColor(1, .82, 0, 0.6)

    S:HandleTab(frame)
    frame:SetTemplate("Transparent")
  end,
  TrimScrollBar = function(frame)
    S:HandleTrimScrollBar(frame)
  end,
  CheckBox = function(frame)
    S:HandleCheckBox(frame)
  end,
  Slider = function(frame)
    S:HandleSliderFrame(frame)
  end,
  InsetFrame = function(frame)
    if frame.NineSlice then
      frame.NineSlice:SetTemplate("Transparent")
    else
      S:HandleInsetFrame(frame)
    end
  end,
  CornerWidget = function(frame, tags)
    if frame:IsObjectType("FontString") and BAGANATOR_ELVUI_USE_BAG_FONT then
      frame:FontTemplate(LSM:Fetch('font', E.db.bags.countFont), Baganator.Config.Get(Baganator.Config.Options.ICON_TEXT_FONT_SIZE), E.db.bags.countFontOutline)
    end
  end,
  DropDownWithPopout = function(button)
    button.HighlightTexture:SetAlpha(0)
    button.NormalTexture:SetAlpha(0)

    local r, g, b, a = unpack(E.media.backdropfadecolor)
    button.Popout:StripTextures()
    button.Popout:SetTemplate('Transparent')
    button.Popout:SetBackdropColor(r, g, b, max(a, 0.9))

    local expandArrow = button:CreateTexture(nil, "ARTWORK")
    expandArrow:SetTexture(E.Media.Textures.ArrowUp)
    expandArrow:SetRotation(S.ArrowRotation.down)
    expandArrow:Size(15)
    expandArrow:SetPoint("RIGHT", -10, 0)

    S:HandleButton(button, nil, nil, nil, true)
    button.backdrop:SetInside(nil, 4, 4)
  end,
}

if C_AddOns.IsAddOnLoaded("Masque") then
  local Masque = LibStub("Masque", true)
  local masqueGroup = Masque:Group("Baganator", "Bag")
  if not masqueGroup.db.Disabled then
    skinners.ItemButton = function() end
  end
else
  hooksecurefunc("SetItemButtonTexture", function(frame)
    if frame.bgrElvUISkin then
      (frame.icon or frame.Icon):SetTexCoord(unpack(E.TexCoords))
    end
  end)
end

local function SkinFrame(details)
  local func = skinners[details.regionType]
  if func then
    func(details.region, details.tags and ConvertTags(details.tags) or {})
  end
end

Baganator.API.Skins.RegisterListener(SkinFrame)

Baganator.Config.Set(Baganator.Config.Options.EMPTY_SLOT_BACKGROUND, true)

for _, details in ipairs(Baganator.API.Skins.GetAllFrames()) do
  SkinFrame(details)
end

local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local skinners = {
  ItemButton = function(frame)
    S:HandleItemButton(frame, true)
    S:HandleIconBorder(frame.IconBorder)
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
}

local function SkinFrame(details)
  local func = skinners[details.regionType]
  if func then
    func(details.region)
  else
    print("missing", details.regionType)
  end
end

Baganator.API.Skins.RegisterListener(SkinFrame)

Baganator.Config.Set(Baganator.Config.Options.EMPTY_SLOT_BACKGROUND, true)

for _, details in ipairs(Baganator.API.Skins.GetAllFrames()) do
  SkinFrame(details)
end

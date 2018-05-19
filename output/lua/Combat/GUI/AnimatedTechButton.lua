--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * New GUI that appears when the marines attempt to buy something using the 'B' key.
]]

class 'AnimatedTechButton'

AnimatedTechButton.kTechButtonTextureSize = 80
AnimatedTechButton.kTechTexture = "ui/buildmenu.dds"
AnimatedTechButton.AnimationTime = 1.25
AnimatedTechButton.AnimationWaitTime = 3

function AnimatedTechButton:Initialize(script, techId, position)

    AnimatedTechButton.kTechButtonSize = Vector(GUIScaleWidth(54), GUIScaleHeight(64), 0)
    AnimatedTechButton.kButtonExpandSize = Vector(GUIScaleWidth(20), GUIScaleHeight(20), 0)

    self.GUIScript = script
    self.TechId = techId
    self.ToolTip = ""

    self.IsEnabled = false
    self.IsSelected = false
    self.IsPurchased = false
    self.IsUnlocked = false

    self.EnabledColor = Color(1, 1, 1, 1)
    self.DisabledColor = Color(1, 0, 0, 1)
    self.PurcahsedColor = Color(1, 1, 1, 1)
    self.SelectedColor = Color(1, 1, 1, 1)
    self.LockedColor = Color(0, 0, 0, 1)

    -- create the graphic
    local iconX, iconY = GetMaterialXYOffset(techId, false)
    iconX = iconX * AnimatedTechButton.kTechButtonTextureSize
    iconY = iconY * AnimatedTechButton.kTechButtonTextureSize

    self.Icon = self.GUIScript:CreateAnimatedGraphicItem()
    self.Icon:SetIsScaling(false)
    self.Icon:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.Icon:SetSize(AnimatedTechButton.kTechButtonSize)
    self.Icon:SetPosition(position)
    self.Icon:SetTexture(AnimatedTechButton.kTechTexture)
    self.Icon:SetTexturePixelCoordinates(iconX, iconY, iconX + AnimatedTechButton.kTechButtonTextureSize, iconY + AnimatedTechButton.kTechButtonTextureSize)

    self.elapsedSinceColorSwap = 0
    self.swapColors = false
    self.unexpandedPosition = position

end

function AnimatedTechButton:SetColors(enabledColor, disabledColor, purchasedColor, selectedColor)

    self.EnabledColor = enabledColor
    self.DisabledColor = disabledColor
    self.PurcahsedColor = purchasedColor
    self.SelectedColor = selectedColor

end

function AnimatedTechButton:SetIsPurchased(isPurchased)
    self.IsPurchased = isPurchased
end

function AnimatedTechButton:SetIsEnabled(isEnabled)
    self.IsEnabled = isEnabled
end

function AnimatedTechButton:SetIsUnlocked(isUnlocked)
    self.IsUnlocked = isUnlocked
end

function AnimatedTechButton:SetIsSelected(isSelected)

    self.IsSelected = isSelected
    
    self.Icon:DestroyAnimations()
    self.elapsedSinceColorSwap = 0

    if isSelected then
        self.Icon:SetSize(self.Icon:GetSize() + AnimatedTechButton.kButtonExpandSize)
        self.Icon:SetPosition(self.unexpandedPosition - AnimatedTechButton.kButtonExpandSize / 2)
    else
        self.Icon:SetSize(AnimatedTechButton.kTechButtonSize)
        self.Icon:SetPosition(self.unexpandedPosition)
    end

end

function AnimatedTechButton:SetToolTip(toolTip)
    self.ToolTip = toolTip
end

function AnimatedTechButton:Update(deltaTime)

    if self.IsPurchased then

        self.elapsedSinceColorSwap = 0
        self.Icon:SetColor(self.PurcahsedColor)

    elseif not self.IsUnlocked then

        self.elapsedSinceColorSwap = 0
        self.Icon:SetColor(self.LockedColor)

    elseif self.IsEnabled and self.IsSelected then

        self.elapsedSinceColorSwap = self.elapsedSinceColorSwap + deltaTime

        if self.elapsedSinceColorSwap >= AnimatedTechButton.AnimationTime then

            self.elapsedSinceColorSwap = 0
            self.swapColors = not self.swapColors
            self.Icon:DestroyAnimations()
            
            self.Icon:SetColor(ConditionalValue(self.swapColors, self.EnabledColor, self.SelectedColor), AnimatedTechButton.AnimationTime)

        end

    elseif self.IsEnabled and not self.IsSelected then

        self.elapsedSinceColorSwap = 0
        self.Icon:SetColor(self.EnabledColor)

    elseif not self.IsEnabled then

        self.elapsedSinceColorSwap = 0
        self.Icon:SetColor(self.DisabledColor)

    end

end
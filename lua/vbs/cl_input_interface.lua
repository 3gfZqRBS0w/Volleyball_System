print("input interface demarrer")


local function AfficheMenu()
    VBS_Verification()

    ListeTouche = RecupereSauvegarde() or {}

    local nbElement = net.ReadInt(9)

    local TOUCHECONFIGURATION = vgui.Create("DFrame")
    TOUCHECONFIGURATION:Center()
    TOUCHECONFIGURATION:SetSize(ScrH() / 3, ScrW() / 5)
    TOUCHECONFIGURATION:ShowCloseButton(false)

    TOUCHECONFIGURATION:SetTitle("Configuration Touche VBS")
    TOUCHECONFIGURATION:SetVisible(true)
    TOUCHECONFIGURATION:SetDraggable(true)
    TOUCHECONFIGURATION:ShowCloseButton(true)
    TOUCHECONFIGURATION:MakePopup()

    TOUCHECONFIGURATION.Paint = function(self, w, h)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(Material("terrain.png"))
        surface.DrawTexturedRect(0, 0, w, h)
        draw.RoundedBox(0, 0, 0, w, 29, Color(0, 0, 0))
    end

    local BarScroll = vgui.Create("DScrollPanel", TOUCHECONFIGURATION)
    BarScroll:Dock(FILL)

    local labelConfiguration = BarScroll:Add("DLabel")
    labelConfiguration:SetPos(40, 40)
    labelConfiguration:Dock(TOP)
    labelConfiguration:SetText("CONFIGURATION")
    labelConfiguration:SetFont("vbsfont1")
    labelConfiguration.Paint = function(self, w, h)
        draw.RoundedBox(2, 0, 0, w, h, Color(255, 0, 0))
    end

    local sbar = BarScroll:GetVBar()
    function sbar:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
    end
    function sbar.btnUp:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0))
    end
    function sbar.btnDown:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0))
    end
    function sbar.btnGrip:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0))
    end

    for k, v in pairs(ListeTouche) do
        local ToucheSelection = BarScroll:Add("DBinder")
        ToucheSelection:SetText(string.Replace(ListeTouche[k]["NomCoup"], "_", " "))
        ToucheSelection:SetFont("vbsfont1")
        ToucheSelection:Dock(TOP)
        ToucheSelection:SetHeight(50)
        ToucheSelection.Col = Color(255, 255, 255, 200)

        ToucheSelection.Paint = function(self, w, h)
            draw.RoundedBox(2, 0, 0, w, h, self.Col)
            surface.SetDrawColor(0, 0, 0, 128)
            surface.DrawOutlinedRect(0, 0, w, h, 1)
        end

        ToucheSelection.OnCursorEntered = function(self)
            self.AncienTitre = self:GetText()

            if (ListeTouche[k]["CodeTouche"] == 0) then
                self.Col = Color(255, 0, 0, 255)
                self:SetText("Non défini")
            else
                self.Col = Color(50, 180, 50, 255)
                self:SetText(input.GetKeyName(ListeTouche[k]["CodeTouche"]))
            end
        end

        ToucheSelection.OnCursorExited = function(self)
            self.Col = Color(255, 255, 255, 200)
            self:SetText(self.AncienTitre or "ERROR")
        end

        function ToucheSelection:OnChange(num)
            if (VerifieToucheConfig(ListeTouche, num)) then
                chat.AddText(Color(255, 0, 0), "[VBS] Cette touche est déjà assigner !")
                ListeTouche[k]["CodeTouche"] = 0
            else
                ListeTouche[k]["CodeTouche"] = num
                print(num, "La touche a été assigner")
            end
        end
    end

    local LabelConfig = BarScroll:Add("DLabel")
    LabelConfig:SetPos(40, 40)
    LabelConfig:Dock(TOP)
    LabelConfig:SetText("ENREGISTREMENT")
    LabelConfig:SetFont("vbsfont1")
    LabelConfig.Paint = function(self, w, h)
        draw.RoundedBox(2, 0, 0, w, h, Color(0, 0, 0))
    end

    local Sauvegarder = BarScroll:Add("DButton")
    Sauvegarder:SetText("Sauvegarder")
    Sauvegarder:SetFont("vbsfont1")
    Sauvegarder:Dock(TOP)
    Sauvegarder:SetHeight(50)
    Sauvegarder.Col = Color(255, 255, 255, 200)
    function Sauvegarder:DoClick()
        VBS_RecordingKeys(ListeTouche)
    end
    Sauvegarder.Paint = function(self, w, h)
        draw.RoundedBox(2, 0, 0, w, h, self.Col)
        surface.SetDrawColor(Color(0, 0, 0, 128))
        surface.DrawOutlinedRect(0, 0, w, h, 1)
    end

    Sauvegarder.OnCursorEntered = function(self)
        self.Col = Color(65, 105, 225)
    end

    Sauvegarder.OnCursorExited = function(self)
        self.Col = Color(255, 255, 255, 128)
    end

    local LabelConfig = BarScroll:Add("DLabel")
    LabelConfig:SetPos(40, 40)
    LabelConfig:SetSize(100, 60)
    LabelConfig:Dock(TOP)
    LabelConfig:SetText("Volley Ball System Bêta V0.75\nEcrit par Lombres\n en 2021")
    LabelConfig:SetFont("vbsfont1")
    LabelConfig.Paint = function(self, w, h)
        draw.RoundedBox(2, 0, 0, w, h, Color(0, 0, 0))
    end
end

concommand.Add(
    "configuration_touche",
    function()
        AfficheMenu()
    end
)

hook.Add(
    "OnPlayerChat",
    "VBS_configuration_touche",
    function(pl, textchat)
        if (string.StartWith(textchat, "/vbs_toucheconfiguration")) then
            AfficheMenu()
        end
    end
)

print("[VBS] les fonctions ont démarrer")

local pl = FindMetaTable("Player")

local function tableHasKey(table, key)
    return table[key] ~= nil
end

function VBS_ActivationDeactivation(pl, text)
    if (string.StartWith(text, "/volley")) then
        if (VBS_ACCES_RANK[pl:GetUserGroup()] or VBS_ACCES_STEAMID[pl:SteamID()]) then
            SetGlobalBool("volley_enabled", not GetGlobalBool("volley_enabled"))
            VBS_CooldownJoueur = {}

            ServerLog("\n[VBS] Volley : ", pl:SteamID(), GetGlobalBool("volley_enabled"))

            if (GetGlobalBool("volley_enabled")) then
                timer.Simple(
                    0.5,
                    function()
                        pl:ChatPrint("Le système de volley est en marche")
                    end
                )
            else
                timer.Simple(
                    0.5,
                    function()
                        pl:ChatPrint("Le système de volley n'est plus en marche")
                    end
                )
            end
        else
            timer.Simple(
                0.5,
                function()
                    pl:ChatPrint("Vous ne pouvez pas vous permettre de faire ça ! ")
                end
            )
        end
    end
end

function RecupereLesAttaques(len, pl)
    if (pl:IsValid() and pl:IsPlayer()) then
        net.Start("vbs_touche")
        net.WriteInt(table.Count(VBS_ShotList), 9)
        for k, v in pairs(VBS_ShotList) do
            net.WriteString(k)
        end
        net.Send(pl)
    end
end

-- bad function but I see no other possibility 
function EstZone(len, pl)
    if (pl:VBS_EstDansTerrain() and GetGlobalBool("volley_enabled")) then
        pl:SetJumpPower(350)
        pl:SetWalkSpeed(180)
        pl:SetRunSpeed(330)
    else
        pl:SetJumpPower(200)
        pl:SetWalkSpeed(160)
        pl:SetRunSpeed(240)
    end
end

function VBS_RecupereBallonsProches()
    local TousLesBallons = {}
    for k, v in pairs(VBS_ListOfBalls) do
        table.Add(TousLesBallons, ents.FindByModel(v))
    end
    return TousLesBallons
end

function VBS_JoueurSaute(len, pl)
    if pl:VBS_EstDansTerrain() and GetGlobalBool("volley_enabled") then

        print("saute") ; 
        pl:EmitSound(table.Random(VBS_JumpSoundList), 80, 100, 1, CHAN_AUTO)
        VBS_EstFatigue = CurTime() + VBS_ReprendSonSouffle
    end
end

function VBS_ComportementBalle(len, pl)
    local Ballon = VBS_RecupereBallonsProches()
    local Coup = net.ReadString()

    if not (tableHasKey(VBS_CooldownJoueur, pl:SteamID())) then
        VBS_CooldownJoueur[pl:SteamID()] = 0
    end

    for k, v in pairs(Ballon) do
        if (VBS_CooldownJoueur[pl:SteamID()] < CurTime()) then
            if (pl:GetShootPos():Distance(v:GetPos()) < VBS_PlayerDistanceBall) then
                if (GetGlobalBool("volley_enabled")) then
                    pl:EmitSound(VBS_ShotList[Coup].Bruitage, 70, 100, 1, CHAN_AUTO)
                    v:GetPhysicsObject():SetVelocity(
                        pl:GetAimVector() * VBS_ShotList[Coup].Force + VBS_ShotList[Coup].Direction
                    )
                end
                VBS_CooldownJoueur[pl:SteamID()] = (CurTime() + VBS_ShotList[Coup].Fatigue)
            end
        end
    end
end

function pl:VBS_EstInterieur(vec1, vec2)
    local PPos = self:GetPos()
    local InsideX = (math.min(vec1.x, vec2.x) <= PPos.x and math.max(vec1.x, vec2.x) >= PPos.x)
    local InsideY = (math.min(vec1.y, vec2.y) <= PPos.y and math.max(vec1.y, vec2.y) >= PPos.y)
    local InsideZ = (math.min(vec1.z, vec2.z) <= PPos.z and math.max(vec1.z, vec2.z) >= PPos.z)

    if (InsideX and InsideY and InsideZ) then
        return true
    else
        return false
    end
end

function pl:VBS_EstDansTerrain()
    for k, v in pairs(VBS_PositionofLands) do
        if (self:VBS_EstInterieur(v.min, v.max)) then
            return true
        end
    end
    return false
end

hook.Add("PlayerSay", "activevolley", VBS_ActivationDeactivation)


VBS_RecordingKeys = function(tbl)
    sql.Query("DELETE FROM TOUCHE_VBS ;")
    for k, v in pairs(tbl) do
        sql.Query(
            "INSERT INTO TOUCHE_VBS(NomCoup, CodeTouche) VALUES('" ..
                tbl[k]["NomCoup"] .. "','" .. tbl[k]["CodeTouche"] .. "') ;"
        )
    end
end

RecupereSauvegarde = function()
    local tbl = sql.Query("SELECT * FROM TOUCHE_VBS")
    for k, v in pairs(tbl) do
        if (type(tbl[k]["CodeTouche"]) == "string") then
            tbl[k]["CodeTouche"] = util.StringToType(tbl[k]["CodeTouche"], "int")
        end
    end
    return tbl
end

VerifieToucheConfig = function(tbl, touche)
    for k, v in pairs(tbl) do
        if (tbl[k]["CodeTouche"] == touche) then
            return true
        end
    end
    return false
end

VBS_Verification = function()
    net.Start("vbs_touche")
    net.SendToServer()
    net.Receive(
        "vbs_touche",
        function(len, pl)
            local nbElement = net.ReadInt(9)
            print(sql.QueryValue("SELECT COUNT(*) FROM TOUCHE_VBS ;"))
            if (util.StringToType(sql.QueryValue("SELECT COUNT(*) FROM TOUCHE_VBS ;"), "int") ~= nbElement) then
                -- On reset la table et on la restitue
                sql.Query("DELETE FROM TOUCHE_VBS ;")
                for I = 1, nbElement do
                    local coup = net.ReadString()
                    sql.Query("INSERT INTO TOUCHE_VBS(NomCoup) VALUES('" .. coup .. "') ; ")
                end
            end
        end
    )
end

local CreationSauvegarde = function()
    if (not sql.TableExists("TOUCHE_VBS")) then
        -- On crée la table
        sql.Query(
            [[ 
            CREATE TABLE IF NOT EXISTS TOUCHE_VBS (
                NomCoup VARCHAR(50) NOT NULL,
                CodeTouche DEFAULT 0
            )]]
        )
        -- Puis on la rempli

        VBS_Verification()
    end
end

hook.Add("InitPostEntity", "SAUVEGARDE_VBS", CreationSauvegarde)

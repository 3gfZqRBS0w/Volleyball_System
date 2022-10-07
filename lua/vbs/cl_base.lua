print("[VBS] The cl_base file has been loaded")

local BtnNoEditable = function(pl, btn)
    net.Start("vbs_zone")
    net.SendToServer()
    if GetGlobalBool("volley_enabled")   then
        if (btn == IN_JUMP) then
            net.Start("vbs_saut")
            net.SendToServer()
        end
    end
end

local BtnEditable = function(pl, btn)
    if ( GetGlobalBool("volley_enabled") )  then
        for k, v in pairs(ListeTouche or {}) do 
            if ( btn == ListeTouche[k]["CodeTouche"]  ) then
                net.Start("vbs_coup")
                net.WriteString(ListeTouche[k]["NomCoup"])
                net.SendToServer()
            end
        end
    end
end

hook.Add("KeyPress", "VBS_MOUVEMENT1", BtnNoEditable)
hook.Add("PlayerButtonDown", "VBS_MOUVEMENT2", BtnEditable)
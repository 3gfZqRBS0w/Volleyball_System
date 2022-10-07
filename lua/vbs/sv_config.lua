print("[VBS] Le fichier de configuration à démarrer")

VBS_ACCES_STEAMID = {
    ["STEAM_0:0:76284524"] = false,
    ["STEAM_0:0:564303706"] = false,
    ["STEAM_0:0:152406162"] = false
}

VBS_ACCES_RANK = {
    ["superadmin"] = true,
    ["admin"] = true,
    ["operator"] = false,
    ["user"] = false,
    ["noaccess"] = false
}

VBS_JumpSoundList = {
    "shoes_sound.mp3",
    "shoes_sound2.mp3",
    "shoes_sound3.mp3"
}

VBS_ListOfBalls = {
    ["balle_volley"] = "models/pejal_models/volleyball/volleyball.mdl",
    ["mikasa"] = "models/pejal_models/volleyball/mikasa.mdl",
    ["molten"] = "models/pejal_models/volleyball/molten.mdl"
}

VBS_PositionofLands = {
    ["Terrain1"] = {
        min = Vector( -1172.330444, -965.748596, -414.603577),
        max = Vector( -2910.872559, -2047.882935, -189.166016)
    }
}

VBS_PlayerDistanceBall = 150

--[[
    The _ will be automatically replaced by a space  
]]
VBS_ShotList = {
    ["Service"] = {
        Force = 1200,
        Direction = Vector(0, 0, 150),
        Fatigue = 1,
        Bruitage = "spike.mp3"
    },
    ["Sauvetage"] = {
        Force = 150,
        Direction = Vector(0, 0, 500),
        Fatigue = 1,
        Bruitage = "receive.mp3"
    },
    ["Smash"] = {
        Force = 1000,
        Direction = Vector(0, 0, -450),
        Fatigue = 1,
        Bruitage = "spike.mp3"
    },
    ["Passe"] = {
        Force = 400,
        Direction = Vector(0, 0, 0),
        Fatigue = 0.5,
        Bruitage = "toss2.mp3"
    },
    ["Lancer"] = {
        Force = 500,
        Direction = Vector(0, 0, 0),
        Fatigue = 1,
        Bruitage = "toss2.mp3"
    },
    ["Lancer_Haut"] = {
        Force = 500,
        Direction = Vector(0, 0, 0),
        Fatigue = 1,
        Bruitage = "toss2.mp3"
    },
    ["Lancer_Bas"] = {
        Force = 700,
        Direction = Vector(0, 0, 100),
        Fatigue = 1,
        Bruitage = "toss2.mp3"
    }
}

-- delai entre le saut de chaque son
VBS_CooldownJoueur = {}

VBS_EstFatigue = 0
VBS_ReprendSonSouffle = 1

-- PAS TOUCHE A CES VARIABLES
balleproche = false

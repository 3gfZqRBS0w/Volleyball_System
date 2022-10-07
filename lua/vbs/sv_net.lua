print("Les nets ont démarrer")

util.AddNetworkString("vbs_saut")
util.AddNetworkString("vbs_coup")
util.AddNetworkString("vbs_zone")
util.AddNetworkString("vbs_touche")

net.Receive("vbs_zone", EstZone)
net.Receive("vbs_coup", VBS_ComportementBalle)
net.Receive("vbs_saut", VBS_JoueurSaute)
net.Receive("vbs_touche", RecupereLesAttaques)


apcEquipmentKey = 1
material = 184

NumpadDiv::
preCmd = /apc_equipment_reinforce %apcEquipmentKey%
send %preCmd% %material% 50000
material++
return

NumpadMult::
exitapp
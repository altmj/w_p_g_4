extends Control

@onready var panel_Top = $"jurnal box top"
@onready var kotakbesarsatu =$"jurnal box top/Ascaris Lumbricoides"
@onready var kotakbesardua = $"jurnal box top/Strongyloides Stercoralis"
@onready var kotakbesartiga =$"jurnal box top/Taenia Solium"
@onready var kotakbesarempat =$"jurnal box top/Listeria Monocytogenes"
@onready var kotakbesarlima =$"jurnal box top/Herpes Simplex"
@onready var kotakbesarenam =$"jurnal box top/Coronavirus"
@onready var kotakbesartujuh=$"jurnal box top/Influenza"
@onready var kotakbesardelapan=$"jurnal box top/Mycobacterium Tuberculosis"
@onready var kotakbesarsembilan=$"jurnal box top/Escherichia Coli"
@onready var kotakbesarsepuluh=$"jurnal box top/Salmonella"
@onready var kotakbesarsebelas=$"jurnal box top/Hepatitis A"
 









func _on_ascaris_lumbricoides_pressed():
	panel_Top.move_child(kotakbesarsatu,1)


func _on_strongyloides_stercoralis_pressed():
	panel_Top.move_child(kotakbesardua,1)


func _on_taenia_solium_pressed():
	panel_Top.move_child(kotakbesartiga,1)
	
func _on_listeria_monocytogenes_pressed():
	panel_Top.move_child(kotakbesarempat,1)

func _on_herpes_simplex_pressed():
	panel_Top.move_child(kotakbesarlima,1)
	
func _on_coronavirus_pressed():
	panel_Top.move_child(kotakbesarenam,1)
	
func _on_influenza_pressed():
	panel_Top.move_child(kotakbesartujuh,1)
	
func _on_mycobacterium_tuberculosis_pressed():
	panel_Top.move_child(kotakbesardelapan,1)
	
func _on_escherichia_coli_pressed():
	panel_Top.move_child(kotakbesarsembilan,1)

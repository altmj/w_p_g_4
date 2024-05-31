extends Node

# Variabel untuk menyimpan level saat ini
var current_level : int = 1
# Variabel untuk menyimpan total pengalaman
var experience : int = 0
# Pengalaman yang diperlukan untuk naik level
var experience_required : int = 100

@onready var expui = $"../UI/ExpBar"

# Fungsi untuk menaikkan level karakter
func level_up():
	current_level += 1
	print("Character leveled up to level ", current_level)
	# Resetting experience required for next level up
	experience -= experience_required
	experience_required = calculate_experience_required()
	expui.max_exp = experience_required
	expui.reset_exp()
	expui.add_exp(experience)
	expui.update_level_text(current_level)

# Fungsi untuk menghitung jumlah pengalaman yang diperlukan untuk naik level
func calculate_experience_required() -> int:
	return current_level * 100

# Fungsi untuk menambahkan pengalaman
func add_experience(exp_amount):
	experience += exp_amount
	expui.add_exp(exp_amount)
	# Cek apakah karakter telah cukup pengalaman untuk naik level
	if experience >= experience_required:
		level_up()

# Contoh penggunaan
func _ready():
	# Cetak statistik awal karakter
	print_character_stats()

# Fungsi untuk mencetak statistik karakter
func print_character_stats():
	print("Level:", current_level)
	print("Experience:", experience)
	print("Experience Required for Next Level:", experience_required)

# Contoh pemanggilan fungsi add_experience() untuk menambahkan pengalaman ke karakter
# Anda dapat memanggil fungsi ini dari tempat lain dalam game Anda, seperti ketika karakter menyelesaikan misi atau mendapatkan pencapaian
# Contoh:
# add_experience(50)

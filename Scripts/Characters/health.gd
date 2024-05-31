extends ProgressBar

# Variabel untuk menyimpan nilai maksimum dan nilai saat ini dari kesehatan
var max_health := 100.0
var current_health := 100.0

# Metode ini dipanggil saat node diinisialisasi
func _ready():
	# Atur nilai maksimum dari progress bar
	max_value = max_health
	# Atur nilai awal dari progress bar
	value = current_health

# Fungsi untuk mengurangi kesehatan
func take_damage(damage_amount):
	current_health -= damage_amount
	# Pastikan kesehatan tidak kurang dari 0
	if current_health < 0:
		current_health = 0
	# Panggil fungsi update_health_bar untuk memperbarui tampilan
	update_health_bar()

# Fungsi untuk menambah kesehatan
func heal(heal_amount):
	current_health += heal_amount
	# Pastikan kesehatan tidak lebih besar dari maksimum
	if current_health > max_health:
		current_health = max_health
	# Panggil fungsi update_health_bar untuk memperbarui tampilan
	update_health_bar()

# Fungsi untuk memperbarui tampilan status kesehatan
func update_health_bar():
	# Menghitung persentase kesehatan yang tersisa
	var health_percentage = current_health / max_health
	# Atur nilai progress bar berdasarkan persentase kesehatan
	value = current_health


# Fungsi untuk memperbarui tampilan setiap frame
func _process(delta):
	pass

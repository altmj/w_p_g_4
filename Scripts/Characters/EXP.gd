extends ProgressBar

# Variabel untuk menyimpan nilai maksimum dan nilai saat ini dari EXP
var max_exp := 100.0
var current_exp := 0.0

# Metode ini dipanggil saat node diinisialisasi
func _ready():
	# Panggil fungsi untuk memperbarui tampilan progress bar
	update_exp_bar()

# Fungsi untuk menambah EXP
func add_exp(exp_amount):
	current_exp += exp_amount
	# Pastikan EXP tidak melebihi nilai maksimum
	if current_exp > max_exp:
		current_exp = max_exp
	# Panggil fungsi untuk memperbarui tampilan progress bar
	print("add xp: " + str(exp_amount))
	update_exp_bar()

# Fungsi untuk memperbarui tampilan progress bar
func update_exp_bar():
	# Menghitung persentase EXP yang telah diperoleh
	var printall = "%f %f" % [current_exp, max_exp]
	var exp_percentage = (current_exp / max_exp) * 100
	# Mengatur nilai dari progress bar berdasarkan persentase EXP
	set_value(exp_percentage)
	print("update exp called :" + printall)

# Fungsi untuk mereset EXP ke nilai awal
func reset_exp():
	current_exp = 0
	# Panggil fungsi untuk memperbarui tampilan progress bar
	update_exp_bar()

func update_level_text(text : Variant):
	$Level.set_text("Lv. " + str(text))

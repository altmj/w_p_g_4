extends Node

var queue_exp := 0

func add_exp(expamount):
	queue_exp += expamount
	print("queue " + str(queue_exp))
 
func check_queue_exp() -> int:
	var previous_queue_exp = queue_exp
	if queue_exp > 0:
		print("check queue is " + str(queue_exp))
		queue_exp = 0
	return previous_queue_exp

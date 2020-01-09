extends Node

const ZERO_CUT_OFF = .000001
func close_to_zero(float_val:float) -> bool:
	if float_val < ZERO_CUT_OFF && float_val > -ZERO_CUT_OFF:
		return true
	return false


func format(text:String)->String:
	return text
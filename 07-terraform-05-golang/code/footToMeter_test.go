package main

import "testing"

func FootToMeter(x float64) float64 {
	return x * 0.3048
}

func TestFootToMeter(t *testing.T) {
	res := FootToMeter(2500)
	if res != 762 {
		t.Errorf("Value was incorrect, got: %f, want: %d.", res, 762)
	}
}

func main() {
	println(FootToMeter(2500))
}

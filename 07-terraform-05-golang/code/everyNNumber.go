package main

func main() {
	var n = 3

	for i := 1; i <= 100; i++ {
		if i%n == 0 {
			println(i)
		}
	}
}

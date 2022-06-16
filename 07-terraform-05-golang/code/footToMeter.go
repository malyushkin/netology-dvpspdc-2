package main

import (
	"fmt"
)

func main() {
	var input float64
	fmt.Print("Enter a number: ")
	fmt.Scanf("%f", &input)
	fmt.Println(input * 0.3048)
}

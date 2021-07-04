package main

import (
	"fmt"
)

func meters2feet(input float64) float64 {
	return input * 0.30478
}

func main() {
	fmt.Print("Enter meters: ")
	var input float64
	fmt.Scanf("%f", &input)

	fmt.Println(input, "meters =", meters2feet(input), "feet")
}

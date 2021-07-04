package main

import (
	"errors"
	"fmt"
	"os"
)

func list_min(values []int) (min int, e error) {
	if len(values) == 0 {
		return 0, errors.New("cannot detect a minimum value in an empty slice")
	}

	min = values[0]
	for _, v := range values {
		if v < min {
			min = v
		}
	}

	return min, nil
}

func main() {
	var nums []int

	for {
		fmt.Print("Enter integer: ")
		var num int
		_, err := fmt.Fscanf(os.Stdin, "%d", &num)
		if err != nil {
			break
		}
		nums = append(nums, num)
	}

	res, err := list_min(nums)

	if err != nil {
		fmt.Println("An error occurred:", err)
	} else {
		fmt.Println("min =", res)
	}
}

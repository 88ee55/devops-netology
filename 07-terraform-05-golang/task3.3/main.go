package main

import (
	"fmt"
	"strings"
)

func division3() string {
	var res string = ""
	for i := 0; i <= 100; i++ {
		if i%3 == 0 {
			if res == "" {
				res = fmt.Sprintf("%d", i)
			} else {
				str := []string{res, fmt.Sprintf("%d", i)}
				res = strings.Join(str, " ")
			}
		}
	}
	return res
}

func main() {
	var res string = division3()
	fmt.Println(res)
}

package main

import (
	"fmt"
	"testing"
)

func TestDivision3(t *testing.T) {
	var want string = "0 3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48 51 54 57 60 63 66 69 72 75 78 81 84 87 90 93 96 99"
	res := division3()
	fmt.Println(res)
	if res != want {
		t.Errorf("division3() != %s", want)
	}
}

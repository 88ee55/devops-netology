package main

import (
	"testing"
)

func TestList_min(t *testing.T) {
	cases := []struct {
		list []int
		min  int
		e    error
	}{
		{[]int{1, 2, 3}, 1, nil},
		{[]int{0}, 0, nil},
		{[]int{-1, 0, 1}, -1, nil},
	}
	for _, c := range cases {
		min, e := list_min(c.list)
		if e != nil {
			t.Errorf("list_min(%v), error %v", c.list, e)
		}
		if min != c.min {
			t.Errorf("list_min(%v) == %d, want min %d", c.list, min, c.min)
		}
	}
}

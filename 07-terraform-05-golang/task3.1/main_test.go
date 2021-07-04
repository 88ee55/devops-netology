package main

import (
	"testing"
)

func TestMeters2feet(t *testing.T) {
	cases := []struct {
		meters, want float64
	}{
		{1, 0.304780},
		{0, 0},
	}
	for _, c := range cases {
		got := meters2feet(c.meters)
		if got != c.want {
			t.Errorf("meters2feet(%f) == %f, want %f", c.meters, got, c.want)
		}
	}
}

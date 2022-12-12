package main

import (
	"fmt"
	
	"github.com/jpillora/opts"
)

var version = "0.0.0-src"

type config struct {
	Foo string
	Bar int
}

func main() {
	c := config{}
	opts.New(&c).Version(version).Parse()
	fmt.Printf("%v\n", c)
}

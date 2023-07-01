{
	let sum
	for { let x } lt(x, 11) { x := add(x, 1) } {
		sum := add(sum, x)
	}
}
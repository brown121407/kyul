{
  let x := factorial(5)

  function factorial(n) -> f {
    if eq(n, 0) {
      f := 1
      leave
    }
    f := mul(n, factorial(sub(n, 1)))
  }
}
{
  // extras din https://docs.soliditylang.org/en/v0.8.19/yul.html
  function power(base, exponent) -> result
  {
    result := 1
    for { let i := 0 } lt(i, exponent) { i := add(i, 1) }
    {
      result := mul(result, base)
    }
  }

  let x := power(2, 10)
}
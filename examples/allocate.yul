{
  // extras din https://docs.soliditylang.org/en/v0.8.19/yul.html
  function allocate(size) -> ptr {
    ptr := mload(0x40)
    // Note that Solidity generated IR code reserves memory offset ``0x60`` as well, but a pure Yul object is free to use memory as it chooses.
    if iszero(ptr) { ptr := 0x60 }
    mstore(0x40, add(ptr, size))
  }

  let p1 := allocate(0x20)
  let p2 := allocate(0x40)
}
# K Semantics of Yul

To build the project, first clone with submodules:

```
git clone --recurse-submodules git@github.com:brown121407/kyul.git
```

Then run `make`, which handles compiling dependencies and linking them with `kompile`.

To run use the `kyul` script. It needs two positional arguments:

- the path of a configuration file describing the state of the blockchain. See the included `ethconfig.xml` file for an example.
- the path of a Yul source code file. This file must only contain a single top-level block of Yul code, i.e. it must NOT be a Yul object.

For example, such a file might contain the following to compute the sum of the first 10 natural numbers:

```yul
{
    let sum
    for { let i } lt(i, 11) { i := add(i, 1) } {
        sum := add(sum, i)
    }
}
```

The variables declared in this top-level block are shown at the end of execution along with memory, storage and the state of the blockchain.

# Licensing

This project is licensed under the the [3-Clause BSD License](./LICENSE).

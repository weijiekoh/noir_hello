# Hello world in Noir

This repository contains a circuit which allows you to prove that you know a
number which is less than 6 and is not 0.

Much of this code is from the MIT-licensed
[`noir-starter`](https://github.com/noir-lang/noir-starter) repository.

## Getting started

The code works has been tested with Nargo 0.6.0 and Forge 0.2.0.

Follow the instructions in the [Noir Docs](https://noir-lang.org/getting_started/nargo_installation) to install nargo.

Next, install foundryup:

```bash
curl -L https://foundry.paradigm.xyz | bash
```

Generate the verifier contract using nargo:

```bash
cd circuits
nargo codegen-verifier
```

A file named `plonk_vk.sol` should appear in the `circuits` folder.

To generate a proof, first make sure that `Prover.toml` contains this text:

```
x = 5
```

Since the logic in the circuit is meant to allow the prover to prove knowledge
of a value between 0 and 6 (exclusive), `x` can be 1, 2, 3, 4, or 5.

Next, run this command, also in the `circuits` folder:

```bash
nargo prove p
```

A file named `p.proof` should appear in the `proofs` folder.

Finally, test that the verifier contract works:

```bash
forge test
```

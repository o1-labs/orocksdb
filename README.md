ORocksDb
========

This repository contains some ocaml bindings to the C api of
[rocksdb](http://github.com/facebook/rocksdb/).
It is most certainly not complete. Not all available/implemented options have
been tested.
Additions and fixes are always welcome.

The binding is used as part of https://github.com/openvstorage/alba.

In case this library is not sufficient for your needs, then feel free to extend
it, or to have a look at one of the alternatives:
https://github.com/ahrefs/ocaml-ahrocksdb and
https://github.com/chetmurthy/ocaml-rocksdb.

## Setup development environment

```shell
opam switch create ./ 4.14.0 --no-install
opam install merlin ocamlformat
```

## Build and run tests

```
opam install . --with-test --deps-only
dune build
dune runtest
dune fmt --auto-promote # to format the code
```

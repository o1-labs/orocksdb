(lang dune 3.0)
(name rocks)

(generate_opam_files true)

(source (github o1-labs/orocksdb))
(license MIT)
(authors "Jan Doms")
(maintainers "O(1) Labs, LLC <opensource@o1labs.org>")
(bug_reports "https://github.com/o1-labs/orocksdb/issues")
(homepage "https://github.com/o1-labs/orocksdb/")

(package
 (name rocks)
 (synopsis "Binding to RocksDB for OCaml")
 (depends
  dune
  (ocaml (and (>= 4.14) (< 5.0)))
  (alcotest :with-test)
  conf-libbz2
  conf-zlib
  (ctypes (>= 0.4.0))
  (ctypes-foreign (>= 0.4.0))
  (rocksdb_stubs (= 5.17.2))
))

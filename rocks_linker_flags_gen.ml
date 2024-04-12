open Core
module C = Configurator.V1

let f dir =
  Sys.file_exists_exn ~follow_symlinks:true (dir ^ "/librocksdb_stubs.a")

(* Library file librocksdb_stubs.a is expected to be found in one of
   the directories in CAML_LD_LIBRARY_PATH *)

let () =
  let path =
      Sys.getenv "CAML_LD_LIBRARY_PATH" |>
      Option.value_map ~default:[] ~f:(String.split ~on:':') |>
      List.find_exn ~f in
  let uname_chan = Unix.open_process_in "uname" in
  let l = In_channel.input_line uname_chan in
  C.Flags.write_sexp "flags.sexp"
    ( match l with
    | Some "Darwin" ->
        [ sprintf "-Wl,-force_load,%s/librocksdb_stubs.a" path
        ; "-lz"
        ; "-lbz2"
        ; "-lc++abi"
        ; "-lc++" ]
    | Some "Linux" ->
        [ sprintf "-L%s" path
        ; "-Wl,--whole-archive"
        ; "-lrocksdb_stubs"
        ; "-Wl,--no-whole-archive"
        ; "-lz"
        ; "-lbz2"
        ; "-lstdc++" ]
    | s ->
        let s' = Option.value ~default:"<none>" s in
        failwith (sprintf "don't know how to link on %s yet" s') )

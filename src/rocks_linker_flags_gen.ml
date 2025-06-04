open Configurator.V1

type os = Darwin | Linux

let file_exists path =
  try Sys.is_directory path |> not with Sys_error _ -> false

let getenv var = try Some (Sys.getenv var) with Not_found -> None

let find_path_with_lib paths =
  let lib_name = "librocksdb_stubs.a" in
  List.find (fun dir -> file_exists (Filename.concat dir lib_name)) paths

let get_os () =
  let ic = Unix.open_process_in "uname" in
  let os = input_line ic in
  close_in ic ;
  match os with
  | "Darwin" ->
      Darwin
  | "Linux" ->
      Linux
  | other ->
      failwith ("Unsupported OS: " ^ other)

let () =
  let paths =
    match getenv "CAML_LD_LIBRARY_PATH" with
    | Some v ->
        String.split_on_char ':' v
    | None ->
        []
  in
  try
    let path = find_path_with_lib paths in
    let os = get_os () in
    let flags =
      match os with
      | Darwin ->
          [ "-Wl,-force_load," ^ Filename.concat path "librocksdb_stubs.a"
          ; "-lz"
          ; "-lbz2"
          ; "-lc++abi"
          ; "-lc++"
          ]
      | Linux ->
          [ "-L" ^ path
          ; "-Wl,--whole-archive"
          ; "-lrocksdb_stubs"
          ; "-Wl,--no-whole-archive"
          ; "-lz"
          ; "-lbz2"
          ; "-lstdc++"
          ]
    in
    Flags.write_sexp "flags.sexp" flags
  with Not_found ->
    failwith "librocksdb_stubs.a not found in CAML_LD_LIBRARY_PATH"

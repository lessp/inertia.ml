module Page_object = struct
  type t =
    { component : string
    ; props : Yojson.Safe.t
    ; url : string
    ; version : string
    }
  [@@deriving yojson]

  let serialize t = Yojson.Safe.to_string (to_yojson t)

  let create ~component ~props ~url ~version = { component; props; url; version }
end

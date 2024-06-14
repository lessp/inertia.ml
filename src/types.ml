module Config = struct
  type t =
    { url : string
    ; root_template : string
    ; version : string
    }
  [@@deriving yojson]

  let create ~url ~root_template ~version = { url; root_template; version }
end

module Props = struct
  type t = (string * Yojson.Safe.t) list

  let to_yojson props = `Assoc (List.map (fun (k, v) -> k, v) props)
  let of_yojson = function
    | `Assoc props -> Ok props
    | _ -> Error "Props.of_yojson: expected an object"
  ;;

  let create ~props = props
end

module Page_object = struct
  type t =
    { component : string
    ; props : Props.t
    ; url : string
    ; version : string
    }
  [@@deriving yojson]

  let create ~component ~props ~url ~version = { component; props; url; version }
end

module Template = struct
  type t =
    { title : string
    ; page_object : Page_object.t
    }
  [@@deriving yojson]

  let create ~title ~page_object () = { title; page_object }
end

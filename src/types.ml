module Inertia = struct
  type t =
    { url : string
    ; root_template : string
    ; version : string
    ; shared_props : (string * Yojson.Safe.t) list
    ; shared_func_map : (string * Yojson.Safe.t) list
    ; template_fs : In_channel.t option (* TODO: What should we use here. *)
    ; ssr_url : string option
    ; ssr_client : (unit -> string) option
    }

  let create
    ?template_fs
    ?ssr_url
    ?ssr_client
    ~url
    ~root_template
    ~version
    ~shared_props
    ~shared_func_map
    ()
    =
    { url
    ; root_template
    ; version
    ; shared_props
    ; shared_func_map
    ; template_fs
    ; ssr_url
    ; ssr_client
    }
  ;;
end

module Page = struct
  type t =
    { component : string
    ; mutable props : (string * Yojson.Safe.t) list
    ; url : string
    ; version : string
    }
  [@@deriving yojson]

  let create ~component ~props ~url ~version = { component; props; url; version }
end

module SSR = struct
  type t =
    { head : string list
    ; body : string
    }
  [@@deriving yojson]

  let create ~head ~body = { head; body }
end

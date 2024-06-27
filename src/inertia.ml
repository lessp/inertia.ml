module PO = struct
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

let root_view_config = ref (fun _ -> "")

module Utils = struct
  let get_partial_component (request : Dream.request) =
    match Dream.header request "X-Inertia-Partial-Component" with
    | Some component -> component
    | None -> ""
  ;;

  let get_partial_data (request : Dream.request) =
    match Dream.header request "X-Inertia-Partial-Data" with
    | Some data -> String.split_on_char ',' data
    | None -> []
  ;;

  let is_version_mismatch new_version (request : Dream.request) =
    match Dream.header request "X-Inertia-Version" with
    | Some version -> new_version <> version
    | None -> false
  ;;

  let classify_request new_version (request : Dream.request) =
    match Dream.header request "X-Inertia" with
    | None -> `Full
    | Some _ ->
      (* TODO: Double check that this actually works. *)
      if is_version_mismatch new_version request then
        `Full
      else (
        match Dream.header request "X-Inertia-Partial-Component" with
        | None -> `Inertia
        | Some _ -> `Partial (get_partial_component request, get_partial_data request)
      )
  ;;

  let hash (input : string) : string = Digest.to_hex (Digest.string input)
end

let set_root_view (root_view : PO.t -> string) = root_view_config := root_view

let render ~component ~props ~request =
  let props = `Assoc props in
  let url = Dream.target request in
  let version = Utils.hash (component ^ url ^ Yojson.Safe.to_string props) in

  match Utils.classify_request version request with
  | `Full ->
    (* Send full HTML response *)
    Dream.log "Sending full HTML response with page object";

    Dream.html @@ !root_view_config (PO.create ~component ~props ~url ~version)
  | `Inertia ->
    (* Only send JSON *)
    Dream.log "Sending page object as JSON";

    PO.create ~component ~props ~url ~version:"TODO"
    |> PO.serialize
    |> Dream.json ~headers:[ "Vary", "X-Inertia"; "X-Inertia", "true" ]
  | `Partial (partial_component, _partial_data) ->
    Dream.log "Sending partial page object as JSON";

    PO.create ~component:partial_component ~props ~url ~version:"TODO"
    |> PO.serialize
    |> Dream.json ~headers:[ "Vary", "X-Inertia"; "X-Inertia", "true" ]
;;

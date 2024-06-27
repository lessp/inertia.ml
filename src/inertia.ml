module Page_object = Types.Page_object

let root_view_config = ref (fun _ -> "")

module Utils = struct
  let is_inertia_request (request : Dream.request) =
    match Dream.header request "X-Inertia" with
    | Some _ -> true
    | None -> false
  ;;

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

  let classify_request (request : Dream.request) =
    match Dream.header request "X-Inertia" with
    | None -> `Full
    | Some _ ->
      (match Dream.header request "X-Inertia-Partial-Component" with
       | None -> `Inertia
       | Some _ -> `Partial (get_partial_component request, get_partial_data request))
  ;;
end

let middleware inner_handler (request : Dream.request) =
  if Utils.is_inertia_request request then (
    Dream.log "Inertia request";
    inner_handler request
  ) else
    inner_handler request
;;

let set_root_view (root_view : Types.Page_object.t -> string) =
  root_view_config := root_view
;;

let render ~component ~props ~request =
  let props = `Assoc props in
  let url = Dream.target request in
  let version = "TODO" in

  match Utils.classify_request request with
  | `Full ->
    (* Send full HTML response *)
    Dream.log "Sending full HTML response with page object";

    Dream.html
    @@ !root_view_config (Types.Page_object.create ~component ~props ~url ~version)
  | `Inertia ->
    (* Only send JSON *)
    Dream.log "Sending page object as JSON";

    Types.Page_object.create ~component ~props ~url ~version:"TODO"
    |> Types.Page_object.serialize
    |> Dream.json ~headers:[ "Vary", "X-Inertia"; "X-Inertia", "true" ]
  | `Partial (partial_component, _partial_data) ->
    Dream.log "Sending partial page object as JSON";

    Types.Page_object.create ~component:partial_component ~props ~url ~version:"TODO"
    |> Types.Page_object.serialize
    |> Dream.json ~headers:[ "Vary", "X-Inertia"; "X-Inertia", "true" ]
;;

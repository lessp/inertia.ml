(** Page object *)
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

type t = { mutable render_root_template : Page_object.t -> string }

let config =
  { render_root_template =
      (fun p ->
        Printf.sprintf
          {|
<html>
  <head>
    <title>No root template set</title>
  </head>
  <body>
    <h1>No root template set</h1>
    <p>You need to set a root template using <code>set_root_view</code> before using Inertia.</p>
    <pre>
      %s
    </pre>
  </body>
  |}
          (Page_object.serialize p))
  }
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

let set_root_view (root_view : Page_object.t -> string) =
  config.render_root_template <- root_view
;;

let render ~component ~(props : (string * Yojson.Safe.t) list) ~request =
  let yojson_props = `Assoc props in
  let url = Dream.target request in
  let version = "TODO" in

  match classify_request request with
  | `Full ->
    (* Send full HTML response *)
    Dream.log "Sending full HTML response with page object";

    Page_object.create ~component ~props:yojson_props ~url ~version
    |> config.render_root_template
    |> Dream.html
  | `Inertia ->
    (* Only send JSON *)
    Dream.log "Sending page object as JSON";

    Page_object.create ~component ~props:yojson_props ~url ~version
    |> Page_object.serialize
    |> Dream.json ~headers:[ "Vary", "X-Inertia"; "X-Inertia", "true" ]
  | `Partial (partial_component, partial_data) ->
    Dream.log "Sending partial page object as JSON";

    let partial_props =
      `Assoc (props |> List.filter (fun (key, _) -> List.mem key partial_data))
    in

    Page_object.create ~component:partial_component ~props:partial_props ~url ~version
    |> Page_object.serialize
    |> Dream.json ~headers:[ "Vary", "X-Inertia"; "X-Inertia", "true" ]
;;

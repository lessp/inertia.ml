module Types = Types

let create_config = Types.Config.create

let default_config =
  create_config ~root_template:"./src/html/app.html" ~version:"TODO" ~url:"todo"
;;

let get_version (request : Dream.request) = Dream.header request "X-Inertia-Version"

let is_inertia_request (request : Dream.request) =
  Dream.header request "X-Inertia"
  |> Option.map (String.equal "true")
  |> Option.value ~default:false
;;

(** The X-Inertia-Partial-Data header is a comma separated list of the desired props (data) keys that should be returned.

    Example: X-Inertia-Partial-Data: user,posts *)
let get_partial_data (request : Dream.request) =
  Dream.header request "X-Inertia-Partial-Data"
;;

(** The X-Inertia-Partial-Component header includes the name of the component that is being partially reloaded. This is necessary, since partial reloads only work for requests made to the same Page_object component. If the final destination is different for some reason (eg. the user was logged out and is now on the login Page_object), then no partial reloading will occur.

    Example: X-Inertia-Partial-Component: Events *)
let get_partial_component (request : Dream.request) =
  Dream.header request "X-Inertia-Partial-Component"
;;

let is_inertia_partial_request (request : Dream.request) =
  match get_partial_data request, get_partial_component request with
  | Some _, Some _ -> true
  | _ -> false
;;

let _create_root_template (_request : Dream.request) =
  let file = Fs.File.read_to_string "./src/html/app.html" |> Result.get_ok in

  print_endline @@ "File: " ^ file;
  ()
;;

let render_raw ~(component : string) ~(props : Types.Props.t) (request : Dream.request) =
  let open Types in
  let url = Dream.target request in
  let version = get_version request |> Option.value ~default:"TODO" in

  match is_inertia_request request with
  | true when is_inertia_partial_request request ->
    `JSON
      (Page_object.create ~component ~props ~url ~version
       |> Page_object.to_yojson
       |> Yojson.Safe.to_string)
  | true ->
    `JSON
      (Page_object.create ~component ~props ~url ~version
       |> Page_object.to_yojson
       |> Yojson.Safe.to_string)
  | _ ->
    let page_object = Page_object.create ~component ~props ~url ~version in

    let root_template =
      Fs.File.read_to_string
        "/Users/ekander/dev/oss/ocaml/inertia_ocaml/src/html/app.html"
      |> Result.map (fun _file -> Types.Template.create ~title:"Foo" ~page_object ())
      |> Result.get_ok
    in

    `HTML (root_template |> Types.Template.to_yojson |> Yojson.Safe.to_string)
;;

let render ~(component : string) ~(props : Types.Props.t) (request : Dream.request) =
  match render_raw ~component ~props request with
  | `HTML html -> Dream.html html
  | `JSON json -> Dream.json json
;;

let middleware inner_handler (request : Dream.request) ~(config : Types.Config.t) =
  let _ = config in
  Dream.log "Inertia middleware";

  let version = get_version request in
  let partial_data = get_partial_data request in
  let partial_component = get_partial_component request in

  Dream.log "Version: %s" (Option.value ~default:"" version);
  Dream.log "Partial data: %s" (Option.value ~default:"" partial_data);
  Dream.log "Partial component: %s" (Option.value ~default:"" partial_component);

  match is_inertia_request request with
  | true when is_inertia_partial_request request ->
    Dream.log "Inertia partial request";
    inner_handler request
  | true ->
    Dream.log "Inertia full request";
    inner_handler request
  | _ ->
    Dream.log "Inertia non request";
    inner_handler request
;;

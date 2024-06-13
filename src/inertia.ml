let is_ssr_enabled (state : Types.Inertia.t) =
  match state.ssr_client, state.ssr_url with
  | Some _, Some _ -> true
  | _ -> false
;;

let enable_ssr (state : Types.Inertia.t) url =
  { state with ssr_url = Some url; ssr_client = None (* TODO: implement *) }
;;

let is_inertia_request (request : Dream.request) =
  match Dream.header request "X-Inertia" with
  | Some "true" -> true
  | _ -> false
;;



let with_prop (request : Dream.request) key value =
  (* Retrieve existing properties from the request context *)
  let props_field = Dream.new_field ~name:Context.context_key_props () in

  let props = Dream.field request props_field in

  let () =
    match props with
    | None -> Dream.set_field request props_field [ key, value ]
    | Some props ->
      (* Update the properties with the new key-value pair *)
      let updated_props = (key, value) :: List.remove_assoc key props in
      (* Set the updated properties back into the request context *)
      Dream.set_field request props_field updated_props
  in

  (* Return the updated request *)
  request
;;

let with_view_data (request : Dream.request) key value =
  (* Retrieve existing view data from the request context *)
  let view_data_field = Dream.new_field ~name:Context.context_key_view_data () in

  let view_data = Dream.field request view_data_field in

  let () =
    match view_data with
    | None -> Dream.set_field request view_data_field [ key, value ]
    | Some view_data ->
      (* Update the view data with the new key-value pair *)
      let updated_view_data = (key, value) :: List.remove_assoc key view_data in
      (* Set the updated view data back into the request context *)
      Dream.set_field request view_data_field updated_view_data
  in

  (* Return the updated request *)
  request
;;

let render
  (state : Types.Inertia.t)
  (request : Dream.request)
  (component : string)
  (props : (string * Yojson.Safe.t) list)
  =
  let only = ref [] in
  let partial = Dream.header request "X-Inertia-Partial-Data" in

  let () =
    match partial with
    | Some partial
      when Dream.header request "X-Inertia-Partial-Component" = Some component ->
      String.split_on_char ',' partial |> List.iter (fun value -> only := value :: !only)
    | _ -> ()
  in

  let page : Types.Page.t =
    Types.Page.create
      ~component
      ~props:[]
      ~url:(Dream.target request)
      ~version:state.version
  in

  let () =
    List.iter
      (fun (key, value) ->
        match !only with
        | [] -> page.props <- (key, value) :: page.props
        | _ when List.mem key !only -> page.props <- (key, value) :: page.props
        | _ -> ())
      state.shared_props
  in

  let context_props =
    Dream.field request (Dream.new_field ~name:Context.context_key_props ())
  in

  let () =
    match context_props with
    | Some context_props ->
      let context_props = List.assoc Context.context_key_props context_props in
      List.iter
        (fun (key, value) ->
          match !only with
          | [] -> page.props <- (key, value) :: page.props
          | _ when List.mem key !only -> page.props <- (key, value) :: page.props
          | _ -> ())
        context_props
    | _ -> ()
  in

  let () =
    List.iter
      (fun (key, value) ->
        match !only with
        | [] -> page.props <- (key, value) :: page.props
        | _ when List.mem key !only -> page.props <- (key, value) :: page.props
        | _ -> ())
      props
  in

  if is_inertia_request request then
    let _js = Yojson.Safe.to_string (Types.Page.to_yojson page) in

    Dream.add_header request "Vary" "Accept" |> ignore;
    Dream.add_header request "X-Inertia" "true" |> ignore;
    Dream.add_header request "Content-Type" "application/json" |> ignore;
  else
    let view_data =
      match Dream.field request (Dream.new_field ~name:Context.context_key_view_data ()) with
      | Some view_data -> List.assoc Context.context_key_view_data view_data
      | _ -> []
    in

    let view_data = ("page", Types.Page.to_yojson page) :: view_data in
    let context_view_data = Dream.new_field ~name:Context.context_key_view_data () in

    let () =
      match Dream.field request context_view_data with
      | None -> Dream.set_field request context_view_data view_data
      | Some view_data ->
        let updated_view_data = List.assoc Context.context_key_view_data view_data in
        Dream.set_field request context_view_data (("page", Types.Page.to_yojson page) :: updated_view_data)
    in

    ()
;;

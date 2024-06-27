Inertia.set_root_view (fun page_object ->
  Root_template.render ~page_object:(Inertia.Types.Page_object.to_string page_object) ())

let asset_loader _root path _request =
  Dream.log "Loading asset %s" path;
  match Dist.read path with
  | None ->
    Dream.log "Asset not found: %s" path;
    Dream.empty `Not_Found
  | Some asset ->
    Dream.log "Asset found: %s" path;
    Dream.respond asset
;;

let mock_events =
  List.init 10 (fun i ->
    `Assoc
      [ "id", `Int (i + 1)
      ; "title", `String (Printf.sprintf "Event %d" (i + 1))
      ; "start_date", `String "2019-06-02"
      ; "description", `String "This is a description"
      ])
;;

let () =
  Dream.run
  @@ Dream.logger
  @@ Inertia.middleware
  @@ Dream.router
       [ Dream.get "/" (fun request ->
           Inertia.render ~request ~component:"Welcome" ~props:(`Assoc []))
       ; Dream.get "/events" (fun request ->
           Inertia.render
             ~request
             ~component:"Event/Index"
             ~props:(`Assoc [ "events", `List mock_events ]))
       ; Dream.get "/events/:id" (fun request ->
           Inertia.render
             ~request
             ~component:"Event/Show"
             ~props:
               (`Assoc
                 [ ( "event"
                   , `Assoc
                       [ "id", `Int (Dream.param request "id" |> int_of_string)
                       ; "title", `String "Birthday party"
                       ; "start_date", `String "2019-06-02"
                       ; ( "description"
                         , `String
                             "Come out and celebrate Jonathan's 36th birthday party!" )
                       ] )
                 ]))
       ; Dream.get "/assets/**" (Dream.static ~loader:asset_loader "")
       ]
;;

Inertia.set_root_view (fun page_object ->
  Root_template.render (Inertia.PO.serialize page_object))

(* Loads assets from the `js/dist` directory. *)
let asset_loader _root path _request =
  match Dist.read path with
  | None -> Dream.empty `Not_Found
  | Some asset -> Dream.respond asset
;;

let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.router
       [ Dream.get "/" (fun request ->
           Inertia.render ~request ~component:"Welcome" ~props:[])
       ; Dream.get "/events" Events_controller.index
       ; Dream.get "/events/:id" Events_controller.show
       ; Dream.get "/assets/**" (Dream.static ~loader:asset_loader "")
       ]
;;

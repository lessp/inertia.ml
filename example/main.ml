let loader _root path _request =
  Dream.log "Loading asset %s" path;
  match Pages.read path with
  | None -> Dream.empty `Not_Found
  | Some asset -> Dream.respond asset
;;

let () =
  Dream.run
  @@ Dream.logger
  @@ Inertia.middleware ~config:Inertia.default_config
  @@ Dream.router [ Dream.get "/assets/**" (Dream.static ~loader "") ]
;;

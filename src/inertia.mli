module Page_object = Types.Page_object

(** Set the root template for Inertia.ml

    {[
      Inertia.set_root_view (fun page_object ->
        Printf.sprintf
          {|
        <!DOCTYPE html>
        <html>
          <head>
            <title>My App</title>
          </head>
          <body>
            <div id="app" data-page='%s' ></div>
            <script type="module" src="/assets/bundle.js"></script>
          </body>
        </html>
      |}
          (Inertia.Page_object.serialize page_object))
    ]} *)
val set_root_view : (Page_object.t -> string) -> unit

val middleware : Dream.middleware

(** Render a component with the given props.

    {[
      Inertia.render ~request ~component:"Home" ~props:[ "user_name", `String "Alice" ]
    ]} *)
val render
  :  component:string
  -> props:(string * Yojson.Safe.t) list
  -> request:Dream.request
  -> Dream.response Lwt.t

module Page_object : sig
  type t =
    { component : string
    ; props : Yojson.Safe.t
    ; url : string
    ; version : string
    }

  (** Serialize a page object to a JSON string *)
  val serialize : t -> string

  (** Create a new page object *)
  val create
    :  component:string
    -> props:Yojson.Safe.t
    -> url:string
    -> version:string
    -> t
end

(** Set the root template for Inertia.ml

    Example:
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
            <div id="app" data-page='%s'></div>
            <script type="module" src="/assets/bundle.js"></script>
          </body>
        </html>
      |}
          (Inertia.PO.serialize page_object))
    ]} *)
val set_root_view : (Page_object.t -> string) -> unit

(** Render a component with the given props.

    {[
      Inertia.render ~request ~component:"Home" ~props:[ "user_name", `String "Alice" ]
    ]} *)
val render
  :  component:string
  -> props:(string * Yojson.Safe.t) list
  -> request:Dream.request
  -> Dream.response Lwt.t

module Page_object = Types.Page_object

(** Set the root view of the page. *)
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

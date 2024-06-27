module Types = Types

(** Set the root view of the page. *)
val set_root_view : (Types.Page_object.t -> string) -> unit

val middleware : Dream.middleware

val render
  :  component:string
  -> props:Yojson.Safe.t
  -> request:Dream.request
  -> Dream.response Lwt.t

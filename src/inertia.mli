val default_config : Types.Config.t

(** Calling render will on fresh page request return the root template with page
    object as props. This will be rendered on the client side.

    On subsequent requests, when `X-Inertia` is set to true, the page object
    will be returned as JSON.

    Example:
    {[
      Inertia.render
        ~component:"Articles/ArticleId"
        ~props:
          [ "title", `String "My article"
          ; "author", `String "John Doe"
          ; "content", `String "Lorem ipsum dolor sit amet"
          ]
        request
    ]} *)
val render
  :  component:string
  -> props:Types.Props.t
  -> Dream.request
  -> Dream.response Lwt.t

val render_raw
  :  component:string
  -> props:Types.Props.t
  -> Dream.request
  -> [> `HTML of string | `JSON of string ]

(** Middleware to be used in the Dream app.

    Example:
    {[
      Dream.run
      @@ Dream.logger
      @@ Inertia.middleware
      @@ Dream.router
           [ Dream.get "/articles/:id" (fun request ->
               Inertia.render
                 ~component:"Articles/ArticleId"
                 ~props:
                   [ "title", `String "My article"
                   ; "author", `String "John Doe"
                   ; "content", `String "Lorem ipsum dolor sit amet"
                   ]
                 request)
           ]
    ]} *)
val middleware : (Dream.request -> 'a) -> Dream.request -> config:Types.Config.t -> 'a

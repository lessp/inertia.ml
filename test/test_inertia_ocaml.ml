open Alcotest

let test_inertia_full_document () =
  let mock_request : Dream.request =
    Dream.request
      ~method_:`GET
      ~target:"/events/80"
      ~headers:[ "Accept", "text/html,application/xhtml+xml" ]
      ""
  in

  let response =
    Inertia.render_raw
      ~component:"Event"
      ~props:
        [ ( "event"
          , `Assoc
              [ "id", `Int 80
              ; "title", `String "Birthday party"
              ; "start_date", `String "2019-06-02"
              ; ( "description"
                , `String "Come out and celebrate Jonathan's 36th birthday party!" )
              ] )
        ]
      mock_request
  in

  match response with
  | `HTML body ->
    let expected_body =
      {|
      <!DOCTYPE html>
      <html lang="en">
        <head>
          <meta charset="utf-8">
          <title>Birthday party</title>
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <link href="/app.css" rel="stylesheet">
          <script src="/app.js" defer></script>
        </head>
        <body>
          <div id="app" data-page="{&quot;component&quot;:&quot;Event&quot;,&quot;props&quot;:{&quot;event&quot;:{&quot;id&quot;:80,&quot;title&quot;:&quot;Birthday party&quot;,&quot;start_date&quot;:&quot;2019-06-02&quot;,&quot;description&quot;:&quot;Come out and celebrate Jonathan's 36th birthday party!&quot;}}}"></div>
        </body>
      </html>
    |}
    in
    check string "same body" expected_body body
  | _ -> failwith "Expected HTML response"
;;

(* REQUEST *)
(* GET: http://example.com/events *)
(* Accept: text/html, application/xhtml+xml *)
(* X-Requested-With: XMLHttpRequest *)
(* X-Inertia: true *)
(* X-Inertia-Version: 6b16b94d7c51cbe5b1fa42aac98241d5 *)
(* X-Inertia-Partial-Data: events *)
(* X-Inertia-Partial-Component: Events *)
(* RESPONSE *)
(* HTTP/1.1 200 OK *)
(* Content-Type: application/json *)
(* { *)
(*   "component": "Events", *)
(*   "props": { *)
(*     "auth": {...},       // NOT included *)
(*     "categories": [...], // NOT included *)
(*     "events": [...]      // included *)
(*   }, *)
(*   "url": "/events/80", *)
(*   "version": "c32b8e4965f418ad16eaebba1d4e960f" *)
(* } *)

let test_inertia_partial () =
  let mock_request : Dream.request =
    Dream.request
      ~method_:`GET
      ~target:"/events/80"
      ~headers:
        [ "Accept", "text/html,application/xhtml+xml"
        ; "X-Requested-With", "XMLHttpRequest"
        ; "X-Inertia", "true"
        ; "X-Inertia-Version", "6b16b94d7c51cbe5b1fa42aac98241d5"
        ; "X-Inertia-Partial-Data", "events"
        ; "X-Inertia-Partial-Component", "Events"
        ]
      ""
  in

  let response =
    Inertia.render_raw
      ~component:"Event"
      ~props:
        [ ( "event"
          , `Assoc
              [ "id", `Int 80
              ; "title", `String "Birthday party"
              ; "start_date", `String "2019-06-02"
              ; ( "description"
                , `String "Come out and celebrate Jonathan's 36th birthday party!" )
              ] )
        ]
      mock_request
  in

  match response with
  | `JSON payload ->
    let expected_payload =
      {|
{
  "component": "Event",
  "props": {
    "event": {
        "id": 80,
        "title": "Birthday party",
        "start_date": "2019-06-02",
        "description": "Come out and celebrate Jonathan's 36th birthday party!"
      }
  },
  "url": "/events/80",
  "version": "6b16b94d7c51cbe5b1fa42aac98241d5"
}
  |}
      |> Yojson.Safe.from_string
      |> Yojson.Safe.to_string
    in
    check string "same payload" expected_payload payload
  | _ -> failwith "Expected HTML response"
;;

let () =
  let open Alcotest in
  run
    "Inertia tests"
    [ ( "render"
      , [ test_case "Render Inertia partial" `Quick test_inertia_partial
        ; test_case "Render Inertia full document" `Quick test_inertia_full_document
        ] )
    ]
;;

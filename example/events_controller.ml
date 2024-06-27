let create_mock_event id =
  `Assoc
    [ "id", `Int id
    ; "title", `String (Printf.sprintf "Event %d" id)
    ; "start_date", `String "2019-06-02"
    ; "description", `String "This is a description"
    ]
;;

let index (request : Dream.request) =
  let events = List.init 10 create_mock_event in

  Inertia.render ~request ~component:"Event/Index" ~props:[ "events", `List events ]
;;

let show (request : Dream.request) =
  let id = Dream.param request "id" |> int_of_string in

  Inertia.render ~request ~component:"Event/Show" ~props:[ "event", create_mock_event id ]
;;

import { Link } from "@inertiajs/react";

export default function ({ event }) {
  return (
    <div>
      <h1>Event</h1>
      <p>{event.title}</p>
      <p>{event.description}</p>
      <p>{event.start_date}</p>
      <Link href={`/events`}>Go to events</Link>
    </div>
  );
}

import { Link } from "@inertiajs/react";

export default function ({ events }) {
  return (
    <div>
      <h1>Events</h1>
      {events.map((event) => (
        <div key={event.id}>
          <p>{event.title}</p>
          <p>{event.description}</p>
          <p>{event.start_date}</p>
          <Link href={`/events/${event.id}`}>Go to event</Link>
        </div>
      ))}
    </div>
  );
}

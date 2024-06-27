import { Link } from "@inertiajs/react";

export default function () {
  return (
    <div>
      <h1>Welcome</h1>
      <Link href={`/events`}>Go to events</Link>
    </div>
  );
}

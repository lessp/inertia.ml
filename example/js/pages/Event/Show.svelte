<script>
import { inertia } from '@inertiajs/svelte'

export let event
</script>

<div>
  <h1>Event</h1>
  <p>{event.title}</p>
  <p>{event.description}</p>
  <p>{event.start_date}</p>
  <a use:inertia href="/events">Go to events</a>
</div>

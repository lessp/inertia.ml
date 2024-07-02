<script>
import { inertia } from '@inertiajs/svelte'

export let events
</script>

<div>
  <h1>Events</h1>
  {#each events as event (event.id)}
    <div>
      <p>{event.title}</p>
      <p>{event.description}</p>
      <p>{event.start_date}</p>
      <a use:inertia href={`/events/${event.id}`}>Go to event</a>
    </div>
  {/each}
</div>

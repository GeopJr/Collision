<script>
	import { scale } from 'svelte/transition';
	import { sineInOut } from 'svelte/easing';

	let options = { duration: 250, easing: sineInOut };
	let optionsOut = { ...options };
	optionsOut.delay = 250;
</script>

<div id="transition" in:scale|local={options} out:scale|local={optionsOut}>
	<slot />
</div>

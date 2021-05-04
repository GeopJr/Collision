<script>
	import { darkMode } from '../stores';
	import PageTransitions from '$lib/page-transitions.svelte';
</script>

<PageTransitions>
	<div class="c-window">
		{#if $darkMode}
			<img
				draggable="false"
				alt="Collision Screenshot"
				class="c-screenshot"
				src="/screenshots/collision-dark.png"
			/>
		{:else}
			<img
				draggable="false"
				alt="Collision Screenshot"
				class="c-screenshot"
				src="/screenshots/collision-light.png"
			/>
		{/if}
		<img draggable="false" alt="Collision Icon" class="c-icon" src="/logos/collision.png" />
	</div>
</PageTransitions>

<style lang="scss">
	.c-window > .c-screenshot {
		transition-duration: 200ms;
	}
	:global(.switcher) > :global(#transition) {
		> .c-window > * {
			pointer-events: none;
		}
		> .c-window > .c-icon {
			display: block;
			transform: scale(1, 1);
			transition-duration: 200ms;
		}
		> .c-window:hover {
			> .c-screenshot {
				transition-duration: 200ms;
				transform: scale(1.05, 1.05);
			}
			> .c-icon {
				bottom: 175px;
			}
		}
	}

	.c-window > .c-icon {
		bottom: 190px;
		transition-duration: 200ms;
		position: fixed;
		transform: scale(0, 0);
		width: 128px;
		filter: drop-shadow(0px 0px 1px #222);
	}
	.c-window {
		display: flex;
		align-items: center;
		justify-content: center;
	}
</style>

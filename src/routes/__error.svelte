<script context="module">
	export function load({ error, status }) {
		return {
			props: {
				title: `${status}: ${error.message}`
			}
		};
	}
</script>

<script>
	export let title;
	import PageTransitions from '$lib/page-transitions.svelte';
	console.log(title);
	$: error = title.length > 30 ? title.substring(0, 33) + '...' : title;
</script>

<svelte:head>
	<title>Collision - Error</title>
	<meta name="og:title" content="Collision - Error" />
</svelte:head>

<PageTransitions>
	<div class="c-window">
		<h1 class="c-error">{error}</h1>
		<img
			draggable="false"
			alt="Eye of GNOME screenshot"
			class="c-screenshot"
			src="/screenshots/error.png"
		/>
		<img draggable="false" alt="Eye of GNOME icon" class="c-icon" src="/logos/error.png" />
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
			> .c-error {
				transition-duration: 200ms;
				transform: scale(1.1, 1.1);
			}
			> .c-screenshot {
				transition-duration: 200ms;
				transform: scale(1.05, 1.05);
			}
			> .c-icon {
				bottom: 0px;
				@media only screen and (max-device-width: 768px) {
					bottom: 200px;
				}
			}
		}
	}

	.c-window > .c-icon {
		bottom: 15px;
		transition-duration: 200ms;
		position: fixed;
		transform: scale(0, 0);
		width: 128px;
		filter: drop-shadow(0px 0px 1px #222);
		@media only screen and (max-device-width: 768px) {
			bottom: 215px;
		}
	}
	.c-window {
		display: flex;
		align-items: center;
		justify-content: center;
	}
	.c-error {
		position: absolute;
		font-weight: bold;
		font-size: 5vw;
		transition-duration: 200ms;
		z-index: 55;
		background-color: black;
		color: white;
		padding: 0 30px;
		white-space: nowrap;
		transform: rotate(-5deg);
	}
</style>

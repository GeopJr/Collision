<script>
	export let type;
	export let url;
	export let title;

	import { darkMode } from '../../stores';

	let headerImage = type.toLowerCase();

	$: header = $darkMode ? `/headers/${headerImage}-dark.png` : `/headers/${headerImage}-light.png`;
	$: borderColor = $darkMode ? '#292929' : '#dfdcd9';
</script>

<div class="c-app-window">
	<div class="window">
		<img draggable="false" alt="" role="presentation" class="header" src={header} />
		<iframe
			src={url}
			allowTransparency="true"
			{title}
			referrerpolicy="no-referrer"
			sandbox="allow-scripts allow-downloads allow-modals allow-popups allow-popups-to-escape-sandbox allow-same-origin"
			style={`border-color: ${borderColor}; background-color: ${borderColor}`}
		>
			Your browser does not support inline frames. This iframe would link to
			{url}.</iframe
		>
	</div>
	<img
		draggable="false"
		alt={type.toLowerCase() + ' icon'}
		class="c-icon"
		src={`/logos/${type.toLowerCase()}.png`}
	/>
</div>

<style lang="scss">
	:global(.switcher) > :global(#transition) > .c-app-window {
		> .window > * {
			pointer-events: none;
		}
		> .c-icon {
			display: block;
			transform: scale(1, 1);
			transition-duration: 200ms;
		}
		&:hover {
			> .window {
				transition-duration: 200ms;
				transform: scale(1.05, 1.05);
			}
			> .c-icon {
				bottom: 5px;
			}
		}
	}
	.c-app-window > .c-icon {
		bottom: 20px;
		transition-duration: 200ms;
		position: fixed;
		transform: scale(0, 0);
		width: 128px;
		filter: drop-shadow(0px 0px 1px #222);
	}
	.c-app-window {
		display: flex;
		align-items: center;
		justify-content: center;
	}

	.window {
		filter: drop-shadow(0px 0px 1px #000);
		transition-duration: 200ms;
	}
	.header {
		width: 60vw;
		position: relative;
		@media only screen and (max-device-width: 768px) {
			width: 100vw;
		}
	}
	iframe {
		width: 60vw;
		height: 80vh;
		@media only screen and (max-device-width: 768px) {
			width: 100vw;
			height: 90vh;
		}
		border: 1px solid #dfdcd9;
		border-top-width: 0px;
	}
</style>

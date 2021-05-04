<script>
	export let switcher;

	import { page } from '$app/stores';

	$: shouldTab = switcher ? '0' : '-1';
	$: currentPage = $page.url.pathname.toLowerCase();
</script>

<div class="c-dash">
	<a
		tabIndex={shouldTab}
		class="c-dash-item"
		class:active={currentPage === '/'}
		sveltekit:prefetch
		href="/"
		alt="Home"
	>
		<img draggable="false" alt="Collision icon" src="/logos/collision.png" />
		<span class="c-tooltip">Collision</span>
	</a>
	<a
		tabIndex={shouldTab}
		class="c-dash-item"
		class:active={currentPage === '/install'}
		sveltekit:prefetch
		href="/install"
		alt="Collision's flathub page"
	>
		<img draggable="false" alt="GNOME Web icon" src="/logos/web.png" />
		<span class="c-tooltip">Web - Install</span>
	</a>
	<a
		tabIndex={shouldTab}
		class="c-dash-item"
		class:active={currentPage === '/code'}
		sveltekit:prefetch
		href="/code"
		alt="Collision's code using github1s.com"
	>
		<img draggable="false" alt="VSCodium icon" src="/logos/code.png" />
		<span class="c-tooltip">Code - Source</span>
	</a>
</div>

<style lang="scss">
	.c-dash {
		background-color: #3b3b3b;
		height: 98px;
		position: absolute;
		bottom: 0;
		padding: 10px;
		margin-bottom: 16px;
		margin-top: 12px;
		border-radius: 24px;
		width: 60vw;
		left: 0;
		right: 0;
		margin-left: auto;
		margin-right: auto;
		z-index: -50;
		display: flex;
		justify-content: space-between;
		> .c-dash-item {
			transition-duration: 75ms;
			padding: 4px 5px 1px;
			align-self: center;
			&:focus {
				background-color: #232323;
				border-radius: 12px;
			}
			> .c-tooltip {
				transition-duration: 75ms;
				position: fixed;
				opacity: 0%;
				bottom: 110px;
				transform: translate(-20%, 0);
				text-align: center;
				color: white;
				background-color: #010101b2;
				border-radius: 99px;
				padding: 3px 12px;
				pointer-events: none;
				@media only screen and (max-device-width: 768px) {
					display: none;
				}
			}
			> img {
				width: 70px;
			}
			&.active::after {
				content: '';
				position: relative;
				padding: 3px;
				background-color: #eeeeee;
				border-radius: 100%;
				left: calc(50% - 3px);
				height: 3px;
				width: 3px;
				display: block;
			}
			&:not(.active)::after {
				content: '';
				position: relative;
				padding: 3px;
				height: 3px;
				width: 3px;
				display: block;
			}
			&:hover {
				background-color: #4e4e4e;
				border-radius: 12px;
				transition-duration: 75ms;
				> .c-tooltip {
					opacity: 100%;
					transition-duration: 700ms;
					display: block;
					@media only screen and (max-device-width: 768px) {
						display: none;
					}
				}
			}
		}
	}
</style>

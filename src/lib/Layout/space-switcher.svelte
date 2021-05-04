<script>
	import { page } from '$app/stores';
	import { darkMode } from '../../stores';

	const screenshots = {
		'/': 'collision',
		'/install': 'web',
		'/code': 'code'
	};
	let pngs = ['collision', 'error'];
	$: type = screenshots[$page.url.pathname.toLowerCase()] ?? 'error';
	$: screenshot =
		type === 'error'
			? '/screenshots/error.png'
			: `/screenshots/${type}-${$darkMode ? 'dark' : 'light'}.${
					pngs.includes(type) ? 'png' : 'jpg'
			  }`;
	$: secondary = `/screenshots/secondary-${$darkMode ? 'dark' : 'light'}.jpg`;
</script>

<div class="c-space-switcher">
	<div class="c-space-item active">
		<img
			draggable="false"
			role="presentation"
			alt=""
			class="c-workspace-screenshot"
			src={screenshot}
		/>
	</div>
	<div class="c-space-item">
		<img
			draggable="false"
			role="presentation"
			alt=""
			class="c-workspace-screenshot"
			src={secondary}
		/>
	</div>
	<div class="c-space-item" />
</div>

<style lang="scss">
	.c-space-switcher {
		position: absolute;
		top: 103px;
		left: 50%;
		transform: translate(-50%, 0);
		z-index: -50;
		display: inline-flex;
		align-items: center;
		justify-content: space-between;
		width: 230px;
		> .c-space-item {
			display: flex;
			align-items: center;
			justify-content: center;
			position: relative;
			width: 73px;
			background-color: #3b3b3b;
			height: 40px;
			border-radius: 3px;
			.c-workspace-screenshot {
				width: 60%;
			}
			&.active {
				outline: 2px solid #3584e4;
				border: 1px solid #3584e4;
			}
		}
	}
</style>

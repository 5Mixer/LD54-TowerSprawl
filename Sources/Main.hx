package;

import kha.Assets;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

class Main {
	var activeState: State;

	public function new() {
		MouseState.setup();
		activeState = new PlayState();
	}

	function update(): Void {
		activeState.update();
		MouseState.update();
	}

	function render(framebuffer: Framebuffer): Void {
		activeState.render(framebuffer);
	}

	public static function main() {
		System.start({title: "TowerSprawl", width: 800, height: 600}, function (_) {
			Assets.loadEverything(function () {
				var main = new Main();
				Scheduler.addTimeTask(function () { main.update(); }, 0, 1 / 60);
				System.notifyOnFrames(function (framebuffers) { main.render(framebuffers[0]); });
			});
		});
	}
}

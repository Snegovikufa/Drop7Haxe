package io.github.snegovikufa.drop7haxe;

import Math;

class GameMode
{
	public var moves:Int;
	public var level:Int;

	public function new () {
		level = 0;
	}

	public function nextLevel (): Void {
		level += 1;
	}
}



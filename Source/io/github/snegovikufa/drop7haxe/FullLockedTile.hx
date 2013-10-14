
package io.github.snegovikufa.drop7haxe;

class FullLockedTile extends Tile {

	public function new () {

		super ("images/full_locked.png");

	}

	public override function initialize ():Void {

		super.initialize ();
		type = -1;

	}

	public override function explode() : Tile
	{
		var tile = new PartialLockedTile ();
		tile.initialize ();
		tile.row = this.row;
		tile.column = this.column;
		tile.x = this.x;
		tile.y = this.y;
		return tile;
	}

}

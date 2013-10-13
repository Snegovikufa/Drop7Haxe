
package io.github.snegovikufa.drop7haxe;

class FullLockedTile extends Tile {
{

	public function new () {

		super ("images/full_locked.png");

	}

	public override function initialize ():Void {

		super ();
		type = -1;

	}

	public function explode() : Tile
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

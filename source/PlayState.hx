package;

import flixel.FlxSprite;
import flixel.FlxState;

class PlayState extends FlxState
{
	var player:FlxSprite;

	override public function create()
	{
		super.create();
		player = new FlxSprite(0, 0);
		player.makeGraphic(16, 16, 0xffff0000);
		player.active = true;
		add(player);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}

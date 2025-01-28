package;

import flixel.FlxG;
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
		if (FlxG.keys.anyPressed([LEFT, A]))
		{
			player.velocity.x = -50;
		}
		else if (FlxG.keys.anyPressed([RIGHT, D]))
		{
			player.velocity.x = 50;
		}
		else
		{
			player.velocity.x = 0;
		}

		if (FlxG.keys.anyJustPressed([UP, W]))
		{
			player.velocity.y = -50;
			player.acceleration.y = -200;
		}
		else
		{
			player.acceleration.y = 0;
		}

		player.acceleration.y += 400;
	}
}

package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	var player:FlxSprite;
	// pretty hud
	var infoTxt:FlxText;
	var score:Int = 0;

	override public function create()
	{
		super.create();
		player = new FlxSprite(0, 0);
		player.makeGraphic(16, 16, 0xffff0000);
		player.active = true;
		add(player);
		infoTxt = new FlxText(10, 10, 0, "Score: " + score, 16);
		infoTxt.active = true;
		infoTxt.setFormat(FlxAssets.FONT_DEFAULT, 16, FlxColor.WHITE, LEFT, OUTLINE_FAST, FlxColor.BLACK);
		add(infoTxt);
	}

	function updateInfoTxt()
	{
		infoTxt.text = "Score: " + FlxMath.lerp(0, score, 0.1);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.keys.justPressed.SPACE)
		{
			score += 100;
			updateInfoTxt();
		}

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

package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.display.FlxRuntimeShader;
import flixel.util.FlxColor;
import openfl.filters.ShaderFilter;

class GameSubState extends FlxSubState
{
	var getBlackBG:Bool = false;
	var bg:FlxSprite;

	public function new(wannaGetBlackBG:Bool = false)
	{
		super();

		getBlackBG = wannaGetBlackBG;
	}

	override function create()
	{
		super.create();

		if (SaveData != null && SaveData.settings != null && SaveData.settings.shaderMode)
			FlxG.camera.filters = [new ShaderFilter(new FlxRuntimeShader(Main.vhsShader))];

		if (getBlackBG)
		{
			bg = new FlxSprite(0, 0);
			bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
			bg.alpha = 0.5;
			bg.screenCenter();
			bg.scrollFactor.set();
			insert(0, bg);
		}
	}
}
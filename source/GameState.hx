package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.FlxRuntimeShader;
import openfl.filters.ShaderFilter;

class GameState extends FlxState
{
	override function create()
	{
		if (SaveData != null && SaveData.settings != null && SaveData.settings.shaderMode)
			FlxG.camera.filters = [new ShaderFilter(new FlxRuntimeShader(Main.vhsShader))];
		super.create();
	}
}
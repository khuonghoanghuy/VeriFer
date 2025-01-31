package options;

import flixel.FlxG;

@:structInit class SaveSettings
{
	public var shaderMode:Bool = true;
}

class SaveData
{
	public static var settings:SaveSettings = {};

	public static function init()
	{
		for (key in Reflect.fields(settings))
			if (Reflect.field(FlxG.save.data, key) != null)
				Reflect.setField(settings, key, Reflect.field(FlxG.save.data, key));
	}

	public static function saveSettings()
	{
		for (key in Reflect.fields(settings))
			Reflect.setField(FlxG.save.data, key, Reflect.field(settings, key));

		FlxG.save.flush();

		trace('settings saved!');
	}

	public static function eraseData()
	{
		FlxG.save.erase();
		init();
	}
}
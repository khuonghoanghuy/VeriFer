package options;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import options.Options.OptionType;

class OptionsState extends GameState
{
	var optionsList:Array<Options> = [
		new Options("Shader", "Disable shader will boost a little fast for the game\nChange Will be Reset the State!", OptionType.Toggle,
			SaveData.settings.shaderMode),
		new Options("Back to Menu", "Back to the main menu", OptionType.Function, function():Void
		{
			SaveData.saveSettings();
			FlxG.switchState(new MenuState());
		})
	];

	var groupOptions:FlxTypedGroup<FlxText>;
	var curSelected:Int = 0;
	var description:FlxText;
	var camFollow:FlxObject;

	override function create()
	{
		super.create();

		optionsList[0].onChange = function(value:Dynamic)
		{
			SaveData.settings.shaderMode = value;
			SaveData.saveSettings();
			FlxG.resetState();
		};

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.screenCenter(X);
		add(camFollow);

		groupOptions = new FlxTypedGroup<FlxText>();
		add(groupOptions);

		for (i in 0...optionsList.length)
		{
			var text:FlxText = new FlxText(20 + (i * -2), 20 + (i * 20), 0, optionsList[i].toString(), 24);
			text.ID = i;
			text.scrollFactor.set();
			text.setFormat(FlxAssets.FONT_DEBUGGER, 18, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
			groupOptions.add(text);
		}

		description = new FlxText(0, FlxG.height - 50, FlxG.width * 0.9, '', 28);
		description.setFormat(FlxAssets.FONT_DEBUGGER, 12, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		description.screenCenter(X);
		description.scrollFactor.set();
		add(description);

		changeSelection(0);
		FlxG.camera.follow(camFollow, null, 0.14);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.UP)
			changeSelection(-1);
		else if (FlxG.keys.justPressed.DOWN)
			changeSelection(1);

		if (FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.LEFT)
		{
			if (optionsList[curSelected].type != OptionType.Function)
				changeValue(FlxG.keys.justPressed.RIGHT ? 1 : -1);
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			final option:Options = optionsList[curSelected];
			if (option != null)
				option.execute();
		}

		if (FlxG.keys.justPressed.ESCAPE)
		{
			SaveData.saveSettings();
			FlxG.switchState(new MenuState());
		}
	}

	private function changeSelection(change:Int = 0)
	{
		curSelected = FlxMath.wrap(curSelected + change, 0, optionsList.length - 1);
		groupOptions.forEach(function(txt:FlxText)
		{
			txt.text = (txt.ID == curSelected) ? "> " + optionsList[txt.ID].toString() : optionsList[txt.ID].toString();
			if (txt.ID == curSelected)
				camFollow.y = txt.y;
		});

		var option = optionsList[curSelected];

		if (option.desc != null)
		{
			description.text = option.desc;
			description.screenCenter(X);
		}
	}

	private function changeValue(direction:Int = 0):Void
	{
		final option:Options = optionsList[curSelected];

		if (option != null)
		{
			option.changeValue(direction);

			groupOptions.forEach(function(txt:FlxText):Void
			{
				if (txt.ID == curSelected)
					txt.text = option.toString();
			});
		}
	}
}
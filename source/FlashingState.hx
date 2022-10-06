package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.util.FlxSave;

class FlashingState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		warnText = new FlxText(0, 0, FlxG.width,
			"Hey there person man/woman   \n
			Some songs contains some flashing and it may cause a headache,\n
			Press Esc if you want to disable it or press Enter if you don't wanna disable it,\n
			\n
			Hope you enjoy this mod.",
			32);
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		add(warnText);
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ENTER) {
			var save:FlxSave = new FlxSave();
			save.bind('avfnf', 'ninjamuffin99');
			save.data.flashinglol = true;
			save.flush();
			FlxG.log.add("Settings saved!");
            FlxG.switchState(new TitleState());
			ClientPrefs.flashing = true;
			ClientPrefs.saveSettings();
			FlxG.sound.play(Paths.sound('cancelMenu'));
            FlxTween.tween(warnText, {alpha: 0}, 1, {
            });
		} else if (FlxG.keys.justPressed.ESCAPE) {
			var save:FlxSave = new FlxSave();
			save.bind('avfnf', 'ninjamuffin99');
			save.data.flashinglol = true;
			save.flush();
			FlxG.log.add("Settings saved!");
            FlxG.switchState(new TitleState());
			ClientPrefs.flashing = false;
			ClientPrefs.saveSettings();
            FlxG.sound.play(Paths.sound('cancelMenu'));
            FlxTween.tween(warnText, {alpha: 0}, 1, {
            });
		}

		super.update(elapsed);
   }
}

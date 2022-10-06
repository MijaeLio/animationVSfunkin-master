package options;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

using StringTools;

class AVFSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Animation Vs FNF Settings';
		rpcTitle = 'Gameplay Settings Menu'; //for Discord Rich Presence
		
		var option:Option = new Option('Toggle ReAnimated BF',
		'If checked, boyfriends skin will be replaced with re-animated bf (smoother)',
		'reanimatedbf',
		'bool',
		false);
		addOption(option);
		
		var option:Option = new Option('Animated Background', //Name
		'If unchecked, all animated backgrounds will turn into images', //Description
		'animatedbg', //Save data variable name
		'bool', //Variable type
		true); //Default value
		addOption(option);

		var option:Option = new Option('Camera Glitch Mechanic',
		'If unchecked, That camera glitch mechanic in Chosen will be disabled',
		'camGlitch',
		'bool',
		true);
		addOption(option);
		
		//I'd suggest using "Downscroll" as an example for making your own option since it is the simplest here
		var option:Option = new Option('Hit Sounds', //Name
		'If checked, notes will play a sound when you hit them.', //Description
		'hitSound', //Save data variable name
		'bool', //Variable type
		false); //Default value
		addOption(option);

		var option:Option = new Option('Bigger Healthbar', //Name
			'If checked, the healthbar will increase in size.(Does not give you more health)', //Description
			'bigHP', //Save data variable name
			'bool', //Variable type
			false); //Default value
		addOption(option);

		var option:Option = new Option('Shaders', //Name
			'If unchecked, shaders will be disabled', //Description
			'shaders', //Save data variable name
			'bool', //Variable type
			true); //Default value
		addOption(option);



		super();
	}
}

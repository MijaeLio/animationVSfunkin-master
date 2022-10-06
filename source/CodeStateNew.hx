package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;
import haxe.Exception;
using StringTools;
import flixel.util.FlxTimer;
import flixel.addons.ui.FlxInputText;
import flixel.system.FlxSound;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.math.FlxMath;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxSubState;
import flixel.util.FlxSave;

class CodeStateNew extends MusicBeatState
{
	public var codeInput:FlxInputText;
	var badSymbol:FlxText;
	var glitchEffect:FlxSprite;
	public var camCode:FlxCamera;
	var chromeOffset:Float = ((2 - ((0.5 / 0.5))));
	var windowPopUp:FlxSprite;
	var cando = true;
	
	override function create()
	{
		var save:FlxSave = new FlxSave();
		save.bind('avfnf', 'ninjamuffin99');

		super.create();
		
		camCode = new FlxCamera();
		FlxG.cameras.add(camCode);
		
        if (ClientPrefs.shaders) {
            chromeOffset /= 350;
            if (chromeOffset <= 0)
            	ShadersHandler.setChrome(chromeOffset);
            else
            	ShadersHandler.setChrome(chromeOffset);
        }

		FlxG.mouse.visible = true;
		
		windowPopUp = new FlxSprite(-80).loadGraphic(Paths.image('SymbolWindowPopup'));
        windowPopUp.scale.set(1.1, 1.1);
		windowPopUp.updateHitbox();
		windowPopUp.screenCenter();
        windowPopUp.x -= 25;
		windowPopUp.antialiasing = ClientPrefs.globalAntialiasing;
		add(windowPopUp);
		
		codeInput = new FlxInputText(475, 325, FlxG.width, "", 32, FlxColor.BLACK, FlxColor.TRANSPARENT, true);
		codeInput.setFormat(Paths.font("tahoma.ttf"), 16, FlxColor.BLACK, FlxTextBorderStyle.OUTLINE,FlxColor.WHITE);
		codeInput.scrollFactor.set();
		codeInput.backgroundColor = FlxColor.TRANSPARENT;
		codeInput.cameras = [camCode];
		codeInput.hasFocus = true;
		codeInput.maxLength = 27;
		codeInput.borderSize = 0.1;
		add(codeInput);
		codeInput.callback = function(text, action){
			if (action == 'enter')
			{
				if(controls.ACCEPT && cando) {
					cando = false;
					switch(text.toLowerCase())
					{
						case 'vengeance':
							glitchThing();
							codeInput.color = 0xFFFF0000;
							new FlxTimer().start(2, function(tmr:FlxTimer) {
							startSongThing('vengeance');
							});
							save.data.vengeanceunlocked = true;
							save.flush();
							FlxG.log.add("Settings saved!");
						case 'chosen':
							glitchThing();
							camCode.setFilters([ShadersHandler.chromaticAberration]);
							new FlxTimer().start(2, function(tmr:FlxTimer) {
							startChosen('chosen');
							});
							save.data.chosenunlocked = true;
							save.flush();
							FlxG.log.add("Settings saved!");
						case 'fallen':
							glitchThing();
							camCode.setFilters([ShadersHandler.chromaticAberration]);
							new FlxTimer().start(2, function(tmr:FlxTimer) {
							startSongThing('fallen');
							});
							save.data.fallenunlocked = true;
							save.flush();
							FlxG.log.add("Settings saved!");
						case 'bloxiam':
							openSubState(new BloxiamSubstate());
							codeInput.hasFocus = false;
						case 'pruimauam':
							openSubState(new PruimauamSubstate());
							codeInput.hasFocus = false;
						case 'an baker':
							PlayState.secret = true;
							PlayState.storyDifficulty = 2;
							PlayState.SONG = Song.loadFromJson('an-baker', 'an-baker');
							PlayState.isStoryMode = false;
							PlayState.storyWeek = 1;
							new FlxTimer().start(1.5, function(tmr:FlxTimer)
							{
								LoadingState.loadAndSwitchState(new PlayState());
							});
							save.data.anbaker = true;
							save.flush();
							FlxG.log.add("Settings saved!");
						default:
							badcode();
					}
					new FlxTimer().start(1, function(tmr:FlxTimer) {
						cando = true;
					});
				}
			}
		}
		
    	badSymbol = new FlxText(0, 0, 0, "You can't enter a symbol with this name", 32);
    	badSymbol.setFormat("VCR OSD Mono", 36, FlxColor.RED, CENTER, SHADOW,FlxColor.BLACK);
    	badSymbol.shadowOffset.set(2,2);
    	badSymbol.screenCenter();
    	badSymbol.y += 100;
	
		glitchEffect = new FlxSprite();
		glitchEffect.frames = Paths.getSparrowAtlas('glitchAnim');
		glitchEffect.animation.addByPrefix('idle', "g", 24, true);
		glitchEffect.scrollFactor.set();
		glitchEffect.screenCenter();
	}
	
	override public function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.BACKSPACE)
		{
			FlxG.sound.play(Paths.sound('keyboardPress'));
		}
		else if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}
		if (FlxG.keys.justPressed.ANY)
		{
			FlxG.sound.play(Paths.sound('keyboardPress'));
		}
	}
	
	function badcode() {
		FlxG.camera.shake(0.0075, 0.50);
		FlxG.sound.play(Paths.sound('glitch'), 1);
		glitchEffect.animation.play('idle', true);
		add(glitchEffect);
		new FlxTimer().start(1, function(tmr:FlxTimer) {
			remove(glitchEffect);
			add(badSymbol);
			new FlxTimer().start(5, function(tmr:FlxTimer) {
				remove(badSymbol);
			});
		});
	}
	
	function glitchThing()
	{
		FlxG.camera.shake(0.0075, 0.50);
		FlxG.sound.play(Paths.sound('glitch'), 1);
		add(glitchEffect);
		glitchEffect.animation.play('idle', true);
		codeInput.hasFocus = false;
	    new FlxTimer().start(1, function(tmr:FlxTimer) {
		remove(glitchEffect);
		});
	}
	
	function startSongThing(songName:String = '') {
		PlayState.storyDifficulty = 2;
		PlayState.SONG = Song.loadFromJson(songName, songName);
		PlayState.isStoryMode = true;
		PlayState.storyWeek = 2;
		if(songName == 'fallen') {
			LoadingState.loadAndSwitchState(new WarningState('fallen'));
		} else if(songName == 'vengeance') {
			LoadingState.loadAndSwitchState(new WarningState('vengeance'));
		}
		FlxG.mouse.visible = false;
		
		/*if (songName == 'chosen') this shit doesn't work anymore im pissed with it
		{
			PlayState.SONG = Song.loadFromJson(songName, songName);
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = 2;
			PlayState.storyWeek = 2;
			LoadingState.loadAndSwitchState(new WarningState());
			FlxG.mouse.visible = false;
		}*/
	}
	
	function startChosen(name:String = '') {
		PlayState.storyDifficulty = 2;
		PlayState.SONG = Song.loadFromJson(name, name);
		PlayState.isStoryMode = true;
		PlayState.storyWeek = 2;
		FlxG.mouse.visible = false;
		LoadingState.loadAndSwitchState(new WarningState('chosen'));
		FlxG.mouse.visible = false;
	}
}

class BloxiamSubstate extends MusicBeatSubstate
{
	var image:FlxSprite;
	public function new() {
		
        super();
        image = new FlxSprite().loadGraphic(Paths.image('bloxiam', 'preload'));
	    image.antialiasing = ClientPrefs.globalAntialiasing;
	    image.updateHitbox();
        image.screenCenter();
        add(image);
	}
	
	override public function update(elapsed:Float)
	{
		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
		    MusicBeatState.switchState(new CodeStateNew());
		}
	}
}

class PruimauamSubstate extends MusicBeatSubstate
{
	var image:FlxSprite;
	public function new() {
		
        super();
        image = new FlxSprite().loadGraphic(Paths.image('pruimauam', 'preload'));
	    image.antialiasing = ClientPrefs.globalAntialiasing;
		image.scale.set(0.4, 0.4);
	    image.updateHitbox();
        image.screenCenter();
        add(image);
	}
	
	override public function update(elapsed:Float)
	{
		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
		    MusicBeatState.switchState(new CodeStateNew());
		}
	}
}
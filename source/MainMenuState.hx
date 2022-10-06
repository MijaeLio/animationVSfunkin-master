package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxTimer;
import flixel.ui.FlxSpriteButton;
import openfl.Lib;
import flixel.util.FlxSave;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.5'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;
	public static var prevcurSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = [
		'play',
		'freeplay',
		'credits',
		'options',	
		'secret'
	];

	var magenta:FlxSprite;
	var frame:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;
	var menusprite:FlxSprite;
	var glitchFrame:FlxSprite;
	var codeMenu:FlxSpriteButton;
	var chromeOffset:Float = ((2 - ((0.5 / 0.5))));
	var bg:FlxSprite;
	var lastbutton = 'play';
	var lastbuttonnumber = 0;
	var curselectedissecret = false;
	var huhthing = false;
	var diffText:FlxText;
	var textSelected:String;

	var curDifficulty:Int = 1;
	private static var lastDifficultyName:String = '';
	
	public static var optionHandler:Bool = false;

	override function create()
	{
		
		optionHandler = false;
		
		var save:FlxSave = new FlxSave();
		save.bind('avfnf', 'ninjamuffin99');
		if(save.data.mainweekdone == null) {
			save.data.mainweekdone = false;
		}
		if(save.data.vengeanceunlocked == null) {
			save.data.vengeanceunlocked = false;
		}
		if(save.data.chosenunlocked == null) {
			save.data.chosenunlocked = false;
		}
		if(save.data.fallenunlocked == null) {
			save.data.fallenunlocked = false;
		}
		if(save.data.beestick == null) {
			save.data.beestick = false;
		}
		if(save.data.anbaker == null) {
			save.data.anbaker = false;
		}
		if(save.data.ignition == null) {
			save.data.ignition = false;
		}
		huhthing = save.data.mainweekdone;
		save.flush();
		FlxG.log.add("Settings saved!");

		if(!save.data.mainweekdone) optionShit.remove('freeplay');

		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
		
		Lib.application.window.title = "Animation vs Friday Night Funkin'";
		
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		FlxG.mouse.visible = false;

		WeekData.setDirectoryFromWeek();
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		if (ClientPrefs.shaders) {
			chromeOffset /= 350;
			if (chromeOffset <= 0)
				ShadersHandler.setChrome(0.0);
			else
				ShadersHandler.setChrome(chromeOffset);
		}

		FlxG.camera.setFilters([ShadersHandler.chromaticAberration]);
		camGame.setFilters([ShadersHandler.chromaticAberration]);
		camAchievement.setFilters([ShadersHandler.chromaticAberration]);

		bg = new FlxSprite(-50, -10).loadGraphic(Paths.image('menuBG'));
		bg.scale.set(0.622, 0.622);
		bg.scrollFactor.set(0, 0.09);
		bg.updateHitbox();
		bg.screenCenter();
		bg.y += 75;
		bg.x += 15;
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		glitchFrame = new FlxSprite(700, 50);
		glitchFrame.frames = Paths.getSparrowAtlas('mainmenu/frameimages/secretFrame');
		glitchFrame.scale.set(0.7, 0.7);
		glitchFrame.animation.addByPrefix('idle', "static frame", 24);
		glitchFrame.animation.play('idle');
		glitchFrame.scrollFactor.set();
		glitchFrame.antialiasing = ClientPrefs.globalAntialiasing;
		glitchFrame.updateHitbox();
		glitchFrame.screenCenter();
		glitchFrame.x += 200;
		glitchFrame.y -= 30;
		add(glitchFrame);

		menusprite = new FlxSprite().loadGraphic(Paths.image(''));
        menusprite.updateHitbox();
        menusprite.screenCenter();
        menusprite.y -= 374;
        menusprite.x -= 640;
        menusprite.scrollFactor.set(0, 0);
        menusprite.scale.set(0.7, 0.7);
        menusprite.antialiasing = ClientPrefs.globalAntialiasing;
        add(menusprite);
		
		frame = new FlxSprite().loadGraphic(Paths.image('mainmenu/frame'));
		frame.scale.set(0.7,0.7);
		frame.scrollFactor.set();
		frame.updateHitbox();
		frame.screenCenter();
		frame.y -= 15;
		frame.antialiasing = ClientPrefs.globalAntialiasing;
		add(frame);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		diffText = new FlxText(FlxG.width * 0.7, 5, 0, "", 42);
		diffText.setFormat(Paths.font("Minecraft.ttf"), 42, FlxColor.WHITE, CENTER);
		diffText.scrollFactor.set();
		diffText.x -= 100;
		add(diffText);
		
		for (i in 0...optionShit.length)
		{
			var addstuff = 70;
			if(!save.data.mainweekdone) addstuff = 140;
			var menuitemstuff:FlxSprite = new FlxSprite(100, (i * 150) + addstuff);
			menuitemstuff.loadGraphic('assets/images/mainmenu/menu_' + optionShit[i] + '.png');
			menuitemstuff.scale.set(0.3, 0.3);
			menuitemstuff.ID = i;
			menuItems.add(menuitemstuff);
			menuitemstuff.scrollFactor.set();
			menuitemstuff.antialiasing = ClientPrefs.globalAntialiasing;
			menuitemstuff.updateHitbox();
			if(optionShit[i] == 'secret')
			{
				menuitemstuff.x += 565;
				menuitemstuff.y -= 80;
				menuitemstuff.visible = huhthing;
			}
			//fixed yo stupid code
		}

		codeMenu = new FlxSpriteButton(875, 452, null, function()
        {
            codeMenuClick();
        });
        codeMenu.screenCenter();
        codeMenu.y -= 250;
        codeMenu.x -= 5;
        codeMenu.width = 388;
        codeMenu.height = 78;
        codeMenu.updateHitbox();
        codeMenu.visible = false;
        add(codeMenu); 

		FlxG.camera.follow(camFollowPos, null, 1);

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));

		changeDiff();

		/*#if PRELOAD_ALL
		var leText:String = textSelected;
		var size:Int = 28;
		#end
		var text:FlxText = new FlxText(textBG.x, textBG.y + 4, FlxG.width, leText, size);
		text.setFormat(Paths.font("vcr.ttf"), size, FlxColor.WHITE, RIGHT);
		text.scrollFactor.set();
		add(text); //XD*/

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	

	override function update(elapsed:Float)
	{
		
		var ctrl = FlxG.keys.justPressed.CONTROL;
		
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		#if debug
		if (FlxG.keys.justPressed.ONE)
		{
			FlxG.save.data.beatStickin =false;
			FlxG.save.flush();
		}
		if (FlxG.keys.justPressed.TWO)
		{
			FlxG.save.data.beatBlue =false;
			FlxG.save.flush();
		}
		if (FlxG.keys.justPressed.THREE)
		{
			FlxG.save.data.unlockedSecret =false;
			FlxG.save.flush();
		}
		
		if (FlxG.keys.justPressed.K)
		{
			optionHandler = true;
			MusicBeatState.switchState(new SongSelectionState());
		}
		
		if (FlxG.keys.justPressed.O)
		{
			MusicBeatState.switchState(new CodeStateNew());
		}
		
		#end

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));
		
		/*for (i in 0...optionShit.length)
		{
			switch(optionShit[i])
			{
					case 'play':
						textSelected = 'A new game has appeared on  the desktop!, Play the Story!. CTRL for Gameplay Changers.';
					case 'freeplay':
						textSelected = 'Be free to play every song on this mod!';
					case 'credits':
						textSelected = 'Know the developers behind this mod!';
					case 'options':
						textSelected = 'Change your keybinds, BF skin and more!';
			}	
		}*/

		if (!selectedSomethin)
		{
			if(huhthing) {
				if((controls.UI_LEFT_P || controls.UI_RIGHT_P) && curSelected != 0) {
					if(curselectedissecret) {
						FlxG.sound.play(Paths.sound('scrollMenu'));
						curSelected = prevcurSelected;
						curselectedissecret = false;
						changeItem();
					} else {
						FlxG.sound.play(Paths.sound('scrollMenu'));
						prevcurSelected = curSelected;
						curSelected = menuItems.length - 1;
						curselectedissecret = true;
						changeItem();
					}
				}
			}

			if(curSelected == 0) {
				if (controls.UI_RIGHT_P)
					changeDiff(-1);
				if (controls.UI_LEFT_P)
					changeDiff(1);
			}

			if(curSelected != menuItems.length - 1) {
				if (controls.UI_UP_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(-1);
				}
				if (controls.UI_DOWN_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(1);
				}
			}

			if (controls.BACK)
			{
				FlxG.mouse.visible = false;
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				imsodamnstupid();
			}
			
			if(ctrl && curSelected == 0)
			{
				persistentUpdate = false;
				openSubState(new GameplayChangersSubstate());
			}
		}

		/*
		menuItems.forEach(function(spr:FlxSprite)
		{
			if (FlxG.mouse.overlaps(spr))
			{
				menuItems.forEach(function(newsprstuff:FlxSprite)
				{
					unselectedbutton(newsprstuff);
				});
				curSelected = spr.ID;
				selectedbutton(spr);
				if (FlxG.mouse.justPressed)
					imsodamnstupid();
				buttonstuff();
			}
		});
		*/

		if(curSelected == 0) {
			diffText.y = FlxMath.lerp(diffText.y, 50, CoolUtil.boundTo(elapsed * 9.6, 0, 1));
		} else {
			diffText.y = FlxMath.lerp(diffText.y, -100, CoolUtil.boundTo(elapsed * 9.6, 0, 1));
		}

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if(!curselectedissecret) {
			if (curSelected >= menuItems.length - 1)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = menuItems.length - 2;
		}

		menuItems.forEach(function(spr:FlxSprite)
		{
			unselectedbutton(spr);
			if (spr.ID == curSelected)
				selectedbutton(spr);
		});

		buttonstuff();
	}

	function codeMenuClick() {
        FlxG.sound.play(Paths.sound('mouseClick'));
        LoadingState.loadAndSwitchState(new CodeState()); 
     }
	 
    function startSong(songlist:Array<String>, difficulty:Int = 1)
    {
	    PlayState.storyPlaylist = songlist;
	    PlayState.isStoryMode = true;
	    PlayState.storyWeek = 1;
		PlayState.secret = false;
	    PlayState.storyDifficulty = curDifficulty;
		PlayState.seenCutscene = false;
		if(curDifficulty == 1)
			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase(), PlayState.storyPlaylist[0].toLowerCase());
		if(curDifficulty == 2)
	    	PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + '-hard', PlayState.storyPlaylist[0].toLowerCase());
	    PlayState.campaignScore = 0;
	    PlayState.campaignMisses = 0;
		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		LoadingState.loadAndSwitchState(new PlayState());
	}

	function selectedbutton(spr:FlxSprite)
	{
		lastbutton = optionShit[spr.ID];
		lastbuttonnumber = spr.ID;
		spr.color = 0xFFFFFFFF;
		spr.alpha = 1;
		var add:Float = 0;
		if(menuItems.length > 4)
		{
			add = menuItems.length * 8;
		}
		camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
		spr.centerOffsets();
	}

	function unselectedbutton(spr:FlxSprite)
	{
		spr.updateHitbox();
		spr.color = 0xFF787878;
		spr.alpha = 0.3;
	}

	function buttonstuff()
	{
		if(optionShit[lastbuttonnumber] == 'secret')
		{
			curselectedissecret = true;
			if (ClientPrefs.shaders)
			{
				ShadersHandler.setChrome(chromeOffset);
			}
			//textSelected = '???';
		}
		else
		{
			menusprite.loadGraphic('assets/images/mainmenu/frameimages/' + optionShit[lastbuttonnumber] + 'Frame.png');
			curselectedissecret = false;
			ShadersHandler.setChrome(0.0);
		}
		glitchFrame.visible = curselectedissecret;
		menusprite.visible = !curselectedissecret;
		frame.visible = !curselectedissecret;
	}

	function imsodamnstupid()
	{
		FlxG.mouse.visible = false;
		selectedSomethin = true;
		FlxG.sound.play(Paths.sound('confirmMenu'));
		menuItems.forEach(function(spr:FlxSprite)
		{
			if (curSelected != spr.ID)
			{
				FlxTween.tween(FlxG.camera, {zoom: 5}, 0.8, {ease: FlxEase.expoIn});
				FlxTween.tween(bg, {angle: 45}, 0.8, {ease: FlxEase.expoIn});
				FlxTween.tween(bg, {alpha: 0}, 0.8, {ease: FlxEase.expoIn});
				FlxTween.tween(menusprite, {angle: 45}, 0.8, {ease: FlxEase.expoIn});
				FlxTween.tween(frame, {angle: 45}, 0.8, {ease: FlxEase.expoIn});
				FlxTween.tween(menusprite, {alpha: 0}, 0.8, {ease: FlxEase.expoIn});
				FlxTween.tween(frame, {alpha: 0}, 0.8, {ease: FlxEase.expoIn});
				FlxTween.tween(glitchFrame, {angle: 45}, 0.8, {ease: FlxEase.expoIn});
				FlxTween.tween(glitchFrame, {alpha: 0}, 0.8, {ease: FlxEase.expoIn});
				FlxTween.tween(spr, {alpha: 0}, 0.4, {
					ease: FlxEase.quadOut,
					onComplete: function(twn:FlxTween)
					{
						spr.kill();
					}
				});
			}
			else
			{
				FlxFlicker.flicker(spr, 0.5, 0.06, false, false, function(flick:FlxFlicker)
				{
					FlxG.mouse.visible = false;
					switch (lastbutton)
					{
						case 'play':
							startSong([
								'unwelcomed',
								'mastermind',
								'stickin-to-it',
								'repeater',
								'rock-blocks',
								'stick-symphony'
							]);
						case 'freeplay':
							MusicBeatState.switchState(new SongSelectionState());
							optionHandler = true;
						case 'secret':
							MusicBeatState.switchState(new CodeStateNew()); 
						case 'credits':
							MusicBeatState.switchState(new NewCreditsState()); 
						case 'options':
							MusicBeatState.switchState(new options.OptionsState());
					}
				});
			} 
		});
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty <= 0)
			curDifficulty = 2;
		if (curDifficulty >= 3)
			curDifficulty = 1;

		lastDifficultyName = CoolUtil.difficulties[curDifficulty];

		PlayState.storyDifficulty = curDifficulty;
		if(curDifficulty == 1)
			diffText.text = '<NORMAL>';
		if(curDifficulty == 2)
			diffText.text = '<HARD>';
	}
}

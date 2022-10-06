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

class SongSelectionState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.5'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;
	public static var curSelected2:Int = 0;
	var realcurselected = 0;
	var realdiff = -1;
	var buttonSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	var textItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;

	var menuInfomation:FlxText;
	
	var optionShit:Array<String> = [
	    'error'
	];
	
	var buttonsItems:FlxTypedGroup<FlxSprite>;
	
	var buttons:Array<String> = ['story', 'extras'];

	var camFollow:FlxObject;
	var debugKeys:Array<FlxKey>;

	var codeMenu:FlxSpriteButton;

	var bg:FlxSprite;
	
	var lastbutton = 'story'; // main menu code copy so I can save time heheheha
	var lastbuttonnumber = 0;
	
	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var lerpRating:Float = 0;
	var intendedScore:Int = 0;
	var intendedRating:Float = 0;
	
	var curDifficulty:Int = 2;
	private static var lastDifficultyName:String = '';
	 
	public static var curstate = 1;

	var changingstate = false;

    public function new(thestatelol:Int = 0)
    {
		if(thestatelol != 0) curstate = thestatelol;
		buttonSelected = curstate - 1;
		switch(curstate) {
			case 1:
				optionShit = [
					'unwelcomed',
					'mastermind',
					'stickin-to-it',
					'repeater',
					'rock-blocks',
					'stick-symphony'
				];
			case 2:
				optionShit = [
					'chosen',
					'vengeance',
					'ignition',
					'fallen',
					'chickened',
					'guitar-wars',
					'an-baker',
					'beestick',
					'dud'
				];
				var save:FlxSave = new FlxSave();
				save.bind('avfnf', 'ninjamuffin99');
				if(!save.data.vengeanceunlocked) optionShit.remove('vengeance');
				if(!save.data.chosenunlocked) optionShit.remove('chosen');
				if(!save.data.fallenunlocked) optionShit.remove('fallen');
				if(!save.data.anbaker) optionShit.remove('an-baker');
				if(!save.data.beestick) optionShit.remove('beestick');
				if(!save.data.dud) optionShit.remove('dud');
				if(!save.data.ignition) optionShit.remove('ignition');
		}
		if(curstate == 1) {
			realcurselected = curSelected;
			realdiff = curDifficulty;
		} else {
			realcurselected = curSelected2;
			realdiff = 2;
		}

        super();
    }

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
		
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In Freeplay", null);
		Lib.application.window.title = "Animation vs Friday Night Funkin'";
		#end
		
		FlxG.mouse.visible = true;

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

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		bg = new FlxSprite(-80).loadGraphic('assets/images/mainmenu/freeplay/background.png');
		bg.updateHitbox();
		bg.screenCenter();
		bg.y += 75;
		bg.x += 15;
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		textItems = new FlxTypedGroup<FlxSprite>();
		add(textItems);

		var addstuff = '';

		switch(curstate) {
			case 2:
				addstuff = 'extras/';
		}

		for(i in 0...optionShit.length) // main menu code copy so I can save time heheheha
		{
			var character:FlxSprite = new FlxSprite(700, 90);
			character.loadGraphic('assets/images/mainmenu/freeplay/' + addstuff + 'freeplay_' + optionShit[i] + '.png');
			character.ID = i;
			menuItems.add(character);
			character.scrollFactor.set();
			character.antialiasing = ClientPrefs.globalAntialiasing;
			character.updateHitbox();
			character.screenCenter();
			character.y += 15;
			character.x += i * 200;
			var name:FlxSprite = new FlxSprite(700, 90);
			name.loadGraphic('assets/images/mainmenu/freeplay/' + addstuff + 'text_' + optionShit[i] + '.png');
			name.scale.set(0.45, 0.45);
			name.ID = i;
			textItems.add(name);
			name.scrollFactor.set();
			name.antialiasing = ClientPrefs.globalAntialiasing;
			name.updateHitbox();
			name.screenCenter();
			name.y = character.y - name.height - 10;
			name.x = character.x;
		}
		
		buttonsItems = new FlxTypedGroup<FlxSprite>();
		add(buttonsItems);
		
		for (i in 0...buttons.length)
		{
			var buttonstuff:FlxSprite = new FlxSprite(710, 30);
			buttonstuff.loadGraphic('assets/images/mainmenu/freeplay/section_' + buttons[i] + '.png');
			buttonstuff.scale.set(0.18, 0.18);
			buttonstuff.ID = i;
			buttonsItems.add(buttonstuff);
			buttonstuff.scrollFactor.set();
			buttonstuff.antialiasing = ClientPrefs.globalAntialiasing;
			buttonstuff.updateHitbox();
			buttonstuff.x += i * 300;
			//fixed yo stupid code
		}

		menuInfomation = new FlxText(110, 680, 1000, "Press SPACE to listen to the Song", 28);
		menuInfomation.setFormat("VCR OSD Mono", 28, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		menuInfomation.scrollFactor.set(0, 0);
		menuInfomation.borderSize = 2;
		add(menuInfomation);
		menuInfomation.screenCenter(X);

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
        //add(codeMenu);
		
		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 42);
		scoreText.setFormat(Paths.font("Minecraft.ttf"), 42, FlxColor.WHITE, CENTER);
		scoreText.y += 600;
		scoreText.x -= 30;
		add(scoreText);
		
		if(curstate == 1) {
			diffText = new FlxText(FlxG.width * 0.7, 5, 0, "", 42);
			diffText.setFormat(Paths.font("Minecraft.ttf"), 42, FlxColor.WHITE, CENTER);
			diffText.y += 580;
			diffText.x -= 730;
			add(diffText);
		}

		// NG.core.calls.event.logEvent('swag').send();

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
		
		if(lastDifficultyName == '')
		{
			lastDifficultyName = CoolUtil.defaultDifficulty;
		}
		
		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));
		if(curstate == 1) {
			realdiff = curDifficulty;
		}
		
		changeDiff();

		bg.screenCenter();

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.x = ((spr.ID - realcurselected) * 400) + (FlxG.height * 0.65);
		});

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
	
	override function beatHit()
	{
		super.beatHit();

		if (!selectedSomethin) {
			FlxTween.tween(FlxG.camera, {zoom:1.02}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD}); //lol
		}
	}

	var selectedSomethin:Bool = false;
	var instPlaying:Int = -1;

	override function update(elapsed:Float)
	{
		var ctrl = FlxG.keys.justPressed.CONTROL;
		var space = FlxG.keys.justPressed.SPACE;
		
		Conductor.songPosition = FlxG.sound.music.time;
		
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));
		lerpRating = FlxMath.lerp(lerpRating, intendedRating, CoolUtil.boundTo(elapsed * 12, 0, 1));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;
			
		var ratingSplit:Array<String> = Std.string(Highscore.floorDecimal(lerpRating * 100, 2)).split('.');
		if(ratingSplit.length < 2) { //No decimals, add an empty space
			ratingSplit.push('');
		}
		
		while(ratingSplit[1].length < 2) { //Less than 2 decimals in it, add decimals then
			ratingSplit[1] += '0';
		}
		
		scoreText.text = 'PERSONAL BEST: \n' + lerpScore + ' (' + ratingSplit.join('.') + '%)';

		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin && !changingstate)
		{
			if(ctrl) {
				persistentUpdate = false;
				openSubState(new GameplayChangersSubstate());
			}

			buttonsItems.forEach(function(spr:FlxSprite)
			{
				if (FlxG.mouse.overlaps(spr)) {
					buttonSelected = spr.ID;
					lastbutton = buttons[spr.ID];
					lastbuttonnumber = spr.ID;
					var add:Float = 0;
					if(buttonsItems.length > 4)
					{
						add = buttonsItems.length * 8;
					}
					camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
					spr.centerOffsets();
					if(FlxG.mouse.justPressed) {
						if((curstate - 1) != spr.ID) {
							changingstate = true;
							buttonsItems.forEach(function(spr:FlxSprite) {
								switch (lastbutton) {
									case 'story':
										MusicBeatState.switchState(new SongSelectionState(1));
									case 'extras':
										MusicBeatState.switchState(new SongSelectionState(2));
								}
							});
						}
					}
					
				}
				if(buttonSelected == spr.ID) {
					spr.color = 0xFFFFFFFF;
					spr.alpha = 1;
				} else {
					spr.updateHitbox();
					spr.color = 0xFF787878;
					spr.alpha = 0.3;
				}
			});

			menuItems.forEach(function(spr:FlxSprite) {
				spr.x = FlxMath.lerp(spr.x, ((spr.ID - realcurselected) * 400) + (FlxG.height * 0.65), CoolUtil.boundTo(elapsed * 9.6, 0, 1));
				for(text in textItems) {
					if(text.ID == spr.ID) {
						text.x = spr.x;
					}
				}
			});

			if (controls.UI_LEFT_P)
				changeItem(-1);
			if (controls.UI_RIGHT_P)
				changeItem(1);
			if(curstate == 1) {
				if (controls.UI_DOWN_P)
					changeDiff(-1);
				if (controls.UI_UP_P)
					changeDiff(1);
			}

			if (controls.BACK) {
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
			}

			if(space) {
				if(instPlaying != realcurselected)
				{
					#if PRELOAD_ALL
					FlxG.sound.playMusic(Paths.inst(optionShit[realcurselected]), 0);
					#end
					
					PlayState.SONG = Song.loadFromJson(optionShit[realcurselected], optionShit[realcurselected]);
					Conductor.changeBPM((PlayState.SONG.bpm));
				}
			} else if (controls.ACCEPT) {
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));

				//if(ClientPrefs.flashing) FlxFlicker.flicker(bg, 1.1, 0.15, false);

				menuItems.forEach(function(spr:FlxSprite)
				{
					textItems.forEach(function(textspr:FlxSprite)
					{
						if(spr.ID == textspr.ID) {
							if (realcurselected != spr.ID) {
								FlxTween.tween(FlxG.camera, {zoom: 5}, 0.8, {ease: FlxEase.expoIn});
								FlxTween.tween(bg, {angle: 45}, 0.8, {ease: FlxEase.expoIn});
								FlxTween.tween(bg, {alpha: 0}, 0.8, {ease: FlxEase.expoIn});
								FlxTween.tween(textspr, {alpha: 0}, 0.4, {
									ease: FlxEase.quadOut,
									onComplete: function(twn:FlxTween)
									{
										textspr.kill();
									}
								});
								FlxTween.tween(spr, {alpha: 0}, 0.4, {
									ease: FlxEase.quadOut,
									onComplete: function(twn:FlxTween)
									{
										spr.kill();
									}
								});
							} else {
								FlxFlicker.flicker(textspr, 0.5, 0.06, false, false);
								FlxFlicker.flicker(spr, 0.5, 0.06, false, false, function(flick:FlxFlicker)
								{
									switch (optionShit[realcurselected])
									{
										default:
											PlayState.secret = false;
											PlayState.storyDifficulty = realdiff;
											if(realdiff == 1) {
												PlayState.SONG = Song.loadFromJson(optionShit[realcurselected], optionShit[realcurselected]); 
											} else {
												if(curstate == 1) {
													PlayState.SONG = Song.loadFromJson(optionShit[realcurselected] + '-' + CoolUtil.difficultyString(), optionShit[realcurselected]);
												} else {
													PlayState.SONG = Song.loadFromJson(optionShit[realcurselected], optionShit[realcurselected]); 
												}
											}
											PlayState.isStoryMode = false;
											PlayState.storyWeek = 1;
											new FlxTimer().start(1.5, function(tmr:FlxTimer)
											{
											LoadingState.loadAndSwitchState(new PlayState());
											});
									}
								});
							}
						}
					});
				});
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		if(huh != 0) FlxG.sound.play(Paths.sound('scrollMenu'));

		realcurselected += huh;

		if (realcurselected >= menuItems.length)
			realcurselected = 0;
		if (realcurselected < 0)
			realcurselected = menuItems.length - 1;

		if(curstate == 1) {
			curSelected = realcurselected;
		} else {
			curSelected2 = realcurselected;
		}
		#if !switch
		intendedScore = Highscore.getScore(optionShit[realcurselected], realdiff);
		intendedRating = Highscore.getRating(optionShit[realcurselected], realdiff);
		#end
	
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.updateHitbox();
			spr.alpha = 0.6;
			if (spr.ID == realcurselected)
			{
				spr.alpha = 1;
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});
		for(spr in textItems)
		{
			spr.updateHitbox();
			spr.alpha = 0.6;
			if (spr.ID == realcurselected)
			{
				spr.alpha = 1;
			}
		}
		
		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		
		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(CoolUtil.defaultDifficulty)));
		if(curstate == 1) {
			realdiff = curDifficulty;
		}
		var newPos:Int = CoolUtil.difficulties.indexOf(lastDifficultyName);
		//trace('Pos of ' + lastDifficultyName + ' is ' + newPos);
		if(newPos > -1)
		{
			realdiff = newPos;
		}
	}
	
	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 1)
			curDifficulty = CoolUtil.difficulties.length-1;
		if (curDifficulty >= CoolUtil.difficulties.length)
			curDifficulty = 1;

		lastDifficultyName = CoolUtil.difficulties[curDifficulty];

		#if !switch
		intendedScore = Highscore.getScore(optionShit[realcurselected], curDifficulty);
		intendedRating = Highscore.getRating(optionShit[realcurselected], curDifficulty);
		#end

		PlayState.storyDifficulty = curDifficulty;
		if(curstate == 1) {
			diffText.text = '^\n' + CoolUtil.difficultyString() + '\nv';
		}
		realdiff = curDifficulty;
	}

	function codeMenuClick() {
        FlxG.sound.play(Paths.sound('mouseClick'));
        LoadingState.loadAndSwitchState(new CodeState()); 
    }
}

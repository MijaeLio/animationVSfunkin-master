package;

import CutsceneState.CutsceneState;
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

class WarningState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var video:MP4Handler = new MP4Handler();
	var warnText:FlxText;
	var isCutscene:Bool = false;
	var thesongnamename = '';

    public function new(songname:String)
	{
		thesongnamename = songname;
		super();
	}

	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		var text = 'Press Space to dodge Tdl slices.';
		if(thesongnamename != 'vengeance') {
			text = "Hey there person man/woman   \n
			This song contains an animated background and it may cause a headache,\n
			Press Esc if you want to disable it or press Enter if you don't wanna disable it,\n
			\n
			Hope you enjoy this song";
		}
		warnText = new FlxText(0, 0, FlxG.width, text, 32);
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		add(warnText);
	}

	override function update(elapsed:Float)
	{
		if(thesongnamename == 'vengeance') {
			if (FlxG.keys.justPressed.ANY) {
				PlayState.animatedbgdisable = false;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				PlayState.SONG = Song.loadFromJson(thesongnamename, thesongnamename);
				//FlxG.switchState(new VideoState('assets/videos/chosen/fight_cutscene.webm', new PlayState()));
				FlxTween.tween(warnText, {alpha: 0}, 1, {
				});
				PlayState.storyDifficulty = 2;
				PlayState.secret = true;
				LoadingState.loadAndSwitchState(new PlayState());
			}
		} else {
			if (controls.ACCEPT) {
				PlayState.animatedbgdisable = false;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				PlayState.SONG = Song.loadFromJson(thesongnamename, thesongnamename);
				//FlxG.switchState(new VideoState('assets/videos/chosen/fight_cutscene.webm', new PlayState()));
				FlxTween.tween(warnText, {alpha: 0}, 1, {
				});
				
				if (PlayState.isStoryMode)
				{
					if(thesongnamename == 'chosen') {
						new FlxTimer().start(1, function(tmr:FlxTimer)
						{
							startMP4vid('fight_cutscene');
						});
					} else {
						PlayState.storyDifficulty = 2;
						PlayState.secret = true;
						LoadingState.loadAndSwitchState(new PlayState());
					}
				}
				else
				{
					PlayState.storyDifficulty = 2;
					PlayState.secret = true;
					LoadingState.loadAndSwitchState(new PlayState());
				}
			}
			else if (controls.BACK) 
			{
				{
					PlayState.animatedbgdisable = true;
					FlxG.sound.play(Paths.sound('cancelMenu'));
					PlayState.SONG = Song.loadFromJson(thesongnamename, thesongnamename);
					//FlxG.switchState(new VideoState('assets/videos/chosen/fight_cutscene.webm', new PlayState()));
					FlxTween.tween(warnText, {alpha: 0}, 1, {
					});
					
					if (PlayState.isStoryMode)
					{
						if(thesongnamename == 'chosen') {
							new FlxTimer().start(1, function(tmr:FlxTimer)
							{
								startMP4vid('fight_cutscene');
							});
						} else {
							PlayState.storyDifficulty = 2;
							PlayState.secret = true;
							LoadingState.loadAndSwitchState(new PlayState());
						}
					}
					else
					{
						PlayState.storyDifficulty = 2;
						PlayState.secret = true;
						LoadingState.loadAndSwitchState(new PlayState());
					}
				}
			}
		}
		super.update(elapsed);
   }
   
   function startMP4vid(name:String)
   {
	   
	   var video:MP4Handler = new MP4Handler();
	   video.playMP4(Paths.video(name));
	   video.finishCallback = function()
	   {
			PlayState.storyDifficulty = 2;
			PlayState.secret = true;
		   	LoadingState.loadAndSwitchState(new PlayState());
	   }
	   isCutscene = true;
   }
}
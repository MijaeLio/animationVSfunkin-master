import flixel.FlxG;
import flixel.FlxSprite;

class CutsceneState extends MusicBeatState
{
	public var handler:MP4Handler;

	public var path:String = "";

	public function new(bruh)
	{
		path = bruh;
		super();
	}

	public function load()
	{
		handler = new MP4Handler();
	}

	public override function update(elapsed)
	{
		if (FlxG.keys.justPressed.ENTER)
		{
			handler.kill();
			MusicBeatState.switchState(new PlayState());
		}
		super.update(elapsed);
	}

	public override function create()
	{
		handler.playMP4(Paths.video(path));
		handler.finishCallback = function()
		{
			MusicBeatState.switchState(new PlayState());
		};
		super.create();
	}
}

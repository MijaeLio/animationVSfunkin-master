package;

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
import flixel.tweens.FlxTween;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import lime.utils.Assets;
import flixel.util.FlxTimer;
import flixel.util.FlxSave;
import lime.app.Application;

using StringTools;

class NewCreditsState extends MusicBeatState
{
    public static var curSelected = 0;
    var stickmangroup:FlxTypedGroup<FlxSprite>;
    var namebg:FlxSprite;
    var nameText:FlxText;
    var descbg:FlxSprite;
    var descText:FlxText;

    var xposcam = 0.0;
    var yposcam = 0.0;

    var creditstuff:Array<Array<Dynamic>> = [
        ['sir chapurato',	    'chap',		        'charter/main director',		'https://www.youtube.com/channel/UC37f51A8bNepi7PvD8owOxQ',     -596,       418 ],
        ['mijaelio',	        'mijae',		    'coder',		                'https://twitter.com/MijaeLio',                                 -526,       421 ], //
        ['03cube/cheese',	    'cube',		        'artist/animator/events guy',	'https://www.youtube.com/channel/UCGSX2AqYE98-Rq59qINt3BQ',     -128,       483 ],
        ['white ninja',	        'white ninja',	    'coder/artist/charter',		    'https://whiteninja.carrd.co/',                                 -82,        532 ], //omw to break the code -whiteninja
        ['John daily',	        'john',		        'charter',		                'https://www.youtube.com/channel/UCodLS1PxWyQguqoHEWNPcYw',     191,        455 ],
        ['longestsoloever',	    'lse',		        'musician',		                'https://www.youtube.com/channel/UCDho0k4J3qvekjkqL4sepfQ',     144,        545 ],
        ['Cancerpinguin 2.0',	'cancer',		    'charter',		                'https://steamcommunity.com/profiles/76561198886673790/',       370,        413 ],
        ['Noogai',	            'noogai',		    'artist/animator',		        'https://www.youtube.com/channel/UC1iEkfmxlghtiFqJm7K_RBg',     415,        535 ],
        ['serkoid',	            'serkoid',		    'coder/animator/artist',		'https://www.youtube.com/channel/UCWXYCOhrmye32o-zvu-GtPQ',     541,        424 ],
        ['sensisgone',	        'sens',		        'charter',		                'https://www.youtube.com/channel/UCtcQQMhWDd_v7tgwbfNuW3w',     527,        594 ],
        ['Ekical',	            'ekical',		    'coder/charter',		        'https://www.youtube.com/c/Ekical',                             661,        400 ], //coolswag
        ['PeaceHacker',	        'peace',		    'code/playtester/charter',		'https://www.youtube.com/channel/UC_AQOgKJ5WvDOGIOV_oTqog',     762,        511 ],
        ['Simox',	            'simox',		    'charter',		                'https://www.youtube.com/channel/UC8cwN_xk8ugqL2_y7LPVOVA',     899,        390 ],
        ['Boink',	            'boink',		    'charter',		                'https://twitter.com/boinky_woinky',                            1017,       528 ],
        ['Ojogadoranimador',	'oja',		        'artist/animator',		        'https://www.youtube.com/channel/UCMKqZBweGhdyXS_yyR_wwfw',     1157,       442 ],
        ['Top 10 awesome',	    'top 10',		    'musician',		                'https://www.youtube.com/channel/UC6NtPGdUgKSC8Wx1F-GN4tg',     1225,       629 ],
        ['salty sovet',		    'salt',		        'coder/co director/artist',		'https://www.youtube.com/channel/UC1qT2vh0aORFdHA4cVAHZUw',     1391,       353 ],
        ['hexal',	            'hexal',		    'artist/animator',		        'https://www.youtube.com/c/Hexalhaxel',                         1527,       537 ],
        ['spoon dice music',	'dice',		        'musician',		                'https://www.youtube.com/c/SpoonDice',                          1697,       491 ],
        ['Savia',	            'savia',		    'artist/animator',		        'https://www.youtube.com/channel/UCFmLZpOectYN9VGcrz89KTA',     1812,       481 ],
        ['idiotic sugar',	    'idiotic',		    'musician',		                'https://www.youtube.com/channel/UCvT7NQk_f401WzDZbQ-DidA',     1971,       525 ],
        ['geon woo',	        'geon',		        'artist/animator',		        'https://www.youtube.com/channel/UCFwBYQZeCWdfpFC8LfBT58Q',     2016,       464 ],
        ['Reginald',	        'ringald',		    'charter',		                'https://youtube.com/channel/UCEqHSAUTzOAssJe8j4ZI3iw',         2160,       411 ],
        ['skwoop',	            'skwoop',		    'charter',		                'https://twitter.com/itsallfuckein',                            2238,       521 ],
        ['The lost gamer',	    'gamer',		    'musician',		                'https://www.youtube.com/channel/UCKLDGnrxzYuu2QDaPa7VlxA',     2293,       424 ],
        ['Tostitos',	        'tost',		        'artist/animator',		        'https://twitter.com/Toorynooo',                                2474,       482 ],
        ['Mayosifrayo',	        'mayo',		        'artist/animator',		        'https://twitter.com/sifrayo',                                  2503,       349 ],
        ['yes, its bee',	    'b',		        'artist/animator/co director',	'https://www.youtube.com/channel/UCi4COUcfP89Il-PKJ33DlNg',     2665,       71  ],
        ['surgespb',	        'surge',		    'musician',		                'https://youtube.com/c/SurgeSPBMakesMusic',                     2761,       488 ],
        ['dareiphobia',	        'dareiphobia',	    'artist',		                'https://twitter.com/PhobiaDarei',                              2981,       463 ],
        ['SulfurAnimations',	'sulfur',		    'artist',		                'https://www.youtube.com/c/Saifyrooma2nd',                      3103,       517 ],
        ['Imjustatommix',	    'atomixx',		    'musician',		                'https://twitter.com/imjustatomixx',                            3227,       550 ],
        ['zeff',	            'zeff',		        'charter',		                'https://www.youtube.com/channel/UCF9eAii5HOQ0t1HzOG-hwtA',     3431,       546 ],
        ['dud',	                'dud',		        'dudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddudduddud',   'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 3710,  761] //dud
        //['name',	            'image',		    'description',		            'link',                                                         x,          y   ]
    ];

    var bg:FlxSprite;
    var backgroundx = -2161;
    var backgroundy = -815;
    var sprx = 0.0;
    var spry = 0.0;
    var namebgx = 0.0;
    var namebgy = 0.0;
    var descbgx = 0.0;
    var descbgy = 0.0;
    var youcan = false;
    var beestick = false;

	override function create()
	{
        var save:FlxSave = new FlxSave();
        save.bind('avfnf', 'ninjamuffin99');
        youcan = save.data.mainweekdone;
        beestick = save.data.beestick;

        #if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

        bg = new FlxSprite(0, 0).loadGraphic(Paths.image('credits/background', 'preload'));
        bg.antialiasing = ClientPrefs.globalAntialiasing;
        bg.scrollFactor.set();
        add(bg);

        stickmangroup = new FlxTypedGroup<FlxSprite>();
		add(stickmangroup);

        for(i in 0...creditstuff.length) {
            var stickman:FlxSprite;
            stickman = new FlxSprite(0, 0).loadGraphic(Paths.image('credits/' + creditstuff[i][1], 'preload'));
            stickman.antialiasing = ClientPrefs.globalAntialiasing;
            stickman.ID = i;
            stickmangroup.add(stickman);
        }

        namebg = new FlxSprite(0, 0).loadGraphic(Paths.image('creditthingdesc', 'preload'));
        namebg.antialiasing = ClientPrefs.globalAntialiasing;
        namebg.width = 1020;
        namebg.height = 50;
        namebg.color = 0xDD000000;
        add(namebg);

        nameText = new FlxText(0, 0, 0, "", 32);
		nameText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		nameText.borderSize = 2.4;
		add(nameText);

        descbg = new FlxSprite(0, 0).loadGraphic(Paths.image('creditthingdesc', 'preload'));
        descbg.antialiasing = ClientPrefs.globalAntialiasing;
        descbg.width = 1020;
        descbg.height = 50;
        descbg.color = 0xDD000000;
        add(descbg);

        descText = new FlxText(0, 0, 0, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.borderSize = 2.4;
		add(descText);

        changeSelection();

        stickmangroup.forEach(function(spr:FlxSprite)
        {
            spr.x = creditstuff[spr.ID][4] - xposcam;
            spr.y = creditstuff[spr.ID][5] - yposcam;
            if(spr.ID == curSelected) {
                sprx = creditstuff[spr.ID][4] - xposcam;
                spry = creditstuff[spr.ID][5] - yposcam;
            }
        });

        bg.x = backgroundx - xposcam;
        bg.y = backgroundy - yposcam;
        descbg.scale.x = (descText.width + 20) / 1020;
        descbg.updateHitbox();
        descbgx = sprx + (stickmangroup.members[curSelected].width / 2) - (descbg.width / 2);
        descbgy = spry - descbg.height - 10;
        descbg.x = descbgx;
        descbg.y = descbgy;
        descText.x = descbgx + 10;
        descText.y = descbgy + 5;
        namebg.scale.x = (nameText.width + 20) / 1020;
        namebg.updateHitbox();
        namebgx = sprx + (stickmangroup.members[curSelected].width / 2) - (namebg.width / 2);
        namebgy = descbgy - namebg.height - 5;
        namebg.x = namebgx;
        namebg.y = namebgy;
        nameText.x = namebgx + 10;
        nameText.y = namebgy + 5;

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

        var coolval = CoolUtil.boundTo(elapsed * 9.6, 0, 1);

        stickmangroup.forEach(function(spr:FlxSprite)
        {
            spr.x = FlxMath.lerp(spr.x, creditstuff[spr.ID][4] - xposcam, coolval);
            spr.y = FlxMath.lerp(spr.y, creditstuff[spr.ID][5] - yposcam, coolval);
            if(spr.ID == curSelected) {
                sprx = creditstuff[spr.ID][4] - xposcam;
                spry = creditstuff[spr.ID][5] - yposcam;
            }
        });

        bg.x = FlxMath.lerp(bg.x, backgroundx - xposcam, coolval);
        bg.y = FlxMath.lerp(bg.y, backgroundy - yposcam, coolval);
        descbg.scale.x = FlxMath.lerp(descbg.scale.x, (descText.width + 20) / 1020, coolval);
        descbg.updateHitbox();
        descbgx = sprx + (stickmangroup.members[curSelected].width / 2) - (descbg.width / 2);
        descbgy = spry - descbg.height - 10;
        descbg.x = FlxMath.lerp(descbg.x, descbgx, coolval);
        descbg.y = FlxMath.lerp(descbg.y, descbgy, coolval);
        descText.x = FlxMath.lerp(descText.x, descbgx + 10, coolval);
        descText.y = FlxMath.lerp(descText.y, descbgy + 5, coolval);
        namebg.scale.x = FlxMath.lerp(namebg.scale.x, (nameText.width + 20) / 1020, coolval);
        namebg.updateHitbox();
        namebgx = sprx + (stickmangroup.members[curSelected].width / 2) - (namebg.width / 2);
        namebgy = descbgy - namebg.height - 5;
        namebg.x = FlxMath.lerp(namebg.x, namebgx, coolval);
        namebg.y = FlxMath.lerp(namebg.y, namebgy, coolval);
        nameText.x = FlxMath.lerp(nameText.x, namebgx + 10, coolval);
        nameText.y = FlxMath.lerp(nameText.y, namebgy + 5, coolval);

		var upP = controls.UI_LEFT_P;
		var downP = controls.UI_RIGHT_P;

		if (upP)
			changeSelection(-1);
		if (downP)
			changeSelection(1);

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}
		if(controls.ACCEPT) {
            if(creditstuff[curSelected][0].toUpperCase() == 'DUD') {
                Application.current.window.alert('take a peek in the files', 'hint');
            }
            CoolUtil.browserLoad(creditstuff[curSelected][3]);
        }

        stickmangroup.forEach(function(spr:FlxSprite) {
            if(FlxG.mouse.overlaps(spr) && creditstuff[spr.ID][0] == 'yes, its bee' && FlxG.mouse.justPressed && youcan && !beestick) {
                var save:FlxSave = new FlxSave();
                save.bind('avfnf', 'ninjamuffin99');
                save.data.beestick = true;
                save.flush();
                FlxG.log.add("Settings saved!");
                SongSelectionState.curstate = 2;
                PlayState.SONG = Song.loadFromJson('beestick', 'beestick');
                PlayState.isStoryMode = false;
                PlayState.storyDifficulty = 2;
                PlayState.storyWeek = 1;
                LoadingState.loadAndSwitchState(new PlayState());
            }
        });
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0)
	{
		if(change != 0) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

        curSelected += change;
        
		if (curSelected < 0)
			curSelected = creditstuff.length - 1;
		if (curSelected >= creditstuff.length)
			curSelected = 0;

        stickmangroup.forEach(function(spr:FlxSprite)
        {
            spr.color = 0xFFDDDDDD;
            spr.alpha = 0.7;
            if(spr.ID == curSelected) {
                xposcam = creditstuff[spr.ID][4] + (spr.width / 2) - 640;
                yposcam = creditstuff[spr.ID][5] + (spr.height / 2) - 400;
                spr.color = 0xFFFFFFFF;
                spr.alpha = 1;
                nameText.text = creditstuff[spr.ID][0].toUpperCase();
                descText.text = creditstuff[spr.ID][2].toUpperCase();
            }
        });

        if(creditstuff[curSelected][0] == 'yes, its bee' && youcan && !beestick) {
            FlxG.mouse.visible = true;
        } else {
            FlxG.mouse.visible = false;
        }
	}
}

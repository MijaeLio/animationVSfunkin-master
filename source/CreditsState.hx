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

using StringTools;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = -1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];
	private var creditsStuff:Array<Array<String>> = [];

	var bg:FlxSprite;
	var descText:FlxText;
	var intendedColor:Int;
	var colorTween:FlxTween;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		bg = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scale.set(0.622, 0.622);
		bg.scrollFactor.set(0, 0);
		bg.updateHitbox();
		bg.screenCenter();
		bg.y += 75;
		bg.x += 15;
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		#if MODS_ALLOWED
		//trace("finding mod shit");
		for (folder in Paths.getModDirectories())
		{
			var creditsFile:String = Paths.mods(folder + '/data/credits.txt');
			if (FileSystem.exists(creditsFile))
			{
				var firstarray:Array<String> = File.getContent(creditsFile).split('\n');
				for(i in firstarray)
				{
					var arr:Array<String> = i.replace('\\n', '\n').split("::");
					if(arr.length >= 5) arr.push(folder);
					creditsStuff.push(arr);
				}
				creditsStuff.push(['']);
			}
		}
		#end

		var pisspoop:Array<Array<String>> = [ //Name - Icon name - Description - Link - BG Color
			['Animation VS FNF Team'],
			['Sir Chapurato', 		'sirchap',			'Director and Charter',									'https://www.youtube.com/channel/UC37f51A8bNepi7PvD8owOxQ'	],
			['Salty Sovet',			'funnisovet',		'Lead coder and Co-Director', 							'https://www.youtube.com/channel/UC1qT2vh0aORFdHA4cVAHZUw'	],
			['Surge SPB',			'noiconhaha',		'Music (coolswag)',										'https://youtube.com/c/SurgeSPBMakesMusic'					],
			['Spoon Dice Music',	'spoonicon',		'Music swaggers',										'https://www.youtube.com/c/SpoonDice'						],
			['ImJustAtomixx',	    'atomixx',		    'Music swaggers',										'https://twitter.com/imjustatomixx'						    ],
			['Juora',	            'noiconhaha',		'Music swaggers',										'https://twitter.com/Juoralol'						    ],
			['Ekical',				'ekicalcoolswag',	'Coder',												'https://www.youtube.com/c/Ekical'							], //coolswag
			['Nom_lol',         	'nomm',          	'Coder',         										'https://www.youtube.com/channel/UCSTIop1Eo1bkpqVTbGSE9WQ'	], //balls
			['MijaeLio',			'mij',		  		'Coder',												'https://twitter.com/MijaeLio'								], //
			['Shpee',				'noiconhaha',		'Coder',												'https://twitter.com/Shpeelock'								],
			['Robotic Press',		'noiconhaha',		'Coder',												'https://twitter.com/PressRobotic'								],
			['Yes, Its bee',		'thefucingbee',		'Artist',												'https://www.youtube.com/channel/UCi4COUcfP89Il-PKJ33DlNg'	],
			['Hexal',				'hexal',			'Artist/Animator',										'https://www.youtube.com/c/Hexalhaxel'						],
			['OJogadorAnimador',    'noiconhaha',	    'Artist/Animator',										'https://www.youtube.com/channel/UCMKqZBweGhdyXS_yyR_wwfw'	],
			['noogai9876',          'canicon',	        'Artist/Animator',										'https://www.youtube.com/channel/UC1iEkfmxlghtiFqJm7K_RBg'	],
			['Savia', 				'Savie', 			'Artist', 												'https://www.youtube.com/channel/UCFmLZpOectYN9VGcrz89KTA'	],
			['Cheese Farmer',		'CHEESE',			'Artist',												'https://www.youtube.com/channel/UCGSX2AqYE98-Rq59qINt3BQ'	],
			['Tostitos2',		    'hiTostitos',	    'Artist',												'https://twitter.com/Toorynooo'	],
			['Sensisgone', 			'sens', 			'Charting', 											'https://www.youtube.com/channel/UCtcQQMhWDd_v7tgwbfNuW3w'	],
			['Serkoid',				'noiconhaha',		'Coder and Artist',										'https://www.youtube.com/channel/UCWXYCOhrmye32o-zvu-GtPQ'	],
			['Chromasen',			'noiconhaha',		'Coder',												'https://twitter.com/ChromaSen'								],
			['The White Ninja',		'wn',				'Coder',												'https://linktr.ee/the_white_ninja'							], //omw to break the code -whiteninja
			['Reginald Reborn', 	'noiconhaha', 		'Charting', 											'https://gamebanana.com/members/2011865'					],
			['CancerPinguin2.0', 	'noiconhaha', 		'Charting',												'https://steamcommunity.com/profiles/76561198886673790/'	],
			['LeGoldenBoots',		'noiconhaha', 		'Coding', 												'https://www.youtube.com/channel/UCysojweWJ_X3iaTAMAvNFCQ'	],
	        ['PeaceHKR', 	'noiconhaha', 		'Charting, Playtesting, Small ammounts of Programming',												'https://www.flowcode.com/page/peacedoesstuff'	],
			['Psych Engine Team'],
			['Shadow Mario',		'shadowmario',		'Main Programmer of Psych Engine',						'https://twitter.com/Shadow_Mario_',	'FFDD33'			],
			['RiverOaken',			'riveroaken',		'Main Artist/Animator of Psych Engine',					'https://twitter.com/river_oaken',		'C30085'			],
			['bb-panzu',			'bb-panzu',			'Additional Programmer of Psych Engine',				'https://twitter.com/bbsub3',			'389A58'			],
			[''],			
			['Engine Contributors'],			
			['shubs',				'shubs',			'New Input System Programmer',							'https://twitter.com/yoshubs',			'4494E6'			],
			['SqirraRNG',			'gedehari',			'Chart Editor\'s Sound Waveform base',					'https://twitter.com/gedehari',			'FF9300'			],
			['iFlicky',				'iflicky',			'Delay/Combo Menu Song Composer\nand Dialogue Sounds',	'https://twitter.com/flicky_i',			'C549DB'			],
			['PolybiusProxy',		'polybiusproxy',	'.MP4 Video Loader Extension',							'https://twitter.com/polybiusproxy',	'FFEAA6'			],
			['Keoiki',				'keoiki',			'Note Splash Animations',								'https://twitter.com/Keoiki_',			'FFFFFF'			],
			[''],			
			["Funkin' Crew"],			
			['ninjamuffin99',		'ninjamuffin99',	"Programmer of Friday Night Funkin'",					'https://twitter.com/ninja_muffin99',	'F73838'			],
			['PhantomArcade',		'phantomarcade',	"Animator of Friday Night Funkin'",						'https://twitter.com/PhantomArcade3K',	'FFBB1B'			],
			['evilsk8r',			'evilsk8r',			"Artist of Friday Night Funkin'",						'https://twitter.com/evilsk8r',			'53E52C'			],
			['kawaisprite',			'kawaisprite',		"Composer of Friday Night Funkin'",						'https://twitter.com/kawaisprite',		'6475F3'			]
		];
		
		for(i in pisspoop){
			creditsStuff.push(i);
		}
	
		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(0, 70 * i, creditsStuff[i][0], !isSelectable, false);
			optionText.isMenuItem = true;
			optionText.screenCenter(X);
			optionText.yAdd -= 70;
			if(isSelectable) {
				optionText.x -= 70;
			}
			optionText.forceX = optionText.x;
			//optionText.yMult = 90;
			optionText.targetY = i;
			grpOptions.add(optionText);

			if(isSelectable) {
				if(creditsStuff[i][5] != null)
				{
					Paths.currentModDirectory = creditsStuff[i][5];
				}

				var icon:AttachedSprite = new AttachedSprite('credits/' + creditsStuff[i][1]);
				icon.xAdd = optionText.width + 10;
				icon.sprTracker = optionText;
	
				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
				Paths.currentModDirectory = '';

				if(curSelected == -1) curSelected = i;
			}
		}

		descText = new FlxText(50, 600, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);

		changeSelection();
		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.BACK)
		{
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}
		if(controls.ACCEPT) {
			CoolUtil.browserLoad(creditsStuff[curSelected][3]);
		}
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
				}
			}
		}
		descText.text = creditsStuff[curSelected][2];
	}

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}
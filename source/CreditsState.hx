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
import lime.utils.Assets;

using StringTools;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = 1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];

	private static var creditsStuff:Array<Dynamic> = [ //Name - Icon name - Description - Link - BG Color
		['Equipo Chilensis'],
		['Sulayre', 'sulayre', 'Director, Código, Artista', 'https://twitter.com/Sulayre', 0xFF395FD2],
		['Beezy', 'beezy', 'Artista', 'https://www.twitter.com/BeezyLoove', 0xFF395FD2],
		['srPerez', 'perez', 'Código', 'https://twitter.com/NewSrPerez', 0xFF395FD2],
		['FlameMind', 'flame', 'Reggaeton de Shaggy', 'https://twitter.com/flamemind10', 0xFF395FD2],
		['JvrZV', 'pat', 'Ayuda con el arte', 'https://twitter.com/zavidraws', 0xFF395FD2],
		['Mozaico', 'mozaico', 'Artista, Voz de Maavo, Código', 'https://www.youtube.com/c/MaavoTheHuman/', 0xFF395FD2],
		['Joan Atlas', 'tono', 'Canción de Matt', 'https://twitter.com/joan_atlas', 0xFF395FD2],
		['Pointy', 'pointy', 'Voz de Matt, Artista, Charter', 'https://twitter.com/fnfAC_D', 0xFF395FD2],
		['Shyrell', 'shy', 'Voz de Girlfriend, Artista', 'https://twitter.com/shy_squishy', 0xFF395FD2],
		['GenoX', 'genox', 'Vocales de Consentida, Canción Asereje', 'https://twitter.com/GenoXACT2', 0xFF395FD2],
		['Surfe', 'surfe', 'Fondo del menú', 'https://twitter.com/SurfeBit', 0xFF395FD2],
		['Ebola', 'ebola', 'Es bakan', 'https://twitter.com/EbolaHorny', 0xFF395FD2],
		['Miki', 'miki', 'Voz de Ivette', '', 0xFF395FD2],
		['Anónima', 'anon', 'Voz de Maritza', 'https://cdn.discordapp.com/emojis/871518994476195840.gif?v=1', 0xFF395FD2],
		['Maty', 'maty', 'Ayuda con sprites de Matt', 'https://twitter.com/SoM4ty', 0xFF395FD2],
		['Juanca Draws', 'juanca', 'Cutscenes', 'https://twitter.com/JuancaDraws', 0xFF395FD2],
		['Neits', 'netis', 'Portraits de los diálogos', 'https://twitter.com/Nebits_art', 0xFF395FD2],
		['Tidal', 'tidal', 'Artista de sprites de Shaggy, Ayuda con el arte', 'https://twitter.com/tiidall', 0xFF395FD2],
		['Bastiano', 'bastiano', 'Ayuda con el escenario', 'https://twitter.com/AliveBastiano', 0xFF395FD2],
		['SODAFIZZIN', 'sodafizzin', 'Outline del diálogo', 'https://twitter.com/SODAFLZZIN', 0xFF395FD2],
		['Expandongus', 'expandongus', 'kek', 'https://twitter.com/expanded_dongus', 0xFF395FD2],
		['Wach', 'wach', 'Voz de Shaggy, Escritor de diálogos', 'https://media.discordapp.net/attachments/853518667270979606/883515823791149066/image0.gif', 0xFF395FD2],
		[''],
		['Psíquico Motor Equipo'],
		['Shadow Mario',		'shadowmario',		'Programador principal de Psych Engine',					'https://twitter.com/Shadow_Mario_',	0xFFFFDD33],
		['RiverOaken',			'riveroaken',		'Artista y animador principal de Psych Engine',				'https://twitter.com/river_oaken',		0xFFC30085],
		[''],
		['Gracias especiales'],
		['Keoiki',				'keoiki',			'Animaciones de los Note Splash',							'https://twitter.com/Keoiki_',			0xFFFFFFFF],
		[''],
		["Los que hicieron el Funkin'"],
		['ninjamuffin99',		'ninjamuffin99',	"Programador del Friday Night Funkin'",				'https://twitter.com/ninja_muffin99',	0xFFF73838],
		['PhantomArcade',		'phantomarcade',	"Animador del Friday Night Funkin'",					'https://twitter.com/PhantomArcade3K',	0xFFFFBB1B],
		['evilsk8r',			'evilsk8r',			"Artista del Friday Night Funkin'",					'https://twitter.com/evilsk8r',			0xFF53E52C],
		['kawaisprite',			'kawaisprite',		"Compositor del Friday Night Funkin'",					'https://twitter.com/kawaisprite',		0xFF6475F3]
	];

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

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		add(bg);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(0, 70 * i, creditsStuff[i][0], !isSelectable, false);
			optionText.isMenuItem = true;
			optionText.screenCenter(X);
			if(isSelectable) {
				optionText.x -= 70;
			}
			optionText.forceX = optionText.x;
			//optionText.yMult = 90;
			optionText.targetY = i;
			grpOptions.add(optionText);

			if(isSelectable) {
				var icon:AttachedSprite = new AttachedSprite('credits/' + creditsStuff[i][1]);
				icon.xAdd = optionText.width + 10;
				icon.sprTracker = optionText;
	
				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
			}
		}

		descText = new FlxText(50, 600, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);

		bg.color = creditsStuff[curSelected][4];
		intendedColor = bg.color;
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

		var newColor:Int = creditsStuff[curSelected][4];
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

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

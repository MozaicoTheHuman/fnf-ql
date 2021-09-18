package;

import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxSubState;

using StringTools;

// TO DO: Clean code? Maybe? idk
class DialogueBoxPsych extends FlxSpriteGroup
{
	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	public var finishThing:Void->Void;
	public var nextDialogueThing:Void->Void = null;
	var bgFade:FlxSprite = null;
	var box:FlxSprite;
	var textToType:String = '';

	var arrayCharacters:Array<FlxSprite> = [];
	var arrayStartPos:Array<Float> = []; //For 'center', it works as the starting Y, for everything else it works as starting X
	var arrayPosition:Array<Int> = [];

	var currentText:Int = 1;
	var offsetPos:Float = -600;

	var textBoxTypes:Array<String> = ['normal', 'angry'];
	var charPositionList:Array<String> = ['left', 'center', 'right'];

	var xOff:Int = 0;
	var yOff:Int = 0;
	var xSize:Float = 1;

	// This is where you add your characters, ez pz
	function addCharacter(char:FlxSprite, name:String) {
		xOff = -170;
		yOff = -40;
		xSize = 0.6;
		switch(name) {
			case 'bf':
				char.frames = Paths.getSparrowAtlas('dialogue/BF_Dialogue');
				char.animation.addByPrefix('talkIdle', 'BFTalk', 24, true); //Dialogue ended
				char.animation.addByPrefix('talk', 'bftalkloop', 24, true); //During dialogue
				char.flipX = !char.flipX;
				xOff = 0;
				yOff = 0;
				xSize = 1;
			case 'gf':
				char.frames = Paths.getSparrowAtlas('dialogue/GF_Dialogue');
				char.animation.addByPrefix('talkIdle', 'gfIdle', 24, true); //Dialogue ended
				char.animation.addByPrefix('talk', 'gf', 24, true); //During dialogue
				xOff = -60;
				yOff = 30;
				xSize = 0.3;
				char.flipX = true;
			case 'dearest':
				char.frames = Paths.getSparrowAtlas('dialogue/Papito_Dialogue');
				char.animation.addByPrefix('talkIdle', 'papaFeliIdle', 24, true); //Dialogue ended
				char.animation.addByPrefix('talk', 'papaFeli', 24, true); //During dialogue
				char.animation.addByPrefix('angryIdle', 'papaEnojaoIdle', 24, true); //Dialogue ended
				char.animation.addByPrefix('angry', 'papaEnojao', 24, true); //During dialogue
				xSize = 1.5;
				xOff = -170;
				yOff = 40;

			case 'ivette':
				char.frames = Paths.getSparrowAtlas('dialogue/Ivette_Dialogue');
				char.animation.addByPrefix('angryIdle', 'ivetteAngryIdle', 24, true); //Dialogue ended
				char.animation.addByPrefix('angry', 'ivetteAngry', 24, true); //During dialogue
				char.animation.addByPrefix('talkIdle', 'ivetteNormalIdle', 24, true); //Dialogue ended
				char.animation.addByPrefix('talk', 'ivetteNormal', 24, true); //During dialogue
				yOff += 20;

			case 'maavo':
				char.frames = Paths.getSparrowAtlas('dialogue/Maavo_Dialogue');
				char.animation.addByPrefix('scaredIdle', 'MavoScaredIdle0', 24, true); //Dialogue ended
				char.animation.addByPrefix('scared', 'MavoScared0', 24, true); //During dialogue
				char.animation.addByPrefix('talkIdle', 'MavoIdle0', 24, true); //Dialogue ended
				char.animation.addByPrefix('talk', 'Mavo0', 24, true); //During dialogue
				char.animation.addByPrefix('whatIdle', 'MavoWhatIdle0', 24, true); //Dialogue ended
				char.animation.addByPrefix('what', 'MavoWhat0', 24, true); //During dialogue

			case 'maritza':
				char.frames = Paths.getSparrowAtlas('dialogue/Maritza_Dialogue');
				char.animation.addByPrefix('confidentIdle', 'maritzaConfidentIdle', 24, true); //Dialogue ended
				char.animation.addByPrefix('confident', 'maritzaConfident', 24, true); //During dialogue
				char.animation.addByPrefix('talkIdle', 'maritzaNormalIdle', 24, true); //Dialogue ended
				char.animation.addByPrefix('talk', 'maritzaNormal', 24, true); //During dialogue
				char.animation.addByPrefix('whatIdle', 'maritzaWhatIdle', 24, true); //Dialogue ended
				char.animation.addByPrefix('what', 'maritzaWhat', 24, true); //During dialogue
				char.animation.addByPrefix('happyIdle', 'maritzaHappyIdle', 24, true); //Dialogue ended
				char.animation.addByPrefix('happy', 'maritzaHappy', 24, true); //During dialogue
				char.animation.addByPrefix('funnyIdle', 'maritzaFunny', 24, true); //Dialogue ended
				char.animation.addByPrefix('funny', 'maritzaFunny', 24, true); //During dialogue
				xSize = 0.3;

			case 'shaggy':
				char.frames = Paths.getSparrowAtlas('dialogue/Shaggy_Dialogue');
				char.animation.addByPrefix('sadIdle', 'ShaggSadIdle', 24, true); //Dialogue ended
				char.animation.addByPrefix('sad', 'ShaggSad', 24, true); //During dialogue
				char.animation.addByPrefix('talkIdle', 'ShaggNormalIdle', 24, true); //Dialogue ended
				char.animation.addByPrefix('talk', 'ShaggNormal', 24, true); //During dialogue
				char.animation.addByPrefix('happyIdle', 'ShaggHappyIdle', 24, true); //Dialogue ended
				char.animation.addByPrefix('happy', 'ShaggHappy', 24, true); //During dialogue
				char.animation.addByPrefix('funnyIdle', 'ShaggFunny', 24, true); //Dialogue ended
				char.animation.addByPrefix('funny', 'ShaggFunny', 24, true); //During dialogue
				xSize = 0.4;
				yOff += 80;

			case 'scooby':
				char.frames = Paths.getSparrowAtlas('dialogue/ScoobyDou_Dialogue');
				char.animation.addByPrefix('talkIdle', 'ScoobyIdle0', 24, true); //Dialogue ended
				char.animation.addByPrefix('talk', 'Scooby0', 24, true); //During dialogue
				char.animation.addByPrefix('alertIdle', 'ScoobyAlertIdle0', 24, true); //Dialogue ended
				char.animation.addByPrefix('alert', 'ScoobyAlert0', 24, true); //During dialogue
				char.animation.addByPrefix('happyIdle', 'ScoobyHappyIdle0', 24, true); //Dialogue ended
				char.animation.addByPrefix('happy', 'ScoobyHappy0', 24, true); //During dialogue
				char.animation.addByPrefix('hungryIdle', 'ScoobyHungryIdle0', 24, true); //Dialogue ended
				char.animation.addByPrefix('hungry', 'ScoobyHungry0', 24, true); //During dialogue
				xSize = 0.4;
				yOff += 20;

			case 'matt':
				char.frames = Paths.getSparrowAtlas('dialogue/Matt_Dialogue');
				char.animation.addByPrefix('talkIdle', 'mattNormalIdle0', 24, true); //Dialogue ended
				char.animation.addByPrefix('talk', 'mattNormal0', 24, true); //During dialogue
				char.animation.addByPrefix('angryIdle', 'mattAngryIdle0', 24, true); //Dialogue ended
				char.animation.addByPrefix('angry', 'mattAngry0', 24, true); //During dialogue
				char.animation.addByPrefix('rageIdle', 'mattENPUTADOIdle0', 24, true); //Dialogue ended
				char.animation.addByPrefix('rage', 'mattENPUTADO0', 24, true); //During dialogue
				char.animation.addByPrefix('happyIdle', 'mattHappyIdle0', 24, true); //Dialogue ended
				char.animation.addByPrefix('happy', 'mattHappy0', 24, true); //During dialogue
				char.animation.addByPrefix('whatIdle', 'mattWhatIdle0', 24, true); //Dialogue ended
				char.animation.addByPrefix('what', 'mattWhat0', 24, true); //During dialogue
				xSize = 0.26;
		}
		char.animation.play('talkIdle', true);
	}


	var voiceInd = 0;
	var voiceFolder = '1maritza';
	var cutFolder = 'cutscene_1';

	var cutSprite:FlxSprite;
	public function new(?dialogueList:Array<String>, song:String)
	{
		super();

		if(song != null && song != '') {
			FlxG.sound.playMusic(Paths.music(song), 0);
			FlxG.sound.music.fadeIn(2, 0, 1);
		}
		var prop = CoolUtil.coolTextFile(Paths.txt(PlayState.SONG.song.toLowerCase() + '/prop'));
		voiceFolder = prop[0];
		cutFolder = prop[1];

		bgFade = new FlxSprite(-500, -500).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.WHITE);
		bgFade.scrollFactor.set();
		bgFade.visible = true;
		bgFade.alpha = 0;
		//add(bgFade);
		cutSprite = new FlxSprite(0, 0).makeGraphic(100, 100);//.loadGraphic(Paths.image('cutscenes/' + cutFolder + '/' + cutImages[0]));
		cutSprite.scrollFactor.set();
		cutSprite.alpha = 0;
		add(cutSprite);

		this.dialogueList = dialogueList;
		spawnCharacters(dialogueList[0].split(" "));

		box = new FlxSprite(70, 370);
		box.frames = Paths.getSparrowAtlas('speech_bubble');
		box.scrollFactor.set();
		box.antialiasing = ClientPrefs.globalAntialiasing;
		box.animation.addByPrefix('normal', 'speech bubble normal', 24);
		box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
		box.animation.addByPrefix('angry', 'AHH speech bubble', 24);
		box.animation.addByPrefix('angryOpen', 'speech bubble loud open', 24, false);
		box.animation.addByPrefix('center-normal', 'speech bubble middle', 24);
		box.animation.addByPrefix('center-normalOpen', 'Speech Bubble Middle Open', 24, false);
		box.animation.addByPrefix('center-angry', 'AHH Speech Bubble middle', 24);
		box.animation.addByPrefix('center-angryOpen', 'speech bubble Middle loud open', 24, false);
		box.visible = false;
		box.setGraphicSize(Std.int(box.width * 0.9));
		box.updateHitbox();
		add(box);

		startNextDialog();
	}

	var dialogueStarted:Bool = false;
	var dialogueEnded:Bool = false;

	function spawnCharacters(splitSpace:Array<String>) {
		for (i in 0...splitSpace.length) {
			var splitName:Array<String> = splitSpace[i].split(":");
			var y:Float = 180;
			var x:Float = 50;
			var char:FlxSprite = new FlxSprite(x, y);
			char.x += offsetPos;
			addCharacter(char, splitName[0]);
			
			char.setGraphicSize(Std.int(char.width * 0.7 * xSize));
			char.updateHitbox();
			char.centerOffsets();
			char.offset.x += xOff;
			char.offset.y += yOff;
			char.antialiasing = ClientPrefs.globalAntialiasing;
			char.scrollFactor.set();
			char.alpha = 0;
			add(char);

			var saveY:Bool = false;
			var pos:Int = 0;
			switch(splitName[1]) {
				case 'center':
					pos = 1;
					char.x = FlxG.width / 2;
					char.x -= char.width / 2;
					y = char.y;
					char.y = FlxG.height + 50;
					saveY = true;
				case 'right':
					pos = 2;
					char.flipX = !char.flipX;
					x = FlxG.width - char.width - 100;
					char.x = x - offsetPos;
			}
			arrayCharacters.push(char);
			arrayStartPos.push(saveY ? y : x);
			arrayPosition.push(pos);
		}
	}

	var textX = 90;
	var textY = 420;
	var scrollSpeed = 4500;
	var daText:Alphabet = null;

	override function update(elapsed:Float)
	{
		if(!dialogueEnded) {
			bgFade.alpha += 0.5 * elapsed;
			if(bgFade.alpha > 0.5) bgFade.alpha = 0.5;

			if(FlxG.keys.justPressed.ANY) {
				if(!daText.finishedText) {
					if(daText != null) {
						daText.killTheTimer();
						remove(daText);
					}
					daText = new Alphabet(0, 0, textToType, false, true, 0.0, 0.7);
					daText.x = textX;
					daText.y = textY;
					add(daText);
				} else if(currentText >= dialogueList.length) {
					dialogueEnded = true;
					for (i in 0...textBoxTypes.length) {
						var checkArray:Array<String> = ['', 'center-'];
						var animName:String = box.animation.curAnim.name;
						for (j in 0...checkArray.length) {
							if(animName == checkArray[j] + textBoxTypes[i] || animName == checkArray[j] + textBoxTypes[i] + 'Open') {
								box.animation.play(checkArray[j] + textBoxTypes[i] + 'Open', true);
							}
						}
					}

					box.animation.curAnim.curFrame = box.animation.curAnim.frames.length - 1;
					box.animation.curAnim.reverse();
					remove(daText);
					daText = null;
					updateBoxOffsets();
					FlxG.sound.music.fadeOut(1, 0);
				} else {
					startNextDialog();
				}
				FlxG.sound.play(Paths.sound('dialogueClose'));
			} else if(daText.finishedText) {
				var char:FlxSprite = arrayCharacters[lastCharacter];
				if(char != null && !char.animation.curAnim.name.endsWith('Idle') && char.animation.curAnim.curFrame >= char.animation.curAnim.frames.length - 1) {
					char.animation.play(char.animation.curAnim.name + 'Idle');
				}
			}

			if(box.animation.curAnim.finished) {
				for (i in 0...textBoxTypes.length) {
					var checkArray:Array<String> = ['', 'center-'];
					var animName:String = box.animation.curAnim.name;
					for (j in 0...checkArray.length) {
						if(animName == checkArray[j] + textBoxTypes[i] || animName == checkArray[j] + textBoxTypes[i] + 'Open') {
							box.animation.play(checkArray[j] + textBoxTypes[i], true);
						}
					}
				}
				updateBoxOffsets();
			}

			if(lastCharacter != -1 && arrayCharacters.length > 0) {
				for (i in 0...arrayCharacters.length) {
					var char = arrayCharacters[i];
					if(char != null) {
						if(i != lastCharacter) {
							switch(charPositionList[arrayPosition[i]]) {
								case 'left':
									char.x -= scrollSpeed * elapsed;
									if(char.x < arrayStartPos[i] + offsetPos) char.x = arrayStartPos[i] + offsetPos;
								case 'center':
									char.y += scrollSpeed * elapsed;
									if(char.y > FlxG.height + 50) char.y = FlxG.height + 50;
								case 'right':
									char.x += scrollSpeed * elapsed;
									if(char.x > arrayStartPos[i] - offsetPos) char.x = arrayStartPos[i] - offsetPos;
							}
							char.alpha -= 3 * elapsed;
							if(char.alpha < 0) char.alpha = 0;
						} else {
							switch(charPositionList[arrayPosition[i]]) {
								case 'left':
									char.x += scrollSpeed * elapsed;
									if(char.x > arrayStartPos[i]) char.x = arrayStartPos[i];
								case 'center':
									char.y -= scrollSpeed * elapsed;
									if(char.y < arrayStartPos[i]) char.y = arrayStartPos[i];
								case 'right':
									char.x -= scrollSpeed * elapsed;
									if(char.x < arrayStartPos[i]) char.x = arrayStartPos[i];
							}
							char.alpha += 3 * elapsed;
							if(char.alpha > 1) char.alpha = 1;
						}
					}
				}
			}
		} else { //Dialogue ending
			if(box != null && box.animation.curAnim.curFrame <= 0) {
				remove(box);
				box = null;
			}

			if(bgFade != null) {
				bgFade.alpha -= 0.5 * elapsed;
				if(bgFade.alpha <= 0) {
					remove(bgFade);
					bgFade = null;
				}
			}
			if (cutSprite != null)
			{
				cutSprite.alpha -= 1.3 * elapsed;
				if (cutSprite.alpha <= 0)
				{
					remove(cutSprite);
					cutSprite = null;
				}
			}

			for (i in 0...arrayCharacters.length) {
				var leChar:FlxSprite = arrayCharacters[i];
				if(leChar != null) {
					leChar.x += scrollSpeed * (i == 1 ? 1 : -1) * elapsed;
					leChar.alpha -= elapsed * 10;
				}
			}

			if(box == null && bgFade == null) {
				for (i in 0...arrayCharacters.length) {
					var leChar:FlxSprite = arrayCharacters[0];
					if(leChar != null) {
						arrayCharacters.remove(leChar);
						remove(leChar);
					}
				}
				finishThing();
				kill();
			}
		}
		super.update(elapsed);
	}

	var lastCharacter:Int = -1;
	var lastBoxType:String = '';
	var voicePlaying:FlxSound = new FlxSound().loadEmbedded(Paths.sound('dialogos/1maritza/1'));
	function startNextDialog():Void
	{
		var splitName:Array<String> = dialogueList[currentText].split(":");
		var character:Int = Std.parseInt(splitName[1]);
		var speed:Float = Std.parseFloat(splitName[3]);
		var vc = currentText + 0;
		var vcSound:String = 'dialogos/' + voiceFolder + '/' + vc;

		var animName:String = splitName[4];
		var boxType:String = textBoxTypes[0];
		for (i in 0...textBoxTypes.length) {
			if(textBoxTypes[i] == animName) {
				boxType = animName;
			}
		}

		textToType = splitName[5];
		//FlxG.log.add(textToType);
		box.visible = true;

		var centerPrefix:String = '';
		if(charPositionList[arrayPosition[character]] == 'center') centerPrefix = 'center-';

		if(character != lastCharacter) {
			box.animation.play(centerPrefix + boxType + 'Open', true);
			updateBoxOffsets();
			box.flipX = (charPositionList[arrayPosition[character]] == 'left');
		} else if(boxType != lastBoxType) {
			box.animation.play(centerPrefix + boxType, true);
			updateBoxOffsets();
		}
		lastCharacter = character;
		lastBoxType = boxType;

		if(daText != null) {
			daText.killTheTimer();
			remove(daText);
		}
		daText = new Alphabet(textX, textY, textToType, false, true, speed, 0.7);
		add(daText);

		cutSprite.loadGraphic(Paths.image('cutscenes/' + cutFolder + '/' + splitName[6]));
		cutSprite.setGraphicSize(FlxG.width);
		cutSprite.updateHitbox();
		cutSprite.screenCenter(X);
		cutSprite.screenCenter(Y);
		cutSprite.alpha = 1;

		var char:FlxSprite = arrayCharacters[character];
		if(char != null) {
			char.animation.play(splitName[2], true);
			var rate:Float = 24 - (((speed - 0.05) / 5) * 480);
			if(rate < 12) rate = 12;
			else if(rate > 48) rate = 48;
			char.animation.curAnim.frameRate = rate;
		}
		currentText++;

		voicePlaying.stop();
		voicePlaying.loadEmbedded(Paths.sound(vcSound));
		voicePlaying.play();

		if(nextDialogueThing != null) {
			nextDialogueThing();
		}
	}

	function updateBoxOffsets() {
		box.centerOffsets();
		box.updateHitbox();
		if(box.animation.curAnim.name.startsWith('angry')) {
			box.offset.set(50, 65);
		} else if(box.animation.curAnim.name.startsWith('center-angry')) {
			box.offset.set(50, 30);
		} else {
			box.offset.set(10, 0);
		}
		
		if(!box.flipX) box.offset.y += 10;
	}
}

package playframe.helpers;

/**
 * thanks fnf devs .
 */
class BeatManager
{
	var bpm:Float;
	var beatInterval:Float;

	var beatFunction:Void -> Void;

	public var curBeat:Int = 0;
	public var curStep:Int = 0;

	public var crochet:Float = 0; // beats in milliseconds
	public var stepCrochet:Float = 0; // steps in milliseconds

	public var songPosition:Float;
	var lastSongPosition:Float = 0;

	public var totalBeats:Int = 0;
	public var lastBeat:Float = 0;

	public var totalSteps:Int = 0;
	public var lastStep:Float = 0;

	public static var safeFrames:Int = 10;
	public static var safeZoneOffset:Float = (safeFrames / 60) * 1000; // is calculated in create(), is safeFrames in milliseconds

	public static var globalCurBeat:Int = 0;
	
	public function new(newbpm:Float, newBeatFunction:Void -> Void)
	{
		bpm = newbpm; 
		beatFunction = newBeatFunction;

		crochet = ((60 / bpm) * 1000);
		stepCrochet = crochet / 4;

		initialize();

		newBeatFunction();
	}

	function initialize():Void{
		beatInterval = 60 / bpm;
		curBeat = 0;
	}

	public function update(elapsed:Float):Void{
		//if(FlxG.sound.music == null) return; //oh no

		lastSongPosition = songPosition;
		songPosition = FlxG.sound.music.time;

		if(songPosition < lastSongPosition){
			lastBeat = 0;
			lastStep = 0;
		}

		updateCurStep();

		everyStep();

		curBeat = Math.round(curStep / 4);

		BeatManager.globalCurBeat = curBeat;
	}

	private function everyStep():Void
	{
		if (songPosition > lastStep + stepCrochet - safeZoneOffset || songPosition < lastStep + safeZoneOffset)
		{
			if (songPosition > lastStep + stepCrochet)
			{
				stepHit();
			}
		}
	}

	private function updateCurStep():Void
	{
		curStep = Math.floor(songPosition / stepCrochet);
	}

	public function stepHit():Void
	{
		totalSteps += 1;
		lastStep += stepCrochet;

		if (totalSteps % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		lastBeat += crochet;
		totalBeats += 1;
		beatFunction();
	}
}
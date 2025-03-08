package playframe.helpers;

/**
 * A class that has basic functions that makes other code easier to write. - Coma
 */
class Utilities
{
	public static var randomshit:Map<String, Dynamic> = [];

	public static function dataFromTextFile(path:String):Array<String>
	{
		var daList:Array<String> = [];

		if (FileSystem.exists(path))
			daList = File.getContent(path).split('\n');

		return daList;
	}

	public static function clamp(value:Float, min:Float, max:Float):Float
	{
		return value < min ? min : (value > max ? max : value);
	}

	public static function invertAboveZero(value:Float):Float
	{
		if (value > 0)
		{
			return 0;
		}
		else
		{
			return Math.abs(value);
		}
	}

	public static function getListFromArray(array:Array<String>):Array<String>{
		var returnThis = [];

		var data = array;

		for (i in 0...data.length)
		{
			var stuff:Array<String> = data[i].split(":");

			returnThis.push(stuff[0]);
		}

		return returnThis;
	}

	public static function grabThingFromText(thingtoget:String, filename:String, theonetosend:Int):String
	{
		var data = Utilities.dataFromTextFile(filename);
		var thingToSend:String = '';

		for (i in 0...data.length)
		{
			var stuff:Array<String> = data[i].split(":");
			if (stuff[0] == thingtoget)
			{
				thingToSend = stuff[theonetosend];
			}
		}

		return thingToSend;
	}

	public static function findFilesInPath(path:String, extns:Array<String>, ?filePath:Bool = false, ?deepSearch:Bool = true):Array<String>
	{
		var files:Array<String> = [];

		if (FileSystem.exists(path))
		{
			for (file in FileSystem.readDirectory(path))
			{
				var path = haxe.io.Path.join([path, file]);
				if (!FileSystem.isDirectory(path))
				{
					for (extn in extns)
					{
						if (file.endsWith(extn))
						{
							if (filePath)
								files.push(path);
							else
								files.push(file);
						}
					}
				}
				else if (deepSearch) // ! YAY !!!! -lunar
				{
					var pathsFiles:Array<String> = findFilesInPath(path, extns, deepSearch);

					for (_ in pathsFiles)
						files.push(_);
				}
			}
		}
		return files;
	}
	
	public static function invertNum(num:Int):Int{
		if(num == 1) num = 0; else num = 1;
		return num;
	}

	public static function boundTo(value:Float, min:Float, max:Float):Float
	{
		var newValue:Float = value;
		if (newValue < min)
			newValue = min;
		else if (newValue > max)
			newValue = max;
		return newValue;
	}

	public static function isSpriteOnScreen(sprite:FlxSprite):Bool {
		var screenLeft:Float = 0;
		var screenRight:Float = FlxG.width;

		return sprite.x + sprite.width > screenLeft && sprite.x < screenRight;
	}

	public static function formatMillisecondsToMinutesSeconds(milliseconds:Int):String
	{
		// Convert milliseconds to seconds
		var totalSeconds:Float = milliseconds / 1000.0;

		// Calculate minutes and seconds
		var minutes:Int = Std.int(totalSeconds / 60);
		var seconds:Int = Std.int(totalSeconds % 60);

		// Format into "minutes:seconds"
		return '$minutes:${(seconds < 10 ? '0' : '')}$seconds';
	}

	public static function formatMilliseconds(milliseconds:Float):String
	{
		milliseconds *= 1000;

		var seconds:Int = Std.int(milliseconds / 1000);
		var minutes:Int = Std.int(seconds / 60);
		var hours:Int = Std.int(minutes / 60);

		seconds %= 60;
		minutes %= 60;

		var returnthis = '';

		if(hours == 0 && minutes == 0 && seconds == 0){
			returnthis = 'No playtime..?';
		} else if(hours == 0 && minutes != 0){
			returnthis = minutes + ' minutes, ' + seconds + ' seconds of playtime';
		} else if(hours == 0 && minutes == 0){
			returnthis = seconds + ' seconds of playtime';
		} else {
			returnthis = hours + ' hours, ' + minutes + ' minutes, ' + seconds + ' seconds of playtime';
		}

		return returnthis;
	}

	public static function renderFlxCameraToBitmapData(camera:FlxCamera):BitmapData { // thanks detective_baldi
		var bitmapData:BitmapData = new BitmapData(camera.width, camera.height);
		bitmapData.draw(camera.canvas, null, null, null, null, false);

		return bitmapData;
	}

	public static function stringToArray(text:String):Array<String>{
		var thing = new StringIteratorUnicode(text);

		var returnthis:Array<String> = [];

		for (i in thing)
		{
			returnthis.push(String.fromCharCode(i));
		}

		return returnthis;
	}

	public static function lerpThing(initialnum:Float, target:Float, elapsed:Float, speed:Float = 15):Float
	{
		return FlxMath.lerp(target, initialnum, Utilities.boundTo(1 - (elapsed * speed), 0, 1));
	}

	public static function centerGroup(group:FlxTypedGroup<Dynamic>, ?array:Array<FlxSprite>, spacing:Float, ?xpos:Float):Void{
		if(xpos == null){
			xpos = FlxG.width / 2;
		}

		var centerX:Float = xpos;

		var members:Array<Dynamic> = [];

		if (array != null){
			members = array;
		} else {
			members = group.members;
		}

		var count:Int = members.length;
		if (count == 0)
			return;

		// Calculate the total width of all sprites including spacing
		var totalWidth:Float = 0;

		for (i in members)
		{
			totalWidth += i.width;
			totalWidth += spacing;
		}
		// Start positioning from the leftmost point
		var startX:Float = centerX - totalWidth / 2;

		var thex = startX;

		for (i in 0...count)
		{
			var sprite = members[i];
			sprite.x = thex + (spacing);
			thex = sprite.x + sprite.width;
		}
	}

	public static function gradientText(nametext:FlxText, color1:FlxColor, color2:FlxColor):Void{
		var textseperated:Array<String> = Utilities.stringToArray(nametext.text);
		var realtext:String = '';

		var realseperated:Array<String> = [];

		var usethese:Array<String> = ['"', "!", "[", "]", "(", ")", "-", ".", "'", "&"];

		for(i in textseperated){
			//if (FileSystem.exists(Paths.image('results/letters/' + i, 'battle')) || usethese.contains(i)){ //isnt a space
			//	realseperated.push(Std.string(i));
			//} else {
			//	realseperated.push('space');
			//}
		}

		var tempcolors = FlxColor.gradient(color1, color2, realseperated.length);

		var increment:Int = 0;
		var colorincrement:Int = 0;

		var rules:Array<FlxTextFormatMarkerPair> = [];

		for(i in realseperated){
			if(i == 'space'){
				realtext += ' ';
			} else {
				realtext += ('%' + increment + '$' + Std.string(i) + '%' + increment + '$');
				rules.push(new FlxTextFormatMarkerPair(new FlxTextFormat(tempcolors[colorincrement]), '%' + increment + '$'));
				colorincrement ++;
			} 

			increment ++;
		}

		nametext.text = realtext;
		nametext.applyMarkup(realtext, rules);
	}

	public static function centerSpriteOnSprite(sprite1:FlxSprite, sprite2:FlxSprite, x:Bool, y:Bool):Void{
		if(x){
			sprite1.x = sprite2.x + sprite2.width / 2 - sprite1.width / 2;
		}

		if(y){
			sprite1.y = sprite2.y + sprite2.height / 2 - sprite1.height / 2;
		}
	}

	public static function centerSpriteOnPos(sprite1:FlxSprite, ?x:Float, ?y:Float):Void
	{
		if (x != null)
		{
			sprite1.x = x - sprite1.width / 2;
		}

		if (y != null)
		{
			sprite1.y = y - sprite1.height / 2;
		}
	}

	public static function freeMemory():Void{
		FlxG.bitmap.dumpCache();
		FlxG.bitmap.clearCache();
		FlxG.bitmap.clearUnused();
		Assets.cache.clear(); //OCRPG IS SAVED UNIRONICALLY 1/27/2025
		freeUnusedMemory();
	}

	public static function freeUnusedMemory():Void{
		System.gc();
	}

	public static function isMultipleWords(str: String):Bool {
   	 	return str.split(" ").length > 1;
	}
	
	public static function invertValue(x:Float):Float {
		if(x == 0) return 0;
		
		return x >= 0 ? (2 - x) : (2 + Math.abs(x));
	}
}
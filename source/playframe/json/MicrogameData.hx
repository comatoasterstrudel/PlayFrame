package playframe.json;

class MicrogameData
{
	var data:Dynamic;

	public var name:String = '';
	public var text:String = '';
	public var color:FlxColor = 0xFFFFFF;
	public var timer:Float = 1;
	public var author:String = '';

	public function new(dataname:String){
		data = Json.parse(File.getContent('assets/data/microgames/' + dataname + '.json'));

		name = data.name;
		text = data.text;
		color = FlxColor.fromRGB(data.color[0], data.color[1], data.color[2]);
		timer = data.timer;
		author = data.author;
    }
}
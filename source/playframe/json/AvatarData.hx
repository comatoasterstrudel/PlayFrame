package playframe.json;

class AvatarData
{
	var data:Dynamic;

	public var name:String = '';
	public var color:FlxColor = 0xFFFFFF;
	public var abilityText:String = '';
	
	public function new(dataname:String){
		data = Json.parse(File.getContent('assets/data/avatars/' + dataname + '.json'));

		name = data.name;
		color = FlxColor.fromRGB(data.color[0], data.color[1], data.color[2]);
		abilityText = data.abilityText;
    }
}
package playframe.menu.practice;

class SmallPracticeText extends FlxText
{
	var sprite:FlxSprite;
	
	public function new(name:String, sprite:FlxSprite)
	{
		super(x, y);
		this.sprite = sprite;
		text = name;
	}

	override function update(elapsed:Float)
	{
		x = sprite.x;
		y = sprite.y + sprite.height + 5;
		alpha = sprite.alpha;

		super.update(elapsed);
	}	
}
package playframe.game;

/**
 * the games namesake. this contains all of the gameplay for each player!!
 */
class PlayFrame extends FlxTypedGroup<FlxTypedGroup<FlxSprite>>
{
    /**
     * the camera the frame is displayed on!!
     */
    var frameCamera:FlxCamera;
    
    /**
     * how wide the frames should be
     */
    public static final frameWidth:Int = 900;
    
    /**
     * how wide the gaps between the top anbd bottom should be
     */
    public static final frameMargin:Int = 20;
     
    var thing2:FlxBackdrop;
    
    public function new(positionOffset:Float){
        super();
        
        frameCamera = new FlxCamera((FlxG.width / 2 - frameWidth / 2) + positionOffset, PlayState.scoreBgHeight + frameMargin, frameWidth, (FlxG.height - PlayState.scoreBgHeight) - (frameMargin * 2));
		frameCamera.bgColor = FlxColor.BLACK;
		FlxG.cameras.add(frameCamera, false);
        
        var thing = new FlxTypedGroup<FlxSprite>();
        add(thing);
        
        thing2 = new FlxBackdrop('assets/images/placeholder.png', XY, 0, 0);
        thing2.velocity.set(20, 20);
        thing.add(thing2);
    }
    
    public function updateSpeed():Void{
        thing2.velocity.set(20 * PlayState.additiveSpeed, 20 * PlayState.additiveSpeed);
    }
    
    override function add(basic:FlxTypedGroup<FlxSprite>):FlxTypedGroup<FlxSprite>{
        basic.camera = frameCamera;
        super.add(basic);
        return basic;
    }
} 
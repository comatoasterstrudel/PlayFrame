package playframe.game;

class GameOverSubstate extends FlxSubState
{
    var bg:FlxSprite;
    var text:FlxText;
    
    var theCam:FlxCamera;
    
    public function new (){
        super();
                
        theCam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		theCam.bgColor = FlxColor.TRANSPARENT;
		FlxG.cameras.add(theCam, false);
        
        var data = new AvatarData(PlayState.curAvatar);
        
        bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, data.color.getDarkened(.8));
        bg.alpha = 0;
        bg.camera = theCam;
        add(bg);
        
        text = new FlxText();
        text.setFormat('assets/fonts/Andy.ttf', 55, data.color.getLightened(.2), CENTER, FlxTextBorderStyle.SHADOW, data.color.getDarkened(.2));
		text.text = 'Final Score - ' + PlayState.curScore + '\nFinal Speed - x' + PlayState.finalSpeed + ' (' + PlayState.speedUps + (PlayState.speedUps == 1 ? ' speed up)\n\nLost Microgames:' : ' speed ups) \n\nLost Microgames:');
        for(i in PlayState.lostMicrogames){
            var data = new MicrogameData(i);
            text.text += '\n' + data.text;
        }
		text.screenCenter();
        text.alpha = 0;
        text.camera = theCam;
		add(text);
        
        fadeIn();
    }
    
    function fadeIn():Void{
        FlxTween.tween(bg, {alpha: .9}, 1.5, {ease: FlxEase.quartOut});
        FlxTween.tween(text, {alpha: 1}, 1.5, {ease: FlxEase.quartOut});      
    }
}
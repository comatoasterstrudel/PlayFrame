package playframe.game;

class GameOverSubstate extends FlxSubState
{
    var bg:FlxSprite;
    var text:FlxText;
    
    var theCam:FlxCamera;
    
    var char:FlxSprite;
    
    var textbox:Textbox;
    
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
        text.setFormat('assets/fonts/Andy.ttf', 45, data.color.getLightened(.2), CENTER, FlxTextBorderStyle.SHADOW, data.color.getDarkened(.2));
		text.text = 'Final Score - ' + PlayState.curScore + '\nFinal Speed - x' + PlayState.finalSpeed + ' (' + PlayState.speedUps + (PlayState.speedUps == 1 ? ' speed up)\n\nFailed Microgames:' : ' speed ups) \n\nFailed Microgames:');
        for(i in PlayState.lostMicrogames){
            var data = new MicrogameData(i);
            text.text += '\n' + data.text;
        }
		text.screenCenter();
        text.x -= 200;
        text.alpha = 0;
        text.camera = theCam;
		add(text);
        
        if(PlayState.curScore > SaveData.highscores.get(PlayState.curAvatar)){
            trace('New Highscore! ' + PlayState.curScore);  
            
            SaveData.highscores.set(PlayState.curAvatar, PlayState.curScore);
            SaveData.save();
            
            textbox = new Textbox(0, 0, {fontSize: 50, font: 'assets/fonts/andy.ttf', charactersPerSecond: 15});
            textbox.setText('@011001500@03331640ANEW  HIGHSCORE!!@010@030');
            textbox.bring();
            textbox.camera = theCam;
            add(textbox);
        }
            
        char = new FlxSprite().loadGraphic('assets/images/gameover/' + PlayState.curAvatar + '.png');
        char.setGraphicSize(Std.int(char.width * .8));
        char.updateHitbox();
        char.screenCenter();
        char.x += 300;
        char.y = FlxG.height;
        char.camera = theCam;
        add(char);

        var data = new AvatarData(PlayState.curAvatar);
        
        char.color = data.color;
        
        fadeIn();
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
        if(textbox != null){
            var sprs = [];
            
            textbox.forEachAlive(function(spr:FlxSprite):Void{
                spr.y = text.y - 100;
                sprs.push(spr);
            });
            Utilities.centerGroup(null, sprs, 10, text.x + text.width / 2);
        }
    }
    function fadeIn():Void{
        FlxTween.tween(bg, {alpha: .9}, 1.5, {ease: FlxEase.quartOut});
        FlxTween.tween(text, {alpha: 1}, 1.5, {ease: FlxEase.quartOut});      
        
        if(PlayState.curAvatar =='trifecta'){ //hang
            char.y = -char.height;
            FlxTween.tween(char, {y: 0}, 3, {startDelay: 2, ease: FlxEase.smootherStepInOut});       
        } else {
            FlxTween.tween(char, {y: FlxG.height / 2 - char.height / 2}, 1, {startDelay: .5, ease: FlxEase.quartOut});                  
        }
    }
}
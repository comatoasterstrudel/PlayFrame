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
        

        if(PlayState.curScore > SaveData.highscores.get(PlayState.curAvatar) && PlayState.practiceGame == ''){
            DiscordClient.changePresence('Game Over.. (New Highscore!)', null);

            trace('New Highscore! ' + PlayState.curScore);  
            
            SaveData.highscores.set(PlayState.curAvatar, PlayState.curScore);
            SaveData.save();
            
            textbox = new Textbox(0, 0, {fontSize: 50, font: 'assets/fonts/andy.ttf', charactersPerSecond: 15});
            textbox.setText('@011001500@03331640ANEW  HIGHSCORE!!@010@030');
            textbox.bring();
            textbox.camera = theCam;
            add(textbox);
        } else {
            DiscordClient.changePresence('Game Over..', null);
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
    
    var leavin:Bool = false;
    
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
        
        if(!leavin && Controls.getControl('ACCEPT', 'RELEASE') || !leavin && Controls.getControl('BACK', 'RELEASE')){
            leavin = true;
            var tran = new ShapeTransition('out', .5);
			tran.camera = theCam;
			add(tran);
						
			new FlxTimer().start(.5, function(tmr:FlxTimer){
				FlxG.switchState(new MainMenuState());
			});
        }
    }
    function fadeIn():Void{
        FlxTween.tween(bg, {alpha: .9}, 1.5, {ease: FlxEase.quartOut});
        FlxTween.tween(text, {alpha: 1}, 1.5, {ease: FlxEase.quartOut});      
        
        if(PlayState.curAvatar =='trifecta'){ //hang
            var og = char.x;
            
            char.y = FlxG.height - char.height;
            char.x = FlxG.width;
            FlxTween.tween(char, {x: og}, 3, {startDelay: 2, ease: FlxEase.smootherStepInOut});       
        } else {
            FlxTween.tween(char, {y: FlxG.height / 2 - char.height / 2}, 1, {startDelay: .5, ease: FlxEase.quartOut});                  
        }
    }
}
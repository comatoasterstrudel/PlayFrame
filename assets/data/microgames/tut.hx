var bg:FlxSprite;
var table:FlxSprite;
var friend:FlxSprite;

var buttons:Array<FlxSprite> = [];

var pressedButtons:Array<Bool> = [false, false, false, false];

var canControl:Bool = true;

var text:FlxSprite;
var textshake:Float = 0;

function create():Void{
    PlayState.wonMicrogame = false;

    bg = new FlxSprite().loadGraphic('assets/images/microgames/tut/bg.png');
    microgameGroup.add(bg);
    
    table = new FlxSprite();
    table.frames = FlxAtlasFrames.fromSparrow('assets/images/microgames/tut/table.png', 'assets/images/microgames/tut/table.xml');
    table.animation.addByPrefix('idle', 'idle', 2);
    table.animation.addByPrefix('win', 'win', 1);
    table.animation.play('idle');
    microgameGroup.add(table);
    
    friend = new FlxSprite();
    friend.frames = FlxAtlasFrames.fromSparrow('assets/images/microgames/tut/friend.png', 'assets/images/microgames/tut/friend.xml');
    friend.animation.addByPrefix('idle', 'idle', 2);
    friend.animation.addByPrefix('win', 'win', 1);
    friend.animation.play('idle');
    microgameGroup.add(friend);
    
    for(i in ['left', 'down', 'up', 'right']){
        var but = new FlxSprite();
        but.frames = FlxAtlasFrames.fromSparrow('assets/images/microgames/tut/button' + i + '.png', 'assets/images/microgames/tut/button' + i + '.xml');
        but.animation.addByPrefix('unpress', 'unpress', 1);
        but.animation.addByPrefix('press', 'press', 1);
        but.animation.play('unpress');
        microgameGroup.add(but);
        
        buttons.push(but);
    }
    
    text = new FlxSprite().loadGraphic('assets/images/microgames/tut/text1.png');
    microgameGroup.add(text);
    
    friend.animation.callback = function(name:String, frameNumber:Int, frameIndex:Int):Void{
        if(name == 'idle'){
            text.setPosition(FlxG.random.int(-3, 3), FlxG.random.int(-3, 3));
        } 
    };
        
}

function update(elapsed:Float):Void{
    var controls = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
    
    if(canControl){
        for(i in 0...4){
            if(Controls.getControl(controls[i], 'RELEASE')){
                if(!pressedButtons[i]){
                    pressedButtons[i] = true;
                    buttons[i].animation.play('press');
                    checkWin();
                    playSound('assets/sounds/keyClick' + FlxG.random.int(1,8) + '.ogg', 1);
                    
                    buttons[i].y += 20;
                    FlxTween.tween(buttons[i], {y: 0}, .5, {ease: FlxEase.quartOut}); 
                    
                    buttons[i].color = 0xFF8294FF;
                }
            }   
        }
    }
}

function checkWin():Void{
    var win:Bool = true;
    
    for(i in pressedButtons){
        if(!i) win = false;
    }
    
    if(win){
        canControl = false;
        
        friend.animation.play('win');
        table.animation.play('win');
        
        playSound('assets/sounds/aura.ogg', .2);
        
        PlayState.wonMicrogame = true;
        
        FlxTween.tween(friend, {alpha: 0}, 1);    
        
        text.loadGraphic('assets/images/microgames/tut/text2.png');
        text.setPosition(0,0);
        FlxTween.tween(text, {x: frameWidth / 2 - text.width / 2, y: -10, alpha: .5}, 2.3, {ease: FlxEase.quartOut});    
        FlxTween.shake(text, 0.05, 0.1);
    }    
}

function endMicrogame():Void{
}

function destroyMicrogame():Void{
    canControl = false;
    
    bg.destroy();
    table.destroy();
    friend.destroy();
    for(i in buttons){
        i.destroy();
    }
}
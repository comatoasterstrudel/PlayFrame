var guy:FlxSprite;
var bg:FlxBackdrop;
var goodbg:FlxBackdrop;

var speed:Float = 200;

var won:Bool = false;

var microgameOver:Bool = false;

function create(){
    bg = new FlxBackdrop('assets/images/microgames/test/bg.png', 0x11, 0, 0);
    microgameGroup.add(bg);
    
    goodbg = new FlxBackdrop('assets/images/microgames/test/bggood.png', 0x11, 0, 0);
    goodbg.visible = false;
    microgameGroup.add(goodbg);
    
    guy = new FlxSprite().loadGraphic('assets/images/microgames/test/guy.png');
    Utilities.centerSpriteOnPos(guy, frameWidth / 2, frameHeight / 2);
    microgameGroup.add(guy);
}

function update(elapsed):Void{
    guy.velocity.set(0,0);
    
    if(!microgameOver){
        if(Controls.getControl('RIGHT', 'HOLD')){
            guy.velocity.x = (speed * PlayState.additiveSpeed);
        }
        
        if(Controls.getControl('LEFT', 'HOLD')){
            guy.velocity.x = (-speed * PlayState.additiveSpeed);
        }
        
        if(Controls.getControl('UP', 'HOLD')){
            guy.velocity.y = (-speed * PlayState.additiveSpeed);
        }
        
        if(Controls.getControl('DOWN', 'HOLD')){
            guy.velocity.y = (speed * PlayState.additiveSpeed);
        }
        
        if(!won){
            if(guy.x + guy.width / 2 <= ((frameWidth / 2) - 300)){
                won = true;
                goodbg.visible = true;
            }            
        }   
        
        PlayState.wonMicrogame = won;
    }
}

function endMicrogame():Void{
    microgameOver = true;
}

function destroyMicrogame():Void{
    bg.destroy();
    goodbg.destroy();
    guy.destroy();
}

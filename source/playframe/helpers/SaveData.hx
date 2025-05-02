package playframe.helpers;

class SaveData{
    public static var highscores:Map<String, Int> = [
        'hexie' => 0,
        'gerbo' => 0,
        '8head' => 0,
        'trifecta' => 0,
        'illbert' => 0,
    ];
    
    public static function init():Void{
    }
    
    public static function load():Void{        
        if(FlxG.save.data.savedAvatar != null) {
            PlayState.curAvatar = FlxG.save.data.savedAvatar;
        } else {
            PlayState.curAvatar = 'hexie';
        }
        
        if(FlxG.save.data.highscores != null){
            highscores = FlxG.save.data.highscores;
        } else {
            highscores = [
                'hexie' => 0,
                'gerbo' => 0,
                '8head' => 0,
                'trifecta' => 0,
                'illbert' => 0,
            ];
        }
        
        var avatar = [];
        
        var data = Utilities.dataFromTextFile('assets/data/avatars.txt');
        
        for (i in 0...data.length)
        {
            var stuff:Array<String> = data[i].split(":");
    
            avatar.push(stuff[0]);
        }
            
        for(i in avatar){
            if(highscores.get(i) == null){
                highscores.set(i, 0);
                trace('Replaced null score: ' + i);
            }
        }
        
        trace('Loaded Save Data');
    }
    
    public static function save():Void{
        FlxG.save.data.savedAvatar = PlayState.curAvatar;
    
        FlxG.save.data.highscores = highscores;
       
        FlxG.save.flush();
        
        trace('Saved Save Data');
    }   
    
    public static function checkIllbertUnlocked():Bool{
        return(highscores.get('hexie') >= 50 && highscores.get('gerbo') >= 50 && highscores.get('8head') >= 50 && highscores.get('trifecta') >= 50);
    }
}
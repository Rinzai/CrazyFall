package
{
	import flash.filesystem.File;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	public final class Assets
	{
		private static var assets:AssetManager;

		private static var musicSoundChannel:SoundChannel;
		
		private static var lastPositionMusic:Number;
		
		private static var _fxVolume:int = 1;
		private static var _musicVolume:int = 1;
		
		public static function loadAsset(progressFunction:Function):void
		{
			assets = new AssetManager();
			//assets.verbose = true;
			
			var appDir:File = File.applicationDirectory;
			assets.enqueue(appDir.resolvePath("texture"));
			assets.enqueue(appDir.resolvePath("sounds"));
			
			assets.loadQueue( progressFunction );
		}
		
		public static function muteMusic(pauseGame:Boolean = false):void
		{
			_musicVolume = 0;
			if(pauseGame == false)
			{
				pauseMusic();
				resumeMusic();
			}
		}

		public static function unmuteMusic(pauseGame:Boolean = false):void
		{
			_musicVolume = 1;
			if(pauseGame == false)
			{
				pauseMusic();
				resumeMusic();
			}
		}
		
		public static function muteFX():void
		{
			_fxVolume = 0;
		}
		
		public static function unmuteFX():void
		{
			_fxVolume = 1;
		}
		
		public static function isMuteMusic():Boolean
		{
			return _musicVolume == 0
		}
		
		public static function isMuteFX():Boolean
		{
			return _fxVolume == 0
		}
		
		
		public static function capuchinCallSound():void
		{
			var capuchinCall:String = "capuchin__"+(int(Math.random()*10)+1)+"_";
			
			assets.playSound(capuchinCall,0,0,new SoundTransform(0.1*_fxVolume));
		}
		
		public static function capuchinCallEatSound():void
		{
			var capuchinCall:String = "capuchin_eat__"+(int(Math.random()*9)+1)+"_";
			
			assets.playSound(capuchinCall,0,0,new SoundTransform(0.2*_fxVolume));
		}
		
		public static function getTexture(img:String):Texture
		{
			return assets.getTexture( img );
		}
		
		public static function getObject(param0:String):*
		{
			return assets.getObject(param0);
		}
		
		public static function playGetFruit():void
		{
			var getFruitSoundChannel:SoundChannel = assets.playSound("get_fruit",0,0,new SoundTransform(0.3*_fxVolume));
		}
		
		public static function playDieSound():void
		{
			var getFruitSoundChannel:SoundChannel = assets.playSound("die",0,0,new SoundTransform(0.4*_fxVolume));
		}
		
		public static function playMusic(position:Number = 0):void
		{
			if(musicSoundChannel == null)
			{
				musicSoundChannel = assets.playSound("music_bkg",position,int.MAX_VALUE,new SoundTransform(0.7*_musicVolume));
			}
		}
		
		public static function resumeMusic():void
		{
			playMusic( lastPositionMusic );
			lastPositionMusic = 0;
		}
		
		public static function pauseMusic():void
		{
			if(musicSoundChannel == null) return;
			
			lastPositionMusic = musicSoundChannel.position;
			
			stopMusic();
		}
		
		public static function stopMusic():void
		{
			if(musicSoundChannel)
			{
				musicSoundChannel.stop();
				musicSoundChannel = null;
			}
		}
		
		public static function playFireToWater():void
		{
			assets.playSound("fire_to_water",0,0,new SoundTransform(0.3*_fxVolume));
		}
		
		public static function playShieldSound():void
		{
			assets.playSound("shield",0,0,new SoundTransform(0.5*_fxVolume));
		}
		
		public static function getTextures(value:String):Vector.<Texture>
		{
			return assets.getTextures(value);
		}
	}
}
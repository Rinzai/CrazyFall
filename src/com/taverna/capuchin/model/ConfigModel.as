package  com.taverna.capuchin.model
{
	import com.taverna.capuchin.model.vo.ConfigData;
	
	import flash.errors.IllegalOperationError;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;

	public final class ConfigModel
	{
		public static const GOOGLE_PLAY_APP:String = "com.google.android.play.games";
		public static const GOOGLE_PLAY_SERVICE_APP:String = "com.google.android.gms";
		
		private static var packageManager:Object;
		
		public static const CONTROL_JOYSTICK:int = 1;
		public static const CONTROL_TOUCH:int = 2;
		
		public static const MUSIC_MUTE:int = 1;
		public static const MUSIC_UNMUTE:int = 2;
		
		public static const FX_MUTE:int = 1;
		public static const FX_UNMUTE:int = 2;
		
		public static const VIEW_TUTORIAL:int = 1;
		
		private static const PLAY_GAME_CONTROL_BUTTON:String = "playGameControl";
		
		public static var _dicFiles:Dictionary = new Dictionary(true);
		
		private static var _lastData:ConfigData;

		private static var _hasConnection:Boolean;

		public function ConfigModel()
		{
			throw new IllegalOperationError("Static Class")
		}

		public static function get hasConnection():Boolean
		{
			return _hasConnection;
		}

		public static function setControl(value:int):void
		{
			var data:ConfigData = getData();
			
			if(data == null)
			{
				data = new ConfigData();
			}
			
			data.control_type = value;
			
			saveData(data);
		}
		
		public static function setMusicStatus(value:int):void
		{
			var data:ConfigData = getData();
			
			if(data == null)
			{
				data = new ConfigData();
			}
			
			data.music_status = value;
			
			saveData(data);
		}
		
		public static function setFxStatus(value:int):void
		{
			var data:ConfigData = getData();
			
			if(data == null)
			{
				data = new ConfigData();
			}
			
			data.fx_status = value;
			
			saveData(data);
		}
		
		public static function setTutorialStatus(value:int):void
		{
			var data:ConfigData = getData();
			
			if(data == null)
			{
				data = new ConfigData();
			}
			
			data.tutorial_status = value;
			
			saveData(data);
		}
		
		public static function canShowRanking(value:Boolean):void
		{
			var data:ConfigData = getData();
			
			if(data == null)
			{
				data = new ConfigData();
			}
			
			data.can_show_leaderboard = value;
			saveData(data);
		}
		
		public static function verifyCanRanking():void
		{
			/*var data:ConfigData = getData();
			
			if(data == null)
			{
				data = new ConfigData();
			}
			
			if(packageManager == null)
			{
				var pkg:Class = getDefinitionByName("com.doitflash.air.extensions.packagemanager.PackageManager") as Class;
				packageManager = new pkg();
			}
			
			var googlePlayApp:String = packageManager.getAppName(GOOGLE_PLAY_APP);
			var googlePlayServiceApp:String = packageManager.getAppName(GOOGLE_PLAY_SERVICE_APP);
			
			data.has_Google_Play_App = (googlePlayApp != null);
			data.has_Google_Play_Service_App = (googlePlayServiceApp != null);
			data.can_show_leaderboard = (data.has_Google_Play_App && data.has_Google_Play_Service_App);
			saveData(data);*/
		}
		
		public static function setRanking(value:int):void
		{
			var data:ConfigData = getData();
			
			if(data == null)
			{
				data = new ConfigData();
			}
			
			if(data.ranking_point < value)
			{
				data.ranking_point = value;
				saveData(data);
			}
		}
		
		public static function incremmentEndGame():void
		{
			var data:ConfigData = getData();
			
			if(data == null)
			{
				data = new ConfigData();
			}
			
			data.end_game_total++;
			saveData(data);
		}
		
		public static function getData():ConfigData
		{
			if(_lastData) return _lastData;
			
			var save:File = File.applicationStorageDirectory.resolvePath("config/capuchin.bin");
			var infoByteArray:ByteArray = new ByteArray();

			if(save.exists) {
				var fs:FileStream = new FileStream();
				fs.open(save, FileMode.READ);
				fs.readBytes(infoByteArray);
				fs.close();
				infoByteArray.position = 0;
				if(infoByteArray.length > 0) {
					infoByteArray.inflate();
					_lastData = infoByteArray.readObject() as ConfigData;
					return _lastData;
				}
			}

			return null;
		}

		private static function saveData(data:ConfigData):void
		{
			var save:File = File.applicationStorageDirectory.resolvePath("config/capuchin.bin");

			var infoByteArray:ByteArray = new ByteArray();
			infoByteArray.writeObject(data);
			infoByteArray.deflate();

			var fs:FileStream = new FileStream();
			fs.open(save, FileMode.UPDATE);
			fs.position = 0;
			fs.truncate();
			fs.writeBytes(infoByteArray);
			fs.close();
			
			_lastData = data;
		}
		
		
		public static function setHasConnection(available:Boolean):void
		{
			_hasConnection = available;
		}
		
		public static function installApp(app:String):void
		{
			if(packageManager == null)
			{
				var pkg:Class = getDefinitionByName("com.doitflash.air.extensions.packagemanager.PackageManager") as Class;
				packageManager = new pkg();
			}
			
			packageManager.installApp(app);
		}
	}
}
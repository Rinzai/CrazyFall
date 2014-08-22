package com.taverna.capuchin.model
{
	import com.taverna.capuchin.helpers.AnalyticsHelper;
	import com.taverna.capuchin.model.vo.DificultData;

	public final class DificultModel
	{
		public static const EASY:int = 0;
		public static const MODERATE:int = 1;
		public static const HARD:int = 2;
		
		
		private static var _easyDificult:Vector.<DificultData> = new Vector.<DificultData>();
		private static var _moderateDificult:Vector.<DificultData> = new Vector.<DificultData>();
		private static var _hardDificult:Vector.<DificultData> = new Vector.<DificultData>();

		private static var _currDificult:int = 1;
		private static var _currDificultIndex:int = 0;

		private static var dData:DificultData;
		
		public static function selectDificult(value:int):void
		{
			_currDificultIndex = 0;
			_currDificult = value;
		}
		
		public static function getCurrentDificultData():DificultData
		{
			return dData;
		}
		
		public static function getNextDificultData():DificultData
		{
			var _dificultName:String = "";
			
			if(_currDificult == 0 && _easyDificult.length > _currDificultIndex)
			{
				dData = _easyDificult[_currDificultIndex++];
				
				if(_easyDificult.length-1 == _currDificultIndex)
				{
					_currDificult++;
					_currDificultIndex = 0;
				}
			}else if(_currDificult == 1 && _moderateDificult.length > _currDificultIndex)
			{
				dData = _moderateDificult[_currDificultIndex++];
				
				if(_moderateDificult.length-1 == _currDificultIndex)
				{
					_currDificult++;
					_currDificultIndex = 0;
				}	
			}else if(_currDificult == 2 && _hardDificult.length > _currDificultIndex)
			{
				dData = _hardDificult[_currDificultIndex++];
			}
			
			
			return dData;
		}
		
		private static function getDificultName(value:int):String
		{
			
			var name:String;
			
			switch(value)
			{
				case 0:
				{
					name = "EASY";
					break;
				}
					
				case 1:
				{
					name = "MODERATE";
					break;
				}
					
				case 2:
				{
					name = "HARD";
					break;
				}
					
				default:
				{
					name = "NO DEFINE"
					break;
				}
			}
			
			return name;
		}
		
		
		public static function initModel():void
		{
			var dificult:DificultData;
			
			for (var i:int = 0; i < 25; i++) 
			{
				dificult = new DificultData();
				
				dificult.chanceToAppearFireBranch = (0.02)+(i/100);
				dificult.fireToBluePoint = 1+(1/100);
				dificult.coefFruit = 0,0005+(i/100000);
				dificult.numBranchsInLevel = 10+i;
				dificult.pointPerBranch = 1;
				dificult.timeToAppearBranch = 1.5-(0.02*i);
				dificult.timeToAppearFruit  = 7-(i*0.01);
				
				if(dificult.timeToAppearBranch < 0.3)
				{
					dificult.timeToAppearBranch == 0.3;
				}
				
				_easyDificult.push( dificult ); 
				
				dificult = new DificultData();
				
				dificult.chanceToAppearFireBranch = (0.05)+(i/60);
				dificult.fireToBluePoint = 20+(i*2);
				dificult.coefFruit = (0.007)+((i+1)*0.001);
				dificult.numBranchsInLevel = 5+int(i/2);
				dificult.pointPerBranch = 40+(i);
				dificult.timeToAppearBranch = 1-(0.02*i);
				dificult.timeToAppearFruit  = 5-(i*0.08);;
				
				if(dificult.timeToAppearBranch < 0.3)
				{
					dificult.timeToAppearBranch == 0.3;
				}
				
				_moderateDificult.push( dificult ); 
				
				dificult = new DificultData();
				
				dificult.chanceToAppearFireBranch = (0.4)+(i/100);
				dificult.fireToBluePoint = 60+(i*4);
				dificult.coefFruit = 0.032+((i+1)*0.001);
				dificult.numBranchsInLevel = 15+i;
				dificult.pointPerBranch = 60+(i*2);
				dificult.timeToAppearBranch = 0.5-(0.02*i);
				dificult.timeToAppearFruit  = 3-(i*0.04);
				
				if(dificult.timeToAppearBranch < 0.3)
				{
					dificult.timeToAppearBranch == 0.3;
				}
				
				_hardDificult.push( dificult ); 
			}
			
			
					
		}
	}
}
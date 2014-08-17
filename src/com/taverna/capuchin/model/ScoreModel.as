package com.taverna.capuchin.model
{
	public final class ScoreModel
	{
		private static var _score:Number = 0;
		private static var _lastBigScore:Number = 0;
		private static var _showLeaderBoard:Boolean = false;
		
		private static var _acaiPoint:Number = 0;
		
		public function ScoreModel()
		{
		}
		
		
		public static function resetAcaiPoint():void
		{
			_acaiPoint = 0;
		}
		
		public static function get acaiPoint():Number
		{
			return _acaiPoint;
		}

		public static function get score():Number
		{
			return _score;
		}

		public static function incrementScore(value:Number):void
		{
			_score += value;
			_acaiPoint += value;
			
			
			if(_score > _lastBigScore)
			{
				_lastBigScore = _score;
				_showLeaderBoard = true;
			}else
			{
				_showLeaderBoard = false;
			}
		}
		
		public static function resetScore():void
		{
			_score = 0;
			_acaiPoint = 0;
		}
		
		public static function showLeaderBoard():Boolean
		{
			return _showLeaderBoard;
		}
	}
}
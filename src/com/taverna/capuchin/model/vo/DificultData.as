package com.taverna.capuchin.model.vo
{
	public final class DificultData
	{
		private var _numBranchsInLevel:Number;
		private var _timeToAppearBranch:Number;
		private var _timeToAppearFruit:Number;
		private var _pointPerSecond:Number;
		private var _coefFruit:Number;
		private var _fireToBluePoint:Number;
		private var _chanceToAppearFireBranch:Number;
		
		public function DificultData()
		{
		}

		public function get numBranchsInLevel():Number
		{
			return _numBranchsInLevel;
		}

		public function set numBranchsInLevel(value:Number):void
		{
			_numBranchsInLevel = value;
		}

		public function get chanceToAppearFireBranch():Number
		{
			return _chanceToAppearFireBranch;
		}

		public function set chanceToAppearFireBranch(value:Number):void
		{
			_chanceToAppearFireBranch = value;
		}

		public function get fireToBluePoint():Number
		{
			return _fireToBluePoint;
		}

		public function set fireToBluePoint(value:Number):void
		{
			_fireToBluePoint = value;
		}

		public function get coefFruit():Number
		{
			return _coefFruit;
		}

		public function set coefFruit(value:Number):void
		{
			_coefFruit = value;
		}

		public function get pointPerBranch():Number
		{
			return _pointPerSecond;
		}

		public function set pointPerBranch(value:Number):void
		{
			_pointPerSecond = value;
		}

		public function get timeToAppearFruit():Number
		{
			return _timeToAppearFruit;
		}

		public function set timeToAppearFruit(value:Number):void
		{
			_timeToAppearFruit = value;
		}

		public function get timeToAppearBranch():Number
		{
			return _timeToAppearBranch;
		}

		public function set timeToAppearBranch(value:Number):void
		{
			_timeToAppearBranch = value;
		}

	}
}
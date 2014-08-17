package com.taverna.capuchin
{
	import starling.events.Event;
	
	public final class CapuchinEvent extends Event
	{
		public static const UPDATE_PLAYER_NAME:String = "updateScreenName";
		public static const GAME_PAUSED:String = "gamePaused";
		public static const GAME_OVER:String = "gameOver";
		public static const SHOW_RANKING:String = "showRanking";
		public static const PLAY_AGAIN_CLICKED:String = "onPlayAgainClicked";
		public static const RESUME_GAME:String = "resumeGame";
		public static const START_BTN_CLICKED:String = "startBtnClicked";
		
		public static const ADD_SCORE:String = "addScore";
		
		public function CapuchinEvent(type:String, bubbles:Boolean=false, data:Object=null)
		{
			super(type, bubbles, data);
		}
	}
}
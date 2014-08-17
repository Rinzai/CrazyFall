package com.taverna.capuchin.model.vo
{
	public final class ConfigData
	{
		public var control_type:int;
		public var tutorial_status:int;
		public var music_status:int;
		public var fx_status:int;
		public var ranking_point:int;
		public var can_show_leaderboard:Boolean = false;
		public var has_Google_Play_App:Boolean;
		public var has_Google_Play_Service_App:Boolean;
		public var end_game_total:int = 0;
		
		public function ConfigData()
		{
		}
	}
}
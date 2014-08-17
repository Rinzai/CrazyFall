package com.taverna.capuchin.graphics
{
	import starling.display.Image;
	import starling.display.Sprite;
	
	public final class Background extends Sprite
	{
		public function Background()
		{
			addChild( new Image(Assets.getTexture("game_bkg")));
		}
	}
}
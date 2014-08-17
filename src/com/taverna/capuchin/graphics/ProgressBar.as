package com.taverna.capuchin.graphics
{
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class ProgressBar extends Sprite
	{
		[Embed(source="progress_bg.png")]
		public static var bkgc:Class;
		
		[Embed(source="progress_b.png")]
		public static var barc:Class;
		
		private const bkg:Image = Image.fromBitmap( new bkgc() );
		private const bar:Image = Image.fromBitmap( new barc() );
		
		public function ProgressBar()
		{
			super();
			
			addChild( bkg );
			bar.x = bkg.width*0.5-bar.width*0.5;
			bar.y = bkg.height*0.6-bar.height*0.5;
			addChild( bar );
			updateBar( 0 );
		}
		
		public function updateBar(value:Number):void
		{
			bar.scaleX = value;
		}
	}
}
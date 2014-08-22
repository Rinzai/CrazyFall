package
{
	import com.freshplanet.ane.AirGooglePlayGames.AirGooglePlayGames;
	import com.purplebrain.adbuddiz.sdk.nativeExtensions.AdBuddiz;
	import com.sticksports.nativeExtensions.mopub.MoPubBanner;
	import com.taverna.capuchin.helpers.AnalyticsHelper;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	
	[SWF(width='640', height='1136', frameRate='60', backgroundColor='#000000')]
	public class CapuchinAndroidVersion extends Sprite
	{
		private var _starling:Starling;
		
		public static var debugSprite:Sprite;

		public function CapuchinAndroidVersion()
		{
			super();
			
			this.addEventListener( Event.ADDED_TO_STAGE, onAddedToStagenHandler );
		}
		
		protected function onAddedToStagenHandler(e:Event):void
		{
			addEventListener( Event.ENTER_FRAME, init );	
		}
		
		private function init( event : Event ) : void
		{
			
			if( stage.stageWidth && stage.stageHeight )
			{
				
				var screenWidth:int  = stage.fullScreenWidth;
				var screenHeight:int = stage.fullScreenHeight;
				var viewPort:Rectangle = new Rectangle(0, 0, screenWidth, screenHeight)
				
				Starling.multitouchEnabled = true;
				Starling.handleLostContext = true;
				
				removeEventListener( Event.ENTER_FRAME, init );
				_starling = new Starling( CapuchinAndroidController, stage, viewPort );
				_starling.antiAliasing = 0;
				_starling.start();
				//_starling.showStats = true;
				//_starling.showStatsAt("left","bottom");
				
				_starling.stage.stageWidth  = 320;
				_starling.stage.stageHeight = 568;
				
				//stage.addChild( debugSprite );
			}
		}
		
		protected function bannerFailed(event:Event):void
		{
			// TODO Auto-generated method stub
			trace( "\n  " + event.type );
		}
		
		protected function bannerReady(event:Event):void
		{
			
		}
		
		protected function eventReceived(event:Event):void
		{
			// TODO Auto-generated method stub
			trace( "\n  " + event.type );
		}
		
	}
}
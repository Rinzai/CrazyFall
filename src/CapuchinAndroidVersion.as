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

		public static var banner:MoPubBanner;
		
		public function CapuchinAndroidVersion()
		{
			super();
			
			this.addEventListener( Event.ADDED_TO_STAGE, onAddedToStagenHandler );
		}
		
		protected function onAddedToStagenHandler(e:Event):void
		{
			addEventListener( Event.ENTER_FRAME, init );
			
			/*var loader:Loader = new Loader();
			loader.load( new URLRequest("https://www.facebook.com/offsite_event.php?id=6014622889462&value=0&currency=BRL"));
			
			ConfigModel.verifyCanRanking();
			
			//if(ConfigModel.getData().can_show_leaderboard && AirGooglePlayGames.isSupported)
			//{
				//AirGooglePlayGames.getInstance().signIn();
			//}
			
			
			if(RateBox.isSupported())
			{
				
				if( ConfigModel.getData().ranking_point > 5000 && ConfigModel.getData().end_game_total%4 == 0)
				{
					RateBox.rateBox.showRatingPrompt("De sua avaliação", "Deixe sua avaliação para o Capuchin!","Avaliar","Depois","Não Vou Avaliar");
				}
				
				RateBox.create(null,
					"De sua avaliação",
					"Deixe sua avaliação para o Capuchin!",
					"Quero Avaliar",
					"Ainda não sei",
					"Não Vou Avaliar",
					3,
					1,
					0,
					1);
				
				RateBox.rateBox.onLaunch();
			}*/
		}		
		
		
		/*private function onFailedReceiveAd(e:AdMobErrorEvent):void
		{
			trace("Ad failed to load.");
			AnalyticsHelper.trackEvent( "AdMobErrorEvent", e.text );
		}
		
		private function onReceiveAd(e:AdMobEvent):void
		{
			trace("recieve Ad");
			if(e.isInterstitial)
			{
				trace("Interstitial has loaded");
				AnalyticsHelper.trackEvent( "AdMobErrorEvent", "recieve interstitial banner" );
			}else
			{
				AnalyticsHelper.trackEvent( "AdMobErrorEvent", "recieve banner" );
			}
		}*/
		
		private function init( event : Event ) : void
		{
			AnalyticsHelper.init();
			
			if( stage.stageWidth && stage.stageHeight )
			{
				/*banner = new MoPubBanner( "9e13e46a14204d7f9028476c61118304", MoPubSize.banner );
				banner.x = 0;
				banner.y = stage.stageHeight - banner.height;
				banner.addEventListener( MoPubEvent.LOADED, bannerReady );
				banner.addEventListener( MoPubEvent.LOAD_FAILED, bannerFailed );
				banner.load();
				banner.autorefresh = true;
				banner.nativeAdsOrientation = MoPubNativeAdOrientation.portrait;*/
				//banner.testing = true;
				
				
				
				/*if(AdMob.isSupported)
				{
					AdMob.init("ca-app-pub-0976264754680933/2622675723");
					//AdMob.loadInterstitial("ca-app-pub-0976264754680933/1145942520",false);
					AdMob.addEventListener(AdMobEvent.RECEIVED_AD,onReceiveAd);
					AdMob.addEventListener(AdMobErrorEvent.FAILED_TO_RECEIVE_AD,onFailedReceiveAd);
					//if(Capabilities.isDebugger)
						//AdMob.enableTestDeviceIDs( AdMob.getCurrentTestDeviceIDs() );
				}*/
				
				//AdBuddiz.setAndroidPublisherKey("65f7440f-4319-48e4-8f08-5e43bc97424d");
				//AdBuddiz.cacheAds();
				
				if(AirGooglePlayGames.isSupported)
				{
					AirGooglePlayGames.getInstance().startAtLaunch();
				}
				
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
			// TODO Auto-generated method stub
			trace( "\n  " + event.type );
			if( banner.width != banner.creativeWidth )
			{
				banner.width = banner.creativeWidth;
				banner.x = ( stage.fullScreenWidth - banner.creativeWidth ) / 2;
			}
			if( banner.height != banner.creativeHeight )
			{
				banner.height = banner.creativeHeight;
				banner.y = stage.fullScreenHeight - banner.creativeHeight;
			}
			banner.show();
		}
		
		protected function eventReceived(event:Event):void
		{
			// TODO Auto-generated method stub
			trace( "\n  " + event.type );
		}
		
	}
}
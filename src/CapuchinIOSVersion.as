package
{
	import com.milkmangames.nativeextensions.AdMob;
	import com.milkmangames.nativeextensions.RateBox;
	import com.milkmangames.nativeextensions.events.AdMobErrorEvent;
	import com.milkmangames.nativeextensions.events.AdMobEvent;
	import com.purplebrain.adbuddiz.sdk.nativeExtensions.AdBuddiz;
	import com.sticksports.nativeExtensions.SilentSwitch;
	import com.sticksports.nativeExtensions.gameCenter.GameCenter;
	import com.taverna.capuchin.helpers.AnalyticsHelper;
	import com.taverna.capuchin.model.ConfigModel;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	
	import starling.core.Starling;
	
	[SWF(width='640', height='1136', frameRate='60', backgroundColor='#000000')]
	public final class CapuchinIOSVersion extends Sprite
	{
		private var _starling:Starling;
		
		public static var debugSprite:Sprite;
		
		public function CapuchinIOSVersion()
		{
			super();
			
			this.addEventListener( Event.ADDED_TO_STAGE, onAddedToStagenHandler );
		}
		
		protected function onAddedToStagenHandler(e:Event):void
		{
			var loader:Loader = new Loader();
			loader.load( new URLRequest("https://www.facebook.com/offsite_event.php?id=6014622889462&value=0&currency=BRL"));
			
			if(GameCenter.isSupported)
			{
				GameCenter.init();
				GameCenter.authenticateLocalPlayer();
			}
			
			SilentSwitch.apply();
			
			addEventListener( Event.ENTER_FRAME, init );
			
			if(RateBox.isSupported())
			{
				
				if( ConfigModel.getData() && ConfigModel.getData().ranking_point > 5000 && ConfigModel.getData().end_game_total%4 == 0)
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
			}
		}		
		
		
		private function onFailedReceiveAd(e:AdMobErrorEvent):void
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
		}
		
		private function init( event : Event ) : void
		{
			AnalyticsHelper.init();
			
			if( stage.stageWidth && stage.stageHeight )
			{
				if(AdMob.isSupported)
				{
					AdMob.init("ca-app-pub-0976264754680933/4289492523");
					//AdMob.loadInterstitial("ca-app-pub-0976264754680933/8502915726",false);
					AdMob.addEventListener(AdMobEvent.RECEIVED_AD,onReceiveAd);
					AdMob.addEventListener(AdMobErrorEvent.FAILED_TO_RECEIVE_AD,onFailedReceiveAd);
					if(Capabilities.isDebugger)
						AdMob.enableTestDeviceIDs( AdMob.getCurrentTestDeviceIDs() );
				}
				
				AdBuddiz.setIOSPublisherKey("78783117-3be5-4f68-ad7e-55e84479712b");
				AdBuddiz.cacheAds();
				
				var screenWidth:int  = stage.fullScreenWidth;
				var screenHeight:int = stage.fullScreenHeight;
				var viewPort:Rectangle = new Rectangle(0, 0, screenWidth, screenHeight)
				
				Starling.multitouchEnabled = true;
				
				removeEventListener( Event.ENTER_FRAME, init );
				_starling = new Starling( CapuchinIOSController, stage, viewPort );
				_starling.antiAliasing = 0;
				_starling.start();
				//_starling.showStats = true;
				//_starling.showStatsAt("left","bottom");
				
				_starling.stage.stageWidth  = 320;
				_starling.stage.stageHeight = 568;
			}
		}
	}
}
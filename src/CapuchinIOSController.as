package
{
	import com.milkmangames.nativeextensions.RateBox;
	import com.purplebrain.adbuddiz.sdk.nativeExtensions.AdBuddiz;
	import com.sticksports.nativeExtensions.gameCenter.GameCenter;
	import com.taverna.capuchin.CapuchinEvent;
	import com.taverna.capuchin.Observer;
	import com.taverna.capuchin.graphics.Branch;
	import com.taverna.capuchin.graphics.Fruit;
	import com.taverna.capuchin.graphics.ProgressBar;
	import com.taverna.capuchin.model.ConfigModel;
	import com.taverna.capuchin.model.DificultModel;
	import com.taverna.capuchin.model.ScoreModel;
	import com.taverna.capuchin.screen.ScreenCapuchinStart;
	import com.taverna.capuchin.screen.ScreenGameOver;
	import com.taverna.capuchin.screen.ScreenPauseIndicator;
	
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.utils.setTimeout;
	
	import air.net.URLMonitor;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class CapuchinIOSController extends Sprite
	{
		
		[Embed(source="taverna_game.png")]
		public static var bkg:Class;
		
		private const bkgImage:Image = Image.fromBitmap(new bkg());
		
		
		private var _capuchinGame:CapuchinGame;
		private var _pauseIndicator:ScreenPauseIndicator;
		private var _startScreen:ScreenCapuchinStart;
		private var _gameOverScreen:ScreenGameOver;
		private var _deactivated:Boolean;
		
		private var monitor:URLMonitor;
		
		public function CapuchinIOSController()
		{
			super();
			
			this.addEventListener( starling.events.Event.ADDED_TO_STAGE, onAddedToStageHandler );
			this.alpha = 0.999;
			
			monitor = new URLMonitor(new URLRequest("http://www.google.com.br") );
			monitor.addEventListener(StatusEvent.STATUS, netConnectivity);
			monitor.pollInterval = 5000;
			monitor.start();
		}
		
		protected function netConnectivity(e:StatusEvent):void 
		{
			ConfigModel.setHasConnection(monitor.available);
		}
		
		private function onAddedToStageHandler(e:starling.events.Event):void
		{
			
			bkgImage.pivotX = bkgImage.width*0.5;
			bkgImage.pivotY = bkgImage.height*0.5;
			bkgImage.x = stage.stageWidth*0.5;
			bkgImage.y = stage.stageHeight*0.5;
			addChild( bkgImage );
			
			var progressBar:ProgressBar = new ProgressBar();
			
			progressBar.x = stage.stageWidth*0.5-progressBar.width*0.5;
			progressBar.y = bkgImage.y+ 100;
			
			addChild( progressBar );
			
			this.removeEventListener( starling.events.Event.ADDED_TO_STAGE, onAddedToStageHandler );
			
			Assets.loadAsset( function(ratio:Number):void
			{
				progressBar.updateBar( ratio );
				
				if(ratio == 1)
				{
					Fruit.createCache();
					Branch.cache();
					DificultModel.initModel();
					
					System.gc();
					System.pauseForGCIfCollectionImminent(0);
					
					var tw:Tween = new Tween( bkgImage, 0.8 ,Transitions.EASE_IN_OUT);
					tw.delay = 0.4;
					tw.scaleTo( 1.5 );
					tw.fadeTo( 0 );
					
					tw.onComplete = initCapuchin;
					
					Starling.juggler.add( tw );
					
					removeChild( progressBar );
					progressBar.dispose();
					progressBar = null;
					
				}
			});
			
		}
		
		protected function onDeactiveHandler(event:flash.events.Event):void
		{
			if(Starling.current.isStarted)
			{
				monitor.stop();
				_deactivated = true;
				if(_capuchinGame && contains(_capuchinGame))
				{
					_capuchinGame.pause(false);
				}
				Starling.current.stop(true);
				trace("deactive");
			}
		}
		
		private function onCloseResumeIndicatorHandler(e:starling.events.Event):void
		{
			if(_capuchinGame && contains(_capuchinGame))
			{
				_capuchinGame.resume();
			}
		}
		
		protected function onActiveHandler(event:flash.events.Event):void
		{
			_deactivated = false;
			if(Starling.current.isStarted == false)
			{
				monitor.start();
				Starling.current.start();
				
				trace("active");
			}
		}
		
		private function initCapuchin():void
		{	
			Starling.current.nativeStage.addEventListener( flash.events.Event.DEACTIVATE, onDeactiveHandler );
			Starling.current.nativeStage.addEventListener( flash.events.Event.ACTIVATE, onActiveHandler );
			
			Observer.dispatcher.addEventListener( CapuchinEvent.START_BTN_CLICKED, onStartBtnClickedHandler );
			Observer.dispatcher.addEventListener( CapuchinEvent.GAME_OVER, onGameOver );
			Observer.dispatcher.addEventListener( CapuchinEvent.GAME_PAUSED, onGamePaused );
			Observer.dispatcher.addEventListener( CapuchinEvent.SHOW_RANKING, onShowRanking );
			Observer.dispatcher.addEventListener( CapuchinEvent.PLAY_AGAIN_CLICKED, onPlayAgainClickedHandler );
			Observer.dispatcher.addEventListener( CapuchinEvent.RESUME_GAME, onCloseResumeIndicatorHandler );
			Observer.dispatcher.addEventListener( CapuchinEvent.ADD_SCORE, onAddScoreHandler );
			
			_startScreen = new ScreenCapuchinStart();
			_capuchinGame = new CapuchinGame();	
			_pauseIndicator = new ScreenPauseIndicator();
			_gameOverScreen = new ScreenGameOver();
			
			
			addChild( _startScreen );
			
		}
		
		private function onAddScoreHandler(e:CapuchinEvent):void
		{
			ScoreModel.incrementScore( e.data as Number );
		}
		
		private function onShowRanking(e:starling.events.Event):void
		{
			if(GameCenter.isSupported && GameCenter.isAuthenticated)
			{
				GameCenter.showStandardLeaderboard();
			}
		}
		   
		
		private function onPlayAgainClickedHandler(e:starling.events.Event):void
		{
			addChildAt( _capuchinGame, getChildIndex( _gameOverScreen )-1 );
			setTimeout( _capuchinGame.startGame, 1000 );
		}
		
		private function onStartBtnClickedHandler(e:starling.events.Event):void
		{
			removeChild( _startScreen );
			addChild( _capuchinGame );
			_capuchinGame.startGame();
		}
		
		private function onGameOver(e:starling.events.Event):void
		{
			updatePlayerName();
			//removeChild( _capuchinGame );
			addChild( _gameOverScreen );
			
			ConfigModel.setRanking( ScoreModel.score );
			
			if(GameCenter.isSupported && GameCenter.isAuthenticated)
			{
				GameCenter.reportScore("capuchin_master_score",ScoreModel.score);
			}
			
			if(RateBox.isSupported() && RateBox.rateBox && ScoreModel.score > 1000)
			{
				RateBox.rateBox.incrementEventCount();
			}
			
			ConfigModel.incremmentEndGame();
			
			if(ConfigModel.getData().end_game_total%3 == 0 )
			{
				AdBuddiz.showAd();
			}
			
		}
		
		private function onGamePaused(e:starling.events.Event):void
		{
			updatePlayerName();
			addChild( _pauseIndicator );
			
			/*try{
			if(_deactivated == false)
			{
			if(AdMob.isInterstitialReady())
			{
			setTimeout(AdMob.showPendingInterstitial, 500);
			setTimeout(AdMob.loadInterstitial,1000,"ca-app-pub-0976264754680933/8502915726",false);
			}
			}
			}catch(e:Error)
			{
			AnalyticsHelper.trackEvent("ERROR", "Erro try show interstial banner pause");
			}*/
			
			if(e.data)
			{
				AdBuddiz.showAd(); 
			}
		}
		
		private function updatePlayerName():void
		{
			if(GameCenter.isAuthenticated)
			{
				Observer.dispatcher.dispatchEvent( new CapuchinEvent( CapuchinEvent.UPDATE_PLAYER_NAME, false, GameCenter.localPlayer.alias ) );
			}else
			{
				
				Observer.dispatcher.dispatchEvent( new CapuchinEvent( CapuchinEvent.UPDATE_PLAYER_NAME, false, "" ) );
			}
		}
		
	}
}
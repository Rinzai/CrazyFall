package
{
	import com.taverna.capuchin.CapuchinEvent;
	import com.taverna.capuchin.Observer;
	import com.taverna.capuchin.graphics.Branch;
	import com.taverna.capuchin.graphics.Fruit;
	import com.taverna.capuchin.graphics.ProgressBar;
	import com.taverna.capuchin.model.ConfigModel;
	import com.taverna.capuchin.model.DificultModel;
	import com.taverna.capuchin.model.ScoreModel;
	import com.taverna.capuchin.screen.CrazyFallHomeScreen;
	import com.taverna.capuchin.screen.ScreenGameOver;
	import com.taverna.capuchin.screen.ScreenPauseIndicatorAndroid;
	
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
	
	public class CapuchinAndroidController extends Sprite
	{

		[Embed(source="logo.png")]
		public static var bkg:Class;
		
		private const bkgImage:Image = Image.fromBitmap(new bkg());
		
		
		private var _capuchinGame:CapuchinGame;
		private var _pauseIndicator:ScreenPauseIndicatorAndroid;
		private var _startScreen:CrazyFallHomeScreen;
		private var _gameOverScreen:ScreenGameOver;
		private var _deactivated:Boolean;

		private var monitor:URLMonitor;
		
		public function CapuchinAndroidController()
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
			if(Starling.current && Starling.current.isStarted)
			{
				monitor.stop();
				_deactivated = true;
				if(_capuchinGame && contains(_capuchinGame))
				{
					_capuchinGame.pause(false);
				}
				setTimeout(Starling.current.stop, 400, true);
				trace("deactive");
				Starling.current.nativeStage.addEventListener( flash.events.Event.ACTIVATE, onActiveHandler );
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
				setTimeout(Starling.current.start, 200);
				
				trace("active");
				Starling.current.nativeStage.removeEventListener( flash.events.Event.ACTIVATE, onActiveHandler );
			}
		}
		
		private function initCapuchin():void
		{	
			Starling.current.nativeStage.addEventListener( flash.events.Event.DEACTIVATE, onDeactiveHandler );
			
			Observer.dispatcher.addEventListener( CapuchinEvent.START_BTN_CLICKED, onStartBtnClickedHandler );
			Observer.dispatcher.addEventListener( CapuchinEvent.GAME_OVER, onGameOver );
			Observer.dispatcher.addEventListener( CapuchinEvent.GAME_PAUSED, onGamePaused );
			Observer.dispatcher.addEventListener( CapuchinEvent.SHOW_RANKING, onShowRanking );
			Observer.dispatcher.addEventListener( CapuchinEvent.PLAY_AGAIN_CLICKED, onPlayAgainClickedHandler );
			Observer.dispatcher.addEventListener( CapuchinEvent.RESUME_GAME, onCloseResumeIndicatorHandler );
			Observer.dispatcher.addEventListener( CapuchinEvent.ADD_SCORE, onAddScoreHandler );
			
			_startScreen = new CrazyFallHomeScreen();
			_capuchinGame = new CapuchinGame();	
			_pauseIndicator = new ScreenPauseIndicatorAndroid();
			_gameOverScreen = new ScreenGameOver();
			
			addChild( _startScreen );
			
		}
		
		private function onAddScoreHandler(e:CapuchinEvent):void
		{
			ScoreModel.incrementScore( e.data as Number );
		}
		
		private function onShowRanking(e:starling.events.Event):void
		{
			
		}
		
		protected function onGooglePlayReady(event:flash.events.Event):void
		{
			
		}
		
		private function updatePlayerName():void
		{
			
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
			removeChild( _capuchinGame );
			addChild( _gameOverScreen );
		}
		
		private function onGamePaused(e:starling.events.Event):void
		{
			updatePlayerName();
			
			addChild( _pauseIndicator );
		}
		
	}
}
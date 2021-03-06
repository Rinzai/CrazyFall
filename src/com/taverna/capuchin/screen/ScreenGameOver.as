package com.taverna.capuchin.screen
{
	import com.taverna.capuchin.CapuchinEvent;
	import com.taverna.capuchin.Observer;
	import com.taverna.capuchin.model.ConfigModel;
	import com.taverna.capuchin.model.ScoreModel;
	
	import flash.events.KeyboardEvent;
	import flash.system.System;
	import flash.ui.Keyboard;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public final class ScreenGameOver extends Sprite
	{
		private const bkg:Image = new Image( Assets.getTexture("end_background") );
		private const logo:Image = new Image( Assets.getTexture("logo") );
		private const scoreBkg:Image = new Image( Assets.getTexture("end_bg_placar") );
		private const playAgainBtn:Button = new Button( Assets.getTexture("end_bt_playagain_pt") );
		//private const ranking:Button = new Button( Assets.getTexture("ranking") );

		private var score:TextField;

		//private var screenName:TextField;
		
		public function ScreenGameOver()
		{
			super();
			
			bkg.touchable = false;
			
			addChild( bkg );
			
			scoreBkg.x = Starling.current.stage.stageWidth*0.5-scoreBkg.width*0.5;
			scoreBkg.y = 400;
			scoreBkg.touchable = false;
			addChild( scoreBkg );
			
			logo.x = Starling.current.stage.stageWidth*0.5-logo.width*0.5;
			logo.y = 100;
			
			addChild( logo );
			
			playAgainBtn.x = Starling.current.stage.stageWidth*0.5-playAgainBtn.width*0.5;;
			playAgainBtn.y = 490;
			addChild( playAgainBtn );
			
			playAgainBtn.addEventListener( starling.events.Event.TRIGGERED, onClickedHandler );
			
			score = new TextField(scoreBkg.width,scoreBkg.height,"0123456789", "Arial Rounded MT Bold", 16, 0xFFFFFF);
			score.hAlign = HAlign.CENTER;
			score.vAlign = VAlign.CENTER;
			score.batchable = true;
			score.x = scoreBkg.x;
			score.y = scoreBkg.y;
			addChild( score );
			
			/*ranking.pivotX = ranking.width*0.5;
			ranking.x = bkg.width*0.5;
			ranking.y = scoreBkg.y - 75;
			addChild( ranking );
*/
			//addPlayerName("Victor Carvalho Tavernari");
			//TODO: SOLUCAO PARA FICAR NOME GENERICO!
			//

			//ranking.addEventListener( starling.events.Event.TRIGGERED, onRankingClickedHandler );
			
			Observer.dispatcher.addEventListener( CapuchinEvent.UPDATE_PLAYER_NAME, onUpdatePlayerName );
			
			this.addEventListener( starling.events.Event.ADDED_TO_STAGE, onAddedToStageHandler );
			this.addEventListener( starling.events.Event.REMOVED_FROM_STAGE, onRemovedFromStageHandler );
			
			
		}
		
		private function onUpdatePlayerName(e:starling.events.Event):void
		{
			addPlayerName( e.data as String );
		}
		
		private function onRemovedFromStageHandler(e:starling.events.Event):void
		{
			Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
		}
		
		private function keyPressed(e:KeyboardEvent):void
		{    
			if(e.keyCode == Keyboard.BACK)
			{
				e.preventDefault();
				e.stopImmediatePropagation();
				
				if(this.touchable)
				{
					onClickedHandler(null);
				}
			}            
		}
		
		private function onRankingClickedHandler(e:starling.events.Event):void
		{
			Observer.dispatcher.dispatchEvent( new CapuchinEvent(CapuchinEvent.SHOW_RANKING) );
		}
		
		private function addPlayerName(value:String):void
		{
			var point:String = "";
			
			if(value == null || value == "") 
			{
				if(ConfigModel.getData())
				{
					point = ConfigModel.getData().ranking_point.toString();
					value = " - You!";
				}else
				{
					return;
				}
				
			}else if(ConfigModel.getData())
			{
				point = ConfigModel.getData().ranking_point.toString();
				score.text = ScoreModel.score+" / "+point;
				point = "";
			}
			
			/*ranking.x = 70;
			
			if(screenName == null)
			{
				screenName = new TextField(180, 30, "","Verdana" ,20,0xFFFFFF);
				screenName.x = ranking.x+ranking.width*0.5;
				screenName.y = scoreBkg.y - 50;
				screenName.hAlign = HAlign.LEFT;
				screenName.autoScale = true;
				addChild( screenName );
			}
			
			screenName.text = point+""+value;*/
		}
		
		private function onAddedToStageHandler(e:starling.events.Event):void
		{
			Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			this.touchable = true;
			score.text = String(ScoreModel.score);
			this.y = this.stage.stageHeight;
			
			var tw:Tween = new Tween( this, 0.3, Transitions.EASE_OUT);
			tw.moveTo(this.x, 0);
			tw.onComplete = function():void
			{
				System.gc();
			}
			
			Starling.juggler.add( tw );
			
		}
		
		private function onClickedHandler(e:starling.events.Event):void
		{
			
			Starling.juggler.removeTweens( this );
			
			this.touchable = false;
			
			var tw:Tween = new Tween(this,1.5, Transitions.EASE_OUT);
			tw.moveTo(0,this.stage.stageHeight);
			
			tw.onStart = Observer.dispatcher.dispatchEvent;
			tw.onStartArgs = [new CapuchinEvent(CapuchinEvent.PLAY_AGAIN_CLICKED)];
			
			tw.onComplete = parent.removeChild;
			tw.onCompleteArgs = [this];
			
			Starling.juggler.add( tw );
		}
	}
}
package com.taverna.capuchin.screen
{
	import com.taverna.capuchin.CapuchinEvent;
	import com.taverna.capuchin.Observer;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public final class CrazyFallHomeScreen extends Sprite
	{
		private const _bkg:Image = new Image(Assets.getTexture("home_bg"));
		private const _crazyFallCharImage:Image = new Image(Assets.getTexture("home_logo_item"));
		private const _crazyFallTextImage:Image = new Image(Assets.getTexture("home_logo_text"));
		private const _startBtn:Button = new Button(Assets.getTexture("home_start_btn"));
		
		public function CrazyFallHomeScreen()
		{
			super();
			
			createScreen();
			
			this.addEventListener( Event.ADDED_TO_STAGE, onAddedToStageHandler );
		}
		
		private function onAddedToStageHandler(e:Event):void
		{
			_bkg.alpha = 0;
			Starling.juggler.tween( _bkg, 0.2, {alpha:1});
			_crazyFallCharImage.alpha = 0;
			_startBtn.scaleX = _startBtn.scaleY = 0;
			_crazyFallTextImage.scaleX = _crazyFallTextImage.scaleY = 0;
			
			Starling.juggler.delayCall( startAnimation, 0.5);
		}
		
		private function startAnimation():void
		{
			var posY:Number = _crazyFallCharImage.y;
			_crazyFallCharImage.y = _crazyFallCharImage.y+20;

			var tw:Tween = new Tween(_crazyFallCharImage, 0.5);
			tw.moveTo( _crazyFallCharImage.x, posY );
			tw.fadeTo(1);
			tw.onComplete = function():void
			{
				var tw2:Tween = new Tween(_startBtn, 0.4, Transitions.EASE_OUT_BACK);
				tw2.scaleTo(1);
				tw2.delay = 0.3;
				
				Starling.juggler.add( tw2 );
				
				var tw3:Tween = new Tween(_crazyFallTextImage, 0.4, Transitions.EASE_OUT_BACK);
				tw3.scaleTo(1);
				
				Starling.juggler.add( tw3 );
				
			}
			Starling.juggler.add( tw );
			
			this.touchable = true;
		}
		
		private function createScreen():void
		{
			addChild( _bkg );
			
			addChild( _crazyFallCharImage );
			_crazyFallCharImage.pivotX = _crazyFallCharImage.width*0.5;
			_crazyFallCharImage.pivotY = _crazyFallCharImage.height*0.5;
			_crazyFallCharImage.x = _bkg.width*0.5;
			_crazyFallCharImage.y = _bkg.height*0.4;

			addChild( _crazyFallTextImage );
			_crazyFallTextImage.pivotX = _crazyFallTextImage.width*0.5;
			_crazyFallTextImage.pivotY = _crazyFallTextImage.height*0.5;
			_crazyFallTextImage.x = _bkg.width*0.5;
			_crazyFallTextImage.y = _bkg.height*0.6;

			addChild( _startBtn );
			_startBtn.pivotX = _startBtn.width*0.5;
			_startBtn.pivotY = _startBtn.height*0.5;
			_startBtn.x = _crazyFallCharImage.x;
			_startBtn.y = _crazyFallTextImage.y+(_crazyFallTextImage.height);
			
			_startBtn.addEventListener( Event.TRIGGERED, onClickedHandler );
		}
		
		private function onClickedHandler(e:Event):void
		{
			Observer.dispatcher.dispatchEvent( new CapuchinEvent(CapuchinEvent.START_BTN_CLICKED) );
			
			this.touchable = false;
		}
	}
}
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
	
	public final class ScreenCapuchinStart extends Sprite
	{
		private const _bkg:Image = new Image(Assets.getTexture("bg_start"));
		private const _capuchinImage:Image = new Image(Assets.getTexture("capuchin_start"));
		
		private const _helpBtn:Button = new Button(Assets.getTexture("help_btn"));
		private const _configBtn:Button = new Button(Assets.getTexture("config_btn"));
		private const _startBtn:Button = new Button(Assets.getTexture("btn_start"));
		
		
		
		public function ScreenCapuchinStart()
		{
			super();
			
			createScreen();
			
			this.addEventListener( Event.ADDED_TO_STAGE, onAddedToStageHandler );
		}
		
		private function onAddedToStageHandler(e:Event):void
		{
			_bkg.alpha = 0;
			Starling.juggler.tween( _bkg, 0.2, {alpha:1});
			_capuchinImage.alpha = 0;
			_startBtn.scaleX = _startBtn.scaleY = 0;
			
			Starling.juggler.delayCall( startAnimation, 0.5);
		}
		
		private function startAnimation():void
		{
			var posY:Number = _capuchinImage.y;
			_capuchinImage.y = _capuchinImage.y+20;

			var tw:Tween = new Tween(_capuchinImage, 0.5);
			tw.moveTo( _capuchinImage.x, posY );
			tw.fadeTo(1);
			tw.onComplete = function():void
			{
				var tw2:Tween = new Tween(_startBtn, 0.4, Transitions.EASE_OUT_BACK);
				tw2.scaleTo(1);
				
				Starling.juggler.add( tw2 );
				
			}
			Starling.juggler.add( tw );
			
			this.touchable = true;
		}
		
		private function createScreen():void
		{
			addChild( _bkg );
			
			addChild( _capuchinImage );
			_capuchinImage.pivotX = _capuchinImage.width*0.5;
			_capuchinImage.pivotY = _capuchinImage.height*0.5;
			_capuchinImage.x = _bkg.width*0.5;
			_capuchinImage.y = _bkg.height*0.4;
			
			addChild( _startBtn );
			_startBtn.pivotX = _startBtn.width*0.5;
			_startBtn.pivotY = _startBtn.height*0.5;
			_startBtn.x = _capuchinImage.x;
			_startBtn.y = _capuchinImage.y+(_capuchinImage.height*0.5)+50;
			
			_startBtn.addEventListener( Event.TRIGGERED, onClickedHandler );
		}
		
		private function onClickedHandler(e:Event):void
		{
			Observer.dispatcher.dispatchEvent( new CapuchinEvent(CapuchinEvent.START_BTN_CLICKED) );
			
			this.touchable = false;
		}
	}
}
package com.taverna.capuchin.screen
{
	import flash.desktop.NativeApplication;
	import flash.events.KeyboardEvent;
	import flash.media.SoundMixer;
	import flash.ui.Keyboard;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.events.Event;

	public final class ScreenPauseIndicatorAndroid extends ScreenPauseIndicator
	{
		private const exitBtn:Button = new Button( Assets.getTexture("exit_btn") );
		
		public function ScreenPauseIndicatorAndroid()
		{
			super();
			
			Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
		}
		
		override protected function onRemovedFromStageHandler(e:Event):void
		{
			Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
		}
		
		override protected function createView():void
		{
			super.createView();
			
			exitBtn.pivotX = exitBtn.width*0.5;
			exitBtn.x = _bkg.width*0.5;
			exitBtn.y = muteMusic.y + 70;
			addChild( exitBtn );

			exitBtn.addEventListener( starling.events.Event.TRIGGERED, onExitBtnClickedHandler );
		}
		
		private function keyPressed(e:KeyboardEvent):void
		{    
			if(e.keyCode == Keyboard.BACK )
			{
				e.preventDefault();
				e.stopImmediatePropagation();
				
				if(ranking.touchable)
				{
					onStartBtnClickedHandler(null);
				}
			}            
		}
		
		
		private function onExitBtnClickedHandler(e:starling.events.Event):void
		{
			SoundMixer.stopAll();
			Starling.current.stop(true);
			Starling.current.dispose();
			NativeApplication.nativeApplication.exit();
		}
	}
}
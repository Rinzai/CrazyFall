package com.taverna.capuchin.screen
{
	import com.taverna.capuchin.CapuchinEvent;
	import com.taverna.capuchin.Observer;
	import com.taverna.capuchin.helpers.AnalyticsHelper;
	
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	public class ScreenPauseIndicator extends Sprite
	{
		protected var _bkg:Shape;
		protected var startBtn:Button;
		
		private var _1:Image;
		private var _2:Image;
		private var _3:Image;
		
		private var _resumeIntervalId:int;
		private var _resumeCount:int = 3;

		private var timeoutBanner:int;
		
		protected var screenName:TextField;
		
		//protected const ranking:Button = new Button( Assets.getTexture("ranking") );
		
		protected const unmuteMusic:Button = new Button( Assets.getTexture("unmute_music") );
		protected const muteMusic:Button = new Button( Assets.getTexture("mute_music") );
		
		protected const unmuteFX:Button = new Button( Assets.getTexture("unmute_effects") );
		protected const muteFX:Button = new Button( Assets.getTexture("mute_effects") );
		
		public function ScreenPauseIndicator()
		{
			super();
			
			this.addEventListener( starling.events.Event.ADDED_TO_STAGE, onAddedToStageHandler );
			this.addEventListener( starling.events.Event.REMOVED_FROM_STAGE, onRemovedFromStageHandler );
			
		}

		private function updateVolume():void
		{
			if(Assets.isMuteFX() == false)
			{
				unmuteFX.visible = true;
				muteFX.visible = false;
			}else
			{
				unmuteFX.visible = false;
				muteFX.visible = true;
			}
			
			if(Assets.isMuteMusic() == false)
			{
				unmuteMusic.visible = true;
				muteMusic.visible = false;
			}else
			{
				unmuteMusic.visible = false;
				muteMusic.visible = true;
			}
		}
		
		protected function onRemovedFromStageHandler(e:starling.events.Event):void
		{
		}
		
		protected function createView():void
		{
			startBtn = new Button(Assets.getTexture("start_grande"));
			startBtn.addEventListener( starling.events.Event.TRIGGERED, onStartBtnClickedHandler );
			
			_bkg = new Shape();
			_bkg.graphics.beginFill(0x00000,0.7);
			_bkg.graphics.drawRect(0,0, stage.stageWidth, stage.stageHeight );
			_bkg.graphics.endFill();
			addChild( _bkg );
			
			startBtn.pivotX = startBtn.width*0.5;
			startBtn.pivotY = startBtn.height*0.5;
			
			startBtn.x = stage.stageWidth*0.5;
			startBtn.y = stage.stageHeight*0.3;
			addChild( startBtn );
			
			_1 = getNumberImage("resume_1");
			_2 = getNumberImage("resume_2");
			_3 = getNumberImage("resume_3");
			
			_1.visible = false;
			_2.visible = false;
			_3.visible = false;
			
			addChild( _1 );
			addChild( _2 );
			addChild( _3 );
			
			//ranking.pivotX = ranking.width*0.5;
			//ranking.x = _bkg.width*0.5;
			//ranking.y = startBtn.y+95;
			//addChild( ranking );
			
			unmuteFX.pivotX = unmuteFX.width*0.5;
			unmuteFX.x = _bkg.width*0.5;
			unmuteFX.y = startBtn.y+95 +110;
			addChild( unmuteFX );
			
			muteFX.pivotX = muteFX.width*0.5;
			muteFX.x = _bkg.width*0.5;
			muteFX.y = startBtn.y+95 + 110;
			addChild( muteFX );
			
			unmuteMusic.pivotX = unmuteMusic.width*0.5;
			unmuteMusic.x = _bkg.width*0.5;
			unmuteMusic.y = muteFX.y + 55;
			addChild( unmuteMusic );
			
			muteMusic.pivotX = muteMusic.width*0.5;
			muteMusic.x = _bkg.width*0.5;
			muteMusic.y = muteFX.y + 55;
			addChild( muteMusic );
			
			unmuteFX.addEventListener( starling.events.Event.TRIGGERED, onUnmuteClickedHandler );
			unmuteMusic.addEventListener( starling.events.Event.TRIGGERED, onUnmuteClickedHandler );
			
			muteFX.addEventListener( starling.events.Event.TRIGGERED, onMuteClickedHandler );
			muteMusic.addEventListener( starling.events.Event.TRIGGERED, onMuteClickedHandler );
			
			//addPlayerName("Victor Carvalho Tavernari");
			//ranking.addEventListener( starling.events.Event.TRIGGERED, onRankingClickedHandler );
			
			Observer.dispatcher.addEventListener( CapuchinEvent.UPDATE_PLAYER_NAME, onUpdatePlayerName );

		}
		
		private function onAddedToStageHandler(e:starling.events.Event):void
		{
			if(_bkg == null)
			{
				createView();
			}
			
			updateVolume();
			//ranking.touchable = true;
			AnalyticsHelper.trackView("PAUSE INDICATOR SCREEN");
			
		}
		
		private function onUpdatePlayerName(e:starling.events.Event):void
		{
			addPlayerName( e.data as String );
		}
		
		private function onMuteClickedHandler(e:starling.events.Event):void
		{
			if(e.currentTarget == muteFX)
			{
				Assets.unmuteFX();
			}else if(e.currentTarget == muteMusic)
			{
				Assets.unmuteMusic(true);
			}
			
			updateVolume()
		}
		
		private function onUnmuteClickedHandler(e:starling.events.Event):void
		{
			if(e.currentTarget == unmuteFX)
			{
				Assets.muteFX();
			}else if(e.currentTarget == unmuteMusic)
			{
				Assets.muteMusic(true);
			}
			
			updateVolume();
		}
		
		private function addPlayerName(value:String):void
		{
			if(value == null || value == "") return;
			
			//ranking.x = 70;
			
			if(screenName == null)
			{
				screenName = new TextField(180, 30, "","Verdana" ,15,0xFFFFFF);
				//screenName.x = ranking.x+ranking.width*0.5;
				//screenName.y = ranking.y + 20;
				screenName.hAlign = HAlign.LEFT;
				screenName.autoScale = true;
				addChild( screenName );
			}
			
			screenName.text = value;
		}
		
		private function onRankingClickedHandler(e:starling.events.Event):void
		{
			Observer.dispatcher.dispatchEvent( new CapuchinEvent( CapuchinEvent.SHOW_RANKING ) );
		}
		
		private function getNumberImage(textureName:String):Image
		{
			var img:Image = new Image(Assets.getTexture(textureName));
			img.pivotX = img.width*0.5;
			img.pivotY = img.height*0.5;
			img.x = stage.stageWidth*0.5;
			img.y = stage.stageHeight*0.3;
			img.touchable = false;
			return img;
		}
		
		protected function onStartBtnClickedHandler(e:starling.events.Event):void
		{
			if(startBtn.touchable == false) return;
			
			startBtn.touchable = false;
			//ranking.touchable = false;
			
			var tw:Tween = new Tween(startBtn, 0.9, Transitions.EASE_IN);
			tw.scaleTo( 0 );
			tw.onComplete = function():void
			{
				startBtn.visible = false;
				startBtn.scaleX = startBtn.scaleY = 1;
				_resumeIntervalId = setInterval( countDown, 1000 );
				countDown();
			}
				
			Starling.juggler.add( tw );
		}
		
		private function countDown():void
		{
			_1.visible = false;
			_2.visible = false;
			_3.visible = false;
			
			var currImg:Image;
			
			switch(_resumeCount)
			{
				case 3:
				{
					currImg = _3;	
					break;
				}
					
				case 2:
				{
					currImg = _2;	
					break;
				}
					
				case 1:
				{
					currImg = _1;	
					break;
				}
					
				default:
				{
					clearInterval( _resumeIntervalId );	
					_resumeCount = 3;
					startBtn.visible = true;
					if(this.parent)
					{
						this.parent.removeChild( this );
					}
					
					Observer.dispatcher.dispatchEvent( new CapuchinEvent(CapuchinEvent.RESUME_GAME));
					return;
					break;
				}
			}
					
			currImg.scaleX = currImg.scaleY = 1.5;
			currImg.visible = true;
			
			var tw:Tween = new Tween(currImg,0.8,Transitions.EASE_OUT_ELASTIC);
			tw.scaleTo(1);
			tw.onComplete = function():void
			{
				var tw2:Tween = new Tween( currImg, 0.2 );
				tw2.fadeTo(0);
				tw2.onComplete = function():void
				{
					currImg.visible = false;
					currImg.alpha = 1;
				}
				
				Starling.juggler.add( tw2 );
			}
			
			Starling.juggler.add(tw);
			
			_resumeCount--
		}
	}
}
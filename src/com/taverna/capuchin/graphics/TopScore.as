package com.taverna.capuchin.graphics
{
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.extensions.PDParticleSystem;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public final class TopScore extends Sprite
	{
		
		public const btnPause:Button = new Button( Assets.getTexture("pause") );
		
		public const unmute:Button = new Button( Assets.getTexture("unmute") );
		public const mute:Button = new Button( Assets.getTexture("mute") );

		private const score:TextField = new TextField(230,20,"0123456789", "Arial Rounded MT Bold", 16, 0xFFFFFF);

		private var shinePs:PDParticleSystem;
		
		public function TopScore()
		{
			super();
			
			addChild( new Image(Assets.getTexture("topo")) );
			
			btnPause.pivotX = btnPause.width*0.5;
			btnPause.pivotY = btnPause.height*0.5;
			btnPause.x = Starling.current.stage.stageWidth - btnPause.width*0.5;
			btnPause.y = 15;
			addChild( btnPause );
			
			unmute.pivotX = unmute.width*0.5;
			unmute.pivotY = unmute.height*0.5;
			unmute.x = Starling.current.stage.stageWidth - btnPause.width - unmute.width*0.5;
			unmute.y = 15;
			addChild( unmute );
			
			mute.pivotX = mute.width*0.5;
			mute.pivotY = mute.height*0.5;
			mute.x = Starling.current.stage.stageWidth - btnPause.width - mute.width*0.5;
			mute.y = 15;
			addChild( mute );
			
			score.hAlign = HAlign.LEFT;
			score.vAlign = VAlign.CENTER;
			score.batchable = true;
			score.x = 50;
			score.y = 8;
			score.touchable = false;
			addChild( score );
			
			updateBtnsVolume();
		}
		
		public function updateScore(value:String):void
		{
			score.text = value;
		}
		
		public function updateBtnsVolume():void
		{
			if(Assets.isMuteFX() && Assets.isMuteMusic())
			{
				mute.visible = true;
				unmute.visible = false;
			}else
			{
				mute.visible = false;
				unmute.visible = true;
			}
		}
	}
}
package com.taverna.capuchin.graphics
{
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public final class BottomFire extends Sprite
	{
		private var fire:MovieClip;
		
		private var body:Body;
		
		public function BottomFire()
		{
			super();
			
			this.touchable = false;
			
			fire = new MovieClip(Assets.getTextures("game_agua_"));
			addChild( fire );
			CapuchinGame.juggler.add( fire );	
			fire.play();
			this.addEventListener( Event.ADDED_TO_STAGE, onAddedToStageHandler );
			
			
			this.pivotX = (this.width*0.5)-38;
			this.pivotY = (this.height*0.5)+28;
		}
		
		private function onAddedToStageHandler(e:Event):void
		{
			var pos:Vec2 = new Vec2(this.x, this.y);
			
			body = Nape.createBody("game_agua_01", this);
			body.type = BodyType.KINEMATIC;
			body.allowMovement = true;
			body.allowRotation = false;
			body.space = CapuchinGame.space;
			body.position = pos;
			body.mass = 0;
			body.velocity = Vec2.weak(0,0);
		}
		
		override public function set y(value:Number):void
		{
			super.y = value;
		}
	}
}
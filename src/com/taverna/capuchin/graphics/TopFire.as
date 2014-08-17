package com.taverna.capuchin.graphics
{
	import nape.callbacks.InteractionType;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public final class TopFire extends Sprite
	{
		private var body:Body;
		
		public function TopFire()
		{
			super();
			
			this.touchable = false;
			this.addEventListener( Event.ADDED_TO_STAGE, onAddedToStageHandler );
			
			this.pivotX = this.width*0.5+32;
			this.pivotY = 28;
			
			this.y = -400;
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
			body.interactingBodies( InteractionType.SENSOR );
			body.velocity = Vec2.weak(0,0);
		}
	}
}
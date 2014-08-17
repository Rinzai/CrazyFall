package com.taverna.capuchin.graphics
{
import flash.geom.Rectangle;

import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.Material;

import starling.animation.DelayedCall;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.MovieClip;
import starling.display.Sprite;
import starling.events.Event;
	
	public final class Monkey extends Sprite
	{
		
		private static const POINT_TO_ACAI:Number = 0.02;
		private const MAX_SHIELD:Number = 10;
		
		private var _currMonkeyImage:DisplayObject;

        private var _bounds:Rectangle = new Rectangle();

        private var _capuchinBody:Body;
		
        public var isWalking:Boolean;
		
		private const game_char:Sprite = new Sprite();
		private const game_char_fall_image:Image = new Image(Assets.getTexture("game_char_fall"));
		private const game_water_left:MovieClip = new MovieClip(Assets.getTextures("game_water_left"));
		private const game_water_right:MovieClip = new MovieClip(Assets.getTextures("game_water_right"));
		
		private const game_char_die:Image = new Image(Assets.getTexture("game_char_die"));
		private const game_char_fear:Image = new Image(Assets.getTexture("game_char_fear"));
		private const game_char_hit:Image = new Image(Assets.getTexture("game_char_hit"));
		

		private var delayedCall:DelayedCall;
		
		private var _isDie:Boolean = false;
		
		private var _velCoef:Number = 1;
		private var _incrVelCoef:Number = 0;

		public function Monkey()
		{
			_capuchinBody = Nape.createBody("player", this);
			_capuchinBody.allowMovement = true;
			_capuchinBody.allowRotation = false;
			_capuchinBody.space = CapuchinGame.space;
			_capuchinBody.setShapeMaterials( new Material(0,0,0,0,0) );
			_capuchinBody.surfaceVel = Vec2.weak(0,0);
			
			game_char.addChild( game_char_fall_image );
			game_char.addChild( game_water_left );
			game_char.addChild( game_water_right );			

			this.touchable = false;
		}
		
		private function onParticleAcaiCompletedHandler(e:Event):void
		{
			_velCoef = _incrVelCoef;
		}
		
		public function get velCoef():Number
		{
			return _velCoef;
		}


		public function get isDie():Boolean
		{
			return _isDie;
		}

		public function get body():Body
		{
			return _capuchinBody;
		}

		private function changeMonkeyImage(image:DisplayObject, valuePhysic:String):void
		{
			if(_currMonkeyImage)
			{
				if(contains( _currMonkeyImage ) )
				{
					removeChild( _currMonkeyImage );
				}
				
				_currMonkeyImage = null;
			}
			
			_currMonkeyImage = image;
			
			addChild( _currMonkeyImage );
			
			this.pivotX = this._currMonkeyImage.width*0.5;
			this.pivotY = 20;
		}
		
		private function removeWaters():void
		{
			game_water_left.visible = false;
			game_water_right.visible = false;
			
			if(CapuchinGame.juggler.contains( game_water_left )) CapuchinGame.juggler.removeTweens( game_water_left );
			if(CapuchinGame.juggler.contains( game_water_right )) CapuchinGame.juggler.removeTweens( game_water_right );
		}
		
		public function walkLeft():void
		{
			if(game_water_left.visible == false)
			{
				removeWaters();
				
				changeMonkeyImage( game_char_fear, "m_w_left" );
				
				callCapuchin();
				
				isWalking = true;
			}
		}
		
		public function walkRight():void
		{
			if(game_water_right.visible == false)
			{
				removeWaters();
				
				changeMonkeyImage( game_char_fear, "m_w_right" );
				
				callCapuchin();
				
				isWalking = true;
			}
		}
		
		public function downLeft():void
		{
			if(game_water_left.visible == false)
			{
				removeWaters();
				
				changeMonkeyImage( game_char, "m_d_left" );
				
				game_water_left.visible = true;
				CapuchinGame.juggler.add(game_water_left);
				
				
				isWalking = false;
			}
		}
		
		public function downRight():void
		{
			if(game_water_right.visible == false)
			{
				changeMonkeyImage( game_char, "m_w_left" );
				
				game_water_right.visible = true;
				CapuchinGame.juggler.add(game_water_right);
				
				isWalking = false;
			}
		}
		
		public function kill():void
		{
			changeMonkeyImage( game_char_die, "m_die_right");
		}
		
		private function callCapuchin():void
		{
			if(Math.random() > 0.90)
			{
				Assets.capuchinCallSound();
			}
		}

		public function ress():void
		{
			downLeft();
			_isDie = false;
			_capuchinBody.space = CapuchinGame.space;
		}
	}
}
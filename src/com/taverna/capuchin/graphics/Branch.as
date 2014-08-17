package com.taverna.capuchin.graphics
{
import flash.geom.Rectangle;

import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;

import starling.display.Image;
import starling.display.MovieClip;
import starling.display.Sprite;
	
	public final class Branch extends Sprite
	{
		private var branch:Image;
		
		private var _isFireBranch:Boolean = false;

        private var _bounds:Rectangle = new Rectangle();

        public var body:Body;
		
		private var _isBlueFireBranch:Boolean;
		
		private static var _vecBranchs:Vector.<Branch> = new Vector.<Branch>();
		private static var _vecFireBranchs:Vector.<Branch> = new Vector.<Branch>();
		private static var _vecBranchsInGame:Vector.<Branch> = new Vector.<Branch>();

		private var siriMovieClip:MovieClip;

		private const water:MovieClip = new MovieClip(Assets.getTextures("game_water_rock"));;

		public var bodyName:String;
		
		public function Branch(withFire:Boolean = false)
		{
			super();
			
			this.touchable = false;

			var rand:Number = Math.random();
			bodyName = "";
			
			if(rand < 0.25)
			{
				bodyName = "game_rock01";
			}else if(rand >= 0.25 && rand < 0.5)
			{
				bodyName = "game_rock02";
			}else if(rand >= 0.5 && rand < 0.75)
			{
				bodyName = "game_rock03";
			}else if(rand >= 0.75)
			{
				bodyName = "game_rock04";
			}
			
			
			branch = new Image(Assets.getTexture( bodyName ) );
			
			_isFireBranch = withFire;
			
			water.y = -14;
			water.x = 5;
			addChild( water );
			
			
			
			addChild( branch );

			if(_isFireBranch)
			{
				siriMovieClip = new MovieClip(Assets.getTextures("game_siri_"),3);
				addChild( siriMovieClip );
				siriMovieClip.y = -23;
				siriMovieClip.x = 15;
			}
			
			this.pivotX = (this.width*0.5)-2;
			this.pivotY = 17;
			
			body = Nape.createBody(bodyName, this );
			body.type = BodyType.DYNAMIC;
			body.mass = 999999999;
			body.inertia = 0;
			body.allowMovement = true;
			body.allowRotation = false;
			body.setShapeMaterials( new Material(0,0,0,0,0) );
			
			
			
		}
		
		public function get isFireBranch():Boolean
		{
			return _isFireBranch;
		}
		
		override public function dispose():void
		{
			super.dispose();

			removeAnimation();
			
			if(siriMovieClip)
			{
				removeChild( siriMovieClip );
				siriMovieClip = null;
			}
			
			if(branch)
			{
				removeChild( branch );
				branch.dispose();
				branch = null;
			}
		}
		
		
		public function removeAnimation():void
		{
			if(CapuchinGame.juggler.containsTweens( siriMovieClip )) CapuchinGame.juggler.removeTweens( siriMovieClip );
			if(CapuchinGame.juggler.containsTweens( water )) CapuchinGame.juggler.removeTweens( water );
		}
		
		public function initAnimations():void
		{
			if(siriMovieClip)
			{
				if(CapuchinGame.juggler.containsTweens( siriMovieClip ) == false) CapuchinGame.juggler.add( siriMovieClip );
				siriMovieClip.play();
			}
			if(CapuchinGame.juggler.containsTweens( water ) == false) CapuchinGame.juggler.add( water );
			water.play();
		}

		public static function saveAllBranch():void
		{
			var i:int = 0;
			var total:int = _vecBranchsInGame.length;
			var branch:Branch;
			
			for (i; i < total; i++) 
			{
				branch = _vecBranchsInGame[i];
				branch.visible = false;
				CapuchinGame.space.bodies.remove( branch.body );
				branch.removeAnimation();
				branch.body.velocity = Vec2.weak(0,0);
				branch.body.space = null;
				registerBranchCache( branch, false );
			}
			
			_vecBranchsInGame.length = 0;
		}
		
		public static function registerBranchCache(branch:Branch, removeFromGame:Boolean = true):void
		{
			var index:int = _vecBranchsInGame.indexOf( branch );
			
			if(index != -1 && removeFromGame)
			{
				_vecBranchsInGame.splice(index,1);
			}
			
			if(_vecFireBranchs.indexOf( branch ) != -1 || _vecBranchs.indexOf( branch ) != -1) return;
			
			if(branch.isFireBranch)
			{
				_vecFireBranchs.push( branch );
				//trace("guarda branch fire");
			}else
			{
				_vecBranchs.push( branch );
				//trace("guarda branch");
			}
		}
		
		public static function getFireBranch():Branch
		{
			var branch:Branch = _vecFireBranchs.shift();
			_vecBranchsInGame.push( branch );
			return branch;
		}
		
		public static function getBranch():Branch
		{
			var branch:Branch = _vecBranchs.shift();
			_vecBranchsInGame.push( branch );
			branch.initAnimations();
			return branch;
		}
		
		public static function hasFireBranchCache():Boolean
		{
			return _vecFireBranchs.length > 0;
		}
		
		public static function hasFireBranch():Boolean
		{
			return _vecBranchs.length > 0;
		}
		
		public static function cache():void
		{
			var branch:Branch;
			while( _vecBranchs.length < 15)
			{
				branch = new Branch(false);
				_vecBranchs.push( branch );
			}
			
			while( _vecFireBranchs.length < 15)
			{
				branch = new Branch(true);
				_vecFireBranchs.push( branch );
			}
			
		}
		
		
	}
}
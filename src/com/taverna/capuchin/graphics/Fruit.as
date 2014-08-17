package com.taverna.capuchin.graphics
{
	import flash.utils.Dictionary;
	
	import nape.callbacks.InteractionType;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public final class Fruit extends Sprite
	{
		public static const BACON:String = "game_bacon";
		public static const FISH:String = "game_fish";
		public static const CHICKEN:String = "game_chicken";
		
		private var fruit:Image;

		public var body:Body;
				
		private static var _fruitCache:Dictionary = new Dictionary(true);
		private static var _fruitInGame:Dictionary = new Dictionary(true);
		private static var _fruitParticlesCache:Dictionary = new Dictionary(true);

		private var _bodyKey:String;
		
		private var _fruitPoint:Number;

		public function Fruit(bodyKey:String)
		{
			super();
			
			_bodyKey = bodyKey;
			
			var rand:int = 100 * Math.random();
			var velRatio:Number = 1;
			
			this.touchable = false;
			
			
			if(_bodyKey == CHICKEN)
			{
				_fruitPoint = 10000;
			}else if(_bodyKey == BACON)
			{
				_fruitPoint = 16000;
			}else if(_bodyKey == FISH)
			{
				_fruitPoint = 11000
			}
			
			fruit = new Image( Assets.getTexture( bodyKey ) );
			addChild( fruit );
			
			this.pivotX = fruit.width*0.5;
			this.pivotY = fruit.height*0.5;
			
			body = Nape.createBody("item", this);
			body.allowRotation = false;
			body.space = CapuchinGame.space;
			body.type = BodyType.DYNAMIC;
			body.interactingBodies( InteractionType.SENSOR );
			body.velocity =  Vec2.weak(0,90*velRatio);
		}
		
		public function get fruitPoint():Number
		{
			return _fruitPoint;
		}

		public function get bodyKey():String
		{
			return _bodyKey;
		}
		
		public static function getFruit():Fruit
		{
			var fruit:Fruit;
			
			var rand:int = 100 * Math.random();
			var _bodyKey:String;
			if(rand < 10)
			{
				_bodyKey = BACON;
			}else if(rand < 60)
			{
				_bodyKey = CHICKEN;
			}else
			{
				_bodyKey = FISH;
			}
			
			if(hasFruitCache( _bodyKey ))
			{
				fruit = _fruitCache[ _bodyKey ].shift();
			}else
			{
				fruit = new Fruit( _bodyKey );
			}
			
			_fruitInGame[ _bodyKey ].push(fruit);
			
			return fruit;
		}
		
		public static function createCache():void
		{
			for (var i:int = 0; i < 10; i++) 
			{
				registerFruitCache( new Fruit("game_bacon") );
				registerFruitCache( new Fruit("game_chicken") );
				registerFruitCache( new Fruit("game_fish") );
			}
		}
		
		public static function hasFruitCache(bodyKey:String):Boolean
		{
			return _fruitCache[ bodyKey ] && _fruitCache[ bodyKey ].length > 0;
		}
		
		public static function saveFruits():void
		{
			var vec:Vector.<Fruit>;
			var fruit:Fruit;
			for each (var o:* in _fruitInGame) 
			{
				vec = o;
				
				if(vec)
				{
					for (var i:int = 0; i < vec.length; i++) 
					{
						fruit = vec[i];
						CapuchinGame.space.bodies.remove( fruit.body );
						fruit.visible = false;
						registerFruitCache(fruit, false);
					}
					
					vec.length = 0;
				}
			}
		}
		
		public static function registerFruitCache(fruit:Fruit, removeFromGame:Boolean = true):void
		{
			var bodyKey:String = fruit.bodyKey;
			var vec:Vector.<Fruit> = _fruitCache[ bodyKey ];
			var vecInGame:Vector.<Fruit> = _fruitInGame[ bodyKey ];
			
			if(vec == null)
			{
				_fruitCache[ bodyKey ] = new Vector.<Fruit>();
				_fruitInGame[ bodyKey ] = new Vector.<Fruit>();
				vec = _fruitCache[ bodyKey ];
				vecInGame = _fruitInGame[ bodyKey ];
			}
			
			var index:int = vecInGame.indexOf( fruit );
			
			if(index != -1 && removeFromGame)
			{
				vecInGame.splice( index, 1 );
			}
			
			if(vec.indexOf( fruit ) == -1)
			{
				vec.push( fruit );
			}
		}
		
	}
}
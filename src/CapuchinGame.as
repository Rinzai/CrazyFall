package
{

import com.taverna.capuchin.CapuchinEvent;
import com.taverna.capuchin.Observer;
import com.taverna.capuchin.graphics.Background;
import com.taverna.capuchin.graphics.BottomFire;
import com.taverna.capuchin.graphics.Branch;
import com.taverna.capuchin.graphics.Fruit;
import com.taverna.capuchin.graphics.Monkey;
import com.taverna.capuchin.graphics.Nape;
import com.taverna.capuchin.graphics.TopFire;
import com.taverna.capuchin.graphics.TopScore;
import com.taverna.capuchin.model.DificultModel;
import com.taverna.capuchin.model.ScoreModel;
import com.taverna.capuchin.model.vo.DificultData;

import flash.events.KeyboardEvent;
import flash.system.System;
import flash.ui.Keyboard;

import nape.callbacks.InteractionType;
import nape.dynamics.InteractionGroup;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.space.Space;
import nape.util.BitmapDebug;
import nape.util.Debug;

import starling.animation.DelayedCall;
import starling.animation.Juggler;
import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Sprite;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public final class CapuchinGame extends Sprite
	{
	
	private static const ACAI_POINT_TO_APPEAR:int = 5000;
	
        private static const PRESS_LEFT:int = 12;
        private static const PRESS_RIGHT:int = 13;
        private static const RELEASE:int = 14;
		
		private static const CAPUCHIN_WALK_LEFT:Vec2 = new Vec2(-240,30);
		private static const CAPUCHIN_WALK_RIGHT:Vec2 = new Vec2(240,30);
		private static const CAPUCHIN_RELEASE:Vec2 = new Vec2(0,150);
		
		private static const CAPUCHIN_WALK_SUPERIFICE_LEFT:Vec2 = new Vec2(-240,0);
		private static const CAPUCHIN_WALK_SUPERFICIE_RIGHT:Vec2 = new Vec2(240,0);
		private static const CAPUCHIN_STOP:Vec2 = new Vec2(0,0);
		
		private const _capuchinWalkLeft:Vec2 = new Vec2();
		private const _capuchinWalkRight:Vec2 = new Vec2();
		private const _capuchinWalkRelease:Vec2 = new Vec2();
		
		private const _capuchinWalkSuperficieLeft:Vec2 = new Vec2();
		private const _capuchinWalkSuperficieRight:Vec2 = new Vec2();
		private const _capuchinWalkSuperficieRelease:Vec2 = new Vec2();
		
		public static var juggler:Juggler = new Juggler();
		private var isPaused:Boolean = false;
		
        private var _currTouchStats:int;

        private var _capuchin:Monkey;
		private var _topFire:TopFire;
		public static var space:Space;
		private var _bottomFire:BottomFire;
		private var debug:Debug;
		private var topScore:TopScore;
		
		private var branchIntervalId:int;
		private var fruitIntervalId:int;
		
		private var frameCount:int = 0;
		private var totalTime:Number = 0;
		private var frameRate:Number = Starling.current.nativeStage.frameRate;
		private var minInteraction:int = 4;
		
		private var branchVelocity:Vec2;

		private var initCapuchinPosition:Vec2;

		private var sendBranchDelay:DelayedCall;

		private var sendFruitDelay:DelayedCall;

		private var bkg:Background;
		
		private var result:Vector.<Touch> = new Vector.<Touch>();

		private var _currMoviment:int;

		private var hasCollision:Boolean;
		
		private var bodyLeft:Body;
		private var bodyRight:Body;
		
		public function CapuchinGame()
		{
            super();
		
			
			
			this.addEventListener( starling.events.Event.ADDED_TO_STAGE, onAddedToStageHandler );
		}
		
		private function onAddedToStageHandler(e:starling.events.Event):void
		{
			this.removeEventListener( starling.events.Event.ADDED_TO_STAGE, onAddedToStageHandler );
			init();
		}
		
		private function keyPressed(e:KeyboardEvent):void
		{    
			if(e.keyCode == Keyboard.BACK )
			{
				e.preventDefault();
				e.stopImmediatePropagation();
				
				if(isPaused == false)
				{
					pause();
				}
			}            
		}
		
		private function resetCapuchinVel():void
		{
			_capuchinWalkLeft.set( CAPUCHIN_WALK_LEFT );
			_capuchinWalkRight.set( CAPUCHIN_WALK_RIGHT );
			_capuchinWalkRelease.set( CAPUCHIN_RELEASE);
			
			_capuchinWalkSuperficieLeft.set( CAPUCHIN_WALK_SUPERIFICE_LEFT );
			_capuchinWalkSuperficieRight.set( CAPUCHIN_WALK_SUPERFICIE_RIGHT );
			_capuchinWalkSuperficieRelease.set( CAPUCHIN_STOP);
		}
		
		private function init():void
		{

			space = new Space( Vec2.weak(0,0));
			
			//debug = new BitmapDebug(stage.stageWidth, stage.stageHeight,stage.color,false);
			//Starling.current.nativeOverlay.addChild(debug.display);
			//debug.display.alpha = 0.7;
			
			bkg = new Background();
			bkg.y = stage.stageHeight-bkg.height;
			addChild( bkg );
			
			_bottomFire = new BottomFire();
			_bottomFire.y = stage.stageHeight;
			_bottomFire.x = stage.stageWidth*0.5
			addChild( _bottomFire );
			
			_capuchin = new Monkey();
			_capuchin.downLeft();
			_capuchin.x = 30
			_capuchin.y = 150;
			_capuchin.body.group = new InteractionGroup(true);
			addChild( _capuchin );
			
			initCapuchinPosition = Vec2.weak( _capuchin.x, _capuchin.y);

			_topFire= new TopFire();
			_topFire.y = -50;
			_topFire.x = stage.stageWidth*0.5
		 	addChild( _topFire );
			
			bodyLeft = Nape.createBody("body_left");
			bodyLeft.mass = 10000;
			bodyLeft.velocity = Vec2.weak(0,0);
			bodyLeft.space = space;
			bodyLeft.position = Vec2.weak(-8,295);
			bodyLeft.allowMovement = false;
			bodyLeft.allowRotation = false;
			bodyLeft.type = BodyType.STATIC;
			bodyLeft.surfaceVel = Vec2.weak(140,0);
			bodyLeft.setShapeMaterials( new Material(0,0,0,0,0) );
			
			bodyRight = Nape.createBody("body_right");
			bodyRight.mass = 10000;
			bodyRight.velocity = Vec2.weak(0,0);
			bodyRight.space = space;
			bodyRight.position = Vec2.weak(bkg.width+12,295);
			bodyRight.allowMovement = false;
			bodyRight.allowRotation = false;
			bodyRight.type = BodyType.STATIC;
			bodyRight.surfaceVel = Vec2.weak(-140,0);
			bodyRight.setShapeMaterials( new Material(0,0,0,0,0) );
			
			topScore = new TopScore();
			topScore.addEventListener( starling.events.TouchEvent.TOUCH, onTopScoreButtonClickedHandler );
			addChild(topScore);
			
			resetCapuchinVel();
			
			
		}
		
		public function startGame():void
		{
			topScore.touchable = true;
			ScoreModel.resetScore();
			topScore.updateScore(ScoreModel.score.toString());
			DificultModel.selectDificult( DificultModel.MODERATE );
			
			_currTouchStats = 0;
			
			_capuchin.x = stage.stageWidth*0.5;
			_capuchin.y = 70;
			_capuchin.ress();
			_capuchin.body.velocity = CAPUCHIN_STOP.copy(true);
			_capuchin.body.mass = 1;
			_capuchin.body.surfaceVel = CAPUCHIN_STOP;
			_capuchin.body.position = Vec2.weak( _capuchin.x, _capuchin.y);
			_capuchin.body.space = space;
			
			Starling.juggler.add( juggler );
			
			configNextDificultData();
			
			Assets.playMusic();
			
			this.addEventListener( EnterFrameEvent.ENTER_FRAME, onEnterFrameHandler );
			this.addEventListener( TouchEvent.TOUCH, onTochHandler );
			Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
		}
		
		private function configNextDificultData():void
		{
			if(_capuchin.isDie) return;
			
			var dificultData:DificultData = DificultModel.getNextDificultData();

			if(sendBranchDelay)
				juggler.remove( sendBranchDelay );
			
			sendBranchDelay = new DelayedCall(sendBranch, dificultData.timeToAppearBranch, [dificultData.chanceToAppearFireBranch]);
			sendBranchDelay.repeatCount = dificultData.numBranchsInLevel;
			sendBranchDelay.addEventListener( starling.events.Event.REMOVE_FROM_JUGGLER , onFinishBranchs ); 
			
			juggler.add( sendBranchDelay );
			
			branchVelocity = Vec2.weak( 0, -1*((110)/dificultData.timeToAppearBranch));
			
			if(sendFruitDelay)
				juggler.remove( sendFruitDelay )
			
			sendFruitDelay = new DelayedCall(sendFruit, dificultData.timeToAppearFruit);
			var fruitRepeat:int = int((sendBranchDelay.totalTime*sendBranchDelay.repeatCount)/sendFruitDelay.totalTime);
			sendFruitDelay.repeatCount = fruitRepeat == 0 ? 1 : fruitRepeat;
			
			juggler.add( sendFruitDelay );
		}
		
		private function onFinishBranchs(e:starling.events.Event):void
		{
			configNextDificultData();
		}
		
		public function pause(canShowBanner:Boolean = true):void
		{
			if(_capuchin.isDie) return;
			
			Observer.dispatcher.dispatchEvent( new CapuchinEvent( CapuchinEvent.GAME_PAUSED,false,canShowBanner ) );
			
			Assets.pauseMusic();
			
			if(!isPaused){
				Starling.juggler.remove(juggler);
				isPaused = true;
			}

			if(Starling.current.nativeStage.hasEventListener(KeyboardEvent.KEY_DOWN))
			{
				Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			}
			this.removeEventListener( EnterFrameEvent.ENTER_FRAME, onEnterFrameHandler );
			//this.removeEventListener( TouchEvent.TOUCH, onTochHandler );
			System.gc();
			System.pauseForGCIfCollectionImminent(0);
			
		}
		
		private function onCloseResumeIndicatorHandler(e:starling.events.Event):void
		{
			resume();
		}
		
		public function resume():void
		{
			topScore.updateBtnsVolume();
			Assets.resumeMusic();
			
			if(isPaused){
				Starling.juggler.add(juggler);
				isPaused = false;
				topScore.touchable = true;
				Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			}
			
			this.addEventListener( EnterFrameEvent.ENTER_FRAME, onEnterFrameHandler );
		}
		
		private function onTopScoreButtonClickedHandler(e:starling.events.TouchEvent):void
		{
			var touch:Touch = e.getTouch( topScore.btnPause, TouchPhase.BEGAN );
			
			if(touch)
			{
				e.stopImmediatePropagation();
				pause();
				return;
			}
			
			touch = e.getTouch( topScore.mute, TouchPhase.BEGAN );
			
			if(touch)
			{
				e.stopImmediatePropagation();
				
				Assets.unmuteFX();	
				Assets.unmuteMusic();
				topScore.updateBtnsVolume();
				return;
			}
			
			touch = e.getTouch( topScore.unmute, TouchPhase.BEGAN );
			
			if(touch)
			{
				e.stopImmediatePropagation();
				Assets.muteFX();
				Assets.muteMusic();	
				topScore.updateBtnsVolume();
				return;
			}
			
			
		}
		
	    private function onTochHandler(e:TouchEvent):void {
	
			var touch:Touch;
			
				result.length = 0;
				e.getTouches(this,null, result);
				
				if(result.length > 0)
				{
					result.reverse();
					touch = result[0];
				}
				
			if(touch && touch.phase != TouchPhase.ENDED)
			{
				if(touch.globalX <= this.bkg.width*.23 )
				{
					_capuchin.walkLeft();
					_currTouchStats = PRESS_LEFT;
					_capuchin.body.velocity.set(_capuchinWalkLeft);
					
				}else if(touch.globalX > this.bkg.width*.77 )
				{
					_capuchin.walkRight();
					_currTouchStats = PRESS_RIGHT;
					_capuchin.body.velocity.set(_capuchinWalkRight);
				}else  if(touch.globalX < _capuchin.x && _currTouchStats != PRESS_LEFT )
				{
				    _capuchin.walkLeft();
				    _currTouchStats = PRESS_LEFT;	
					_capuchin.body.velocity.set(_capuchinWalkLeft);
				}else if(touch.globalX > _capuchin.x && _currTouchStats != PRESS_RIGHT)
				{
				    _capuchin.walkRight();
				    _currTouchStats = PRESS_RIGHT;
					_capuchin.body.velocity.set(_capuchinWalkRight);
				}
				
			}else
			{
			    if(_currTouchStats == PRESS_LEFT)
			    {
			        _capuchin.downLeft();
			    }else
			    {
			        _capuchin.downRight();
			    }
				_currTouchStats = RELEASE;
				_capuchin.body.velocity.set(_capuchinWalkRelease);
			}
	
		}

        private function onEnterFrameHandler(e:EnterFrameEvent):void
        {		
			space.step(e.passedTime);
			
			space.liveBodies.foreach(onUpdate);
			_capuchin.body.interactingBodies( InteractionType.COLLISION ).foreach( onCapuchinColisions );//.length == 0 ? updateCapuchinPosition() : null;
			_capuchin.body.interactingBodies( InteractionType.SENSOR ).foreach( onCapuchinSensor );
			
			updateCapuchinPosition();
			
			//debug.clear();
			//debug.draw(space);
			//debug.flush();
		}
		
		private function updateCapuchinPosition():void
		{
			hasCollision = false;
			
			if( _currTouchStats == PRESS_LEFT && _capuchin.body.velocity.x != _capuchinWalkLeft.x )
			{
				_capuchin.body.velocity.set(_capuchinWalkLeft);
				
			}else if( _currTouchStats == PRESS_RIGHT && _capuchin.body.velocity.x != _capuchinWalkRight.x)
			{
				_capuchin.body.velocity.set(_capuchinWalkRight);
			}else if( _currTouchStats == RELEASE && _capuchin.body.velocity.x != _capuchinWalkRelease.x)
			{
				_capuchin.body.velocity.set(_capuchinWalkRelease);
			}
		}
		
		private function onCapuchinSensor(b:Body):void
		{
			var graphic:DisplayObject = b.userData.graphic;
			if(graphic is Fruit)
			{
				var fruit:Fruit = graphic as Fruit;
				getFruit( fruit, function():void
				{
					var fruitScore:Number = fruit.fruitPoint*DificultModel.getCurrentDificultData().coefFruit;
					trace("FRUIT POINT = ", fruitScore);
					Observer.dispatcher.dispatchEvent( new CapuchinEvent( CapuchinEvent.ADD_SCORE,false, int(fruitScore) ) );
					topScore.updateScore( ScoreModel.score.toString());
				});
				
				return;
			}
			
			if(graphic is TopFire || graphic is BottomFire)
			{
				capuchinDie();
			}
			
			if(graphic is Branch)
			{
				
				this.swapChildren(graphic, _capuchin );
				
				if(Branch(graphic).isFireBranch)
				{					
					capuchinDie();
				}
				return;
			}
		}
		
		
		private function onCapuchinColisions(b:Body):void
		{
			var graphic:DisplayObject = b.userData.graphic;
			
			
			
			if(b == bodyLeft || b == bodyRight)
			{
				_capuchin.body.surfaceVel = _capuchinWalkSuperficieRelease;
				return;
			}
			
			if(graphic is Branch && Branch(graphic).isFireBranch)
			{					
				capuchinDie();
				return;
			}
			
			hasCollision = true;
			
		}
		
		private function capuchinDie():void
		{
			if(_capuchin.isDie) return;
			
			//this.removeEventListener( EnterFrameEvent.ENTER_FRAME, onEnterFrameHandler );
			this.removeEventListener( TouchEvent.TOUCH, onTochHandler );
			topScore.touchable = false;
			
			_capuchin.kill();
			Assets.pauseMusic();
			
			resetCapuchinVel();
			
			_capuchin.body.space = null;
			
			var tw:Tween = new Tween(_capuchin, 2, _capuchin.y < this.bkg.height+0.2 ? Transitions.EASE_IN_BACK : Transitions.EASE_IN);
			tw.moveTo( _capuchin.x, this.bkg.height+20);
			tw.onComplete = function():void
			{
				Fruit.saveFruits();
				Branch.saveAllBranch();
				
				juggler.advanceTime( juggler.elapsedTime );
				
				if(Starling.current.nativeStage.hasEventListener(KeyboardEvent.KEY_DOWN))
				{
					Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
				}
				
				Observer.dispatcher.dispatchEvent( new CapuchinEvent( CapuchinEvent.GAME_OVER ) );
				
				Starling.juggler.remove( tw );
			};
			
			Starling.juggler.add( tw );
			
			Assets.playDieSound();
		}
		
		private function getFruit(fruit:Fruit, onComplete:Function):void
		{
			space.bodies.remove( fruit.body );

			var twFruit:Tween = new Tween(fruit,0.4,Transitions.EASE_IN_OUT_BOUNCE);
			twFruit.scaleTo( 0 );
			twFruit.onComplete = onComplete;
			
			juggler.add( twFruit );	
			
		}
		
		private function removeFruit(fruit:Fruit):void
		{
			Fruit.registerFruitCache( fruit );
			space.bodies.remove( fruit.body );
			fruit.visible = false;
		}
		
		private function onUpdate(b:Body):void
		{
			const graphic:DisplayObject = b.userData.graphic;
			if(graphic.name != "siri")
			{
				graphic.x = b.position.x;
				graphic.y = b.position.y;
			}
			//graphic.rotation = (b.rotation * 180 / Math.PI) % 360;
			
			if(graphic is Branch)
			{
				var branch:Branch = graphic as Branch;
				if(graphic.y < 0)
				{
				
					branch.visible = false;
					space.bodies.remove( branch.body );
					Branch.registerBranchCache( branch );
				
				}
				
				
				if(branch.isFireBranch)
				{
					branch.siriBody.position = Vec2.weak( branch.x+branch.siriMovieClip.x-20, branch.y+branch.siriMovieClip.y-5);	
				}
				
				
				return;
			}
			
			if(graphic is Monkey && graphic.y > stage.stageHeight)
			{
				b.position.y = 70;
				return;
			}
			
			if(graphic is Fruit  && graphic.y > stage.stageHeight)
			{
				var fruit:Fruit = graphic as Fruit;
				removeFruit( fruit );
				return;
			}
			
		}
		
		private function sendFruit(acai:Boolean = false):void
		{
			if(_capuchin.isDie) return;
			
			var fruit:Fruit = Fruit.getFruit();
			fruit.scaleX = fruit.scaleY = 1;
			fruit.visible = true;
			fruit.alpha = 1;
			
			var fruitMidleSize:Number = fruit.width*0.5;
			
			fruit.x = Math.random()*stage.stageWidth;
			fruit.y = 50;
			
			if(fruit.x < fruit.width)
			{
				fruit.x = fruit.width+30;
			}else if(fruit.x > stage.stageWidth-fruit.width)
			{
				fruit.x = stage.stageWidth-fruit.width-30;
			}
			
			if(contains( fruit ) == false)
			{
				addChildAt( fruit, 1);
			}else
			{
				setChildIndex( fruit, 1);
			}
			
			var pos:Vec2 = Vec2.weak(fruit.x, fruit.y);
			
			fruit.body.position = pos;
			fruit.body.space = space;
		}
		
		private function sendBranch(chanceToFire:Number = 0.3):void
		{
			if(_capuchin.isDie) return;
			
			var branch:Branch;
			var isBranchFire:Boolean = (Math.random()<chanceToFire);
			var pos:Vec2;
			var _body:Body;
			
			
			if( isBranchFire && Branch.hasFireBranchCache())
			{
				branch = Branch.getFireBranch();//_vecFireBranchs.shift();
				branch.visible = true;
				
				//trace("reuse Branch Fire");
			}else if( !isBranchFire && Branch.hasFireBranch())
			{
				branch = Branch.getBranch();//_vecBranchs.shift();
				branch.visible = true;
				//trace("reuse Branch");
			}else
			{
				//trace("create Branch");
				
				branch = new Branch(isBranchFire);
				addChildAt(branch,1);
				_body = Nape.createBody(branch.bodyName, branch );
				_body.type = BodyType.DYNAMIC;
				_body.mass = 999999999;
				_body.inertia = 0;
				_body.allowMovement = true;
				_body.allowRotation = false;
				_body.setShapeMaterials( new Material(0,0,0,0,0) );
				branch.body = _body;
			}
			
			if(_body == null)
			{
				_body = branch.body;
			}
			
			var branchMidleSize:Number = branch.width*0.5;
			
			branch.visible = true;
			addChildAt( branch, 1);
			
			branch.x = Math.random()*(stage.stageWidth);
			branch.y = stage.stageHeight-45;
			
			if(branch.x < branchMidleSize+_capuchin.width)
			{
				branch.x = branch.width-branchMidleSize+2;
			}else if(branch.x > stage.stageWidth-branchMidleSize-_capuchin.width)
			{
				branch.x = stage.stageWidth-branchMidleSize;
			}
			
			
			
			branch.initAnimations();

			pos = Vec2.weak(branch.x, branch.y);
			
			_body.position = pos;
			_body.velocity = branchVelocity.copy(true);
			_body.space = space;
			
			if(branch.isFireBranch)
			{
				branch.siriBody.space = space;
			}
			
			Observer.dispatcher.dispatchEvent( new CapuchinEvent(CapuchinEvent.ADD_SCORE,false,DificultModel.getCurrentDificultData().pointPerBranch ));
			topScore.updateScore( String(ScoreModel.score) );
			
			if(ScoreModel.acaiPoint > ACAI_POINT_TO_APPEAR)
			{
				sendFruit( true );
				ScoreModel.resetAcaiPoint();
			}
	}
		
		
	}
}
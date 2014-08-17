package
{
import ash.core.Engine;

import com.taverna.capuchin.components.Display;
import com.taverna.capuchin.components.GameState;
import com.taverna.capuchin.components.Motion;
import com.taverna.capuchin.components.Position;
import com.taverna.capuchin.graphics.Branch;
	
	import flash.geom.Point;
	
	import ash.core.Entity;

	public class EntityCreator
	{
        private var engine:Engine;

		public function EntityCreator(engine:Engine)
		{
           this.engine = engine;
		}

        public function createGame() : Entity
        {
            var gameEntity : Entity = new Entity()
                    .add( new GameState() );
            engine.addEntity( gameEntity );
            return gameEntity;
        }

		public function createBranch(position:Point, velocity:Number, withFire:Boolean = false):Entity
		{
			var branch:Entity = new Entity();
			branch.add( new Position(position.x, position.y));
            branch.add( new Motion(0,velocity));
            branch.add( new Display(new Branch(withFire)) );

            engine.addEntity( branch );
			
			return branch;
			
		}
	}
}
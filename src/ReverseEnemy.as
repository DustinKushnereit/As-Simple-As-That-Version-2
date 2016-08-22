package
{
	import flash.display.MovieClip;
	import flash.events.*;
	
	public class ReverseEnemy extends MovieClip
	{
		private var _root:Object;
		private var speed:int = 3;
		
		public function ReverseEnemy()
		{
			addEventListener(Event.ADDED, beginClass);
			addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		private function beginClass(event:Event):void
		{
			_root = MovieClip(root);
		}
		
		private function enterFrame(event:Event):void
		{			
			if (hitTestObject(_root.ship))
			{
				_root.time -= 250;
				if ( _root.lives >= 1 )
				{
					removeEventListener(Event.ENTER_FRAME, enterFrame);
					_root.removeChild(this);
				}
			}
			
			if (hitTestObject(_root.theShield))
			{
				if ( _root.lives >= 1 )
				{
					removeEventListener(Event.ENTER_FRAME, enterFrame);
					_root.removeChild(this);
				}
			}
			
			if (getDistance(this.x, this.y, _root.middleObject.x+10, _root.middleObject.y+10) <= 20)
			{
				if ( _root.lives >= 1 )
				{
					removeEventListener(Event.ENTER_FRAME, enterFrame);
					_root.removeChild(this);
				}
			}
				
			if (_root.lives <= 0 )
				_root.hitEnemy = true;
			
			if(_root.hitEnemy)
			{
				removeEventListener(Event.ENTER_FRAME, enterFrame);
				_root.removeChild(this);
			}
			
			if(_root.score >= 20)
				_root.hitEnemy = true;
			
			moveToCenter();
			updateRotation();
		}
		
		public function removeListeners():void
		{
			this.removeEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		public function moveToCenter():void
		{
			if (getDistance(this.x, this.y, _root.middleObject.x, _root.middleObject.y) > 0)
			{
				travel(this, speed, getAngle(this.x, this.y, _root.middleObject.x+10, _root.middleObject.y+10));
			}
		}
		
		public function getAngle(X1:Number, Y1:Number, X2:Number, Y2:Number):Number
		{
			var direction:Number = radtoDeg(Math.atan2((Y2 - Y1), (X2 - X1)));
			
			return direction;
		}
		
		public function radtoDeg(radians:Number):Number
		{
			var degrees:Number = radians * 180 / Math.PI;
			
			return degrees;
		}
		
		public function getDistance(X1:Number, Y1:Number, X2:Number, Y2:Number):Number
		{
			var distance:Number = Math.sqrt(Math.pow((X2 - X1), 2) + Math.pow((Y2 - Y1), 2));
			
			return distance;
		}
		
		public function travel(movingObject:Object, speed:Number, dir:Number):void
		{
			var dx:Number = speed * Math.cos(dir * Math.PI / - 180);
			var dy:Number = speed * Math.sin(dir * Math.PI / - 180);
			
			movingObject.x += dx;
			movingObject.y -= dy;
		}
		
		private function updateRotation():void
		{
			var dx:Number = this.x - _root.middleObject.x;
			var dy:Number = this.y - _root.middleObject.y;
			
			var rotateTo:Number = getDegrees(getRadians(dx, dy));
			
			if (rotateTo > this.rotation + 180) rotateTo -= 360;
			if (rotateTo < this.rotation - 180) rotateTo += 360;

			var trueRotation:Number = (rotateTo - this.rotation);
			
			this.rotation += trueRotation + 15;
		}
		
		public function getRadians(deltaX:Number, deltaY:Number):Number
		{
			var r:Number = Math.atan2(deltaY, deltaX);
			
			if (deltaY < 0)
			{
				r += (2 * Math.PI);
			}
			
			return r;
		}
		
		public function getDegrees(radians:Number):Number
		{
			return (Math.floor( radians / (Math.PI / 180) ) );
		}		
	}
}
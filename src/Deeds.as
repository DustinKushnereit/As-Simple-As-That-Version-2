package 
{
	import flash.display.MovieClip;
	import flash.events.*;
	
	public class Deeds extends MovieClip
	{
		private var _root:Object;
		private var speed:int = 2;
		
		public function Deeds()
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
				if(_root.lives < 10)
					_root.lives++;
					
				if (_root.time < 7350)
					_root.time -= 250;
				
				if ( _root.lives >= 1 )
				{
					removeEventListener(Event.ENTER_FRAME, enterFrame);
					_root.removeChild(this);
					_root.makeDeed = true;
				}
			}
			
			if (this.hitTestObject(_root.middleObject))
			{
				if ( _root.lives >= 1 )
				{
					removeEventListener(Event.ENTER_FRAME, enterFrame);
					_root.removeChild(this);
					_root.makeDeed = true;
				}
			}
			
			if(_root.hitEnemy)
			{
				removeEventListener(Event.ENTER_FRAME, enterFrame);
				_root.removeChild(this);
			}
			
			moveToCenter();
		}
		
		public function removeListeners():void
		{
			this.removeEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		public function moveToCenter():void
		{
			if (getDistance(this.x, this.y, _root.middleObject.x, _root.middleObject.y) > 0)
			{
				travel(this, speed, getAngle(this.x, this.y, _root.middleObject.x, _root.middleObject.y));
			}
		}
		
		public function getAngle(X1:Number, Y1:Number, X2:Number, Y2:Number):Number
		{
			var dir:Number = radtoDeg(Math.atan2((Y2 - Y1), (X2 - X1)));
			
			return dir;
		}
		
		public function radtoDeg(radians:Number):Number
		{
			var degrees:Number = radians * 180 / Math.PI;
			
			return degrees;
		}
		
		public function getDistance(X1:Number, Y1:Number, X2:Number, Y2:Number):Number
		{
			var dist:Number = Math.sqrt(Math.pow((X2 - X1), 2) + Math.pow((Y2 - Y1), 2));
			
			return dist;
		}
		
		public function travel(movingObject:Object, speed:Number, dir:Number):void
		{
			var dx:Number = speed * Math.cos(dir * Math.PI / - 180);
			var dy:Number = speed * Math.sin(dir * Math.PI / - 180);
			
			movingObject.x += dx;
			movingObject.y -= dy;
		}
	}

}
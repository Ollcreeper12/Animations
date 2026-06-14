package{
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	
	public class SliderButton extends Sprite{
		
		private var _maxX:Number=0;
		private var _minX:Number=0;
		private var _percent:Number=0
		private var _timeout:uint;
		
		public function SliderButton():void{
			
		}
		
		public function set percent(n:Number):void{
			_percent=Math.max(0,Math.min(n,1));
			calculate();
		}
		
		public function get percent():Number{
			return _percent;
		}
		
		override public function set x(n:Number):void{
			var xn:Number=Math.max(_minX,(Math.min(_maxX,n)));
			percent=(xn-_minX)/(_maxX-_minX);
		}
		
		private function calculate():void{
			clearTimeout(_timeout);
			super.x=_minX+_percent*(_maxX-_minX);
		}
		
		public function set minX(n:Number):void{
			_minX=n;
			invalidate();
		}
		
		public function get minX():Number{
			return _minX;
		}
		
		public function set maxX(n:Number):void{
			_maxX=n;
			invalidate();
		}
		
		public function get maxX():Number{
			return _maxX;
		}
		
		public function invalidate():void{
			_timeout=setTimeout(calculate,0);
		}
	}
}
		
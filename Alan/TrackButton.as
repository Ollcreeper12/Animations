package{
	
	import flash.display.*;
	import flash.events.*;
	
	public class TrackButton extends MovieClip{
		
		private var _toggled:Boolean;
		
		public function TrackButton():void{
			addEventListener(MouseEvent.MOUSE_OVER,onOver,false,0,true);
			addEventListener(MouseEvent.MOUSE_OUT,onOut,false,0,true);
			mouseChildren=false;
			gotoAndStop(1);
		}
		
		public function get toggled():Boolean{
			return _toggled;
		}
		
		public function set toggled(b:Boolean):void{
			_toggled=b;
			if(_toggled){
				removeEventListener(MouseEvent.MOUSE_OVER,onOver);
				removeEventListener(MouseEvent.MOUSE_OUT,onOut);
				gotoAndStop(3);
			}else{
				addEventListener(MouseEvent.MOUSE_OVER,onOver,false,0,true);
				addEventListener(MouseEvent.MOUSE_OUT,onOut,false,0,true);
				gotoAndStop(1);
			}
			mouseEnabled=!_toggled;
		}
		
		private function onOver(e:MouseEvent):void{
			gotoAndStop(2);
		}
		
		private function onOut(e:MouseEvent):void{
			gotoAndStop(1);
		}
	}
}
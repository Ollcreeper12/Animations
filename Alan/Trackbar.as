package{
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.media.*;
	import com.greensock.*;
	
	public class Trackbar extends Sprite{
		
		/////////////////////////////////////////////////
		// Private properties
		/////////////////////////////////////////////////
		private var _timeout:uint;
		private var _playing:Boolean;
		private var _autohide:int=500;
		private var _hideY:int=340;
		
		/////////////////////////////////////////////////
		// Public properties
		/////////////////////////////////////////////////
		public var playBtn:PlayButton;
		public var pauseBtn:PauseButton;
		public var thumbBtn:ThumbButton;
		public var volBtn:VolumeButton;
		public var clip:MovieClip;
		public var startFrame:Number=1;
		public var showY:Number=400;
		public var hideY:Number=450;
		public var bar:Sprite;
		public var bg:Sprite;
		public var volumeBg:Sprite;
		
		/////////////////////////////////////////////////
		// Private static properties
		/////////////////////////////////////////////////
		private static var __instance:Trackbar;
		
		public function Trackbar(p_key:SingletonBlocker):void{
			playBtn.addEventListener(MouseEvent.MOUSE_DOWN,onPlayDown,false,0,true);
			pauseBtn.addEventListener(MouseEvent.MOUSE_DOWN,onPauseDown,false,0,true);
			addEventListener(Event.ENTER_FRAME,onFrame,false,0,true);
			addEventListener(Event.ENTER_FRAME,checkMousePosition,false,0,true);
			
			playBtn.buttonMode=true;
			pauseBtn.buttonMode=true;
			
			addEventListener(Event.ADDED_TO_STAGE,onAdded,false,0,true);
			
			thumbBtn.minX=59;
			thumbBtn.maxX=709;
			thumbBtn.buttonMode=true;
			thumbBtn.addEventListener(MouseEvent.MOUSE_DOWN,onThumbDown,false,0,true);
			
			volBtn.minX=663;
			volBtn.maxX=707;
			volBtn.percent=1;
			volBtn.buttonMode=true;
			volBtn.addEventListener(MouseEvent.MOUSE_DOWN,onVolDown,false,0,true);
			bar.addEventListener(MouseEvent.CLICK,onBarClick,false,0,true);

			playClip();
			y=hideY;
			visible=false;
			blendMode="layer";
		}
		
		private function onAdded(e:Event):void{
			var shape:Sprite=new Sprite();
			shape.graphics.beginFill(0x000000,0);
			shape.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
			stage.addChildAt(shape,0);
			removeEventListener(Event.ADDED_TO_STAGE,onAdded);
			stage.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut,false,0,true);
			stage.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver,false,0,true);
		}
		
		public function onMouseOut(e:Event):void{
			removeEventListener(Event.ENTER_FRAME,checkMousePosition);
			hide();
		}
		
		public function onMouseOver(e:Event):void{
			addEventListener(Event.ENTER_FRAME,checkMousePosition,false,0,true);
		}
		
		public static function get instance():Trackbar{
			if(__instance==null){
				__instance=new Trackbar(new SingletonBlocker());
			}
			return __instance;
		}
		
		public function playClip():void{
			playBtn.toggled=true;
			pauseBtn.toggled=false;
			if(clip){;
				clip.play();
			}
			_playing=true;
		}
		
		public function pauseClip():void{
			playBtn.toggled=false;
			pauseBtn.toggled=true;
			if(clip){;
				clip.stop();
			}
			_playing=false;
		}
		
		private function onPlayDown(e:MouseEvent):void{
			playClip();
		}
		
		private function onPauseDown(e:MouseEvent):void{
			pauseClip();
		}
		
		private function onBarClick(e:MouseEvent):void{
			thumbBtn.x=mouseX;
			gotoClipFrame(startFrame+int(thumbBtn.percent*(clipTotalFrames-startFrame)));
			if(_playing && clipCurrentFrame!=clip.totalFrames){
				clip.play();
			}
		}
		
		override public function set width(n:Number):void{
			var diff:Number=bg.width-n;
			volumeBg.x-=diff;
			thumbBtn.maxX-=diff;
			
			volBtn.minX-=diff;
			volBtn.maxX-=diff;
			bar.width-=diff;
			bg.width=n;
		}
		
		private function checkMousePosition(e:Event):void{
			if(!stage && !mouseChildren)return;
			
			if(stage.mouseY<_hideY && !_timeout ){
				delayHide();
			}else if(stage.mouseY>_hideY){
				show();
				clearTimeout(_timeout);
				_timeout=0;
			}
		}
		
		private function onFrame(e:Event):void{
			if(clip){
				thumbBtn.percent=(clipCurrentFrame-startFrame)/(clipTotalFrames-startFrame);
			}else{
				thumbBtn.percent=0;
			}
		}
		
		public function delayHide():void{
			_timeout=setTimeout(hide,_autohide);
		}
		
		public function hide():void{
			TweenMax.to(this,.25,{autoAlpha:0,y:hideY});
		}
		
		public function show():void{
			TweenMax.to(this,.40,{autoAlpha:1,y:showY});
		}
		
		private function onThumbDown(e:MouseEvent):void{
			removeEventListener(Event.ENTER_FRAME,onFrame);
			stage.addEventListener(MouseEvent.MOUSE_UP,onThumbUp,false,0,true);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onThumbMove,false,0,true);
			stage.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			stage.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
		}
		
		private function onThumbMove(e:MouseEvent):void{
			thumbBtn.x=mouseX;
			gotoClipFrame(startFrame+int(thumbBtn.percent*(clipTotalFrames-startFrame)));
		}
		
		private function onThumbUp(e:MouseEvent):void{
			stage.removeEventListener(MouseEvent.MOUSE_UP,onThumbUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onThumbMove);
			addEventListener(Event.ENTER_FRAME,onFrame,false,0,true);
			if(_playing && clipCurrentFrame!=clip.totalFrames){
				clip.play();
			}
			stage.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut,false,0,true);
			stage.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver,false,0,true);
		}
		
		private function onVolDown(e:MouseEvent):void{
			stage.addEventListener(MouseEvent.MOUSE_UP,onVolUp,false,0,true);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onVolMove,false,0,true);
			stage.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			stage.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
		}
		
		private function onVolMove(e:MouseEvent):void{
			volBtn.x=mouseX;
			var st:SoundTransform=new SoundTransform();
			st.volume=volBtn.percent;
			if(clip){
				clip.soundTransform=st;
			}
		}
		
		private function onVolUp(e:MouseEvent):void{
			stage.removeEventListener(MouseEvent.MOUSE_UP,onVolUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onVolMove);
			stage.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut,false,0,true);
			stage.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver,false,0,true);
		}
		
		public function get clipTotalFrames():Number{
			return clip.totalFrames;
		}
		
		public function get clipCurrentFrame():Number{
			var c:int=0;
			for(var i:String in clip.scenes){
				if(clip.scenes[i].name==clip.currentScene.name){
					c+=clip.currentFrame;
					break;
				}else{
					c+=clip.scenes[i].numFrames;
				}
			}
			return c;
		}
		
		public function gotoClipFrame(n:int):void{
			var t:int=0;
			var c:int=0;
			for(var i:String in clip.scenes){
				t=c;
				c+=clip.scenes[i].numFrames;
				if(c>=n){
					clip.gotoAndStop(Math.max(startFrame,n-t),clip.scenes[i].name);
					break;
				}
			}
			var vcam:*=parent;
		}
	}
}

internal class SingletonBlocker {};
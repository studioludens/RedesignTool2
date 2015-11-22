package com.ludens.redesigntool.events
{
	import flash.events.Event;
	import flash.geom.Point;

	public class DragEvent extends Event
	{
		public static const DRAG_START:String = "dragStart";
		public static const DRAG_MOVE:String = "dragMove";
		public static const DRAG_STOP:String = "dragStop";
		
		
		public var stageX:Number;
		public var stageY:Number;
		
		public var localX:Number;
		public var localY:Number;
		
		
		public var startPoint:Point;
		public var mousePoint:Point;
		
		public function DragEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}
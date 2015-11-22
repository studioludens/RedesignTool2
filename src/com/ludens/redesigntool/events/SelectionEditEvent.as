package com.ludens.redesigntool.events
{
	import com.ludens.data.Bounds;
	
	import flash.events.Event;

	public class SelectionEditEvent extends Event
	{
		public static const EDIT:String = "edit";
		public static const START_EDIT:String = "startEdit";
		
		public var startMoveX:Number;
		public var startMoveY:Number;
		
		public var moveX:Number;
		public var moveY:Number;
		
		public var scale:Number;
		public var bounds:Bounds;
		
		public function SelectionEditEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}
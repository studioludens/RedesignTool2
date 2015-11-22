package com.ludens.redesigntool.events
{
	import flash.events.Event;

	public class SelectionEvent extends Event
	{
		public static const SELECT:String = "select";
		public static const CLEAR:String = "clear";
		public static const DESELECT:String = "deselect";
		
		public var id:String;
		public var shiftKey:Boolean = false;
		
		public function SelectionEvent(type:String, id:String = null, shiftKey:Boolean=false, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.id = id;
			super(type, bubbles, cancelable);
		}
		
	}
}
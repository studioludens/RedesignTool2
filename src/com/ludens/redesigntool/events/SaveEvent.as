package com.ludens.redesigntool.events
{
	import flash.events.Event;

	public class SaveEvent extends Event
	{
		public static const SAVE:String = "save";
		public static const SAVED:String = "saved";
		
		public function SaveEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}
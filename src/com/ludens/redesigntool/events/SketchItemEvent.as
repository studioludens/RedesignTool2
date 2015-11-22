package com.ludens.redesigntool.events
{
	import flash.events.Event;

	public class SketchItemEvent extends Event
	{
		public static const ADD	:String = "add";
		
		public var sketchItemType:String;
		
		public function SketchItemEvent(type:String, sketchItemType:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.sketchItemType = sketchItemType;
		}
		
	}
}
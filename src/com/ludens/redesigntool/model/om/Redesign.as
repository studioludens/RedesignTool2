package com.ludens.redesigntool.model.om
{
	import com.ludens.redesigntool.model.helpers.DataTransferObject;
	
	import flash.net.registerClassAlias;
	
	import mx.utils.ObjectUtil;
	
	/**
	 * 
	 * @author ludens
	 * 
	 */
	public class Redesign extends DataTransferObject
	{
		
		public var id:int;
		public var title:String;
		public var description:String;
		public var basedOn:int;
		
		public var skinName:String = "DEFAULT_SKIN";
		
		/**
		 * an array of SketchItem objects
		 */
		public var sketchItems:Array;
		
		
		public function Redesign()
		{
			//TODO: implement function
			super();
			
			sketchItems = new Array();
		}
		
		/**
		 * Duplicates the current object  
		 * @return A duplicated object of type Redesign 
		 * 
		 */
		public function clone():Redesign
		{
			registerClassAlias( "com.ludens.redesigntool.model.om.Redesign", Redesign);
			return Redesign( ObjectUtil.copy( this ) );
		}
		
	}
}
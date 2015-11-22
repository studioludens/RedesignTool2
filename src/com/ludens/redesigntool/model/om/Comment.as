package com.ludens.redesigntool.model.om
{
	/**
	 * The base class implementation for a Comment object
	 * 
	 * <p>This is the model for a simple comment.</p>
	 * <p>Height is read-only or not implemented</p>
	 * <p>A comment has a <code>title</code> and a <code>description</code></p>
	 *  
	 * @author ludens
	 * 
	 */
	public class Comment extends SketchItem
	{
		public var title		:String;
		public var description	:String;
		public var icon			:String;
		
		public var boxWidth		:Number;
		public var boxHeight	:Number;
		
		public var boxX			:Number;
		public var boxY			:Number;
		
		public function Comment()
		{
			super();
		}
		
	}
}
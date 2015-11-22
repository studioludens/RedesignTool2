package com.ludens.redesigntool.model.om
{
	/**
	 * The base class implementation for a TextBox object
	 * 
	 * <p>This is the model for a simple text box.</p>
	 * <p>The width and height properties of a TextBox are read only</p>
	 *  
	 * @author ludens
	 * 
	 */	
	public class TextBox extends SketchItem
	{
		
		public var text:String;
		
		public function TextBox()
		{
			super();
		}
		
	}
}
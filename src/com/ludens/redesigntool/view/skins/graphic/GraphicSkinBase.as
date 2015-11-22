package com.ludens.redesigntool.view.skins.graphic
{
	import com.ludens.redesigntool.view.skins.ISkin;
	import mx.containers.Canvas;

	public class GraphicSkinBase extends Canvas implements ISkin
	{
		
		//--------------------------------------------------------------------------
	    //
	   	//  Public Properties
	  	//
		//--------------------------------------------------------------------------
		
		override public function set data(value:Object):void {
			
			_data = value;
			
			invalidateProperties();
		}
		
		override public function get data():Object {
			return _data;
		}
		
		
		//--------------------------------------------------------------------------
		//
		// 	Private Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _data			:Object;
		
		[Bindable]
		protected var _width		:Number;	// width of the image box	
		[Bindable]
		protected var _height		:Number;	// height of the image box	
		
		[Bindable]
		protected var _title	:String;	// description text of comment
		[Bindable]
		protected var _url			:String;	// indicator icon of comment
		
		protected var _titleDirty	:Boolean = false;
		

		//--------------------------------------------------------------------------
		//
		// 	Constructor
		//
	    //--------------------------------------------------------------------------

		public function GraphicSkinBase()
		{
			super();
			
			this.horizontalScrollPolicy = "off";
			this.verticalScrollPolicy   = "off";
			this.clipContent = false;
		}
		
		
		//--------------------------------------------------------------------------
	    //
	   	//  Private methods
	  	//
		//--------------------------------------------------------------------------
		
		
		protected function titleChangedHandler(e:Event):void {
			
			_titleDirty = true;
		}
		
		
		
		
		//--------------------------------------------------------------------------
	    //
	   	//  UIComponent override methods
	  	//
		//--------------------------------------------------------------------------
		
		override protected function commitProperties():void {
			
			_width		 = _data.width;
			_height		 = _data.height;
			_title 		= _data.title;
			_url 		 = _data.url;
		}
		
		
		
	}
}
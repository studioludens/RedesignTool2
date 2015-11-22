package com.ludens.redesigntool.view.skins.comment
{
	import com.ludens.redesigntool.view.skins.ISkin;
	import com.ludens.redesigntool.events.PropertyUpdateEvent;
	
	import mx.containers.Canvas;
	import mx.controls.TextArea;
	import flash.events.FocusEvent;
	
	/**
	 * The CommentSkinBase can be extended to create comment skins.
	 * The CommentSkinBase cannot act as a concrete skin.
	 * Be sure to call the CHANGE and FOCUS_OUT handlers in the concrete skins
	 * when text input is changed or out of focus so that the Comment will dispatch
	 * an event to notify others of the data change
	 */
	public class CommentSkinBase extends Canvas implements ISkin
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
		protected var _width		:Number;	// width of the  total comment object
		
		[Bindable]
		protected var _boxWidth		:Number;	// width of the comment box	
		[Bindable]
		protected var _boxX			:Number;	// x location of the comment box (relative to anchor point)	
		[Bindable]
		protected var _boxY			:Number;	// y location of the comment box (relative to anchor point)
		
		[Bindable]
		protected var _title		:String;	// title text of comment
		[Bindable]
		protected var _description	:String;	// description text of comment
		[Bindable]
		protected var _icon			:String;	// indicator icon of comment
		
		protected var _titleDirty		:Boolean = false;
		protected var _descriptionDirty	:Boolean = false;
		

		//--------------------------------------------------------------------------
		//
		// 	Constructor
		//
	    //--------------------------------------------------------------------------

		public function CommentSkinBase()
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
		
		protected function descriptionChangedHandler(e:Event):void {
			
			_descriptionDirty = true;
		}
		
		protected function focusOutTitleHandler(e:FocusEvent):void {
			
			if( _titleDirty ) {
			
				var event:PropertyUpdateEvent = new PropertyUpdateEvent( PropertyUpdateEvent.UPDATE );
				
				event.propertyName = "title";
				event.newValue = ( e.currentTarget as TextArea ).text;
				dispatchEvent( event );

				_titleDirty = false;
			}
		}
		
		protected function focusOutDescriptionHandler(e:FocusEvent):void {
			
			if( _descriptionDirty ) {
				
				var event:PropertyUpdateEvent = new PropertyUpdateEvent( PropertyUpdateEvent.UPDATE );
				event.propertyName = "description";
				event.newValue = ( e.currentTarget as TextArea ).text;
				dispatchEvent( event );
				
				_descriptionDirty = false;
			}
		}
		
		//--------------------------------------------------------------------------
	    //
	   	//  UIComponent override methods
	  	//
		//--------------------------------------------------------------------------
		
		override protected function commitProperties():void {
			
			_boxX		 = _data.boxX;
			_boxY		 = _data.boxY;
			
			_width	 	 = _data.width;
			_boxWidth	 = _data.boxWidth;
			_title 		 = _data.title;
			_description = _data.description;
			_icon 		 = _data.icon;
		}
		
	}
}
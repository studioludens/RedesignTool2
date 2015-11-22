package com.ludens.redesigntool.view.components.editor
{
	import com.ludens.redesigntool.events.ModelUpdateEvent;
	import com.ludens.redesigntool.events.PropertyUpdateEvent;
	import com.ludens.redesigntool.events.SelectionEvent;
	import com.ludens.redesigntool.view.skins.ISkin;
	import com.ludens.redesigntool.view.skins.SkinUtil;
	
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	import mx.utils.ObjectUtil;

	/**
	 * The SketchItemBaseView is the base class for every sketch item.
	 * 
	 * It's data object includes the properties:
	 * - x
	 * - y
	 * - width
	 * - height
	 * 
	 * these properties are applied in the <CODE>updateDisplayList</CODE> and
	 * will render any similarly named properties in the UIComponent's API irrelevant.
	 * This way, the consistency between the model and view is secured.
	 * 
	 * When subclassing the SketchItemBaseView, override the <CODE>updateDataProperties()</CODE>,
	 * call its super and include any properties to check for this specific subclass.
	 * Also, set <CODE>super.data</CODE> to the new value in the <CODE>set data(value:Object)</CODE>
	 * and call the <i>subclass's</i> <CODE>updateDataProperties()</CODE> afterwards.
	 * 
	 * @author: ludens
	 */
	public class SketchItemBaseView extends Canvas
	{
		//--------------------------------------------------------------------------
	    //
	    //  Class constants
	    //
	    //--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
	    //
	   	//  Public Properties
	  	//
		//--------------------------------------------------------------------------
		
		/**
		 * this is used in dragging the item across the canvas
		 * <p>It stores the starting position when beginning to drag</p>
		 */
		public var dragStartPosition:Point;
		
		
		protected var _data:Object;
		
		/**
		 * the data object contains a copy of the model's VO
		 */
		override public function set data( value:Object ):void {	
			
			_data = value;
			updateBasePropertiesWithData();
			updateSkinData();
			
			invalidateProperties();
		}
		override public function get data():Object {		
			
			//var dataCopy:Object = ObjectUtil.copy( _data ) as Object;
			//return dataCopy;
			return _data;
		}
		
		/**
		 * use this to get easy access to the id value of a data object this view represents
		 */
		public function get dataId():String {
			
			if(data.id) return data.id;
			else 		return null;
		}
		
		public function get selected():Boolean {
			return _selected;
		}
		
		public function set selected(value:Boolean):void{
			
			var changed:Boolean = false;
						
			// fire an event if something changed
			if(!_selected && value){
				changed = true;
				
			}
			_selected = value;
			
			/*
				simple implementation of selection method. 
				If selected, we apply a glow filter.
			*/	
			if( _selected ) {
				this.filters = [ new GlowFilter(0x008FCB, 0.6, 25, 25) ];
			} else {
				this.filters = [];
			}
			
			/* only fire a selectionevent when something has actually changed
			*/
			if(changed)
				dispatchEvent(new SelectionEvent(SelectionEvent.SELECT, dataId ));
			
			
		}
		
		
		//--------------------------------------------------------------------------
		//
		// 	Private Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Properties of the SketchItem <CODE>data</CODE> object
		 */
		protected var _x			:Number;
		protected var _y			:Number;
		protected var _width		:Number;
		protected var _height		:Number;
		
		protected var _skinName		:String;			// unique name of skin	
		protected var _skin			:ISkin;		 		// skin display content and style
		protected var _skinType		:String = "noType";	// needs to be set in concrete classes 
		
		protected var _selected		:Boolean;
		
		
		// this canvas holds the skin. We do it like this, so we can change the order of things afterwards
		private var _skinContainer: Canvas;
		
		//--------------------------------------------------------------------------
		//
		// 	Constructor
		//
	    //--------------------------------------------------------------------------
	    
		public function SketchItemBaseView()
		{
			super();
			_selected = false;
			
			clipContent = false;
			horizontalScrollPolicy = "off";
			verticalScrollPolicy = "off";
		}
		
		
		//--------------------------------------------------------------------------
		//
		// 	UIComponent methods
		//
	    //--------------------------------------------------------------------------	
		
		override protected function createChildren():void {
			
			super.createChildren();
			
			_skinContainer = new Canvas();
			_skinContainer.clipContent = false;
			_skinContainer.x = _skinContainer.y = 0;
			
			addChild(_skinContainer);
		}
		
		override protected function commitProperties():void {
			
			super.commitProperties();
			
			if(data) {
				
				// update skin if skinName has changed
				if( data.skinName && _skinName != data.skinName ) {
					_skinName = data.skinName;			// update skinName
					setSkinBySkinName( _skinName );		// set new skin
				}		
			}
		}
		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			// override location and size settings
			this.x = _x;
			this.y = _y;
			this.measuredWidth 	= _width;
			this.measuredHeight = _height;
		}
		
		//--------------------------------------------------------------------------
	    //
	   	//  Public methods
	  	//
		//--------------------------------------------------------------------------
	
		/**
		 * moves the object by setting the x and y values of the view's data object. 
		 * This ensures validation and no unnecessary display updates.
		 */
		public function moveByData( newX:int, newY:int ):void {
			
			// copy existing data object
			//var newData:Object = ObjectUtil.copy(data);
			var newData:Object = ObjectUtil.copy(data);
			
			// set new x & y
			newData.x = newX;
			newData.y = newY;
			
			//trace( "new position: " + newData.x + " " + newData.y );
			
			// set the data through the setter, starting the validation process
			data = newData; 
		}
		
		public function transformByData( newScale:Number ):void {
			this.scaleX = newScale;
			this.scaleY = newScale;
		}
		
		/**
		 * Returns a value indicating whether the mouse is on anything
		 * visible in this item. It checks whether the alpha value is 0,
		 * so semi-transparency is detected
		 */
		public function checkMouseOnItem( ):Boolean {
			
			var mouseOnItem:Boolean = false;
			var contentRect:Rectangle = getBounds( this );
			
			
			var bitmapData:BitmapData = new BitmapData(  contentRect.width - contentRect.x, 
														 contentRect.height - contentRect.y,
														 true, 0x00 );
			
			var matrix:Matrix = new Matrix( 1, 0, 0, 1, - contentRect.x, - contentRect.y );
			bitmapData.draw( this, matrix );
			
			var mousePixel:uint = bitmapData.getPixel32( mouseX - contentRect.x, 
														 mouseY - contentRect.y );
			if( mousePixel != 0 )
				mouseOnItem = true;
			
			return mouseOnItem;
		}
		
		//--------------------------------------------------------------------------
	    //
	   	//  Private methods
	  	//
		//--------------------------------------------------------------------------
		
		/**
		 * Checks the <CODE>data</CODE> object for specific properties.
		 * 
		 * If they exist, are of the right type and have a different value
		 * than the current sketch item's property, it applies them and
		 * will call <CODE>invalidateDisplayList()</CODE>
		 */
		protected function updateBasePropertiesWithData():void {
			
			// x
			if( data.x != _x ) {
				_x = _data.x;
				invalidateDisplayList();
			}
			
			// y
			if( data.y != _y ) {
				_y = _data.y;
				invalidateDisplayList();
			}
			
			// width	
			if( data.width != _width ) {
				_width = _data.width;
				invalidateDisplayList();
			}
			
			// height
			if( data.height != _height ) {
				_height = _data.height;
				invalidateDisplayList();
			}
		}	
		
		/**
		 * Updates the <CODE>data</CODE> object of the skin with the <CODE>Comment</CODE> data object
		 */
		protected function updateSkinData( ):void {	
			if( _skin )
				_skin.data = data;
		}
		
		/**
		 * sets the <CODE>_skin</CODE> property based on 
		 * the <CODE>_skinName</CODE> property.
		 * 
		 * Uses the SkinUtil library to get skin class.
		 * 
		 * If skin does not exist, it sets the skin to the default value.
		 */
		protected function setSkinBySkinName( skinName:String ):void {
			
			// if _skinType is not set by a concrete class, do nothing...
			if( _skinType == "noType" ) {
				
				trace( "[SketchItemBaseView] skin has no _skinType" );
				return;
			}
			// ... else, set the skin
			else {
			
				// if skin is currently set...
				if( _skin )	
					// ...remove skin instance from display list
					_skinContainer.removeChild( _skin as UIComponent );				
				
				// get new skin
				var newSkinClass:Class = SkinUtil.getSkinByTypeAndName( _skinType, skinName );
				trace( newSkinClass );
				_skin = new newSkinClass();
				
				_skin.addEventListener(PropertyUpdateEvent.UPDATE, propertyUpdateHandler);
				//_skin.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				
				// if skin exists...
				if( _skin ) {
					// ...add new skin instance to display list
					_skinContainer.addChild( _skin as UIComponent);
					// and set its data if Comment has a data object
					if( data )
						_skin.data = data;
				}
			}
		}
		
		protected function propertyUpdateHandler(e:PropertyUpdateEvent):void {
			
			data[e.propertyName] = e.newValue;
			
			var event:ModelUpdateEvent = new ModelUpdateEvent( ModelUpdateEvent.UPDATE_MODEL, data );
			dispatchEvent( event );
		}
		
		/** 
		 * maybe we should move this function to the RedesignView ?
		 */
		
		/*
		private var _mouseDownShift:Boolean;
		
		protected function mouseDownHandler( e:MouseEvent ):void {
			
			// the user has clicked on this item, set selected to true
			// by setting the shapeFlag to true, we take into account the alpha layer of the item
			
			var mP:Point = localToGlobal(new Point(e.localX, e.localY));
			
			//trace("[V] SketchItemBase : shift key pressed: " + e.shiftKey);
			if(this.hitTestPoint(mP.x, mP.y, true)){
				_mouseDownShift = e.shiftKey;
				selected = true;
			}
		}*/
	}
}
package com.ludens.redesigntool.view.components.editor
{
	import com.ludens.data.Bounds;
	import com.ludens.redesigntool.events.PropertyUpdateEvent;
	import com.ludens.redesigntool.events.SelectionEditEvent;
	import com.ludens.redesigntool.events.SelectionEvent;
	import com.ludens.redesigntool.events.SketchItemEvent;
	import com.ludens.redesigntool.model.SketchItemType;
	import com.ludens.redesigntool.model.om.*;
	import com.ludens.redesigntool.view.factories.SketchItemFactory;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.containers.Canvas;
	import mx.graphics.ImageSnapshot;

	/**
	 * The RedesignView is the base class for the Redesign canvas displayed on the screen
	 * 
	 * This Canvas will hold all the SketchItemView components
	 * 
	 */
	public class RedesignView extends Canvas
	{
		
		public static const STATE_NEW_DRAWING:String = "newDrawing";
		public static const STATE_EDITING:String = "editing";
		
		//--------------------------------------------------------------------------
		//
		// 	Private Properties
		//
		//--------------------------------------------------------------------------
		
		private var _sketchItemViews:Array; // this is an array of SketchItemView objects
		
		private var _currentState	:String;
		
		/**
		 * the object that the handles are displayed with when editing items
		 */
		private var _selection:SelectionView;
		
		private var _editor:Canvas;
		
		private var _message:InstructionMessage;
		
		//--------------------------------------------------------------------------
		//
		// 	Constructor
		//
	    //--------------------------------------------------------------------------
		
		public function RedesignView()
		{
			super();
			
			this.verticalScrollPolicy = "off";
			//this.clipContent = false;
			this.horizontalScrollPolicy = "off";
			
			_sketchItemViews = new Array();
	
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);

			_editor = new Canvas();
			_editor.horizontalScrollPolicy = "off";
			_editor.verticalScrollPolicy = "off";
			
			_editor.addEventListener( MouseEvent.MOUSE_DOWN, editorMouseDownHandler );
			
			_selection = new SelectionView();
			_selection.addEventListener( SelectionEditEvent.EDIT, selectionEditedHandler );
			_selection.addEventListener( SelectionEditEvent.START_EDIT, selectionEditedHandler );
			
			_message = new InstructionMessage();
			_message.visible = false;

			_currentState = RedesignView.STATE_EDITING;

		}
		
		
		
		
		//--------------------------------------------------------------------------
	    //
	   	//  UIComponent override methods
	  	//
		//--------------------------------------------------------------------------
		
		override protected function createChildren():void {
			
			super.createChildren();
			
			addChild(_editor);
			addChild(_selection);
			addChild(_message);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			
			// if we have changed size, make sure all the elements are placed in their correct positions and 
			// send and event that we changed something
			
			_selection.data = {x: 0, y:0, width: width, height:height};
			
			_editor.width = this.width;
			_editor.height = this.height;
			
			_editor.x = 0;
			_editor.y = 0;
			
			updateHandles( new Array() );
			
		}
		
		
		//--------------------------------------------------------------------------
	    //
	   	//  Public  methods
	  	//
		//--------------------------------------------------------------------------
		
		/**
		 * this function adds a sketch item view to the display list
		 */
		public function addSketchItemView( model:SketchItem ):SketchItemBaseView {
			
			var newItem:SketchItemBaseView = SketchItemFactory.createSketchItemView( model );
			
			// add new item to array
			_sketchItemViews.push( newItem );
			// add item to child list
			_editor.addChild( newItem );
			
			return newItem;
		}
		
		public function deleteSketchItemViewById( id:String ):void {
			
			// remove it from the list of _sketchItemViews
			
			for (var i:int = 0; i < _sketchItemViews.length; i++ ){
				
				if( _sketchItemViews[i].dataId == id){
					// remove this object
					_editor.removeChild( _sketchItemViews[i] );
					// remove it from the array
					_sketchItemViews.splice(i, 1);
					
				}
				
			}
			
		}
		
		/**
		 * this function finds a sketch item view with an id matching the <code>id</code> argument
		 */
		public function getSketchItemViewById( id:String ):SketchItemBaseView {
			
			for each ( var sketchItemView:SketchItemBaseView in _sketchItemViews ){
				if( sketchItemView.dataId == id){
					// return this object
					return sketchItemView;
				}
			}
			
			return null;
		}
		
		public function get editor():Canvas {
			return _editor;
		}
		
		public function get sketchItemViews():Array {
			return _sketchItemViews;
		}
		
		public function get selectedSketchItemViews():Array {
			
			var selectedViews:Array = new Array();
			
			for each ( var sketchItemView:SketchItemBaseView in _sketchItemViews ){
				if( sketchItemView.selected){
					// return this object
					selectedViews.push( sketchItemView );
				}
			}
			
			return selectedViews;
		}
		
		
		private var _isDragging:Boolean = false;
		
		public function set isDragging( value:Boolean ):void {
			_isDragging = value;
		}
		
		public function get isDragging( ):Boolean {
			return _isDragging;
		}
		
		/**
		 * this function updates the handles display when the selection has changed.
		 * <p>Basically, we check which items are selected and give that to the objecthandles object.
		 * That is responsible for the manipulation of the items
		 * </p>
		 * 
		 */
		 
		private var _selectionBounds:Bounds;
		
		public function clearSelection():void{
			for each( var item:SketchItemBaseView in this.sketchItemViews){
				item.selected = false;
			}
			
			_selection.visible = false;
			
			//focusManager.hideFocus();
		}
		
		public function updateHandles( items:Array ):void {
			
			//trace("[V] Redesign Updating Handles " + selectedSketchItemViews.length);
			
			// wouter says: SELECTED SKETCH ITEM LIST IS NOT UPDATED BEFORE
			// APPLYING IT TO SELECTION VIEW? 
			
			if(selectedSketchItemViews.length == 0) 
				_selection.visible = false;
			else
				_selection.visible = true;
			
			_selection.selectedObjects = selectedSketchItemViews;
			
			/*
			// set the selection
			_selection.data = { 	selectionBounds: _selectionBounds,
									selectedObjects: selectedSketchItemViews
								};
			*/					
			
			
			
			
			// gather the data from the selection
			
			
		}
		
		public function setState( newState:String ):void {
			
			_currentState = newState;
			
			if( _currentState == RedesignView.STATE_NEW_DRAWING ) {
				_message.text = "press mouse to start drawing";
				_message.visible = true;
			}
		}
		
		public function getScreenShot():Bitmap {
			var bmpData:BitmapData = ImageSnapshot.captureBitmapData(_editor);
			var bmp:Bitmap = new Bitmap(bmpData);
			
			return bmp;
			
		}
		
		//--------------------------------------------------------------------------
	    //
	   	//  Private methods
	  	//
		//--------------------------------------------------------------------------
		
		/**
		 * at the moment, drawing a new item is implemented as a mouse action on the RedesignView
		 */
		private function mouseDownHandler(event:MouseEvent):void {
			
			_message.visible = false;
			
			/*
				if we have a new drawing state, fire a sketchitemevent
				
			
			*/
			if( _currentState == RedesignView.STATE_NEW_DRAWING ) {
				
				var newEvent:SketchItemEvent = new SketchItemEvent( SketchItemEvent.ADD, SketchItemType.DRAWING_ITEM );
				dispatchEvent( newEvent );
				
				_currentState = RedesignView.STATE_EDITING;
			}
		}
		
		private function editorMouseDownHandler( event:MouseEvent):void {
			
			/*
				check the selection of objects
			*/
			
			var onChild:int = 0;
			for each( var itemView:SketchItemBaseView in _sketchItemViews){
				if (itemView.checkMouseOnItem()) {
					itemView.selected = true;
					onChild++;
				}
			}
			
			//trace("[V] Redesign : selected # of children: " + onChild);
			if(onChild == 0){
				clearSelection();
				
				dispatchEvent(new SelectionEvent(SelectionEvent.CLEAR));
			}
			
		}
		
		private function mouseWheelHandler(event:MouseEvent):void {
			
			var newEvent:PropertyUpdateEvent = new PropertyUpdateEvent( PropertyUpdateEvent.UPDATE,
																		"scroll", event.delta );
			dispatchEvent( newEvent );
		}
		
		
		private var _startDragMousePos:Point;
		
		private function selectionEditedHandler( event:SelectionEditEvent ):void {
			//trace("[V] Redesign Selection edited!");
			
			if(event.type == SelectionEditEvent.START_EDIT){
				_startDragMousePos = new Point(event.startMoveX, event.startMoveY);
				//trace("[V] Redesign Selection start edit -->");
				for each( var viewItem:SketchItemBaseView in selectedSketchItemViews){
					// make sure the object saves it's original location for later use in the next
					// part of this function
					viewItem.dragStartPosition = new Point(viewItem.x, viewItem.y);
				}
			}
			
			if(event.type == SelectionEditEvent.EDIT){
				// update the positions of the selected sketch items
				for each( var item:SketchItemBaseView in selectedSketchItemViews){
					if(event.moveX && event.moveY){
						
						var moveChangeX:Number = event.moveX - _startDragMousePos.x;
						var moveChangeY:Number = event.moveY - _startDragMousePos.y;
						
						//trace("[V] Redesign Selection move -->" + moveChangeX + "," + moveChangeY);
						
						item.moveByData( item.dragStartPosition.x + moveChangeX, item.dragStartPosition.y + moveChangeY );
						
					}
						
					if(event.scale) 
						item.transformByData( event.scale );
					//item.rotateByData( event.rotation );
				}
			}
			
			
		}
		
		
		
	}
}
package com.ludens.redesigntool.view.components.editor
{
	import com.ludens.redesigntool.events.PropertyUpdateEvent;
	import com.ludens.redesigntool.view.skins.SkinUtil;
	
	import flash.events.Event;
	
	import mx.containers.Canvas;
	import mx.managers.FocusManager;
	
	/**
	 * The CommentView is the component that manages the display of a comment.
	 * 
	 * The CommentView itself does not display comment, but is assigned a skin
	 * that takes care of the visual representation of the data.
	 * 
	 * Model equivalent: Comment
	 * 
	 * @author ludens
	 */
	
	public class CommentView extends SketchItemBaseView
	{
		
		private var controls:Canvas;
		
		private var boxWidthCP:ControlPoint;
		private var boxPosCP:ControlPoint;
		
		
		override public function set selected(value:Boolean):void {
			
			super.selected = value;
			
			if(!selected) focusManager.deactivate();
			
			if( value )
				showControls();
			else
				hideControls();
		}
		
		override public function set data( value:Object ):void {
			
			// maybe this boxX and boxY updating should be done in the proxy?
			
			// update the boxX and boxY position
			// based on old and new X and Y positions (anchor point)
			if( _data ) {
				value.boxX += _data.x - value.x;
				value.boxY += _data.y - value.y;
			}
			
			super.data = value;
			
			setControlPositions();
		}
		
		//--------------------------------------------------------------------------
		//
		// 	Constructor
		//
	    //--------------------------------------------------------------------------
	    
	    public function CommentView()
		{
			super();
			
			_skinType = SkinUtil.COMMENT_TYPE;		
		}
		
		
		
		override protected function createChildren():void {
			
			super.createChildren();
			
			controls = new Canvas();
			controls.visible = false;
			controls.clipContent = false;
			addChild( controls );
			
			boxWidthCP = new ControlPoint();
			boxWidthCP.iconPath = ControlPoint.HORIZONTAL_ARROWS;
			boxWidthCP.verticalLock = true;
			boxWidthCP.addEventListener( Event.CHANGE, boxWidthChangeHandler );
			
			boxPosCP = new ControlPoint();
			boxPosCP.iconPath = ControlPoint.FOUR_ARROWS;
			boxPosCP.addEventListener( Event.CHANGE, boxPosChangeHandler );
			
			
			controls.addChild( boxWidthCP );
			controls.addChild( boxPosCP );
			
			setControlPositions();
		}
		
		protected function setControlPositions():void {
			
			if(controls) {
				boxWidthCP.x = data.boxX + data.boxWidth;
				boxWidthCP.y = data.boxY + 0.5 * data.boxHeight;
				
				boxPosCP.x = data.boxX;
				boxPosCP.y = data.boxY;	
			}
		}	
		
		protected function showControls():void {
			
			controls.visible = true;
		}
		
		protected function hideControls():void {
			
			controls.visible = false;
		}
		
		protected function boxWidthChangeHandler( event:Event ):void {
			
			var propertyEvent:PropertyUpdateEvent = new PropertyUpdateEvent( PropertyUpdateEvent.UPDATE,
																			 "width", event.currentTarget.x );																 
			this.propertyUpdateHandler( propertyEvent );
			
			var newData:Object = data;
			newData.boxWidth = event.currentTarget.x - data.boxX;
			data = newData;
		}
		
		protected function boxPosChangeHandler( event:Event ):void {
			
			var newData:Object = data;
			
			newData.boxX = boxPosCP.x;
			newData.boxY = boxPosCP.y;
			
			data = newData;
			
			var propertyEvent:PropertyUpdateEvent = new PropertyUpdateEvent( PropertyUpdateEvent.UPDATE,
																			 "boxX", boxPosCP.x );																 
			this.propertyUpdateHandler( propertyEvent );
			
		}
	}
}
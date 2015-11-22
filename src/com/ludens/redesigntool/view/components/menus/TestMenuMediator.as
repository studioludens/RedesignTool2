package com.ludens.redesigntool.view.components.menus
{
	import com.ludens.redesigntool.controller.Notifications;
	import com.ludens.redesigntool.events.DataLoadedEvent;
	import com.ludens.redesigntool.events.PropertyUpdateEvent;
	import com.ludens.redesigntool.model.AppSettingsProxy;
	import com.ludens.redesigntool.model.RedesignProxy;
	import com.ludens.redesigntool.model.SelectionProxy;
	import com.ludens.redesigntool.model.om.*;
	import com.ludens.redesigntool.view.components.editor.RedesignView;
	import com.ludens.redesigntool.view.components.editor.drawingitem.DrawingItemMediator;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class TestMenuMediator extends Mediator
	{
		public static const NAME:String = "testMenuMediator";
		
		public function TestMenuMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			// add event listeners to view component
			view.addEventListener( "addComment", sendAddCommentNotification );
			view.addEventListener( DataLoadedEvent.UPLOADED_IMAGE, sendAddImageNotification );
			view.addEventListener( "addDrawingItem", sendChangeRedesignStateNotification );
			
			view.addEventListener( "undo", sendUndoNotification );
			view.addEventListener( "redo", sendRedoNotification );
			view.addEventListener( PropertyUpdateEvent.UPDATE, propertyUpdateHandler );
			
			view.addEventListener( "deleteSelection", sendDeleteSelectionNotification );
			
			view.uploadURL = AppSettingsProxy.IMAGE_UPLOAD_PATH;
		}
		
		public function get view():TestMenu {
			return viewComponent as TestMenu;
		}
		
		override public function listNotificationInterests():Array {
			
			return [ Notifications.SELECTION_EDITED, Notifications.DRAWING_SETTINGS_CHANGED ];
		}
		
		override public function handleNotification(note:INotification):void {
			
			switch( note.getName() ) {
				
				case Notifications.SELECTION_EDITED:
					var selectionArray:Array = note.getBody() as Array;
					
					if( selectionArray.length != 0 ) {
						view.showSelectionControls();
						if( selectionArray.every( isDrawingItem ) ) { 
							view.showDrawingControls();
							// THIS IS A TEMPORARY HACK
							// the values should be retrieve from the model, not from fellow mediators
							view.setLineColor( (facade.retrieveMediator( "SketchItemMediator_" + selectionArray[0] ) as DrawingItemMediator).view.data.lineColor );
							view.setFillColor( (facade.retrieveMediator( "SketchItemMediator_" + selectionArray[0] ) as DrawingItemMediator).view.data.fillColor );
						}
					}
					else {
						view.hideDrawingControls();
						view.hideSelectionControls();
					}	
					
					break;
					
				case Notifications.DRAWING_SETTINGS_CHANGED:
						view.selectionRange = note.getBody().selectionRange;
					break;
			}
		}
		
		
		
		// sends a notification to request a new comment
		private function sendAddCommentNotification(e:Event):void {
			
			this.sendNotification( Notifications.ADD_ITEM, Comment );
		}
		
		public function sendAddImageNotification(e:DataLoadedEvent):void {
			
			
			sendNotification( Notifications.ADD_ITEM, { 
														itemClass: Graphic, 
														itemData: {
															url: AppSettingsProxy.BASE_PATH + e.imageUrl,
															width: e.imageWidth,
															height: e.imageHeight
														} 
													   } );
			
		}
		
		/*
		// sends a notification to request a new comment
		private function sendAddDrawingItemNotification(e:Event):void {
			
			this.sendNotification( Notifications.ADD_ITEM, DrawingItem );
		}
		*/
		
		private function sendChangeRedesignStateNotification(e:Event):void {
			
			this.sendNotification( Notifications.CHANGE_REDESIGN_STATE, RedesignView.STATE_NEW_DRAWING );
		}
		
		/**
		 * send a notification to request the undo action
		 * 
		 */
		private function sendUndoNotification(e:Event):void {
			
			this.sendNotification( Notifications.UNDO );
		}
		
		/**
		 * send a notification to request the redo action
		 * 
		 */
		private function sendRedoNotification(e:Event):void {
			
			this.sendNotification( Notifications.REDO );
		}
		
		/**
		 * send a notification to request a new scale ratio
		 * 
		 */
		private function sendScaleRatioChangeNotification(e:PropertyUpdateEvent):void {
			
			this.sendNotification( Notifications.CHANGE_SCALE_RATIO, e.newValue );
		}
		/**
		 * send a notification to request the deletion of all the selected items
		 * 
		 */
		private function sendDeleteSelectionNotification(e:Event):void {
			
			// get all the selected items
			//var redesignProxy:RedesignProxy = facade.retrieveProxy( RedesignProxy.NAME ) as RedesignProxy;
			
			var selectionProxy:SelectionProxy = facade.retrieveProxy( SelectionProxy.NAME ) as SelectionProxy;
			this.sendNotification( Notifications.DELETE_ITEMS, selectionProxy.selectedItems );
		}
		
		private function isDrawingItem(element:*, index:int, arr:Array):Boolean {
			
			return (facade.retrieveProxy( RedesignProxy.NAME ) as RedesignProxy).getSketchItem( element ) is DrawingItem;
		}
		
		
		protected function propertyUpdateHandler( event:PropertyUpdateEvent ):void {
			
			if( event.propertyName == "selectionRange" )
				this.sendNotification( Notifications.CHANGE_DRAWING_SETTINGS, [ { propertyName: event.propertyName,
																			 	  newValue: event.newValue } ] );
			else {	
				//var proxy:RedesignProxy = facade.retrieveProxy( RedesignProxy.NAME ) as RedesignProxy;
				//var selectionProxy:SelectionProxy = facade.retrieveProxy( SelectionProxy.NAME ) as SelectionProxy;
				
				var newProperties:Object = new Object();
				newProperties[event.propertyName] = event.newValue;
				
				sendNotification(Notifications.EDIT_ITEMS, newProperties);
				
				/*
				for each( var drawingItemId:String in selectionProxy.selectedItems ) {
					
					// THIS IS REALLY BAD (UPDATING A MEDIATOR'S VIEW FROM INSIDE ANOTHER MEDIATOR
					// this needs to update the model of the specified sketch item (ID) through a
					// command called "EditSketchItemsCommand" or "EditDrawingItemsCommand", which
					// in turn needs to be called through an EDIT_SKETCH_ITEMS or EDIT_DRAWING_ITEMS notification.
					
					
					var drawingItemMediator:DrawingItemMediator = 
								facade.retrieveMediator( "SketchItemMediator_" + drawingItemId ) as DrawingItemMediator;
					
					drawingItemMediator.view.data[event.propertyName] = event.newValue;
					// to trigger the redraw. This would be done automatically as a reaction to the model's update
					// when implemented correctly
					drawingItemMediator.view.data = drawingItemMediator.view.data; 
				}*/
			}
		}
	}
}
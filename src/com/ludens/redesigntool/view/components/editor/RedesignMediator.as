package com.ludens.redesigntool.view.components.editor
{
	import com.ludens.redesigntool.controller.Notifications;
	import com.ludens.redesigntool.events.PropertyUpdateEvent;
	import com.ludens.redesigntool.events.SelectionEvent;
	import com.ludens.redesigntool.events.SketchItemEvent;
	import com.ludens.redesigntool.model.DrawingSettingsProxy;
	import com.ludens.redesigntool.model.SketchItemType;
	import com.ludens.redesigntool.model.om.*;
	import com.ludens.redesigntool.view.factories.SketchItemFactory;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class RedesignMediator extends Mediator implements IMediator
	{
		//--------------------------------------------------------------------------
	    //
	    //  Class constants
	    //
	    //--------------------------------------------------------------------------
		
		public static const NAME:String = "redesignMediator";
		
		//--------------------------------------------------------------------------
	    //
	   	//  Public Properties
	  	//
		//--------------------------------------------------------------------------
			
		public function get view():RedesignView {
			return viewComponent as RedesignView;
		}
		
		//--------------------------------------------------------------------------
		//
		// 	Private Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		// 	Constructor
		//
	    //--------------------------------------------------------------------------
		
		public function RedesignMediator(viewComponent:Object=null)
		{
			super( NAME, viewComponent);
			
			view.addEventListener( SketchItemEvent.ADD, addSketchItemHandler);
			view.addEventListener( MouseEvent.MOUSE_DOWN, mouseDownHandler );
			view.addEventListener( PropertyUpdateEvent.UPDATE, viewPropertyUpdateEvent);
			view.addEventListener( SelectionEvent.CLEAR, selectionClearHandler );
			// dragging handlers
			//view.addEventListener( DragEvent.DRAG_START, dragStartHandler );
			//view.addEventListener( DragEvent.DRAG_MOVE, dragMoveHandler );
			//view.addEventListener( DragEvent.DRAG_STOP, dragStopHandler );
		}
		
		//--------------------------------------------------------------------------
	    //
	   	//  Public  methods
	  	//
		//--------------------------------------------------------------------------
		
		/**
		 * Returns a list of notifications the SketchItemMediator is interested in.
		 */
		override public function listNotificationInterests():Array
		{
			
			var interests:Array = [ Notifications.ITEMS_EDITED, 
									Notifications.ITEM_ADDED, 
									Notifications.CLEAR, 
									Notifications.ITEMS_DELETED,
									Notifications.SELECTION_EDITED,
									Notifications.CHANGE_REDESIGN_STATE,
									Notifications.EDIT_ITEMS,   // these are a temporary notification interests
									Notifications.DELETE_ITEMS	// (should link to the ITEM_EDITED from the model,
															    //  now it is short-looped, leaving the unused model out now)
								  ];
			
			return interests;
		}
		
		/**
		 * This function is called when a notification is sent to it
		 */
		override public function handleNotification(note:INotification):void
		{	
			
			switch ( note.getName() ) {
				
				/*
					TODO:
					- implement this function 
				*/
				case Notifications.ITEMS_EDITED:
					trace("[M] Redesign ITEMS_EDITED");
					break;
				case Notifications.ITEM_ADDED:
					var sketchItemView:SketchItemBaseView = view.addSketchItemView( note.getBody().sketchItem as SketchItem );
					facade.registerMediator( SketchItemFactory.createSketchItemMediator( sketchItemView ) );
					break;
				case Notifications.CLEAR:
					trace("[M] Redesign CLEAR");
					break;
				case Notifications.ITEMS_DELETED:
					//trace("[M] Redesign ITEMS_DELETED : " + note.getBody().itemsDeleted.length);
					for each( var id:String in note.getBody().itemsDeleted){
						// remove the mediator
						facade.removeMediator( "SketchItemMediator_" + id );
						// remove the view item
						view.deleteSketchItemViewById( id );
					}
					break;
				case Notifications.SELECTION_EDITED:
					// we should make sure that we show editing items for the selected items
					updateHandles( note.getBody() as Array );
					break;
				
				case Notifications.CHANGE_REDESIGN_STATE:
					view.setState( note.getBody() as String );
					break;
				
				// temporary notification handlers, that should be linked to
				// ITEMS_EDITED and ITEMS_DELETED when the proxies are actually updated	
				case Notifications.EDIT_ITEMS:
					//trace("[M] Redesign : EDIT ITEMS FOR HANDLES");
					updateHandles( new Array() );
					break;
				case Notifications.DELETE_ITEMS:
					// because the items have been deleted, remove the selection handles
					// should this be placed here?
					updateHandles( new Array() );
					break;
			}
		}
		
		public function getBounds():Object {
			
			//trace( view.width + " " + view.height );
			
			return { width: view.width, 
					 height: view.height };
		}
		
		/**
		 * this is a temporary function for taking a screenshot of the Redesign view component
		 */
		public function getScreenShot():Bitmap {
			return view.getScreenShot();
			
		}
		
		//--------------------------------------------------------------------------
	    //
	   	//  Private methods
	  	//
		//--------------------------------------------------------------------------
		
		/**
		 * this function deletes a sketch item view component, for example if it is not used any more
		 * 
		 * based on the id of the item
		 */
		private function deleteSketchItemView( id:String ):void {
			// get a specific sketch item from the view
			
			// delete the View and the Mediator objects
			view.deleteSketchItemViewById( id );
			
			// remove the mediator
			/*
				HOW TO GET THE NAME OF THE MEDIATOR TO BE DELETED?
			*/
			//facade.removeMediator( );
		}
		
		private function addSketchItemHandler(event:SketchItemEvent):void {
			
			if( event.sketchItemType == SketchItemType.DRAWING_ITEM )
				sendNotification( Notifications.ADD_ITEM, DrawingItem );
			
			if( event.sketchItemType == SketchItemType.COMMENT )
				sendNotification( Notifications.ADD_ITEM, Comment );
		}
		/**
		 * what we do here is trying to decide if all the sketchitems should be deselected
		 * 
		 */
		private function mouseDownHandler(e:MouseEvent):void {
			
			/*
			var onChild:Boolean = false;
			
			if(view.contains( e.target as DisplayObject )) onChild = true;
			
			trace("[M] Redesign clear = " + !onChild);
			*/
			
			/* 
			the notification arrives at the RedesignMediator 
			first, before the selected property of it's children 
			can be set. Since it relies on this (for now) to check
			whether to display the selection controls, we have to manually
			override this for the moment
			*/
			
			/*
			if(!onChild) view.clearSelection();
			
			sendNotification( Notifications.EDIT_SELECTION, { clear: ! onChild });
			*/
		}
		
		private function selectionClearHandler( event:SelectionEvent ):void{
			if( event.type == SelectionEvent.CLEAR ){
				sendNotification( Notifications.EDIT_SELECTION, { clear: true });
			}
		}
		
		private function viewPropertyUpdateEvent( event:PropertyUpdateEvent ):void {
			
			if( event.propertyName == "scroll" ) {
				var curSelectionRange:Number = facade.retrieveProxy( DrawingSettingsProxy.NAME ).getData().selectionRange;
				//var factor:Number = Math.sqrt( ( (event.newValue as Number) + 6) / 6 );
				var newSelectionRange:Number = curSelectionRange * (event.newValue as Number); 
				sendNotification( Notifications.CHANGE_DRAWING_SETTINGS, { selectionRange: newSelectionRange } );
			}
		}
		
		/**
		 * MANIPULATION FUNCTIONS
		 * 
		 * TODO:
		 * - organize them well
		 * - eventually, move them to a seperate class
		 */
		
		private function updateHandles( items:Array ):void{
			
			view.updateHandles( items );
			
		}
		
		
		
		
		
	}
}
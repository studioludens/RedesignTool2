package com.ludens.redesigntool.controller
{
	/**
	 * provides a simple class for storing the Notification constants
	 * 
	 */
	public class Notifications
	{
		/**
		 * Application Notifications 
		 */
		public static const STARTUP:String = "startup";
		public static const SHUTDOWN:String = "shutdown";
		
		public static const SAVE:String = "save";
		public static const LOAD:String = "load";
		public static const DATA_LOADED:String = "dataLoaded";
		
		public static const CHANGE_SCALE_RATIO:String = "changeScaleRatio";
		public static const SCALE_RATIO_CHANGED:String = "scaleRatioChanged";
		
		public static const CHANGE_DRAWING_SETTINGS:String = "changeDrawingSettings";
		public static const DRAWING_SETTINGS_CHANGED:String = "drawingSettingsChanged";
		
		/**
		 * @name: CHANGE_REDESIGN_STATE
		 * @description: change the state of the redesign 
		 * @args: 
		 *   - String: state
		 *     * one of RedesignView.STATE_*
		 * 
		 * @senders:
		 *   - TestMenuMediator
		 * @listeners:
		 *   - RedesignMediator
		 * @commands:
		 *   - ?
		 */
		public static const CHANGE_REDESIGN_STATE:String = "changeRedesignState"; 
		
		
		/**
		 * Editor Notifications
		 */
		
		/**
		 * @name: ADD_ITEM
		 * @description: add an item to the object model
		 * @args: 
		 *   - Object:
		 *     - itemClass: Class (required)
		 * 	   - itemData:  Object (optional)
		 *       * object with zero or more properties which 
		 *         all match with one of the properties of the itemClass
		 * 
		 * @senders:
		 *   - StartupViewCommand
		 *   - RedesignMediator
		 *   - TestMenuMediator
		 *   - UploadMenuMediator
		 * @listeners:
		 *   - ?
		 * @commands:
		 *   - AddItemCommand
		 */
		public static const ADD_ITEM:String = "addItem";
		
		/**
		 * @name: ITEM_ADDED
		 * @description: an item has been added to the object model, inform the system of this. The content of the model class is added as an argument
		 * @args: 
		 *   - Object:
		 *     - sketchItem: SketchItem (required)
		 * 
		 * @senders:
		 *   - RedesignProxy
		 * @listeners:
		 *   - RedesignMediator
		 */
		public static const ITEM_ADDED:String = "itemAdded";
		
		
		/**
		 * @name: DELETE_ITEMS
		 * @description: delete one or more items from the object model
		 * @args: 
		 *   - Array:
		 *     - (elements) id:String
		 * 
		 * @senders:
		 *   - TestMenuMediator
		 * @listeners:
		 *   - RedesignMediator (REMOVE THIS ASAP!)
		 * @commands:
		 *   - DeleteItemsCommand
		 */
		public static const DELETE_ITEMS:String = "deleteItems";
		
		/**
		 * @name: ITEMS_DELETED
		 * @description: an item has been deleted from the object model, inform the system of this.
		 * @args: 
		 *   - Object
		 *     - itemsDeleted:Array
		 *       * array of ID's of Sketchitems that have been deleted
		 * 
		 * @senders:
		 *   - RedesignProxy
		 * @listeners:
		 *   - RedesignMediator
		 * @commands:
		 *   - ?
		 */
		public static const ITEMS_DELETED:String = "itemsDeleted";
		
		
		/**
		 * SketchItem Notifications
		 */	
		 
		/**
		 * @name: EDIT_ITEMS
		 * @description: edit one or more properties of items in the object model
		 * @args: 
		 *   - Object
		 *     - properties: any property that has been changed
		 * 
		 * @senders:
		 *   - Menu Mediators
		 * @listeners:
		 *   - RedesignMediator (remove)
		 *   - SketchItemMediator (remove)
		 *   - DrawingItemMediator (?) (remove)
		 * @commands:
		 *   - (EditSketchItemsCommand) (add)
		 */
		public static const EDIT_ITEMS:String = "editItems";
		
		/**
		 * @name: ITEMS_EDITED
		 * @description: one or more items have been edited in the object model, inform the system of this.
		 * @args: 
		 *   - Array:
		 *     - (elements) item:SketchItem / Object (which to use??)
		 * 
		 * @senders:
		 *   - ?
		 * @listeners:
		 *   - RedesignMediator
		 *   - SketchItemMediator
		 *   - DrawingItemMediator
		 * @commands:
		 *   - ?
		 */
		public static const ITEMS_EDITED:String = "itemsEdited";
		
		/**
		 * @name: EDIT_ITEM
		 * @description: edit one object in the model, usually sent from a SketchItem Mediator
		 * @args: 
		 *   - Object:SketchItem
		 *     * can be directly put in the model
		 * 
		 * 
		 * @senders:
		 *   - Menu Mediators
		 * @listeners:
		 *   - RedesignMediator (remove)
		 *   - SketchItemMediator (remove)
		 *   - DrawingItemMediator (?) (remove)
		 * @commands:
		 *   - (EditSketchItemsCommand) (add)
		 */
		public static const EDIT_ITEM:String = "editItem";
		
		/**
		 * @name: ITEM_EDITED (deprecated)
		 * @description: an item has been edited in the object model, inform the system of this.
		 * @args: 
		 *   - Array:
		 *     - (elements) item:SketchItem / Object (which to use??)
		 * 
		 * @senders:
		 *   - RedesignProxy
		 * @listeners:
		 *   - RedesignMediator
		 * @commands:
		 *   - ?
		 */
		// should we have a notification for a single edited item?
		public static const ITEM_EDITED:String = "itemEdited";
		
		
		public static const UNDO:String = "undo";
		public static const REDO:String = "redo";
		
		public static const CLEAR:String = "clear";
		
		/**
		 * Selection Notifications
		 */
		public static const EDIT_SELECTION			:String = "editSelection";
		public static const SELECTION_EDITED		:String = "selectionEdited";
		
		/**
		 * Comment Notifications
		 */
		//public static const EDIT_COMMENTS	:String = "editComments";
		public static const COMMENTS_EDITED	:String = "commentsEdited";
		
		/**
		 * Graphics Notifications
		 */
		//public static const EDIT_GRAPHICS	:String = "editGraphics";
		public static const GRAPHICS_EDITED	:String = "graphicsEdited";
		
		/**
		 * TextBox Notifications
		 */
		//public static const EDIT_TEXTBOXES	:String = "editTextBoxes";
		//public static const TEXTBOXES_EDITED:String = "textBoxesEdited";
		
		/**
		 * DrawingItem Notifications
		 * 
		 */
		//public static const EDIT_DRAWING_ITEMS		:String = "editDrawingItems";
		public static const DRAWING_ITEMS_EDITED	:String = "drawingItemsEdited";
		
		
		public function Notifications()
		{
		}

	}
}


		//public static const EDIT_DESCRIPTION:String = "editDescription";
		//public static const EDIT_TITLE:String = "editTitle";
		
		//public static const EDIT_BACKGROUND:String = "editBackground";
		//public static const EDIT_THEME:String = "editTheme";
		

		
		
package com.ludens.redesigntool.controller.commands
{
	import com.ludens.redesigntool.model.RedesignProxy;
	import com.ludens.redesigntool.model.om.SketchItem;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.utilities.undo.controller.UndoableCommandBase;
	
	/**
	 * 
	 * @author rulkens
	 * 
	 */
	public class AddItemCommand extends UndoableCommandBase implements ICommand
	{
		
		public function AddItemCommand()
		{
			super();
			
		}
		
		
		override public function execute(note:INotification):void
		{
			
			super.execute( note );
			registerUndoCommand( DeleteItemsCommand );
			
			
		}
		
		/**
		 * execute the AddItemCommand Command
		 * 
		 * <p>call the RedesignProxy to add a new Sketch Item with the class
		 * specified in the body of the notification.</p>
		 * 
		 */
		override public function executeCommand():void {
			
			trace(">> Item added >>");
			
			var modelClass:Class;
			var itemData:Object;
		 
			
			// get class type from note body
			/**
			 * TODO: change this to conform to the system description of handling this notification
			 */
			if(getNote().getBody() is Class){
				modelClass = getNote().getBody() as Class;
			} else {
				// if we have no direct class, assume we have extra data for the object to fill in
				modelClass = getNote().getBody().itemClass as Class;
				// the itemData is a non-typed object that contains fields corresponding to the om class
				itemData = getNote().getBody().itemData;
				
			}
			// get redesign proxy
			var redesignProxy:RedesignProxy = facade.retrieveProxy( RedesignProxy.NAME ) as RedesignProxy;	
			// request redesign proxy to make a new sketch item based on class
			var newItem:SketchItem = redesignProxy.addSketchItemByClass( modelClass, itemData );
			
			trace("[C] AddItem with id = " + newItem.id );
			
			// save the item back in the note, so we can undo it later
			getNote().setBody( [ newItem ] );
			
			
			
		}
		
		override public function getCommandName():String {
			
			return "Add Item";
			
		}
		
		
		
	}
}
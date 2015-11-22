package com.ludens.redesigntool.controller.commands
{
	import com.ludens.redesigntool.model.RedesignProxy;
	import com.ludens.redesigntool.model.SelectionProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.utilities.undo.controller.UndoableCommandBase;

	/**
	 * this command deletes a SketchItem
	 */
	public class DeleteItemsCommand extends UndoableCommandBase implements ICommand
	{
		public function DeleteItemsCommand()
		{
			super();
		}
		
		override public function execute(note:INotification):void
		{
			super.execute( note );
			registerUndoCommand( DeleteItemsCommand );
			
		}
		
		/**
		 * the getBody() has to return an array of id strings
		 */
		override public function executeCommand():void {			
			
			// get item IDs to delete
			var delItems:Array = getNote().getBody() as Array;		
			//trace("[C] DeleteItems count = " + delItems.length);
			
			// call the proxy and tell it to delete the item
			var redesignProxy:RedesignProxy = facade.retrieveProxy( RedesignProxy.NAME ) as RedesignProxy;
			
			var selectionProxy:SelectionProxy = facade.retrieveProxy( SelectionProxy.NAME ) as SelectionProxy;	
			
			
			
			// delete the items from the redesign model
			redesignProxy.deleteSketchItemsById( delItems );
			
			// remove the items from the selection array
			selectionProxy.removeSelectedItems( delItems );
			selectionProxy.notifyChange();
					
			 
			
		}
		
		override public function getCommandName():String {
			
			return "Delete Item";
		}
		
	}
}
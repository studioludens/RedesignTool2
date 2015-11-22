package com.ludens.redesigntool.controller.commands
{
	import com.ludens.redesigntool.model.RedesignProxy;
	import com.ludens.redesigntool.view.components.editor.RedesignMediator;
	
	import flash.display.Bitmap;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * This command takes care of the saving of a redesign to the server
	 * 
	 * 
	 * @author rulkens
	 * 
	 */
	public class SaveCommand extends SimpleCommand implements ICommand
	{
		
		public function SaveCommand()
		{
			super();
			
		}
		
		/**
		 * execute the Save Command
		 * 
		 * <p></p>
		 * 
		 */
		override public function execute(notification:INotification):void
		{
			trace(">> Saving redesign ...  >>");
			
			// get the redesign mediator
			var redesignMediator:RedesignMediator = facade.retrieveMediator(RedesignMediator.NAME) as RedesignMediator;
			
			
			// ask it to create a snapshot of the view
			var bmp:Bitmap = redesignMediator.getScreenShot();
			
			// capture the snapshot and save it to the server
			var redesignProxy:RedesignProxy = facade.retrieveProxy( RedesignProxy.NAME) as RedesignProxy;
			
			redesignProxy.saveBitmap(bmp);
		}
		
	}
}
package com.ludens.redesigntool.controller.commands
{
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.interfaces.ICommand;
	
	/**
	 * This command takes care of the loading of a redesign and informs the
	 * right Mediators to load the design in the View.
	 * 
	 * @author rulkens
	 * 
	 */
	public class LoadCommand extends SimpleCommand implements ICommand
	{
		
		public function LoadCommand()
		{
			super();
			
		}
		
		/**
		 * execute the Load Command
		 * 
		 * <p></p>
		 * 
		 */
		override public function execute(notification:INotification):void
		{
			trace(">> Loading redesign ...  >>");
		}
		
	}
}
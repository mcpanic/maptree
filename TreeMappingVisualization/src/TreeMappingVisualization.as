package {
	import flash.display.Sprite;

	// Convenient way to pass in compiler arguments
	// Place after import statements and before first class declaration 
	[SWF(width='1024', height='768', backgroundColor='#ffffff', frameRate='30')]
	
	public class TreeMappingVisualization extends Sprite
	{
		public function TreeMappingVisualization()
		{
			initComponents();
			
			buildSprite();
//			var test:TreeTest = new TreeTest();
			//var test:XMLTreeTest = new XMLTreeTest();

		}
		
		private function initComponents():void
		{
		}
		
		private function buildSprite():void
		{
		}
	}
}




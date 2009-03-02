package
{
	import flare.util.Orientation;
	import flare.util.Shapes;
	import flare.vis.Visualization;
	import flare.vis.controls.ExpandControl;
	import flare.vis.controls.HoverControl;
	import flare.vis.controls.IControl;
	import flare.vis.data.Data;
	import flare.vis.data.NodeSprite;
	import flare.vis.data.Tree;
	import flare.vis.events.SelectionEvent;
	import flare.vis.operator.encoder.PropertyEncoder;
	import flare.vis.operator.layout.NodeLinkTreeLayout;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	// Convenient way to pass in compiler arguments
	// Place after import statements and before first class declaration 
	[SWF(width='1024', height='768', backgroundColor='#ffffff', frameRate='30')]
	
	public class TreeTest extends Sprite
	{
		private var vis:Visualization;
		
		private var data:Data;
		
		// default values
		private var nodes:Object = {
			shape: Shapes.SQUARE,
			fillColor: 0x88aaaaaa,
			lineColor: 0xdddddddd,
			lineWidth: 1,
			size: 1.5,
			alpha: 1,
			visible: true
		}
		
		private var edges:Object = {
			lineColor: 0xffcccccc,
			lineWidth: 1,
			alpha: 1,
			visible: true
		}
		
		private var ctrl:IControl;
		
		private var nodeNum:Number = 0;
		
		public function TreeTest()
		{
			initComponents();
			
			buildSprite();
		}
		
		private function initComponents():void
		{
			Shapes.setShape("RECT", drawRectangle);
			
			// create data and set defaults
			data = createTree();//GraphUtil.diamondTree(3,4,4);
			
			data.nodes.setProperties(nodes);
			data.edges.setProperties(edges);
			for (var j:int=0; j<data.nodes.length; ++j) {
				data.nodes[j].data.label = String(j);
				data.nodes[j].buttonMode = true;
			}
			
			ctrl = new ExpandControl(NodeSprite,
				function():void { vis.update(1, "nodes","main").play(); });
			
			initVis();
		}
		
		private function initVis():void
		{
			vis = new Visualization(data);
//			vis.bounds = new Rectangle(stage.width/2, stage.height/2, stage.width/2, stage.height/2);
			vis.operators.add(new NodeLinkTreeLayout(Orientation.LEFT_TO_RIGHT,20,5,10));
			vis.setOperator("nodes", new PropertyEncoder(nodes, "nodes"));
			vis.setOperator("edges", new PropertyEncoder(edges, "edges"));
			vis.controls.add(new HoverControl(NodeSprite,
				// by default, move highlighted items to front
				HoverControl.MOVE_AND_RETURN,
				// highlight node border on mouse over
				function(e:SelectionEvent):void {
					e.node.lineWidth = 2;
					e.node.lineColor = 0x88ff0000;
				},
				// remove highlight on mouse out
				function(e:SelectionEvent):void {
					e.node.lineWidth = 0;
					e.node.lineColor = nodes.lineColor;
				}));
			vis.controls.add(ctrl);
			vis.update();
		}
		
		private function buildSprite():void
		{
			addChild(vis);
		}
		
		private function createTree():Tree
		{
			var b:int = 2;
			var d1:int = 2;
			var d2:int = 2;
			
			var tree:Tree = new Tree();
			var n:NodeSprite = tree.addRoot();
			addImageNode(n); 
			
			var l:NodeSprite = tree.addChild(n);
			addImageNode(l);
			
			var r:NodeSprite = tree.addChild(n);
			addImageNode(r);
            
            deepHelper(tree, l, b, d1-2, true);
        	deepHelper(tree, r, b, d1-2, false);
        
			while (l.firstChildNode != null)
				l = l.firstChildNode;
			while (r.lastChildNode != null)
				r = r.lastChildNode;
        	
        	deepHelper(tree, l, b, d2-1, false);
        	deepHelper(tree, r, b, d2-1, true);
        
        	return tree;
		}
		
		private function deepHelper(t:Tree, n:NodeSprite,
			breadth:int, depth:int, left:Boolean) : void
		{
			var c:NodeSprite = t.addChild(n);
			addImageNode(c);

			if (left && depth > 0)
				deepHelper(t, c, breadth, depth-1, left);
			
			for (var i:uint = 1; i<breadth; ++i) {
				c = t.addChild(n);
				addImageNode(c);
			}
			
			if (!left && depth > 0)
				deepHelper(t, c, breadth, depth-1, left);
		}
		
		private function addImageNode(n:NodeSprite):void
		{
			var image:DisplayObject = addImage(n, ++nodeNum);
			n.addChild(image);
		}
		
		private function addImage(n:NodeSprite, num:Number):DisplayObject
		{
			var ldr:Loader = new Loader();
			var url:String = "E:\\Code\\CS448B\\maptree\\images\\"+num+".jpg";
 			var urlReq:URLRequest = new URLRequest(url);
			ldr.load(urlReq);
			
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE,
				function(evt:Event):void
				{	
					iw = ldr.width;
					ih = ldr.height;
//					n.shape = "RECT"; // Trying to make the node shaped like the image 
					vis.update();
				});
						
			return ldr;
		}
		
		private static var iw:Number;
		private static var ih:Number;
		
		public static function drawRectangle(g:Graphics, size:Number) : void
		{
			g.drawRect(0,0, iw, ih);	
		}
	}
}
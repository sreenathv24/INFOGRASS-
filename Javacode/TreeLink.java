package javacode;

public class TreeLink {

	private	class TreeNode {

		private int data;
		private TreeNode right;
		private TreeNode left;	

		public int getData() {
			return data;
		}
		public void setData(int data) {
			this.data = data;
		}
	}

	TreeNode rootNode;

	public void addTree(int data) {
		rootNode=addTreeRec(rootNode, data);
	}
	public TreeNode addTreeRec(TreeNode rootNode,int data) {
		if(rootNode==null) {
			rootNode = new TreeNode();
			rootNode.setData(data);
		}
		else if(data<rootNode.getData()) {
			rootNode.left=addTreeRec(rootNode.left, data);
		}else if(data>rootNode.getData()){
			rootNode.right=addTreeRec(rootNode.right, data);
		}

		return rootNode;
	}

	public void showDepth() {
		showDepthRec(rootNode);
	}
	public void showDepthRec(TreeNode rootNode) {
		if (rootNode!=null) {
			System.out.print(rootNode.getData()+" ");
			showDepthRec(rootNode.left);
			showDepthRec(rootNode.right);
		}
	}

	public static void main(String[] args) {
		TreeLink t1 = new TreeLink();

		t1.addTree(10);
		t1.addTree(5);
		t1.addTree(12);
		t1.addTree(7);
		t1.addTree(15);
		t1.addTree(6);

		t1.showDepth();
		//		t1.showWidth();

	}
}


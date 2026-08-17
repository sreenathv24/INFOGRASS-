package javacode;

public class StackNode {
	
	Node head;
	public void PushStack(int data) {
//		Node container = new Node();
//		Node tempNode =new Node();
//		container.setData(data);
//		if (head == null) {
//			head = container;
//		} else {
//			if (head!= null) {
//				tempNode=head;
//				container.setNext(tempNode);
//				head=container;
//			}
//		}
		Node container=new Node();
		Node tempNode=head;
		container.setData(data);
		if(head==null) {
			head=container;
		}
		else {
			container.setNext(head);
			tempNode.setPrevious(container);
		}
	}
	public void PopStack() {
		Node tempNode=head;
		if(head.getNext()==null) {
			System.out.println("Poped out "+head.getData());
			head=null;
		}else {
			tempNode=head;
			System.out.println("Poped out "+tempNode.getData());
			head=tempNode.getNext();
			tempNode=null;
		}
	}
	public void CountStack() {
		Node tempNode=head;
		int count=1;
		if(tempNode==null) {
			System.out.println("Number of Nodes in Stack = 0");
		}else {
			while(tempNode.getNext()!=null) {
				count++;
				tempNode=tempNode.getNext();
			}
			System.out.println("Number of Nodes in Stack = "+count);
		}

	}
	public void FindStack(int data) {
		Node tempNode=head;
		boolean matchFound=false;
		if(head==null)
		{
			System.out.println("list is empty cannot search for given number");
			return;
		}else {

			while((tempNode!=null) && (!matchFound)) {
				if(tempNode.getData()==data) {
					System.out.println(data+" Match found in the List");
					matchFound=true;
				}
				tempNode=tempNode.getNext();
			}
			if(!matchFound) {
				System.out.println("Match Not Found in the List");
			}
		}
	}
	public void ShowStack() {
		Node container = head;
		if(container==null) {
			System.out.println("empty");
		}else {
			while (container.getPrevious()!= null) {
				System.out.println(container.getData());
				container = container.getPrevious();
			}
			System.out.println(container.getData());
		}
	}
	public static void main(String[] args) {
		StackNode s1=new StackNode();

		s1.PushStack(20);
		s1.PushStack(50);
//		s1.PushStack(90);
//		s1.PushStack(100);

//		s1.PopStack();
//		s1.PopStack();
//		s1.PopStack();
//		s1.PopStack();


//		s1.CountStack();

//		s1.FindStack(50);

		System.out.println("Current List is: ");
		s1.ShowStack();
	}
}
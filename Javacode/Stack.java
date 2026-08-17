package javacode;

public class Stack {
	Node head;

	public void stackPush(int data) {
		Node container = new Node();
		Node tempNode;
		container.setData(data);
		if (head == null) {
			head = container;
		} else {
			if (head!= null) {
				tempNode=head;
				container.setNext(tempNode);
				head=container;
			}
		}
	}
	public void stackPop() {
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
	public void stackCount() {
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
	public void stackFind(int data) {
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
	public void stackShow() {
		Node container = head;
		if(container==null) {
			System.out.println("empty");
		}else {
			while (container.getNext()!= null) {
				System.out.println(container.getData());
				container = container.getNext();
			}
			System.out.println(container.getData());
		}
	}
	public static void main(String[] args) {
		Stack s1=new Stack();

		s1.stackPush(20);
		s1.stackPush(50);
		s1.stackPush(90);
		s1.stackPush(100);

		s1.stackPop();
		s1.stackPop();


		s1.stackCount();

		s1.stackFind(50);

		System.out.println("Current List is: ");
		s1.stackShow();
	}

}

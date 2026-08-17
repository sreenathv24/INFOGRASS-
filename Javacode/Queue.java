package javacode;

public class Queue {

	Node head;

	public void qPush(int data) {
		Node container = new Node();
		container.setData(data);
		Node tempNode;
		if(head==null)
		{
			head=container;
		}
		else {
			tempNode=head;
			container.setNext(tempNode);
			head=container;
		}
	}

	public void qRemove() {
		Node temp;
		Node pre=null;
		temp=head;
		pre=temp.getNext();

		if(temp.getNext()==null) {
			System.out.println("REMOVED: "+temp.getData()+" from the list");
			head=null;
		}else {
			while(pre.getNext()!=null){
				temp=pre;
				pre=pre.getNext();
			}
			System.out.println("REMOVED: "+pre.getData()+" from the list");
			temp.setNext(null);
		}
	}
	public void qCount() {
		Node tempNode=head;
		int count=1;
		if(tempNode==null) {
			System.out.println("Number of Nodes in Queue = 0");
		}else {
			while(tempNode.getNext()!=null) {
				count++;
				tempNode=tempNode.getNext();
			}
			System.out.println("Number of Nodes in Queue = "+count);
		}
	}

	public void qFind(int data) {
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
	public void qShow() {
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
		Queue q1 =new Queue();

		q1.qPush(10);
		q1.qPush(20);
		q1.qPush(30);
		q1.qPush(40);

		q1.qRemove();

		q1.qCount();
		
		q1.qFind(30);

		System.out.println("current Queue is: ");
		q1.qShow();
	}
}
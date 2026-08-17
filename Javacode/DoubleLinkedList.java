package javacode;

public class DoubleLinkedList {

	Node head;
	Node tail;

	public void addNode(int data) {
		Node newNode = new Node();
		newNode.setData(data);
		if (head == null) {
			head = tail = newNode;
		} else {
			tail.setNext(newNode);
			newNode.setPrevious(tail);
			tail = newNode;
		}
	}

	public void deleteFirst() {
		Node tempNode=head;
		if(head==tail) {
			tail=null;
			System.out.println("deleted "+tempNode.getData()+" from the list");
		}else {
			head.getNext().setPrevious(null);
			System.out.println("deleted "+tempNode.getData()+" from the list");
		}
		head=head.getNext();
		tempNode.setNext(null);
	}

	public void insertafter(int index,int data) {

		Node tempNode = new Node();
		tempNode.setData(data);
		tempNode.setNext(null);
		tempNode.setPrevious(null);
		
		Node newNode = head;
		int i=0;
		while(newNode!=null) {
			i++;
			newNode=newNode.getNext();
		}
		if((index!=i)&&(index<i)) {
			newNode=head;
			while (--index>0) {
				newNode = newNode.getNext();
			}
			Node nextNode = newNode.getNext(); 
			nextNode.setPrevious(tempNode);

			tempNode.setNext(nextNode);
			tempNode.setPrevious(newNode);
			newNode.setNext(tempNode);
			System.out.println(tempNode.getData()+" number is inserted");
		}
		if(index==i) {
			tempNode.setNext(null);
			if (head == null) {
				head = tempNode;
				tempNode.setPrevious(null);
				System.out.println(tempNode.getData()+" number is inserted");
				return;
			}
			Node last = head;
			while (last.getNext() != null)
				last = last.getNext();
			last.setNext(tempNode);
			tempNode.setPrevious(last);
			tail=tempNode;
		}
		if(index>i) {
			System.out.println("cannot Insert the value in the given index ");
		}
	}
	public void showList() {
		Node tempNode = head;
		if(tempNode==null) {
			System.out.println("list is empty");
			return;
		}
		
			while (tempNode != null) {
				System.out.print(tempNode.getData() + " ");
				tempNode = tempNode.getNext();
			}
		
	}

	public void showListreverse() {
		Node tempNode = tail;
		if(tempNode==null) {
			System.out.println("list is empty");
		}
		else{
			while (tempNode != null) {
				System.out.print(tempNode.getData() + " ");
				tempNode = tempNode.getPrevious();
			}
		}	
	}

	public static void main(String[] args) 
	{
		DoubleLinkedList list = new DoubleLinkedList();

		list.addNode(5);
		list.addNode(10);
		list.addNode(15);
		list.addNode(20);
		list.addNode(25);
		list.addNode(30);
		
		list.deleteFirst();
		list.deleteFirst();
		list.deleteFirst();
		
		list.insertafter(1, 40);
		list.insertafter(3, 50);
		
		System.out.println("Current List is :");
		list.showList();
		
		System.out.println(" ");
		System.out.println("List in reverse :");
		list.showListreverse();
	}
}

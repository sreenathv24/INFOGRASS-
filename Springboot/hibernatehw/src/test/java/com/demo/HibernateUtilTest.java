package com.demo;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.*;
import org.hibernate.query.*;
import org.junit.jupiter.api.*;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.*;

public class HibernateUtilTest {

	public static SessionFactory sessionFactory;
	public static Session session;
	public static Query query;
	
	@BeforeAll
	public static void setUpDb() {
		sessionFactory = mock(SessionFactory.class);
		session = mock(Session.class);
		session.beginTransaction();
		 com.demo.named.dto.DepartmentEntity d1 = new com.demo.named.dto.DepartmentEntity();
		    d1.setName("HR");
		    session.persist(d1);
		//    Query query =
		  //  		session.createNamedQuery(com.demo.named.dto.DepartmentEntity.QUERY_GET_DEPARTMENT_BY_ID)
		    //            .setParameter("id", 1);
		    query = mock(Query.class);
		    when(sessionFactory.getCurrentSession()).thenReturn(session);
		    when(session.createQuery("from DepartmentEntity d WHERE d.id = 1")).thenReturn(query);
		    
		    com.demo.named.dto.DepartmentEntity dept = new com.demo.named.dto.DepartmentEntity();
		    dept.setId(1);
		    dept.setName("HR");
		  //  System.out.println(dept.getName());
		    ArrayList list = new ArrayList();
		    list.add(dept);
		    when(query.list()).thenReturn(list);
		    //System.out.println(dept.getName());
		    
		
	}
	
	public static List findDept() {
		return query.list();
	}
	
	@Test
	public void testDeptList() {
		List list = findDept();
		com.demo.named.dto.DepartmentEntity dept = (com.demo.named.dto.DepartmentEntity)list.get(0);
		System.out.println(dept.getName());
		 assertEquals("HR", dept.getName());
	}
	
	@AfterAll
	public static void cleanUp() {
		session.close();
	}
	
	//@Test
	//public void testDeptList1() {
		//System.out.println("test");
	//}
	//@Test
	public void testList() {
		SessionFactory sessionFactory = mock(SessionFactory.class);
		Session session = mock(Session.class);
		session.beginTransaction();
		 com.demo.named.dto.DepartmentEntity d1 = new com.demo.named.dto.DepartmentEntity();
		    d1.setName("HR");
		    session.persist(d1);
		//    Query query =
		  //  		session.createNamedQuery(com.demo.named.dto.DepartmentEntity.QUERY_GET_DEPARTMENT_BY_ID)
		    //            .setParameter("id", 1);
		    Query query = mock(Query.class);
		    when(sessionFactory.getCurrentSession()).thenReturn(session);
		    when(session.createQuery("from DepartmentEntity d WHERE d.id = 1")).thenReturn(query);
		    
		    com.demo.named.dto.DepartmentEntity dept = new com.demo.named.dto.DepartmentEntity();
		    dept.setId(1);
		    dept.setName("HR");
		    System.out.println(dept.getName());
		    ArrayList list = new ArrayList();
		    list.add(dept);
		    when(query.list()).thenReturn(list);
		    System.out.println(dept.getName());
		    session.close();
	}
	
}

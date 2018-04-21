package com.mvc.dao;

import java.util.List;

import com.mvc.domain.Customer;

public interface CustomerDAO {
	
	/**
	 * ���������ѯ������ List
	 * @param cc: ��װ�˲�ѯ����
	 * @return
	 */
	public List<Customer> getForListWithCriteriaCustomer(CriteriaCustomer cc);
	
	public List<Customer> getAll();
	
	public void save(Customer customer);
	
	public Customer get(Integer id);
	
	public void delete(Integer id);
	
	public void update(Customer customer);
	
	/**
	 * ���غ� name ��ȵļ�¼��. 
	 * @param name
	 * @return
	 */
	public long getCountWithName(String name);
	
}	

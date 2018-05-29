package com.struts2.helloworld;



public class Product {
	
	private Integer productId;
	private String productName;
	private String productDesc;
	
	public Integer getProductId() {
		return productId;
	}
	public void setProductId(Integer productId) {
		this.productId = productId;
	}
	public String getProductName() {
		return productName;
	}
	public void setProductName(String productName) {
		this.productName = productName;
	}
	public String getProductDesc() {
		return productDesc;
	}
	public void setProductDesc(String productDesc) {
		this.productDesc = productDesc;
	}
	@Override
	public String toString() {
		return "Product [productId=" + productId + ", productName=" + productName + ", productDesc=" + productDesc
				+ "]";
	}

	public String save(){
		System.out.println("save: " + this);
		return "details";
	}
	
	public String test(){
		System.out.println("test");
		return "success";
	}
	
	public Product() {
		System.out.println("Product's constructor...");
	}

}

package eibooks.dto;

public class OrderDTO {

	private int pur_i_seq;
	private int pur_seq;
	private int book_seq;
	private int cus_seq;
	private int pur_i_count;
	private String orderDate;
	private BookDTO bookInfo;
	private CustomerDTO customerInfo;
	
	public OrderDTO() {

	}

	public OrderDTO(int pur_i_seq, int pur_seq, int book_seq, int cus_seq, int pur_i_count, String orderDate) {
		super();
		this.pur_i_seq = pur_i_seq;
		this.pur_seq = pur_seq;
		this.book_seq = book_seq;
		this.cus_seq = cus_seq;
		this.pur_i_count = pur_i_count;
		this.orderDate = orderDate;
	}
	
	public OrderDTO(int pur_i_seq, int pur_seq, int book_seq, int cus_seq, int pur_i_count, String orderDate,
			BookDTO bookInfo, CustomerDTO customerInfo) {
		super();
		this.pur_i_seq = pur_i_seq;
		this.pur_seq = pur_seq;
		this.book_seq = book_seq;
		this.cus_seq = cus_seq;
		this.pur_i_count = pur_i_count;
		this.orderDate = orderDate;
		this.bookInfo = bookInfo;
		this.customerInfo = customerInfo;
	}

	public int getPur_i_seq() {
		return pur_i_seq;
	}

	public void setPur_i_seq(int pur_i_seq) {
		this.pur_i_seq = pur_i_seq;
	}

	public int getPur_seq() {
		return pur_seq;
	}

	public void setPur_seq(int pur_seq) {
		this.pur_seq = pur_seq;
	}

	public int getBook_seq() {
		return book_seq;
	}

	public void setBook_seq(int book_seq) {
		this.book_seq = book_seq;
	}

	public int getCus_seq() {
		return cus_seq;
	}

	public void setCus_seq(int cus_seq) {
		this.cus_seq = cus_seq;
	}

	public int getPur_i_count() {
		return pur_i_count;
	}

	public void setPur_i_count(int pur_i_count) {
		this.pur_i_count = pur_i_count;
	}

	public String getOrderDate() {
		return orderDate;
	}

	public void setOrderDate(String orderDate) {
		this.orderDate = orderDate;
	}

	public BookDTO getBookInfo() {
		return bookInfo;
	}

	public void setBookInfo(BookDTO bookInfo) {
		this.bookInfo = bookInfo;
	}

	public CustomerDTO getCustomerInfo() {
		return customerInfo;
	}

	public void setCustomerInfo(CustomerDTO customerInfo) {
		this.customerInfo = customerInfo;
	}
	
}

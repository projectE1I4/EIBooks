package eibooks.dto;

public class OrderQnaDTO {

	private int pur_q_seq;
	private int cus_seq;
	private int book_seq;
	private int pur_seq;
	private int pur_i_seq;
	private String type;
	private String title;
	private String content;
	private String imageFile;
	private String regDate;
	private int state;
	private int depth;
	private int ref_seq;
	private CustomerDTO cusInfo;
	private BookDTO bookInfo;
	private OrderDTO orderInfo;
	
	public OrderQnaDTO() {

	}
	
	public OrderQnaDTO(int cus_seq, int book_seq, int pur_seq, int pur_i_seq, String type, String title, String content, String imageFile) {
		super();
		this.cus_seq = cus_seq;
		this.book_seq = book_seq;
		this.pur_seq = pur_seq;
		this.pur_i_seq = pur_i_seq;
		this.type = type;
		this.title = title;
		this.content = content;
		this.imageFile = imageFile;
	}

	public int getPur_q_seq() {
		return pur_q_seq;
	}

	public void setPur_q_seq(int pur_q_seq) {
		this.pur_q_seq = pur_q_seq;
	}

	public int getCus_seq() {
		return cus_seq;
	}

	public void setCus_seq(int cus_seq) {
		this.cus_seq = cus_seq;
	}

	public int getBook_seq() {
		return book_seq;
	}

	public void setBook_seq(int book_seq) {
		this.book_seq = book_seq;
	}

	public int getPur_seq() {
		return pur_seq;
	}

	public void setPur_seq(int pur_seq) {
		this.pur_seq = pur_seq;
	}

	public int getPur_i_seq() {
		return pur_i_seq;
	}

	public void setPur_i_seq(int pur_i_seq) {
		this.pur_i_seq = pur_i_seq;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getImageFile() {
		return imageFile;
	}

	public void setImageFile(String imageFile) {
		this.imageFile = imageFile;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}

	public int getState() {
		return state;
	}

	public void setState(int state) {
		this.state = state;
	}

	public int getDepth() {
		return depth;
	}

	public void setDepth(int depth) {
		this.depth = depth;
	}

	public int getRef_seq() {
		return ref_seq;
	}

	public void setRef_seq(int ref_seq) {
		this.ref_seq = ref_seq;
	}

	public CustomerDTO getCusInfo() {
		return cusInfo;
	}

	public void setCusInfo(CustomerDTO cusInfo) {
		this.cusInfo = cusInfo;
	}

	public BookDTO getBookInfo() {
		return bookInfo;
	}

	public void setBookInfo(BookDTO bookInfo) {
		this.bookInfo = bookInfo;
	}

	public OrderDTO getOrderInfo() {
		return orderInfo;
	}

	public void setOrderInfo(OrderDTO orderInfo) {
		this.orderInfo = orderInfo;
	}

}

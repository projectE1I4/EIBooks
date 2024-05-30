package eibooks.dto;

public class QnaDTO {

	private int qna_seq;
	private int book_seq;
	private int cus_seq;
	private String type;
	private String title;
	private String content;
	private String protect_YN;
	private String regDate;
	private String state;
	private int depth;
	private int ref_seq;
	private CustomerDTO cusInfo;
	private BookDTO bookInfo;
	
	public QnaDTO() {

	}
	
	public QnaDTO(int book_seq, int cus_seq, String content) {
		super();
		this.book_seq = book_seq;
		this.cus_seq = cus_seq;
		this.content = content;
	}
	
	public QnaDTO(int book_seq, int cus_seq, String type, String title, String content, String protect_YN) {
		super();
		this.book_seq = book_seq;
		this.cus_seq = cus_seq;
		this.type = type;
		this.title = title;
		this.content = content;
		this.protect_YN = protect_YN;
	}

	public int getQna_seq() {
		return qna_seq;
	}

	public void setQna_seq(int qna_seq) {
		this.qna_seq = qna_seq;
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

	public String getProtect_YN() {
		return protect_YN;
	}

	public void setProtect_YN(String protect_YN) {
		this.protect_YN = protect_YN;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
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
	
}

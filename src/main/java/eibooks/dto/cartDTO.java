package eibooks.dto;

import eibooks.dto.BookDTO;

public class cartDTO {
	
	private int cartISeq; //장바구니 목록 순차번호
	private int cartSeq; //장바구니 순차번호
	private int cusSeq; //회원 순차번호
	private int book_seq; //도서 순차번호
	private int cartICount; //장바구니 목록 테이블의 수량(권)
	private BookDTO bookInfo; // 장바구니에 담긴 도서 정보
	
	 public cartDTO() {       
	 }
	 
	public cartDTO(int cartISeq, int cartSeq, int cusSeq, int book_seq, int cartICount, BookDTO bookInfo) {
		super();
		this.cartISeq = cartISeq;
		this.cartSeq = cartSeq;
		this.cusSeq = cusSeq;
		this.book_seq = book_seq;
		this.cartICount = cartICount;
		this.bookInfo = bookInfo;
	}

	public int getCartISeq() {
		return cartISeq;
	}

	public void setCartISeq(int cartISeq) {
		this.cartISeq = cartISeq;
	}

	public int getCartSeq() {
		return cartSeq;
	}

	public void setCartSeq(int cartSeq) {
		this.cartSeq = cartSeq;
	}

	public int getCusSeq() {
		return cusSeq;
	}

	public void setCusSeq(int cusSeq) {
		this.cusSeq = cusSeq;
	}

	
	public int getBook_seq() {
		return book_seq;
	}


	public void setBook_seq(int book_seq) {
		this.book_seq = book_seq;
	}


	public int getCartICount() {
		return cartICount;
	}

	public void setCartICount(int cartICount) {
		this.cartICount = cartICount;
	}

	public BookDTO getBookInfo() {
		return bookInfo;
	}

	public void setBookInfo(BookDTO bookInfo) {
		this.bookInfo = bookInfo;
	}
}

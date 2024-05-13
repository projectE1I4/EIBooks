package eibooks.dto;

import eibooks.dto.BookDTO;

public class cartDTO {
	
	private int cartISeq; //장바구니 목록 순차번호
	private int cartSeq; //장바구니 순차번호
	private int cusSeq; //회원 순차번호
	private int bookSeq; //도서 순차번호
	private int cartICount; //장바구니 목록 테이블의 수량(권)
	private BookDTO bookInfo; // 장바구니에 담긴 도서 정보
	
	 public cartDTO() {
	        
	    }
	
	public cartDTO(int cartISeq, int cartSeq, int cusSeq, int bookSeq, int cartICount) {
		super();
		this.cartISeq = cartISeq;
		this.cartSeq = cartSeq;
		this.cusSeq = cusSeq;
		this.bookSeq = bookSeq;
		this.cartICount = cartICount;
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

	public int getBookSeq() {
		return bookSeq;
	}

	public void setBookSeq(int bookSeq) {
		this.bookSeq = bookSeq;
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

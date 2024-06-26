package eibooks.common;

public class PageDTO {

	private int startPage; // 페이징 첫번째 번호
	private int endPage; // 페이징 마지막 번호
	private boolean prev, next; // 이전버튼, 다음버튼 활성화여부

	private int pageNum; // 현재 조회하는 페이지번호
	private int amount; // 화면 리스트 목록
	private int total; // 전체 데이터 수
	
	private int realEnd;

	// 생성자에서는 객체가 생성될때 계산을 처리
	public PageDTO(int pageNum, int amount, int total) {
		this.pageNum = pageNum;
		this.amount = amount;
		this.total = total;

		// 1. endPage결정
		//		 ex) 조회하는 페이지 1 -> 끝번호 10
		//		 ex) 조회하는 페이지 9 -> 끝번호 10
		//		 ex) 조회하는 페이지 11 -> 끝번호 20
		//		 공식 = (int)Math.ceil(페이지번호 / 페이지네이션개수) * 페이지네이션개수
		// pageNum 넘어오는 거 확인
		this.endPage = (int)Math.ceil(this.pageNum * 0.1) * 10;
		
		// 2. startPage결정
		// 공식 = 끝페이지 - 페이지네이션개수 + 1
		this.startPage = this.endPage - 10 + 1;

		// 3. realEnd(진짜 끝번호) 구해서 endPage의 값을 다시 결정
		//		 만약 게시글이 52개라면 -> 진짜 끝번호 6
		//		 만약 게시글이 105개라면 -> 진짜 끝번호 11
		//		 공식 = (int)Math.ceil(전체게시글수 / 화면에보여질데이터개수)
		this.realEnd = (int)Math.ceil(this.total / (double)this.amount);
		System.out.println("엔드"+realEnd + "total"+ total+ "amount" + amount);

		//		 마지막페이지 도달했을 때 보여져야 하는 끝번호가 달라집니다.
		//		 ex) 131개 게시물
		//		 1번 페이지 클릭시 -> endPage = 10, realEnd = 14 ( endPage로 세팅 )
		//		 11번 페이지 클릭시 -> endPage = 20, realEnd = 14 ( realEnd로 세팅 )
		if(this.endPage > realEnd) {
			this.endPage = realEnd;
		}

		// 4. prev결정 ( startPage의 번호는 1, 11, 21... )
		this.prev = this.startPage > 1;

		// 5. next결정
		//		 ex: 131개 게시물
		//		 1~10 클릭시 endPage = 10, realEnd = 14 -> 다음버튼 true
		//		 11 클릭시 endPage = 14 , realEnd = 14 -> 다음버튼 false
		this.next = this.endPage < realEnd;

		// 확인
		System.out.println("시작페이지:" + this.startPage + ", 끝페이지:" + this.endPage +", 페이지 넘버:" + this.pageNum + ",리얼엔드:" + this.realEnd); 
	}

	public int getStartPage() {
		return startPage;
	}

	public void setStartPage(int startPage) {
		this.startPage = startPage;
	}

	public int getEndPage() {
		return endPage;
	}

	public void setEndPage(int endPage) {
		this.endPage = endPage;
	}

	public boolean isPrev() {
		return prev;
	}

	public void setPrev(boolean prev) {
		this.prev = prev;
	}

	public boolean isNext() {
		return next;
	}

	public void setNext(boolean next) {
		this.next = next;
	}

	public int getPageNum() {
		return pageNum;
	}

	public void setPageNum(int pageNum) {
		this.pageNum = pageNum;
	}

	public int getAmount() {
		return amount;
	}

	public void setAmount(int amount) {
		this.amount = amount;
	}

	public int getTotal() {
		return total;
	}

	public void setTotal(int total) {
		this.total = total;
	}

	public int getRealEnd() {
		return realEnd;
	}
	
}

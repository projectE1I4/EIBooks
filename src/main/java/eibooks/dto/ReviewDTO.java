package eibooks.dto;

public class ReviewDTO {
	private int bookNum;
	private int userNum;
	private int reviewNum;
	private int grade;
	private int depth;
	private String userId;
	private String reviewDate;
	private String content;
	private int ref_seq;
	private String ref_YN;
	
	public ReviewDTO() {
	}

	
	
	public ReviewDTO(int bookNum, String userId, String content) {
		super();
		this.bookNum = bookNum;
		this.userId = userId;
		this.content = content;
	}


	public ReviewDTO(int bookNum, int reviewNum, int grade, String userId, String content) {
		super();
		this.bookNum = bookNum;
		this.reviewNum = reviewNum;
		this.grade = grade;
		this.userId = userId;
		this.content = content;
	}

	

	public ReviewDTO(int bookNum, int reviewNum, int grade, String userId, String reviewDate, String content) {
		super();
		this.bookNum = bookNum;
		this.reviewNum = reviewNum;
		this.grade = grade;
		this.userId = userId;
		this.reviewDate = reviewDate;
		this.content = content;
	}

	public ReviewDTO(int grade, String userId, String reviewDate, String content) {
		super();
		this.grade = grade;
		this.userId = userId;
		this.reviewDate = reviewDate;
		this.content = content;
	}
	
	public ReviewDTO(int bookNum, int grade, String userId, String reviewDate, String content) {
		super();
		this.bookNum = bookNum;
		this.grade = grade;
		this.userId = userId;
		this.reviewDate = reviewDate;
		this.content = content;
	}

	public ReviewDTO(int bookNum, int userNum, int grade, String content) {
		super();
		this.bookNum = bookNum;
		this.userNum = userNum;
		this.grade = grade;
		this.content = content;
	}
	
	public ReviewDTO(int bookNum, int userNum, int reviewNum, int grade, String userId, String content) {
		super();
		this.bookNum = bookNum;
		this.userNum = userNum;
		this.reviewNum = reviewNum;
		this.grade = grade;
		this.userId = userId;
		this.content = content;
	}

	public int getBookNum() {
		return bookNum;
	}

	public void setBookNum(int bookNum) {
		this.bookNum = bookNum;
	}

	public int getUserNum() {
		return userNum;
	}

	public void setUserNum(int userNum) {
		this.userNum = userNum;
	}

	public int getReviewNum() {
		return reviewNum;
	}

	public void setReviewNum(int reviewNum) {
		this.reviewNum = reviewNum;
	}

	public int getGrade() {
		return grade;
	}

	public void setGrade(int grade) {
		this.grade = grade;
	}

	public int getDepth() {
		return depth;
	}

	public void setDepth(int depth) {
		this.depth = depth;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getReviewDate() {
		return reviewDate;
	}

	public void setReviewDate(String reviewDate) {
		this.reviewDate = reviewDate;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public int getRef_seq() {
		return ref_seq;
	}

	public void setRef_seq(int ref_seq) {
		this.ref_seq = ref_seq;
	}

	public String getRef_YN() {
		return ref_YN;
	}

	public void setRef_YN(String ref_YN) {
		this.ref_YN = ref_YN;
	}



	@Override
	public String toString() {
		return "ReviewDTO [bookNum=" + bookNum + ", userNum=" + userNum + ", reviewNum=" + reviewNum + ", grade="
				+ grade + ", userId=" + userId + ", reviewDate=" + reviewDate + ", content=" + content + "]";
	}

}

package dto;

public class ReviewDTO {
	private int bookNum;
	private int userNum;
	private int reviewNum;
	private int grade;
	private String userId;
	private String reviewDate;
	private String content;
	
	public ReviewDTO() {
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

	public ReviewDTO(int bookNum, int userNum, int grade, String userId, String reviewDate, String content) {
		super();
		this.bookNum = bookNum;
		this.userNum = userNum;
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

	@Override
	public String toString() {
		return "ReviewDTO [bookNum=" + bookNum + ", userNum=" + userNum + ", reviewNum=" + reviewNum + ", grade="
				+ grade + ", userId=" + userId + ", reviewDate=" + reviewDate + ", content=" + content + "]";
	}

}

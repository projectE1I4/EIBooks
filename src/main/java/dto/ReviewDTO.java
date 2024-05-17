package dto;

public class ReviewDTO {
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
		return "ReviewDTO [grade=" + grade + ", userId=" + userId + ", reviewDate=" + reviewDate + ", content="
				+ content + "]";
	}
	
}

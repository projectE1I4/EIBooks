package eibooks.dto;

public class ReviewDTO {
	private int bookNum;
	private int userNum;
	private int pur_seq;
	private int pur_i_seq;
	private int reviewNum;
	private int grade;
	private String content;
	private String reviewDate;
	private int depth;
	private int ref_seq;
	private String ref_YN;
	private String del_YN;
	private CustomerDTO cusInfo;
	
	public ReviewDTO() {
	}
	
	

	public ReviewDTO(int bookNum, int userNum, int pur_seq, int pur_i_seq, int grade, String content) {
		super();
		this.bookNum = bookNum;
		this.userNum = userNum;
		this.pur_seq = pur_seq;
		this.pur_i_seq = pur_i_seq;
		this.grade = grade;
		this.content = content;
	}

	public ReviewDTO(int bookNum, int pur_i_seq, int reviewNum, int grade, String content) {
		super();
		this.bookNum = bookNum;
		this.pur_i_seq = pur_i_seq;
		this.reviewNum = reviewNum;
		this.grade = grade;
		this.content = content;
	}


	public ReviewDTO(int bookNum, int userNum, int pur_seq, int pur_i_seq, int reviewNum, int grade, String content,
			String reviewDate) {
		super();
		this.bookNum = bookNum;
		this.userNum = userNum;
		this.pur_seq = pur_seq;
		this.pur_i_seq = pur_i_seq;
		this.reviewNum = reviewNum;
		this.grade = grade;
		this.content = content;
		this.reviewDate = reviewDate;
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

	public String getDel_YN() {
		return del_YN;
	}

	public void setDel_YN(String del_YN) {
		this.del_YN = del_YN;
	}

	public CustomerDTO getCusInfo() {
		return cusInfo;
	}

	public void setCusInfo(CustomerDTO cusInfo) {
		this.cusInfo = cusInfo;
	}



	@Override
	public String toString() {
		return "ReviewDTO [bookNum=" + bookNum + ", userNum=" + userNum + ", pur_seq=" + pur_seq + ", pur_i_seq="
				+ pur_i_seq + ", reviewNum=" + reviewNum + ", grade=" + grade + ", content=" + content + ", reviewDate="
				+ reviewDate + ", depth=" + depth + ", ref_seq=" + ref_seq + ", ref_YN=" + ref_YN + ", del_YN=" + del_YN
				+ ", cusInfo=" + cusInfo + "]";
	}



}

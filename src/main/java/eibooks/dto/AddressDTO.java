package eibooks.dto;

public class AddressDTO {

	private int cus_seq;
	private String postalCode;
	private String addr;
	private String addr_detail;
	
	public AddressDTO() {

	}

	public AddressDTO(int cus_seq, String postalCode, String addr, String addr_detail) {
		super();
		this.cus_seq = cus_seq;
		this.postalCode = postalCode;
		this.addr = addr;
		this.addr_detail = addr_detail;
	}

	public int getCus_seq() {
		return cus_seq;
	}

	public void setCus_seq(int cus_seq) {
		this.cus_seq = cus_seq;
	}

	public String getPostalCode() {
		return postalCode;
	}

	public void setPostalCode(String postalCode) {
		this.postalCode = postalCode;
	}

	public String getAddr() {
		return addr;
	}

	public void setAddr(String addr) {
		this.addr = addr;
	}

	public String getAddr_detail() {
		return addr_detail;
	}

	public void setAddr_detail(String addr_detail) {
		this.addr_detail = addr_detail;
	}
	
}

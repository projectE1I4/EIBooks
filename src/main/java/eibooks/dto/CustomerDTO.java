package eibooks.dto;

public class CustomerDTO {

    private int cus_seq;
    private String cus_id;
    private String password;
    private String name;
    private String tel;
    private String email;
    private String regDate;
    private AddressDTO addrInfo;

    public CustomerDTO() {
    }

    public CustomerDTO(int cus_seq, String cus_id, String password, String name, String tel, String email, String regDate) {
        this.cus_seq = cus_seq;
        this.cus_id = cus_id;
        this.password = password;
        this.name = name;
        this.tel = tel;
        this.email = email;
        this.regDate = regDate;
    }

    public int getCus_seq() {
        return cus_seq;
    }

    public void setCus_seq(int cus_seq) {
        this.cus_seq = cus_seq;
    }

    public String getCus_id() {
        return cus_id;
    }

    public void setCus_id(String cus_id) {
        this.cus_id = cus_id;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getTel() {
        return tel;
    }

    public void setTel(String tel) {
        this.tel = tel;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRegDate() {
        return regDate;
    }

    public void setRegDate(String regDate) {
        this.regDate = regDate;
    }

    public AddressDTO getAddrInfo() {
        return addrInfo;
    }

    public void setAddrInfo(AddressDTO addrInfo) {
        this.addrInfo = addrInfo;
    }

}

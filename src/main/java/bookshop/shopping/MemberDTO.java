package bookshop.shopping;

import java.sql.Timestamp;

//-------------------------------------------------------------------------------------------------
// 회원 정보 DTO (Data Transfer Object)
//-------------------------------------------------------------------------------------------------
public class MemberDTO {

	private	String		id;
	private	String		passwd;
	private	String		name;
	private	Timestamp	reg_date;
	private	String		tel;
	private	String		address;
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getPasswd() {
		return passwd;
	}
	public void setPasswd(String passwd) {
		this.passwd = passwd;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public Timestamp getReg_date() {
		return reg_date;
	}
	public void setReg_date(Timestamp reg_date) {
		this.reg_date = reg_date;
	}
	public String getTel() {
		return tel;
	}
	public void setTel(String tel) {
		this.tel = tel;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	
	@Override
	public String toString() {
		return "MemberDTO [id=" + id + ", passwd=" + passwd + ", name=" + name + ", reg_date=" + reg_date + ", tel="
				+ tel + ", address=" + address + "]";
	}
		
} // End - public class MemberDTO


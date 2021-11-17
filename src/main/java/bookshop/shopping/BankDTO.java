package bookshop.shopping;

//-------------------------------------------------------------------------------------------------
// 은행
//-------------------------------------------------------------------------------------------------
public class BankDTO {

	private	String	account;	// 은행 계좌 번호
	private	String	bank;		// 은행명
	private	String	name;		// 은행 계좌 소유주
	
	public String getAccount() {
		return account;
	}
	public void setAccount(String account) {
		this.account = account;
	}
	public String getBank() {
		return bank;
	}
	public void setBank(String bank) {
		this.bank = bank;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
	@Override
	public String toString() {
		return "BankDTO [account=" + account + ", bank=" + bank + ", name=" + name + "]";
	}
	
	
} // End - public class BankDTO

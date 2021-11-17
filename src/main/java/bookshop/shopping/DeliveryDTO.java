package bookshop.shopping;

//-------------------------------------------------------------------------------------------------
// public class DeliveryDTO
//-------------------------------------------------------------------------------------------------
public class DeliveryDTO {

	private	Long	buy_id;		// 구매 아이디
	private	String	status;		// 배송상태 : 1(상품 준비중) 2(배송 중) 3(배송 완료)
	
	public Long getBuy_id() {
		
		return buy_id;
	}
	public void setBuy_id(Long buy_id) {
		this.buy_id = buy_id;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	
	@Override
	public String toString() {
		return "DeliveryDTO [buy_id=" + buy_id + ", status=" + status + "]";
	}
	
} // End - public class DeliveryDTO

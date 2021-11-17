package bookshop.manager;

//-------------------------------------------------------------------------------------------------
// 책의 종류
//-------------------------------------------------------------------------------------------------
public class BookTypeDTO {

	private	String	id;		// 책의 종류 코드
	private	String	name;	// 책의 종류 이름
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	@Override
	public String toString() {
		return "BookTypeDTO [id=" + id + ", name=" + name + "]";
	}
	
} // End - public class BookTypeDTO
